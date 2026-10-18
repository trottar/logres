# P0252 — Complete Quest action visual parity

Baseline: verified GitHub main `45d46544b26a7111c5cf1ffc6226e78663b3e4a4`, P0251 R3. Scope is *visual only* in `Quest/Dialogue.lua` plus runtime version, checker and memory updates.

Changes: same offer-control button factory and textures; raise completion rule draw layer, tighten the panel-to-action gap by 10 UI units, remove "Complete Quest below" from the owned reward footer (not from stock fallback). No claim dispatch mutation or API changes. Static checks are run transactionally by the applier. In-client appearance and protected state remain UNVERIFIED until separately tested. Preserve quest 237 and prior failures. P0251 R3 OFF→ON is now scoped PASS from user and load334 diagnostics, while claim still DEFERRED.

## P0252 R0 — prewrite memory-health failure; R1 correction (2026-10-18)

User verified the original P0252 ZIP SHA-256 `b0505f040da242b211f25dc1f568cbee08c46eab19a0bbefb2dcabd396b8dc67`. Its applier reported exact pushed P0251 baseline PASS and unique source/memory transforms PASS, then **REFUSED in shadow validation before any tracked writes**. `tools/check_memory_health.py` reported `ERROR: CURRENT_HANDOFF.md must point readers to CURRENT.md` because the generated replacement handoff failed to reference its authority file. It also reported `WARNING: CURRENT.md exceeds 10 KB soft maintenance threshold`; that is a nonfatal, pre-existing maintenance warning, not the refusal cause. `git status --short` showed only the unrelated, previously untracked P0214/P0215/P0219 preview PNGs; no new manifest was created. This is a patch-authoring failure, **not a WoW runtime failure**.

R1 adds an explicit `docs/memory/CURRENT.md` authority reference in the replacement handoff, adds a prewrite guard for the required `CURRENT.md` token, and leaves all proposed runtime source transforms and claim behavior identical. Repository full shadow/postwrite static checks and WoW visual acceptance remain UNVERIFIED until the corrected applier is run and deployment is tested. R0 is CLOSED as a prewrite failure; no rollback, Git reset, or rebase is necessary.
