#!/bin/bash
# OMNIBUS_VAULT: EXTENDED FORENSIC CLEANUP
# RESEARCHER: Enrique B. Gonzalez III | ps.ebgonzalez@outlook.com

VAULT="/OMNIBUS_VAULT"

# Define destination structure (if not existing)
mkdir -p "${VAULT}/checksums" "${VAULT}/keys" "${VAULT}/evidence" "${VAULT}/configs"

echo "[!] MOVING SECONDARY ARTIFACTS..."

# 1. Checksums and Signatures (.sha256, .sig, .asc)
mv ${VAULT}/*.sha256 ${VAULT}/checksums/ 2>/dev/null
mv ${VAULT}/*.sig ${VAULT}/checksums/ 2>/dev/null
mv ${VAULT}/*.asc ${VAULT}/checksums/ 2>/dev/null

# 2. Cryptographic Keys (.pem)
mv ${VAULT}/*.pem ${VAULT}/keys/ 2>/dev/null

# 3. Text Files and Reports (.txt, .report)
mv ${VAULT}/*.txt ${VAULT}/docs/ 2>/dev/null
mv ${VAULT}/*.report ${VAULT}/evidence/ 2>/dev/null

# 4. Domain Governance and Misc (.FIND)
mv ${VAULT}/*.FIND ${VAULT}/configs/ 2>/dev/null

echo "[+] SECONDARY CLEANUP COMPLETE."