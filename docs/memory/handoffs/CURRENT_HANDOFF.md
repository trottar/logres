# P0327 handoff — merchant/flight inert descriptive fixtures

**Authority:** `docs/memory/CURRENT.md`, `docs/memory/architecture/P0327_MERCHANT_FLIGHT_FIXTURE.md`, D-046/D-047/D-048, P0326 source audit and issue register.

Verified pushed P0326 `7949d7cb79a491db6ca0c2264694a31588db05e8`. P0327 prepares 8 synthetic merchant/flight models in `tools/` only. This is **NOT** an in-client P — Previews renderer or native source adapter. All native Browse/Sell/Buyback/Repair/Close and Route map/Fares/Route selection/Travel/Close controls remain Blizzard-owned. `MerchantFrame` is a source candidate; `FlightMapFrame` versus `TaxiFrame` remains **UNRESOLVED**. Only trainer is registered in `NPCServiceSession`. No merchant/flight parking or new hooks.

Apply exact clean pushed P0326 guard, 198 PREWRITE + POSTWRITE checkers, diff hygiene and manifest; user commits/pushes then verify main. **No WoW redeploy** for this tools/docs-only patch. P0321 GossipFrame parking/restoration is **WoW UNVERIFIED / DEFERRED until November 4**; first validate it in-client, then use read-only H **Native Service Frame Audit** and H **Native NPC Services Check** with naturally available merchant/flight and retain Blizzard transaction/travel ownership. Never enable H **Native Auto Position (TEST)** for baseline diagnostics. Five live selectors and migration not implemented; Camera/DynamicCam frozen. Quest 237 reserved; L-003/L-004 remain feature gaps, not runtime bugs.

Next meaningful step: an in-game P — Previews candidate consuming same future Lua renderer/model, gated by runtime access, or additional source-specific read-only evidence; do not infer success from offline fixtures.
