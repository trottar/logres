# P0362 — Read-only stock action replacement diagnostic ownership

**Source baseline:** verified pushed P0361 R1 main `c5aa34c12939aaedefaf9a9bf86ad0536ca88936`, committed manifest 232/232 PREWRITE/POSTWRITE STATIC, version `0.0.250-dev`; WoW runtime UNVERIFIED / DEFERRED. The P0361 R0 assistant handoff failure remains documented in P0361 evidence and is not runtime evidence.

## Narrow hypothesis and evidence

`runStockReplacementCheck()` in `Logres/Core/Commands.lua` is a read-only diagnostic reporting addon-owned StockActionReplacement status: requested/applied versus immersion intent, snapshot readiness, pending/failure, Bar 2/3/4/5 alpha, mouse and binding routing, stock main and unsupported-bar preservation, and lifecycle source deferrals/retry event. It emits PASS plus extras plus startup status, or FAIL plus startup status (five format emissions in two branches). It samples existing GetDebugStatus, not new protected/native state. The already-loaded `Actions/StockReplacement.lua` is the appropriate owner, with Commands retaining the dispatcher.

## Scope and historical contracts

Extract the original diagnostic body byte-for-byte except its method declaration as `StockReplacement:RunDevStockReplacementCheck(emit, boolText)`. Retain the original local Commands wrapper, `/logres stockreplacecheck`, phase-C developer panel, Run All position after primary ownership and before immersion, and all unchanged output. The pre-existing `handleStockReplacement` command, native stock frame restoration, protected routing, combat deferral and non-polling retry behavior remain untouched.

Migrate ONLY diagnostic-location assertions in `tools/check_stock_replacement_contract.py` and `tools/check_stock_startup_recovery_contract.py`. Keep native safety prohibitions, source-readiness handling and deferred lifecycle checks intact. P0361 historical checker already uses a minimum count >=232, so no P0361 checker modification is needed. New checker #233 enforces exact forwarding, report semantics, native-safe scope, route/counts, former checker migration, memory and version parity. Candidate `0.0.251-dev`, 94 Lua load entries, 120 developer-panel actions/38 previews, saved schema 3 and offline-only D-048 unchanged; no new event, hook, timer, polling, camera or client side effect is intended.

## Validation and negative evidence

The transactional applier checks exact pushed main SHA, clean tracked state, full 40-hex Git blob IDs for all 13 changed tracked files, unique source anchors, payload inventory and memory budgets. The complete **233/233 PREWRITE shadow STATIC** check is required before a tracked write; the complete **233/233 POSTWRITE STATIC** suite plus `git diff --check` must pass before generating a manifest. Failure before writes is REFUSED, not PASS or WoW FAIL. POSTWRITE failure restores patch-owned sources. No local full repository static run is claimed because the delivery container cannot resolve GitHub to materialize a complete checkout; user's WSL gate remains mandatory.

P0321 native GossipFrame stock restoration is the FIRST contingent in-client gate. WoW runtime UNVERIFIED / DEFERRED; no deployment or in-game test is requested for P0362. L-022 focused quest visual artifact, L-027 native transient popups and L-028 target debuff inconsistency OPEN; L-019 public distribution BLOCKED; L-031 environmental validation deferred. Historical P0354 R0/R1/R2, P0355 R0/R1, P0358 R0 and P0361 R0 handoff failure remain preserved in their existing records. Negative or failed P0362 attempts must be recorded if WSL refuses; do not reinterpret static evidence as runtime acceptance.
