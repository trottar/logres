# P0307 — trainer family compatibility and modularity diagnostic

Date: 2026-10-22. Baseline verified GitHub `main` P0306 `5acc447da13252fc651945033f4bb4c7b33b6add` (`0.0.207-dev`). **PREPARED, complete WSL and WoW tests UNVERIFIED.**

## Observed in-client result

User uploaded two screenshots after P0306 and said: "Class trainer works as expected no issues. Went to another trainer and its the blizzard frame." The class-trainer image shows one Logres trainer without a visible Blizzard duplicate: **scoped P0306 visual/parking PASS**. The second shows Grimnur Stonebrand <Fishing Trainer> in Ironforge with a Blizzard-owned training window (Journeyman Fishing already known) and no Logres panel. This confirms the service-family divergence but does NOT establish the underlying reason or whether manual H Live Trainer would support that profession. It does not establish purchase while parked, full Goodbye stock restoration, other profession families, or long-session behavior.

## Narrow hypothesis

Shared `NPCServiceSession.lua` is tied to normalized interaction type 7, source root `ClassTrainerFrame`, and readiness `TRAINER_SHOW` / `TRAINER_UPDATE`. The current `NPCTrainerLiveTrial` source probe also guards type 7. Separate native profession sessions might expose a different normalized type, different native frame, or different readable source data. **These alternatives are UNVERIFIED**; do not guess an enum or bypass guards. `TrainerPurchaseTrial.QuoteAll` explicitly denies an `IsTradeskillTrainer()` true source, so copying class Train All to fishing would be unsafe. The reusable catalogue/rendering methods are already independent of native services, but family classification needs actual client evidence.

## P0307 targeted diagnostic

Add one read-only trainer-family source probe and one explicit developer H-panel action. It reads only separately ordinary values from state, `ClassTrainerFrame:IsProtected/IsShown`, `IsTradeskillTrainer`, `GetNumTrainerServices`, and bounded first-row `GetTrainerServiceInfo`. A row is classified by already-safe field shape, without printing a potentially secret native value. Captures only addon-owned live/session audit state. It never buys, selects, parks, closes, moves, skins, scans a full roster, uses a timer or polls. The H panel output is saved to Logres diagnostics by the existing command path. Blizzard stock remains available for fishing. One click per trainer visit is sufficient.

## R0 negative result and R1 checker-set repair

The user ran the original P0307 archive against the exact clean P0306 baseline. SHA-256, source blobs, candidate source anchors, memory headings and prewrite whitespace gates **PASS**. The applier then stopped with **`P0307: FAIL PREWRITE: unexpected checker count 178`**. This is an assistant-authored installer invariant error, not a Lua/client capability failure. Independently inspected GitHub P0306 tree contains exactly **177 tracked `tools/check_*.py` scripts**; the prepared candidate correctly adds **one**, making **178**. R0 incorrectly demanded at least 179. **R0 PREWRITE FAIL; zero tracked writes**; no rollback or redeployment needed.

**R1 content repair:** derive the expected checker filename set from the pinned baseline and add precisely the P0307 checker. PREWRITE shadow and POSTWRITE checkout must each contain that exact set and every script must return PASS. This avoids both false failure from a stale count and silent omission of a check. **R1 full WSL checker suite and WoW compatibility diagnostic remain UNVERIFIED until tested.** No read-only probe logic, native frame policy, transaction guard, visual geometry, camera or class-trainer behavior is changed by R1.

## Tests and limits

After full static WSL PASS and deploy, visit Grimnur Stonebrand with stock Fishing Trainer open, then `/logres panel` -> H — Integration and Polish -> **Trainer Family Check (READ-ONLY)**. Inspect status, `interactionType`, `professionTrainer`, `nativeShown`, `nativeProtected`, `serviceCount`, `service1Type`, `source`, `session`, and `live`. If no in-game action is available or safe, record environmental deferral instead of PASS. Do not spend currency merely for evidence. Class trainer regressions and taint/secret/Lua failures are real FAIL. This checkpoint is an evidence-first modularity test, **no purchase and no parking change**.

## Next implementation

Use observed ordinary service-family data to route a profession-specific guarded adapter through the **existing** portrait-free Logres landscape and shared catalogue. Retain Blizzard input/purchases for any family whose transaction gates are not independently proven. When class-parking lifecycle and purchase while parked are tested, finalize class trainer recovery separately. Then gossip, merchant, flight in the established order.
