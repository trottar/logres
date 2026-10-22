# P0309 — guarded one-skill profession trainer transaction

2026-10-22. Source baseline GitHub `main` P0308 `78a0c03ddb89de8e7042c9772619d9f055463743` (0.0.209-dev). **PREPARED / complete WSL static and WoW runtime UNVERIFIED.** No native profession purchase has yet been observed through Logres.

## User evidence and distinct trainer-family outcomes

- P0308 **class PASS (user report)**: only Logres is on screen, class Goodbye closes cleanly and Blizzard does not reappear. This supersedes the P0306 expected restore-only test and separately validates the P0308 close workflow. User did not retest purchases with stock parked: **UNVERIFIED**.
- P0308 **Cooking/Enchanting PASS within presentation scope**: same Logres catalogue, Blizzard training controls remain visible and usable, profession Goodbye only dismisses the Logres panel. **No Logres profession purchase has yet been tested.** Treat presentation as PASS, transactions as UNVERIFIED. Earlier screenshots had matching profession service rows and prices but not transaction execution.
- P0307 **Fishing source-empty**: normalized type 7, IsTradeskillTrainer true, native frame shown/unprotected but GetNumTrainerServices returned 0 for Grimnur Stonebrand. This remains **OPEN / SOURCE EMPTY / BLIZZARD FALLBACK**; no synthetic service rows or guessed behavior.

## Narrow source analysis

The original P0296 one-skill transaction controller rechecks native identity, price, funds and available service, but does not explicitly reject profession trainers. Class Train All already requires IsTradeskillTrainer() ordinary false and native frame shown. `GetTrainerServiceCost` has multiple potential values (money, talent, profession resource cost). The P0309 profession adapter explicitly guards all three returns, rejecting any unreadable or nonzero additional cost. The native service's `available` identity must match the selected captured row, and if the probe reported a skill requirement, it must still match before purchase. Preserve the class controller as class-only and use the profession controller only after fresh ordinary family classification.

## Single-service design and safety

P0309 creates a separate `NPCTrainerProfessionPurchaseTrial.Attempt(row,snapshot)` called only by explicit click on the existing Train selected (TEST) region when snapshot profession is ordinary true. The attempt checks normalized interaction type 7, noncombat state, ordinary IsTradeskillTrainer true, safe shown nonprotected native root, same trainer name/count, identical live service name/rank/icon/level, matching reported skill requirement, exactly matching money cost and wallet, and no unsupported extra-resource costs. Any changed/ambiguous data **DEFERS**, leaving usable native controls. One `pcall(BuyTrainerService,index)` at most, no retries, timers, automatic purchase or bulk transaction for profession trainers. The native `ClassTrainerFrame` remains visible per P0308 parking gate; Logres auto-dismisses after an issued request so a stale catalogue cannot be clicked again. A successful pcall is an issued request, not proof of training. D-046 preview model and renderer unchanged; D-047 service-specific transaction ownership maintained.

## Client validation scope

After WSL PREWRITE/POSTWRITE PASS, user commit/push, independent GitHub verification, deployment and `/reload`: open Cooking or Enchanting naturally (no H action needed), verify Blizzard remains visible, search/selection and disabled actions. If a service is available, affordable and the user intends to buy it, click its row then **Train selected (TEST)** once. Confirm skill learned/cost in native Blizzard. Do not manufacture purchases or travel to find a particular recipe; if unavailable, defer this runtime transaction gate. Verify class trainer opens Logres only and Goodbye closes; no class re-purchase necessary. Fishing should continue stock-only when service count 0. Any Lua/protected/secret error is a real FAIL, not a deferred PASS. Static checks cannot prove native training success.

## Negative result retention

P0303 R0 checkers and P0307 R0 checker-count failures remain in their canonical records. P0304 automatic trainer first entry failed, repaired by P0305. P0306 parking originally removed native profession input: P0308 fixed by retaining visible Blizzard for professions. These historical failures must not be erased because P0309 shares their infrastructure. No new failure inferred from this proposed checkpoint.
