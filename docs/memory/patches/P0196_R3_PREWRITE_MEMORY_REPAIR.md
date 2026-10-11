# P0196 R3 — correct failed R2 memory-check delivery

**Date:** 2026-10-11. **Baseline:** verified GitHub P0195 `9097f43e52cc9d8fe4626ff1917579b5a8f0c84a`. P0196 R1 and R2 **not pushed**.

**R1 runtime FAIL:** user screenshot shows loss of crafted Logres PlayerHelpfulAuras frames and substituted tiny 18px icons; runtime `native-surfaces` FAIL with `OnShow` hook unsupported on target aura object. Preserve these as failures, not acceptance.

**R2 delivery FAIL:** user supplied terminal output: R2 shadow `check_memory_health.py` reported `CURRENT_HANDOFF.md must point readers to CURRENT.md`. R2 had passed whitespace check, its own contract and earlier static checkers. It stopped before writing patch-owned files and no R2 runtime validation occurred. The R1 uncommitted working tree remained. Cause: `update_memory()` rebuilt `CURRENT_HANDOFF.md` omitting the required pointer to `../CURRENT.md`.

**R3 narrow repair:** include literal `Authority: `../CURRENT.md`` in generated handoff, add dedicated memory-health check before the remaining full static suite, preserve R2 failures and all project design decisions. R3 retains intended R2 correction: exact P0195 PlayerHelpfulAuras and native harmful/target status size/layout, disables the rejected native 18px helpful takeover, leaves unsupported contextual target aura fold open/fail-open, retains candidate pet secure routing and stock-access fallback. Addon candidate remains `0.0.106-dev`; no version bump is needed because R2 never applied. No damage meter or reporter changes.

**Validation:** static checks are not gameplay success. In WoW after successful apply, visually verify original framed buffs and correct placement and tooltip; ensure no small generic aura icons; test pet action and stock on-demand controls, Immersion OFF/ON, native access and Run All. Any Lua/taint/secret/protected/missing aura/visual error is FAIL. Never commit before runtime acceptance.
