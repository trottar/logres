# P0346 — Architecture health source inventory and regression boundary

- **Baseline:** P0345 pushed `626b22038d09e738bd3fa90684e3a95e36905d45`; manifest 216/216 static PREWRITE/POSTWRITE, client UNVERIFIED.
- **Source finding:** 94/94 loaded Lua, 120 developer-panel actions, 38 P-tab previews, ~241 KB cross-domain command dispatcher. Existing P0323 and P0324 D-048 module/32-domain fixtures cover design/static validation, not five live independent D-048 switches.
- **Change:** add pure `tools/architecture_health_audit.py` and checker #217, plus prioritized `docs/memory/architecture/P0346_ARCHITECTURE_GAP_REGISTER.md`, evidence and memory pointers. Preserve all addon-loaded source and current P panel inventory byte-for-byte; no source-version bump.
- **Safety:** no native UI mutation, frame observation, combat action, secret value, polling, user setting, saved schema, camera or public release. P0321 first runtime gate on contingent November 4. L-022/L-027/L-028 OPEN, L-019 BLOCKED.
- **Acceptance:** 217/217 full PREWRITE candidate and POSTWRITE source checkers, actual audit on WSL checkout, diff hygiene and manifest. **STATIC ONLY / WoW UNVERIFIED**.
