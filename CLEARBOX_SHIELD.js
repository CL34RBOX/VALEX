// ===== CLEARBOX_SHIELD EOF =====
// End of CLEARBOX_SHIELD.js
// Version: 2026-06-04
// Integrity: Signed manifest required; any runtime modification must trigger alert.
// DO NOT ADD CODE BELOW THIS LINE
(function () {
  'use strict';
  const _CLEARBOX_EOF = Object.freeze({
    name: 'CLEARBOX_SHIELD',
    version: '2026-06-04',
    eof: true,
    expectedSeal: 'your_real_signed_manifest_seal_here', 
    loadedAt: new Date().toISOString()
  });
  try {
    if (!Object.prototype.hasOwnProperty.call(window, '__CLEARBOX_SHIELD__')) {
      Object.defineProperty(window, '__CLEARBOX_SHIELD__', {
        value: _CLEARBOX_EOF,
        writable: false,
        configurable: false,
        enumerable: false
      });
    }
  } catch (e) { console.debug('CLEARBOX EOF: defineProperty failed', e?.message); }
  function _eofTamperNotify(detail) {
    try {
      const evt = { type: 'clearbox-eof-tamper', detail, ts: new Date().toISOString() };
      if (navigator.serviceWorker && navigator.serviceWorker.controller) {
        navigator.serviceWorker.controller.postMessage({ clearbox_event: evt });
      } else if (typeof fetch === 'function') {
        fetch('/_local-clearbox-audit', {
          method: 'POST',
          credentials: 'omit',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(evt)
        }).catch(() => {});
      } else {
        console.warn('CLEARBOX EOF tamper', evt);
      }
    } catch (err) { console.debug('CLEARBOX EOF notify failed', err?.message); }
  }
  (function observeCurrentScript() {
    try {
      const script = document.currentScript || Array.from(document.scripts).slice(-1)[0];
      if (!script || !script.parentNode) return;
      const mo = new MutationObserver((mutations) => {
        for (const m of mutations) {
          if (m.type === 'attributes') {
            _eofTamperNotify({ reason: 'attribute-change', attribute: m.attributeName, scriptSrc: script.src || null });
          } else if (m.type === 'characterData' || m.type === 'childList') {
            _eofTamperNotify({ reason: 'content-change', scriptSrc: script.src || null });
          }
        }
      });
      mo.observe(script, { attributes: true, attributeFilter: ['src', 'integrity', 'type'], childList: true, subtree: true, characterData: true });
      const parentMo = new MutationObserver((mutations) => {
        for (const m of mutations) {
          if (m.type === 'childList') {
            for (const removed of m.removedNodes) {
              if (removed === script) {
                _eofTamperNotify({ reason: 'script-removed', scriptSrc: script.src || null });
              }
            }
          }
        }
      });
      parentMo.observe(script.parentNode, { childList: true });
      Object.defineProperty(window, '__CLEARBOX_EOF_OBSERVERS__', {
        value: { mo, parentMo },
        writable: false,
        configurable: false,
        enumerable: false
      });
    } catch (e) {}
  })();
  try { if (window.CLEARBOX_SHIELD && typeof window.CLEARBOX_SHIELD === 'object') Object.freeze(window.CLEARBOX_SHIELD); } catch (e) {}
  try { Object.defineProperty(window, '__CLEARBOX_SHIELD_EOF__', { value: true, writable: false, configurable: false, enumerable: false }); } catch (e) {}
  setTimeout(() => {
    try {
      const sealOk = (window.__CLEARBOX_SHIELD__ && window.__CLEARBOX_SHIELD__.expectedSeal === _CLEARBOX_EOF.expectedSeal);
      if (!sealOk) {
        _eofTamperNotify({ reason: 'seal-mismatch', expected: _CLEARBOX_EOF.expectedSeal, found: window.__CLEARBOX_SHIELD__?.expectedSeal || null });
      } else {
        CLEARBOX_CONFIG?.integrityHook?.({ type: 'eof-heartbeat', ts: new Date().toISOString(), seal: _CLEARBOX_EOF.expectedSeal });
      }
    } catch (e) {}
  }, 2500);
})();
 // ===== CLEARBOX_SHIELD EOF =====
 // End of CLEARBOX_SHIELD.js
 // Version: 2026-06-04
 // Integrity: Signed manifest required; any runtime modification must trigger alert.
 // DO NOT ADD CODE BELOW THIS LINE
 /* EOF */
