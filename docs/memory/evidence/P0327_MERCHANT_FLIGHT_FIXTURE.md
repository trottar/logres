# P0327 — Merchant/flight synthetic fixture evidence

**Source baseline:** pushed P0326 GitHub `main` `7949d7cb79a491db6ca0c2264694a31588db05e8`. Audit `docs/memory/architecture/P0326_MERCHANT_FLIGHT_AUDIT.md` preserves `MerchantFrame`, `FlightMapFrame` and `TaxiFrame` as source candidates. Only trainer is live registered in `NPCServiceSession`.

## Evidence scope

P0327 creates `tools/p0327_service_model.py` (not in the addon TOC), with **8 synthetic models** and an independent checker. It covers shared descriptions, zero-row, unavailable-source and native-handoff states, preserving Blizzard control lists and never creating enabled actions, IDs, item cost, fare or destination connectivity. This is **D-046 model-only preparation**, not a production renderer and **not an in-game visual preview**.

## Negative/deferred results

**WoW runtime UNVERIFIED.** No purchases, repairs, buyback, routes, taxi travel, frame parking or restoration were attempted. No secret or protected values were inspected. No merchant/flight client source completeness can be inferred. The longstanding `FlightMapFrame` versus `TaxiFrame` candidate ambiguity remains open; so do issue register L-003/L-004. P0321 GossipFrame native-root parking remains **UNVERIFIED** until its November 4 client gate. D-047 Camera/DynamicCam remains frozen; no Lua was changed. The checker is an offline contract and cannot prove live source, visual acceptance or gameplay.

## Verification

Author-side model fixtures, syntax, generated candidate hygiene, negative check case and ZIP integrity are scoped static checks; **198 PREWRITE/POSTWRITE repository checkers remain for the user WSL applier**. After the pushed checkpoint, a separate runtime or in-game P — Previews step is required; no WoW deploy for this tools/docs-only patch.
