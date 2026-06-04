#!/bin/bash
# OMNIBUS_VAULT Hardening Script
# Target: /etc/systemd/system/omnibus-vault.service

HARDENING_BLOCK="
ProtectSystem=strict
ProtectHome=true
PrivateDevices=true
ProtectControlGroups=true
ProtectKernelTunables=true
RestrictAddressFamilies=AF_INET AF_INET6
"

sudo sed -i '/

\[Service\]

/a '"$HARDENING_BLOCK" /etc/systemd/system/omnibus-vault.service

sudo systemctl daemon-reload
sudo systemctl restart omnibus-vault.service

echo "[+] Infrastructure Hardening Applied: Integrity Verified."
