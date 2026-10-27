# P0357 — F.6 objective progress read-only diagnostic ownership

**Verified baseline:** GitHub `main` P0356 `56afe0f9c99f522de8d1980994bf4b1dc2f21e1f`, committed manifest 227/227 PREWRITE and POSTWRITE STATIC, `0.0.245-dev`; WoW UNVERIFIED. The module `Quest/Progress.lua` already owns `QuestObjectiveProgress` and loads before Commands.

## Hypothesis and narrow extraction

The original `runObjectiveProgressCheck()` in Core/Commands uses only `GetModuleStatus("QuestObjectiveProgress")` and the module's `GetDebugStatus()`; it does **not** query live quest objectives, mutate UI, drive timers, or inspect Blizzard frames. Its 3,292-character report body may reside in Quest/Progress, while Commands retains the exact wrapper, emit sink, Run All ordering, slash dispatch and Phase F panel.

P0357 moves the unchanged report body (except function signature) to `Progress:RunDevObjectiveProgressCheck(emit)`. The original `check_objective_progress_contract.py` is migrated narrowly: F.6 forbidden source/control operations, secret-container-first inspection, layout bounds and native fallback policies remain; only diagnostic ownership moves from Commands to Progress. P0356's exact 227-checker count is migrated to a 227-checker floor, retaining all prior checks. New #228 contract verifies report text, source ownership, safety, routes, version parity, inventories and historical memory continuity.

## Proof and limitations

Source-checking at construction identified the original report and F.6 contract migration as single unique source anchors. The guarded WSL applier refuses unexpected Git baseline/blob state, builds a shadow candidate, executes **228/228** PREWRITE static checkers before writing tracked files, executes the same 228 checks POSTWRITE, rolls back its files on postwrite failure, checks whitespace and writes a manifest only on successful checks. All schema 3, camera, D-046/D-047/D-048 policy, stock action/quest controls and native GossipFrame remain unchanged.

WoW runtime remains **UNVERIFIED / DEFERRED**, not PASS. P0321 native GossipFrame restoration remains FIRST contingent client safety gate. L-022 focused quest artifact, L-027 transient popup and L-028 target aura inconsistency remain OPEN; L-019 public distribution remains BLOCKED, L-031 natural compass validation DEFERRED.

## Negative results retained

Historical P0354 R0/R1/R2 and P0355 R0/R1 prewrite failures remain in their evidence and active handoff; none wrote tracked files. P0356 had no reported failed apply. P0357 has no reported negative runtime result; the lack of a client prevents acceptance. Any new checker failure must be captured as an explicit refusal and corrected in a subsequent patch rather than counted as PASS.
