╔══════════════════════════════════════════════════════════════════════════════╗
║  ██████╗██╗     ███████╗ █████╗ ██████╗ ██████╗  ██████╗ ██╗  ██╗██╗  ██╗  ║
║ ██╔════╝██║     ██╔════╝██╔══██╗██╔══██╗██╔══██╗██╔═══██╗╚██╗██╔╝╚██╗██╔╝  ║
║ ██║     ██║     █████╗  ███████║██████╔╝██████╔╝██║   ██║ ╚███╔╝  ╚███╔╝   ║
║ ██║     ██║     ██╔══╝  ██╔══██║██╔══██╗██╔══██╗██║   ██║ ██╔██╗  ██╔██╗   ║
║ ╚██████╗███████╗███████╗██║  ██║██║  ██║██████╔╝╚██████╔╝██╔╝ ██╗██╔╝ ██╗  ║
║  ╚═════╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝  ║
╠══════════════════════════════════════════════════════════════════════════════╣
║  CLASSIFICATION : CONFIDENTIAL — STAGING                                    ║
║  PACKAGE DATE   : 2026-05-12  |  ASSEMBLED : 18:34 PDT                      ║
╚══════════════════════════════════════════════════════════════════════════════╝

                        TEST HARNESS — README
                NIST Staging Forensic Package — Test Scripts
══════════════════════════════════════════════════════════════════════════════

FILES IN THIS HARNESS
─────────────────────
  01_waf_csp_sentry_validate.sh  — Main bash validation suite
  02_curl_replay_snippets.sh     — Exact curl replays per evidence item
  03_node_replay.mjs             — Node.js async replay with assertions
  README.txt                     — This file

PREREQUISITES
──────────────
  Bash:  bash >= 4.x, curl >= 7.x, sha256sum (GNU coreutils)
  Node:  Node.js >= 18 (ESM + built-in crypto/https)
  Auth:  Run from staging network or VPN with access to nist-stg.example.gov

USAGE
──────
  # Bash validation suite
  chmod +x 01_waf_csp_sentry_validate.sh
  ./01_waf_csp_sentry_validate.sh 2>&1 | tee validate_run_$(date +%Y%m%d_%H%M%S).log

  # Curl replays (observe headers/bodies manually)
  chmod +x 02_curl_replay_snippets.sh
  ./02_curl_replay_snippets.sh 2>&1 | tee curl_replay_$(date +%Y%m%d_%H%M%S).log

  # Node.js replay
  node 03_node_replay.mjs 2>&1 | tee node_replay_$(date +%Y%m%d_%H%M%S).log

INTERPRETING RESULTS
─────────────────────
  [PASS]  Check passed — remediation action confirmed effective
  [FAIL]  Check failed — remediation action NOT yet applied or regressed
  [WARN]  Ambiguous result — manual review required

EVIDENCE MAPPING
─────────────────
  NST-STG-0001 → Tests 1, curl-1, node-1   (Telemetry beacon)
  NST-STG-0002 → Tests 2,3, curl-2, node-2 (CSP violations)
  NST-STG-0003 → Test 4, curl-3, node-3    (Sentry PII exposure)
  NST-STG-0004 → Test 5, curl-4, node-4    (Service Worker intercept)

NOTE: All test payloads use [REDACTED] placeholders for uid/session/token/email.
      CID is SHA-256 hashed in all test payloads.

CLASSIFICATION: CONFIDENTIAL — STAGING
