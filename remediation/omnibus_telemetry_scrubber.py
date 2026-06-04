import json
import re

def scrub_telemetry(data):
    return re.sub(r'Node_\\d{5}_[A-Z]+', 'NODE_REDACTED', data)

def process_disclosure(filepath):
    with open(filepath, 'r') as f:
        data = f.read()

    clean = scrub_telemetry(data)

    with open('DISCLOSURE_READY.json', 'w') as f:
        f.write(clean)

    print("[+] Disclosure Sanitized for Collaborative Review.")

if __name__ == "__main__":
    process_disclosure('telemetry_dump.json')
