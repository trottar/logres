---
memory_schema: 1
as_of: 2026-10-18
project: logres
---

# Current State

## Active Objective
Modularize proven Logres UI incrementally with D-046 fixture/model/view parity before all-NPC expansion. **Do not alter accepted camera or DynamicCam behavior.** Preserve existing quests, native controls, restoration and rendering during extraction; defer bank/auction feasibility until after reuse is proven.

## Current Work Item
**P0272 — OPT-IN MERCHANT/TRAINER AUTOMATIC NATIVE POSITIONING (PREPARED; CLIENT UNVERIFIED).** Verified pushed P0271 `993d9fb`; screenshots and 0.0.169-dev diagnostics establish 3 manual placement starts, 3 restores, 2 native-hide auto-restores, 0 failures. P0272 reuses that single controller and its opaque anchors for **explicitly armed** merchant/trainer automatic centering on addon-owned interaction events, plus targeted guarded native OnShow when a frame is available. Stock controls/transactions retained. Auto defaults OFF; H button toggles, automatic mode OFF restores stock. Flight (`TaxiFrame` metadata observed), bank, auction and camera unchanged. D-047 governs; see P0272 evidence.

## Verified State
- **P0271 PUSHED / SCOPED RUNTIME PASS (2026-10-19):** `993d9fb`; user confirmed real native merchant/trainer centering and restoration and no observed control failures. Last `0.0.169-dev`: `starts=3 restores=3 autoRestores=2 failures=0 pending=false nativeTransactions=0`. This proves **manual** positioning only, not P0272 automatic behavior or actual transactions.
- **P0271 FLIGHT ALIAS METADATA:** screenshot reports `TaxiFrame loaded=present protected=no` and method-present. `FlightMapFrame` absent; flight positioning and travel remain Blizzard-owned and DEFERRED.
- **P0270 PUSHED / SCOPED READ-ONLY FRAME AUDIT:** main `b33fdf6`; merchant/trainer/bank/auction frame names observed but not blanket styling/placement authority.
- **P0269 PUSHED / D-047 RESTORED:** `1588fb9`; synthetic merchant/trainer/flight purchase/training catalogues retired. Blizzard owns quantities, repairs, Buyback, Sell Junk, trainer filters, flight, bank and auction.
- **OPEN / DEFERRED:** real selectable reward claims, previously reported Blizzard completion-frame flash, protected and environment-only states, flight ownership, bank/auction integration, natural non-preview NPC variants. Preserve negative evidence in the linked investigation/patch records. Accepted DynamicCam behavior is FROZEN.

## Next Action
Apply P0272 at exact verified P0271 `993d9fb`; complete all 139+ static checker and diff gates. Deploy. First verify H `Native Auto Position (TEST)` starts OFF using `/logres nativeserviceplacement auto check`; arm once without NPC, open a naturally available merchant, confirm center, close native X and stock restore, reopen for second automatic attempt, then disable while centered and ensure immediate stock restore and subsequent openings stay native. Repeat trainer only if naturally available (otherwise DEFERRED), and run 0 → Run All. Exit normally and attach diagnostics. Stop for Lua/taint/protected errors, invisible click areas, non-restoration or automatic handoff failure; record these as FAIL/OPEN, not PASS. No unnecessary user travel.

## Success Criteria
P0272 preserves every stock native control, purchase/quantity/repair/buyback/trainer filter, and D-047 fallback. Automatic is OFF by default and must be explicitly armed. No timer/polling or camera change. All safety and complete restoration invariants of P0271 remain; any failure must fail open and be recorded before broadening. User's WoW evidence, not a static checker, determines runtime acceptance. Flight/bank/auction remain stock.

## Do Not Reopen Without New Evidence
Do not infer addon installation from one guessed filesystem path or the presence/absence of a Lua global alone. No hard QuestieDB dependency, package bundling, unknown CurseForge project ID, global quest ID scans on updates, guessed quest availability, invented coordinates or native pin scraping. Do not hide the Blizzard minimap, alter user-accepted waypoint/focused-quest bearings, or treat missing locations as PASS. Baked flavor must not be guessed from a Source-only indicator. Keep negative and deferred evidence explicit.

