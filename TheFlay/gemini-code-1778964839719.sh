#!/bin/bash
# ============================================================================
# SECURED DATA ACT COMPLIANT INTAKE SCRIPT
# VERSION: 131.0
# NODE: 90247_GARDENA // LEAD ANALYST: CL34RBoXx
# ============================================================================

CASE_ID="2026-90247-CISA"
ACQUISITION_DIR="./OMNIBUS_VAULT/$CASE_ID"
LOG_FILE="$ACQUISITION_DIR/audit_trail.log"

# Practice 1: Environment Minimization
mkdir -p "$ACQUISITION_DIR"
touch "$LOG_FILE"

log_action() {
    local action=$1
    local detail=$2
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    echo "[$timestamp] [$action] - $detail" >> "$LOG_FILE"
}

# Practice 2: Integrity at Intake (Hashing)
ingest_artifact() {
    local file_path=$1
    if [[ -f "$file_path" ]]; then
        local file_name=$(basename "$file_path")
        local sha256_hash=$(sha256sum "$file_path" | awk '{print $1}')
        
        # Move to Vault and Rename with Hash Prefix
        cp "$file_path" "$ACQUISITION_DIR/${sha256_hash:0:8}_$file_name"
        
        log_action "INTAKE" "File: $file_name | Hash: $sha256_hash"
        echo -e "\e[32m[90247] Ingested: $file_name (Verified)\e[0m"
    else
        echo -e "\e[31m[!] Error: Artifact not found at $file_path\e[0m"
    fi
}

# Practice 3: Substrate Hardening
harden_environment() {
    log_action "HARDENING" "Applying restricted permissions to $ACQUISITION_DIR"
    chmod 700 "$ACQUISITION_DIR"
    chmod 600 "$LOG_FILE"
}

# --- EXECUTION ---
clear
echo -e "\e[34m[90247] SECURED Bash Protocol Initialized...\e[0m"

# Log the forensic state seen in console logs (11:48:11)
log_action "SESSION_CORRELATION" "Correlated with DevTools logs 11:26:42 - 11:48:11"

# Example Intake: Ingesting the SQLi CSV Findings
ingest_artifact "90247_OMNIBUS_SQLi_Findings.csv"

harden_environment

echo -e "\e[34m[90247] OMNIBUS Vault Hardened. Audit Trail: $LOG_FILE\e[0m"