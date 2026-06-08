#!/bin/bash

# Target and Output configurations
DB_PATH="/home/enrique/vault/AppData/Local/Packages/Mozilla.Firefox_n80bbvh6b1yt2/LocalCache/Roaming/Mozilla/Firefox/Profiles/alxiazh7.default-release/storage/default/https+++shinyhunters.com/ls/data.sqlite"
OUTPUT_DIR="/VALEX"
OUTPUT_FILE="${OUTPUT_DIR}/sqlite_check_report.json"

# Check if output directory exists and is writable, otherwise try to create it
if [ ! -d "$OUTPUT_DIR" ]; then
    mkdir -p "$OUTPUT_DIR" 2>/dev/null
    if [ $? -ne 0 ]; then
        echo "[ERROR] Cannot create output directory $OUTPUT_DIR. Please ensure you have root/sudo privileges or write access."
        exit 1
    fi
fi

# Ensure output file can be written to
touch "$OUTPUT_FILE" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "[ERROR] Cannot write to $OUTPUT_FILE. Ensure permissions are correct."
    exit 1
fi

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

write_json_report() {
    local status="$1"
    local message="$2"
    local tables="$3"
    
    # Format tables list as a JSON array string if tables exist
    local tables_json="[]"
    if [ -n "$tables" ]; then
        # Replace spaces/newlines with JSON array format safely if jq is available
        tables_json=$(echo "$tables" | tr -s '[:space:]' '\n' | jq -R . | jq -s .)
        if [ $? -ne 0 ]; then
            # Fallback parsing mechanism if jq is not installed on the system
            tables_json="[$(echo "$tables" | tr -s '[:space:]' '\n' | sed 's/.*/"&"/' | paste -sd, -)]"
        fi
    fi

    cat << EOF > "$OUTPUT_FILE"
{
  "timestamp": "$TIMESTAMP",
  "database_path": "$DB_PATH",
  "status": "$status",
  "message": "$message",
  "tables": $tables_json
}
EOF
}

# 1. Check if the file exists and is not empty
if [ ! -f "$DB_PATH" ]; then
    write_json_report "ERROR" "File does not exist at the specified path." ""
    echo "[ERROR] File does not exist. Report written to $OUTPUT_FILE"
    exit 1
elif [ ! -s "$DB_PATH" ]; then
    write_json_report "EMPTY" "File exists but it is empty (0 bytes)." ""
    echo "[WARNING] File is empty. Report written to $OUTPUT_FILE"
    exit 0
fi

# 2. Check if sqlite3 CLI tool is installed
if ! command -v sqlite3 &> /dev/null; then
    write_json_report "DEPENDENCY_MISSING" "'sqlite3' command line tool is not installed." ""
    echo "[ERROR] 'sqlite3' tool missing. Report written to $OUTPUT_FILE"
    exit 1
fi

# 3. Verify database integrity and retrieve tables
TABLES=$(sqlite3 "$DB_PATH" ".tables" 2>&1)
EXIT_CODE=$?

if [ $EXIT_CODE -ne 0 ]; then
    write_json_report "CORRUPTED" "Failed to read the file. It may not be a valid SQLite database or it is corrupted. Details: $TABLES" ""
    echo "[ERROR] Database validation failed. Report written to $OUTPUT_FILE"
    exit 1
fi

# 4. Success handling
if [ -z "$TABLES" ]; then
    write_json_report "SUCCESS" "Database is valid but contains no tables." ""
    echo "[OK] Database is valid (empty tables). Report written to $OUTPUT_FILE"
else
    write_json_report "SUCCESS" "Database is valid and structure successfully read." "$TABLES"
    echo "[OK] Database check complete. Report written to $OUTPUT_FILE"
fi