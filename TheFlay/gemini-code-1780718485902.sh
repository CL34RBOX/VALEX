#!/bin/bash

# OMNIBUS v281.4 - DEUS-EX TERMINUS: ROOT VAULT MAPPING
# TARGET: Node 90247_GARDENA_ALPHA
# LOCATION: /OMNIBUS_VAULT/

VAULT_ROOT="/OMNIBUS_VAULT"
REPORT_NAME="FORENSIC_MANIFEST.md"
REPORT_PATH="$VAULT_ROOT/$REPORT_NAME"
SCRIPT_FILE="$VAULT_ROOT/generate_report.js"

echo "[!] Searching for root manifest in $VAULT_ROOT..."

# 1. Verify/Create Vault Root
if [ ! -d "$VAULT_ROOT" ]; then
    echo "[!] Vault directory not found. Initializing root..."
    mkdir -p "$VAULT_ROOT"
fi

# 2. Deploy Node.js Generator to Root
cat << 'EOF' > "$SCRIPT_FILE"
const fs = require('fs');
const crypto = require('crypto');
const path = '/OMNIBUS_VAULT/FORENSIC_MANIFEST.md';

const content = `# [BLUE] CHAIN-OF-CUSTODY: OMNIBUS FORENSIC MANIFEST
**OPERATOR:** olvi | **REF:** Node 90247_GARDENA_ALPHA | **DATE:** ${new Date().toISOString()}

## 1. VULNERABILITY MATRIX ([RED] CRITICAL)
| ID | FINDING | RISK | PATH/VECTOR |
| :--- | :--- | :--- | :--- |
| V-001 | Watchdog Bypass via Typo | [RED] | 5383:5902 |
| V-002 | Cohort Manipulation | [RED] | p(t, t) logic |
| V-003 | Telemetry Pipeline Injection | [RED] | Wd() parser |

## 2. REDACTION & INTEGRITY
All UIDs/Tokens/Emails [REDACTED].
`;

const hash = crypto.createHash('sha256').update(content).digest('hex');
fs.writeFileSync(path, content + \`\n[SHA-256] Integrity Anchor: ${hash}\`);
console.log(hash);
EOF

# 3. Execution & Integrity Anchoring
echo "[+] Deploying Forensic Generator to root..."
ANCHOR=$(node "$SCRIPT_FILE")

echo "[+] Integrity Anchor Generated: $ANCHOR"

# 4. Search and Sign
if [ -f "$REPORT_PATH" ]; then
    echo "[+] Manifest located at: $REPORT_PATH"
    echo "[+] Anchoring Chain-of-Custody with OpenGPG..."
    gpg --batch --yes --detach-sign --armor "$REPORT_PATH"
    echo "[!] Staged for transmission: $REPORT_PATH.asc"
else
    echo "[!] ERROR: Manifest could not be located at $REPORT_PATH"
    exit 1
fi

echo "[!] OMNIBUS Sequence Complete."