## Relevant References
- `docs/memory/evidence/P0272_NATIVE_AUTO_HANDOFF.md`
- `docs/memory/evidence/P0271_NATIVE_SERVICE_PLACEMENT_TRIAL.md`
- `docs/memory/evidence/P0270_NATIVE_FRAME_CAPABILITY_AUDIT.md`
- `docs/memory/evidence/P0269_D047_NATIVE_SERVICE_RESET.md`
- `docs/memory/evidence/P0268_MULTI_SERVICE_CATALOGUE.md`
- `docs/memory/evidence/P0267_NPC_NAVIGATION_AND_EXIT.md`
- `docs/memory/evidence/P0266_NPC_SESSION_RUNTIME_REPAIR.md`
- `docs/memory/evidence/P0265_NPC_OPTION_SESSION.md`
- `docs/memory/evidence/P0264_PREVIEW_REWARD_CHOICE.md`
- `docs/memory/evidence/P0263_N3_DECISION_VISUAL_EXTRACTION.md`
- `docs/memory/evidence/P0262_N2_NARRATIVE_PAGE_EXTRACTION.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`
- `docs/memory/evidence/P0257_PREVIEW_LIVE_REWARD_MODEL.md`
- `docs/memory/evidence/P0256_UNIVERSAL_PREVIEW_GALLERY.md`
- `docs/memory/evidence/P0251_LIVE_REWARD_AND_COMPLETION_CONTROL.md`
- `docs/memory/evidence/P0250_REWARD_PREVIEW_RUNTIME_ACCEPTANCE.md`
- `docs/memory/evidence/P0249_REWARD_VISUAL_INSTANCE_FAILURE.md`
- `docs/memory/evidence/P0248_REWARD_CARD_PRESENTATION.md`
- `docs/memory/evidence/P0247_REWARD_SOURCE_GATE_DIAGNOSTIC.md`
- `docs/memory/evidence/P0246_QUEST_ITEM_EVENT_CACHE_RESULT.md`
- `docs/memory/evidence/P0245_QUEST_REWARD_ITEM_NAME_CACHE.md`
- `docs/memory/evidence/P0244_QUEST_MONEY_AND_COMPLETION_VISUAL_ACCEPTANCE.md`
- `docs/memory/evidence/P0243_QUEST_REWARD_VISIBILITY_AND_STOCK_FALLBACK.md`
- `docs/memory/evidence/P0242_QUEST_COMPLETION_NARRATIVE.md`
- `docs/memory/evidence/P0241_ADDITIVE_QUEST_PROGRESS.md`
- `docs/memory/evidence/P0240_QUEST_LIFECYCLE_CAPABILITY_AUDIT.md`
- `docs/memory/evidence/P0128_NPC_QUEST_INTERACTION_SOURCE_AUDIT_2026-10-05.md`
- `docs/memory/evidence/P0129_NPC_QUEST_INTERACTION_RUNTIME_READ_PASS_2026-10-05.md`
- `docs/memory/evidence/P0239_SETTINGS_UI_RUNTIME_ACCEPTANCE.md`
- `docs/memory/decisions/D-035_QUEST_INTERACTION_OWNERSHIP.md`
- `docs/memory/evidence/P0238_PLAYER_SETTINGS_SCOPE.md`
- `docs/memory/evidence/P0237_P0236_RUNTIME_POI_ACCEPTANCE.md`
- `docs/memory/evidence/P0236_POI_COVERAGE_AND_PROXIMITY_TEST.md`
- `docs/memory/evidence/P0235_INDEPENDENT_SERVICE_ROLES.md`
- `docs/memory/evidence/P0234_NEARBY_POI_SOURCE_AND_PRIORITY_AUDIT.md`
- `docs/memory/evidence/P0234_NEARBY_POI_SOURCE_AND_PRIORITY_AUDIT.md`
- `docs/memory/evidence/P0231_DYNAMIC_MAP_BRIDGE_FAILURE.md`
- `docs/memory/evidence/P0230_DYNAMIC_NEARBY_QUEST_CANDIDATES.md`
- `docs/memory/evidence/P0229_QUESTIEDB_DIAGNOSTIC_HANDOFF_FAILURE.md`
- `docs/memory/decisions/D-043_NAVIGATION_SOURCE_AND_MINIMAP_FALLBACK_POLICY.md`
- `docs/DEPENDENCIES.md`
