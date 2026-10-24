# P0326 — merchant and flight-master source audit evidence

## Baseline
Verified GitHub `main` at P0325 `c596fe24462d1cabd6c8027f46f713ba0d10da8f`. Read-only inspection of `NativeServicePolicy.lua`, `NativeServiceCapabilities.lua`, `ServiceElementIndex.lua`, `NPCServiceSession.lua`, `NativeServicePlacementTrial.lua`, `NPCServiceNativeParking.lua`, `NPCGossipStockParking.lua`, `NPCGossipSource.lua`, `NPCGossipPresentation.lua`, `OptionModel.lua`, `Camera/WorldCombat.lua`, `Core/State.lua` and the registered developer-panel controls in `Core/Commands.lua`.

## Positive source observations
- Merchant `MerchantFrame` is a candidate in policy, metadata audit and geometry trial (native type `5`); shop/repair/buyback remains Blizzard owned.
- Flight family policy names `FlightMapFrame` but element index names `TaxiFrame` and Classic children. Read-only capability auditor inventories both; there is no proof which actually owns Forever route map, fare or click behavior.
- `NPCServiceSession.Register("trainer", ...)` is the only live registry call in its module. Native service readiness hooks are trainer-specific. Distinct gossip/trainer parking remains capability-gated and not generalizable to merchant/flight from static similarity.
- H **Native Service Frame Audit** and H **Native NPC Services Check** are registered read-only developer-panel actions; H **Native Auto Position (TEST)** is a mutation trial and is explicitly excluded from baseline inspection.

## Negative / deferred result
**No merchant, flight, fare, buying, selling, repair, map, restoration or taxi gameplay was executed.** No new reproducible runtime defect can be claimed, and there is no merchant/flight runtime PASS. This result is source-only. `FlightMapFrame` vs `TaxiFrame` is **UNRESOLVED SOURCE CANDIDATE**, not a verified client discrepancy. P0321 gossip parking remains **WoW UNVERIFIED / DEFERRED until November 4**. Preserve L-003/L-004, all historical failures, D-047 camera freeze, stock fallback and Quest 237. P0326 creates docs and one static checker only; no Lua or runtime change and no WoW redeploy.

## Verification expectations
The applier must enforce exact pushed P0325 main, committed blob guards, unmodified tracked baseline, exact candidate prewrite whitespace, all **197** `tools/check_*.py` checks PREWRITE and POSTWRITE, `git diff --check`, and a generated manifest. Author-side source inspection and candidate tests are not 197-checker WSL PASS; runtime access is not available for this checkpoint.
