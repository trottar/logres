# P0352 — Lifecycle diagnostic ownership seam

**Verified source baseline:** pushed GitHub `main` P0351 `e8b71bc59a04f3077925bb24f0d6850a71340841` (222/222 PREWRITE/POSTWRITE STATIC; version `0.0.240-dev`). WoW client UNVERIFIED. P0321 GossipFrame stock restoration FIRST contingent in-client gate. L-022/L-027/L-028 remain OPEN; L-019 public license BLOCKED.

## Targeted source finding

`Core/Commands.lua` owns `runLifecycleCheck()`, which explicitly enables then disables its registered `DevLifecycleProbe`; it also toggles and restores `immersionEnabled` twice to test preference subscriptions while enabled and disabled. The diagnostic is **effectful**, not a passive audit. The module lifecycle rules are owned by `Core/Modules.lua`, which already loads before Commands. Critically, `DevLifecycleProbe` registration is currently in Commands and registration order is authoritative for module initialization. Moving the registration itself to earlier-loaded Modules would change initialization order and is not a behavior-preserving extraction. The old `check_module_contract.py` and P0175 `check_status_aura_disabled_contract.py` require that registration and original command-local wrapper to remain.

## Narrow candidate

Move only the original body unchanged into `Logres:RunDevLifecycleCheck(emit, lifecycleProbe, lifecycleProbeModule)` in `Core/Modules.lua`. Leave the original `DevLifecycleProbe` definition, counter table, registration point, `runLifecycleCheck()` wrapper, Run All ordering, slash command and phase-0 developer-panel action in Commands. Forward the existing probe objects and emitter explicitly, without new global state. The original PASS/FAIL strings, counters, tests, enable/disable order, preference changes and native resource-cleanup expectations are preserved. Add version parity `0.0.241-dev` and new static checker #223; 94 Lua/120 actions/38 P previews unchanged.

## Scope and evidence gate

Candidate applier checks exact pushed baseline and relevant Git blobs, refuses tracked working-tree drift, constructs a shadow candidate, runs all 223 historical + new STATIC checkers before touching tracked files, checks candidate whitespace, applies transactionally, runs all 223 POSTWRITE, `git diff --check`, then emits manifest. The static checker preserves both P0175 and original A.4 module safety contracts rather than migrating them. No new event, timer, protected/native frame inspection, polling, schema migration, D-048 live selector or Camera change; no FPS or in-game PASS is claimed.

## Pending acceptance

P0352 runtime: **UNVERIFIED / DEFERRED** while WoW Forever beta is inaccessible. P0321 GossipFrame restore remains first contingent client gate; subsequent natural gameplay L-022 artifact, L-027 popup frame attribution and L-028 aura evidence remain OPEN. All historical refused appliers and negative evidence (including P0349 R0, P0347 R0) are preserved. Do not stage a candidate if any PREWRITE checker refuses.
