# P0326 — guarded merchant and flight-master read-only source audit

**Pushed baseline required:** P0325 `c596fe24462d1cabd6c8027f46f713ba0d10da8f`; clean tracked main, exact committed blob IDs. **Scope:** `docs/memory/architecture/P0326_MERCHANT_FLIGHT_AUDIT.md` + P0326 evidence and patch record, fresh static contract, current handoff and append-only memory/roadmap. No Lua, no `Logres/` files, no camera, no SavedVariables, no quest, gossip, trainer, secure action or UI mutation.

**Source outcome:** existing stock merchant candidate `MerchantFrame` (policy/placement) versus unresolved flight `FlightMapFrame` / `TaxiFrame` candidate names. Current session is trainer-only. Merchant/flight travel/transaction and native controls retained; no new capability claimed. User-facing alpha fallback remains Blizzard. D-046/D-047/D-048 honored.

**Checker gates:** 197 PREWRITE and 197 POSTWRITE, generator hygiene and transactional rollback on postwrite failure; `P0326_MANIFEST.txt` generated. WoW runtime **UNVERIFIED**, P0321 stock parking **DEFERRED until November 4**. Negative findings and issue L-003/L-004 remain open; source audit is not a bug reproduction. **No WoW redeploy** for this docs-only checkpoint.

**Next:** source-grounded inert merchant/flight fixture proposal or November 4 readonly merchant/flight audits; no speculative native parking/session registrations, camera or transaction changes.
