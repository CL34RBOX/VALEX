#!/bin/bash

# OMNIBUS PHOENIX: DATABASE TELEMETRY INSPECTOR
# TARGET: /OMNIBUS_VAULT/ingress_discovery.sqlite
# USAGE: ./inspect_ingress.sh

DB_PATH="/OMNIBUS_VAULT/ingress_discovery.sqlite"

if [ ! -f "$DB_PATH" ]; then
    echo "[PHOENIX_AUDIT] ERROR: Database not found at $DB_PATH"
    exit 1
fi

echo "[PHOENIX_AUDIT] Querying telemetry shards from $DB_PATH"
echo "--------------------------------------------------------"

# List all tables to identify the storage schema
echo "TABLES:"
sqlite3 "$DB_PATH" ".tables"

# Extract all records (assuming a standard dnsrecon schema)
echo -e "\nRECORDS:"
sqlite3 -header -column "$DB_PATH" "SELECT * FROM dns_records;"

echo -e "\n[PHOENIX_AUDIT] Extraction complete."