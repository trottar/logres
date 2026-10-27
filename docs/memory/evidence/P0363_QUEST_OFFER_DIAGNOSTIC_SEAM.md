# P0363 — P0165/P0168 quest-offer stock suppression read-only diagnostic seam

**Baseline:** verified pushed GitHub main P0362 `ea4077d00c71e1b6720a3e9b7286ec108fcb9ad7` (committed 233/233 PREWRITE/POSTWRITE STATIC, `0.0.251-dev`). WoW runtime remains UNVERIFIED / DEFERRED; this is not an in-client acceptance claim.

## Narrow source observation

`Core/Commands.lua` still implements the 72-line `runQuestOfferStockSuppressionCheck()` status report. It reads only addon-owned `QuestOfferStockSuppression:GetDebugStatus()` and `QuestDialogue:GetDebugStatus()`: policy-eligible ordinary offers, requested/applied/snapshot ownership coherence, supported source commit and failure state. It emits exactly two lines, including `Logres questofferstocksuppressioncheck:` PASS/FAIL and the QuestFrame presentation ownership note. It does not read Blizzard frame presentation directly, inspect a secret-capable alpha restoration token, mutate a protected region or call native quest actions. `Quest/OfferStockSuppression.lua` loads before Commands and owns the debug status being reported.

## Proposed narrow implementation

Move the original function body unchanged except its declaration to `Suppression:RunDevQuestOfferStockSuppressionCheck(emit)` in `Quest/OfferStockSuppression.lua`; keep the existing local Commands wrapper with the same `emit` callback. Preserve `checkall` order, `/logres questofferstocksuppressioncheck`, Phase H developer-panel registration, the exact two lines and all original PASS/FAIL predicates. The older `check_quest_offer_stock_suppression_contract.py` checker migrates only source-location assertions for the report and requires its delegated wrapper. P0362 exact 233-checker ceiling becomes a >=233 floor without dropping any stock safety assertion. New P0363 static contract #234 verifies output, source owner, native fail-open policy, version parity, action counts, memory continuity and dispatch.

No stock click, frame, alpha, parent, event, timer, hook, quest action, restoration policy, camera or preference change is made. Importantly, P0165 and P0168 protection against inspecting opaque `snapshot.alpha`, broad QuestFrame suppression, secret-capable child access, and unsafe native quest action requests remains intact. No Lua TOC entry is added. Candidate `0.0.252-dev`, 94 Lua load entries, 120 panel actions/38 previews and persisted schema 3 unchanged. D-046 preview-first, frozen D-047 camera and offline-only D-048 five-domain model are unchanged.

## Static gates and negative evidence

The one-time applier requires exact P0362 main SHA, clean tracked baseline, complete 40-digit Git blob guards, uniquely matched source and legacy checker anchors, exact guard/payload path maps, version policy and memory size budgets. It constructs the entire candidate before tracked writes, requires 234/234 PREWRITE shadow static checks, prewrite whitespace hygiene, then 234/234 POSTWRITE static checks, `git diff --check` and a manifest. POSTWRITE error rolls back patch-owned tracked files. No STATIC result is presumed prior to actual WSL execution. Any refusal is a source/patch failure, not a runtime FAIL or PASS.

P0354 R0/R1/R2, P0355 R0/R1, P0358 R0, P0361 R0 handoff errors and other historical PREWRITE refusals remain in earlier evidence. L-022 focused-quest artifact, L-027 popup and L-028 target aura issue OPEN; L-019 distribution BLOCKED; L-031 compass environmental validation deferred. P0321 native GossipFrame stock restoration remains FIRST contingent in-client safety gate; November 4 contingent. WoW runtime UNVERIFIED. No WoW deployment or in-client check is requested for P0363.
