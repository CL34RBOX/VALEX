#!/usr/bin/env bash
set -euo pipefail

# CONFIG
ONEDRIVE_ROOT="${ONEDRIVE_ROOT:-/mnt/onedrive/Attachments}"   # local sync mount or mounted share
VAULT_ROOT="${VAULT_ROOT:-/opt/omnibus/vault}"
MANIFEST="${VAULT_ROOT}/manifest.json"
DISCOVERY_TS="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
REPORT="${VAULT_ROOT}/ingestion_reports/ingestion_${DISCOVERY_TS}.json"
TMPDIR="$(mktemp -d)"
ID_PREFIX="OMNI-ID-FIND"
DISCOVERY_INDEX="${TMPDIR}/one_drive_manifest.json"

# Ensure directories
mkdir -p "${VAULT_ROOT}/Interface/FIND/AUDIT-RECORDINGS"
mkdir -p "${VAULT_ROOT}/Interface/FIND/SCREENSHOTS"
mkdir -p "${VAULT_ROOT}/Telemetry/FIND"
mkdir -p "$(dirname "${MANIFEST}")"
mkdir -p "$(dirname "${REPORT}")"

# Helpers
sha256sum_file() { sha256sum "$1" | awk '{print $1}'; }
iso_ts() { date -u -r "$1" +"%Y-%m-%dT%H:%M:%SZ"; }

# 1) Enumerate Attachments
echo "Enumerating OneDrive Attachments under ${ONEDRIVE_ROOT}..."
find "${ONEDRIVE_ROOT}" -maxdepth 2 -type f \( -iname "*.url" -o -iname "*.mp4" -o -iname "*.mov" -o -iname "*.jpg" -o -iname "*.png" -o -iname "*.txt" -o -iname "*.log" \) > "${TMPDIR}/files.txt"

# Build discovery index
jq -n --arg ts "${DISCOVERY_TS}" '{generated_at:$ts, items:[]}' > "${DISCOVERY_INDEX}"
while IFS= read -r src; do
  fname="$(basename "$src")"
  fext="${fname##*.}"
  mime="application/octet-stream"
  case "${fext,,}" in
    mp4|mov) mime="video/mp4" ;;
    jpg|jpeg) mime="image/jpeg" ;;
    png) mime="image/png" ;;
    url) mime="internet-shortcut" ;;
    txt|log) mime="text/plain" ;;
  esac
  item=$(jq -n --arg fn "$fname" --arg sp "$src" --arg mt "$mime" --arg dt "$(iso_ts "$src")" \
    '{filename:$fn, original_path:$sp, type:$mt, discovered:$dt}')
  jq ".items += [${item}]" "${DISCOVERY_INDEX}" > "${DISCOVERY_INDEX}.tmp" && mv "${DISCOVERY_INDEX}.tmp" "${DISCOVERY_INDEX}"
done < "${TMPDIR}/files.txt"

# 2) Ingest each file
ingested_count=0
declare -a ingested_items
while IFS= read -r src; do
  fname="$(basename "$src")"
  fext="${fname##*.}"
  dest_dir="${VAULT_ROOT}/Interface/FIND/AUDIT-RECORDINGS"
  meta_domain="Interface:FIND:AUDIT-RECORDINGS"
  if [[ "${fext,,}" =~ ^(jpg|jpeg|png)$ ]]; then
    dest_dir="${VAULT_ROOT}/Interface/FIND/SCREENSHOTS"
    meta_domain="Interface:FIND:SCREENSHOTS"
  fi

  # Copy file preserving timestamps
  cp -p "$src" "${dest_dir}/"
  dest="${dest_dir}/${fname}"

  # Compute SHA256
  sha256="$(sha256sum_file "${dest}")"
  orig_ts="$(iso_ts "$src")"
  ingested_ts="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  short_id="$(echo "${fname}" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | cut -c1-24)"
  artifact_id="${ID_PREFIX}-${short_id}"

  # Create metadata header
  meta_file="${dest}.meta.json"
  jq -n \
    --arg artifact_id "$artifact_id" \
    --arg dlo "$meta_domain" \
    --arg srcp "$src" \
    --arg ftype "$mime" \
    --arg sha "$sha256" \
    --arg discovered_by "Enrique" \
    --arg discovered_at "$DISCOVERY_TS" \
    --arg ingested_at "$ingested_ts" \
    --arg provenance_note "Ingested from OneDrive Attachments; original path preserved." \
    '{
      artifact_id:$artifact_id,
      domain_layer_object:$dlo,
      original_source:"OneDrive",
      original_path:$srcp,
      file_type:$ftype,
      sha256:$sha,
      discovered_by:$discovered_by,
      discovered_at:$discovered_at,
      ingested_at:$ingested_at,
      provenance_note:$provenance_note
    }' > "${meta_file}"

  # For media files, extract technical metadata (ffprobe) and store derived JSON
  if [[ "${fext,,}" =~ ^(mp4|mov)$ ]]; then
    ffprobe -v quiet -print_format json -show_format -show_streams "${dest}" > "${dest}.ffprobe.json" || true
  fi

  ingested_items+=("{\"filename\":\"${fname}\",\"artifact_id\":\"${artifact_id}\",\"path\":\"${dest}\",\"sha256\":\"${sha256}\"}")
  ingested_count=$((ingested_count+1))
done < "${TMPDIR}/files.txt"

# 3) Write Telemetry manifest index
jq -n --arg gen "${DISCOVERY_TS}" --argjson items "$(jq '.items' "${DISCOVERY_INDEX}")" \
  '{generated_at:$gen, items:$items, items_count:(($items|length))}' > "${VAULT_ROOT}/Telemetry/FIND/ONE_DRIVE_MANIFEST.json"

# 4) Append to manifest.json (simple append; replace with your manifest management)
# Load existing manifest, add Interface FIND items and bump version to 3.2.1
if [ -f "${MANIFEST}" ]; then
  tmp_manifest="${TMPDIR}/manifest.json"
  jq --arg ver "3.2.1" --arg gen "${DISCOVERY_TS}" \
    '.version=$ver | .governance.last_audit=$gen' "${MANIFEST}" > "${tmp_manifest}" && mv "${tmp_manifest}" "${MANIFEST}"
fi

# 5) Write ingestion report
jq -n --arg ts "${DISCOVERY_TS}" --argjson ingested "$(printf '%s\n' "${ingested_items[@]}" | jq -s '.')" \
  '{discovery_ts:$ts, ingested_count:(($ingested|length)), items:$ingested}' > "${REPORT}"

echo "Ingestion complete. ${ingested_count} items processed."
echo "Discovery index: ${DISCOVERY_INDEX}"
echo "Telemetry manifest: ${VAULT_ROOT}/Telemetry/FIND/ONE_DRIVE_MANIFEST.json"
echo "Ingestion report: ${REPORT}"

# Cleanup
rm -rf "${TMPDIR}"
exit 0
