import { createHash } from 'crypto';
import { readFileSync, readdirSync } from 'fs';

const vaultPath = '/OMNIBUS_VAULT';
const manifest = JSON.parse(readFileSync('manifest/manifest.json', 'utf8'));

function checksum(data) {
    return createHash('sha256').update(data).digest('hex');
}

const files = readdirSync(vaultPath);

files.forEach(file => {
    const content = readFileSync(\`\${vaultPath}/\${file}\`);
    const hash = checksum(content);

    if (manifest.files[file] !== hash) {
        console.error(\`[ALERT] Integrity Mismatch: \${file}\`);
        process.exit(1);
    }
});

console.log("[+] Integrity Verification Passed.");
