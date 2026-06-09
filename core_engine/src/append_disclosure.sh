#!/usr/bin/env bash
# append_disclosure.sh
# Appends a disclosure block to /OMNIBUS_VAULT/disclosure.txt (creates dir/file if needed)
# Usage: ./append_disclosure.sh [-n|--dry-run] [-v|--verbose] "Your disclosure text here"
# If no argument is provided the script reads disclosure text from stdin.

set -euo pipefail

TARGET_DIR="/OMNIBUS_VAULT"
TARGET_FILE="${TARGET_DIR}/disclosure.txt"
BACKUP_DIR="${TARGET_DIR}/backups"
TS="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
USER_NAME="${USER:-$(whoami 2>/dev/null || echo unknown)}"
DRY_RUN=0
VERBOSE=0

# Simple arg parsing for dry-run and verbose
while [ $# -gt 0 ]; do
  case "$1" in
    -n|--dry-run) DRY_RUN=1; shift ;;
    -v|--verbose) VERBOSE=1; shift ;;
    --) shift; break ;;
    -*) echo "Unknown option: $1" >&2; exit 2 ;;
    *) break ;;
  esac
done

# Read disclosure text from first remaining arg or stdin
if [ $# -ge 1 ]; then
  DISCLOSURE_TEXT="$*"
else
  DISCLOSURE_TEXT="$(cat -)"
fi

# Ensure directory exists before mktemp
mkdir -p -- "${BACKUP_DIR}"
# Restrict directory permissions
chmod 700 -- "${TARGET_DIR}" "${BACKUP_DIR}" || true

if [ "${VERBOSE}" -eq 1 ]; then
  echo "Target dir: ${TARGET_DIR}"
  echo "Target file: ${TARGET_FILE}"
  echo "Backup dir: ${BACKUP_DIR}"
  echo "Timestamp: ${TS}"
  echo "User: ${USER_NAME}"
fi

if [ "${DRY_RUN}" -eq 1 ]; then
  echo "DRY RUN: would append disclosure block:"
  printf '%s\n' "----" "AppendedBy: ${USER_NAME}" "AppendedAtUTC: ${TS}" "Disclosure:" "${DISCLOSURE_TEXT}" "----"
  exit 0
fi

# If target file exists, make a timestamped backup
if [ -f "${TARGET_FILE}" ]; then
  BACKUP_FILE="${BACKUP_DIR}/disclosure.${TS}.bak"
  cp -- "${TARGET_FILE}" "${BACKUP_FILE}"
  chmod 600 -- "${BACKUP_FILE}" || true
  [ "${VERBOSE}" -eq 1 ] && echo "Backup created: ${BACKUP_FILE}"
fi

# Compose the block to append preserving newlines
read -r -d '' BLOCK <<'EOF' || true
--- DISCLOSURE APPEND START ---
AppendedBy: __USER__
AppendedAtUTC: __TS__
Disclosure:
__DISC__
--- DISCLOSURE APPEND END ---
EOF

# Replace placeholders safely
BLOCK="${BLOCK//__USER__/${USER_NAME}}"
BLOCK="${BLOCK//__TS__/${TS}}"
# Use printf to preserve newlines in DISCLOSURE_TEXT
BLOCK="${BLOCK//__DISC__/${DISCLOSURE_TEXT}}"

# Create a secure temporary file in the target directory
TMP="$(mktemp -p "${TARGET_DIR}" .disclosure.XXXXXX)"
printf "%s\n" "${BLOCK}" > "${TMP}"
chmod 600 -- "${TMP}" || true

# Append tmp to target file (create if missing)
cat "${TMP}" >> "${TARGET_FILE}"
rm -f -- "${TMP}"

# Ensure conservative permissions on target file
chmod 600 -- "${TARGET_FILE}" || true

echo "Disclosure appended to ${TARGET_FILE} (backup created if file existed)."
