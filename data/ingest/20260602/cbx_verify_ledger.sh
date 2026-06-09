#!/usr/bin/env bash
# === CLEARBOXX LEDGER VERIFIER ===

set -euo pipefail

VAULT_ROOT="${VAULT_ROOT:-$HOME/OMNIBUS_VAULT}"
LEDGER_DIR="$VAULT_ROOT/ledger"
MASTER_LEDGER="${1:-$LEDGER_DIR/MASTER_LEDGER.log}"

if [[ ! -f "$MASTER_LEDGER" ]]; then
  echo "[VERIFY] ERROR: Master ledger not found."
  exit 1
fi

ok=0
bad=0
missing=0

while IFS='|' read -r ts hash path; do
  ts="${ts//[[:space:]]/}"
  hash="${hash//[[:space:]]/}"
  path="${path## }"

  [[ -z "$ts" || -z "$hash" || -z "$path" ]] && continue

  if [[ ! -f "$path" ]]; then
    echo "[MISSING] $ts | $path"
    ((missing++))
    continue
  fi

  cur_hash="$(sha256sum "$path" | awk '{print $1}')"

  if [[ "$cur_hash" == "$hash" ]]; then
    echo "[OK] $ts | $path"
    ((ok++))
  else
    echo "[MISMATCH] $ts | $path"
    echo "  ledger: $hash"
    echo "  disk:   $cur_hash"
    ((bad++))
  fi
done < "$MASTER_LEDGER"

echo
echo "[VERIFY] Summary:"
echo "  OK:       $ok"
echo "  MISSING:  $missing"
echo "  MISMATCH: $bad"

if (( bad == 0 )); then
  echo "[VERIFY] STATUS 200: LEDGER CONSISTENT."
else
  echo "[VERIFY] STATUS 409: INTEGRITY VIOLATIONS DETECTED."
fi
