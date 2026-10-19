---
memory_schema: 1
as_of: 2026-10-18
project: logres
---

# Current State

## Active Objective
Modularize proven Logres UI incrementally with D-046 fixture/model/view parity before all-NPC expansion. **Do not alter accepted camera or DynamicCam behavior.** Preserve existing quests, native controls, restoration and rendering during extraction; defer bank/auction feasibility until after reuse is proven.

## Current Work Item
**P0274 — ADDITIVE MERCHANT/TRAINER NATIVE-SERVICE ACCENT (PREPARED; CLIENT UNVERIFIED).** Verified pushed P0273 `591ed52`; 0.0.171-dev user screenshots show native GossipFrame and ClassTrainerFrame center at the same position, with 3 starts/3 restores, gossip 2/2, zero placement failures, no native transactions and 0 → Run All without reported FAIL. P0274 adds an opt-in addon-owned, mouse-disabled gold rule to **merchant/trainer ONLY** through the existing controller; Blizzard controls/transactions and anchor restoration remain unchanged. Native gossip keeps positioning plus stock visual fallback. **NEXT after P0274:** gated live gossip data/action adapter to the already accepted Logres D-046 quest/NPC renderer, not another custom renderer; never assume synthetic previews prove native action safety. No camera, bank, auction, flight, or other service changes.

## Verified State
- **P0273 PUSHED / SCOPED CLIENT ACCEPTANCE (2026-10-19):** `591ed52`; user screenshot shows both initial Blizzard gossip and subsequent native trainer centered, options and training controls visible, exit/OFF restores stock. 0.0.171-dev audit: starts=3 restores=3 gossipStarts=2 gossipRestores=2 autoDeferred=0 pending=false failures=0 nativeTransactions=0; Run All no reported FAIL. Source still stock presentation. Developer panel overlaps native windows in screenshots; clean panel-closed cosmetic evaluation remains OPEN.
- **P0274 PROPOSED STYLING BOUNDARY:** native merchant/trainer obtain an addon-owned, mouse-disabled ornament only during successful opt-in placement; native textures, controls, labels, prices, input, anchor setter and transactions untouched. Decoration is hidden before restore, and cosmetic failure must never block native access. Gossip intentionally remains stock fallback until genuine live adapter is proven.
- **P0272 HISTORICAL INTEGRITY:** original WSL full-suite gate and absent original manifest remain UNVERIFIED despite reconstructed evidence/checker in P0273. Do not retroactively claim PASS.
- **D-047 NATIVE OWNERSHIP:** Blizzard owns merchant quantities, repair/selling, trainer filters/learning, flight/taxi, bank/auction. TaxiFrame metadata not mutation authority; accepted camera and DynamicCam frozen.
- **OTHER OPEN/DEFERRED:** live reward claims, native completion-frame flash, protected/secret and environmental cases, broader NPC service ownership.

## Next Action
Apply P0274 from pushed P0273 `591ed52`; WSL shadow+postwrite **141** static checkers and diff gate, commit/push. Deploy. Open developer panel; H `Native Auto Position (TEST)` ON, use naturally available native merchant/trainer and check small gold accent without obstructing Blizzard input, confirm clean restoration and accent removal on close/OFF; gossip remains stock and centered when ON. H ownership check, then 0 Run All. Panel closed screenshots for accurate user presentation; no spending/travel. STOP and record any Lua/taint/input/restore failure. After accepted P0274, implement a gated **live gossip adapter to existing D-046 renderer**; no custom merchant/trainer transactions.

## Success Criteria
One reusable mouse-disabled UIParent-owned ornament is shown for actual merchant/trainer native frames only, exactly while the existing opt-in positioning controller owns the session; fully hidden on restore. Stock geometry/controls remain usable; decorative failure is nonfatal, separately audited. No new H actions, no gossip visual replacement, no native child/text/texture mutation, no timers/polls, no camera edits. Real WoW evidence required to accept. Next step live gossip adapter requires separate source/action safety and fail-open stock fallback.

## Do Not Reopen Without New Evidence
Do not infer addon installation from one guessed filesystem path or the presence/absence of a Lua global alone. No hard QuestieDB dependency, package bundling, unknown CurseForge project ID, global quest ID scans on updates, guessed quest availability, invented coordinates or native pin scraping. Do not hide the Blizzard minimap, alter user-accepted waypoint/focused-quest bearings, or treat missing locations as PASS. Baked flavor must not be guessed from a Source-only indicator. Keep negative and deferred evidence explicit.

## Relevant References
- `docs/memory/evidence/P0274_NATIVE_SERVICE_ACCENT.md`
- `docs/memory/evidence/P0273_NATIVE_GOSSIP_CONTINUITY.md`
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
