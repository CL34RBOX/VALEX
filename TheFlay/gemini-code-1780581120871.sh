#!/bin/bash
# OMNIBUS_VAULT: AUTOMATED ORGANIZATION SCRIPT
# RESEARCHER: Enrique B. Gonzalez III | ps.ebgonzalez@outlook.com

VAULT="/OMNIBUS_VAULT"

# Define destination structure
mkdir -p "${VAULT}/logs" "${VAULT}/archives" "${VAULT}/configs" "${VAULT}/scripts" "${VAULT}/evidence" "${VAULT}/docs" "${VAULT}/telemetry" "${VAULT}/static"

echo "[!] STARTING ORGANIZATION..."

# 1. Move Logs
mv ${VAULT}/*.log ${VAULT}/logs/ 2>/dev/null
mv ${VAULT}/*system_activity.log ${VAULT}/logs/ 2>/dev/null

# 2. Move Archives
mv ${VAULT}/*.tar.gz ${VAULT}/archives/ 2>/dev/null
mv ${VAULT}/*.tgz ${VAULT}/archives/ 2>/dev/null

# 3. Move Scripts
mv ${VAULT}/*.sh ${VAULT}/scripts/ 2>/dev/null
mv ${VAULT}/*.js ${VAULT}/scripts/ 2>/dev/null

# 4. Move Manifests and JSON
mv ${VAULT}/*.json ${VAULT}/configs/ 2>/dev/null
mv ${VAULT}/manifest* ${VAULT}/configs/ 2>/dev/null

# 5. Move Evidence
mv ${VAULT}/evidence_* ${VAULT}/evidence/ 2>/dev/null
mv ${VAULT}/Flagged ${VAULT}/evidence/ 2>/dev/null

# 6. Move Docs
mv ${VAULT}/HTMLfILES ${VAULT}/docs/ 2>/dev/null
mv ${VAULT}/TEXTFILES ${VAULT}/docs/ 2>/dev/null

echo "[+] ORGANIZATION COMPLETE."