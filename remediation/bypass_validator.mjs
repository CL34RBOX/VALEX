const config = {
  weights: { dom: 0.35, global: 0.40, infra: 0.25 },
  thresholds: { critical: 0.75, high: 0.50, medium: 0.25 }
};

export function validateConfig(cfg = config) {
  const { dom, global, infra } = cfg.weights;
  const sum = dom + global + infra;

  if (Math.abs(sum - 1) > 1e-6) throw new Error("Weight sum must equal 1");

  const { critical, high, medium } = cfg.thresholds;
  if (!(critical > high && high > medium)) throw new Error("Invalid threshold ordering");

  return true;
}

export function bypassScore(dom, global, infra, cfg = config) {
  const w = cfg.weights;
  return dom * w.dom + global * w.global + infra * w.infra;
}

export function classify(score, cfg = config) {
  const t = cfg.thresholds;
  return score >= t.critical ? "CRITICAL"
       : score >= t.high ? "HIGH"
       : score >= t.medium ? "MEDIUM"
       : "LOW";
}

if (import.meta.url === \`file://\${process.argv[1]}\`) {
  validateConfig();
  const s = bypassScore(0.8, 0.2, 0.1);
  console.log("Bypass Score:", s);
  console.log("Severity:", classify(s));
}
