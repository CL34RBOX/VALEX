#!/bin/bash
LOG_FILE=$1
WHITELIST_FILE="/VALEX_VAULT/manifests/whitelist.txt"
AUDIT_LOG="/VALEX_VAULT/logs/audit_run.log"

# Perform audit and log simultaneously
{
    echo "[+] VALEX Forensic Analysis: $(date)"
    echo "[+] Scanning $LOG_FILE against whitelist..."
    
    grep -E -o "https?://[a-zA-Z0-9.-]+" "$LOG_FILE" | \
    grep -v -f "$WHITELIST_FILE" | \
    sort -u > unauthorized_endpoints.txt

    if [ -s unauthorized_endpoints.txt ]; then
        echo "[!!!] SECURITY ALARM: Unauthorized endpoints found:" | tee -a "$AUDIT_LOG"
        cat unauthorized_endpoints.txt | tee -a "$AUDIT_LOG"
    else
        echo "[+] Audit Pass: No unauthorized exfiltration detected." | tee -a "$AUDIT_LOG"
    fi
} | tee -a "$AUDIT_LOG"
/*
EOF-METADATA-BEGIN
HASH: df5c4863e02558021c74eafc71afff049a4ad619de6d433607ecf89966a3922eb69f38900004dd8b72dc592be16f7ef632109656d259749ed4ded2ec29281f69
SIGNATURE: MEUCIEguXKvKVHkYctAM9YZ2lCXbQnJD3LhS9mTMtSw/PZcIAiEAwMVbn4hePvSdgmoPlYvRgPgOGQcFdI12cUxu3+Tw1yU=
TIMESTAMP: 2026-06-01T21:14:24Z
FILE: ./scripts/audit_ledger.sh
EOF-METADATA-END
*/
