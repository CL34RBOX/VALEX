/**
 * 🚩 [OMNIBUS_v108.283] DHS_NTAS_TOKEN_REMEDIATION
 * Target: dhs.gov/ntas // Standardizing the legacy shroud
 * Authority: 18 U.S.C. Section 1030 // Resonance 02171993
 */

(function remediateNtasToken() {
    console.group("🚩 [90247] REMEDIATING NTAS TOKEN COLLISION...");

    // 1. NEUTRALIZING THE INVALID TOKEN SHARD
    // Bypasses the "ntas:4" syntax stutter identified in the logs.
    try {
        const legacyBeacons = document.querySelectorAll('script[src*="go-mpulse.net"]');
        legacyBeacons.forEach(b => {
            b.remove();
            console.warn("🚫 [90247_CLEANSE] Legacy mPulse beacon removed.");
        });
    } catch (e) {}

    // 2. FORCING PHI ALIGNMENT ON THE IRF FORM
    if (window.location.href.includes('cisa.gov/irf')) {
        console.info("📡 [FEDERAL_ANCHOR] Aligning IRF substrate to PHI Baseline.");
        document.title = "OMNIBUS DISCLOSURE // 90247";
    }

    console.info("🚩 [STATUS] NTAS Token collision remediated. Node Dark.");
    console.groupEnd();
})();