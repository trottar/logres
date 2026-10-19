---
memory_schema: 1
as_of: 2026-10-18
project: logres
---

# Current State

## Active Objective
Modularize proven Logres UI incrementally with D-046 fixture/model/view parity before all-NPC expansion. **Do not alter accepted camera or DynamicCam behavior.** Preserve existing quests, native controls, restoration and rendering during extraction; defer bank/auction feasibility until after reuse is proven.

## Current Work Item
**P0273 — OPT-IN NATIVE GOSSIP → MERCHANT/TRAINER POSITION CONTINUITY (PREPARED / CLIENT UNVERIFIED).** Verified pushed main `c5ef384` includes P0272 0.0.170-dev runtime source, but its historical checker/evidence/patch record/manifest were absent (commit message also labels P0271). P0273 restores the missing P0272 checker and documentary records without fabricating an earlier full-suite or manifest PASS, and expands the **same native placement controller** to guarded `GossipFrame` normalized type 3. Existing merchant 5/trainer 7, complete opaque-anchor restoration, opt-in H auto OFF default, no native controls/transactions or camera mutation remain. User screenshot proves stock gossip at left and later centered trainer; P0273 hypothesis is consistent native center for both while preserving Blizzard selection. See P0273 evidence and D-047.

## Verified State
- **P0272 SOURCE PRESENT ON MAIN / SCOPED CLIENT PASS (2026-10-19):** source in `c5ef384` (0.0.170-dev); diagnostics show opt-in auto ON, 2 starts, OFF with 2 restores, `autoDeferred=0 pending=false failures=0 nativeTransactions=0`; user confirms the behavior worked. `0 → Run All` completed without reported FAIL in performed scope. **INCOMPLETE DURABLE P0272 PATCH CHECKPOINT:** remote commit c5ef384 was labeled P0271 and lacks original P0272 checker, two records and generated manifest. Original P0272 WSL full suite remains UNVERIFIED, not retrospectively PASS. Historical docs/checker repaired as part of P0273; missing original manifest is not fabricated.
- **OPEN GOSSIP POSITION HANDOFF:** user screenshots capture Blizzard GossipFrame at left for **Train me** and ClassTrainerFrame at center. P0272 only owned merchant/trainer placement; this is a visual continuity defect, not proven input failure. P0273 adds gated type-3 native gossip placement, not a replacement custom conversation UI. Real gossip movement/close transitions UNVERIFIED until in-client test.
- **P0271 PUSHED / SCOPED NATIVE MANUAL PASS:** `993d9fb` shows 3 starts, 3 restores and 2 OnHide auto-restores with no failures; client confirmed working.
- **D-047 NATIVE OWNERSHIP:** Blizzard owns actual merchant purchases/quantities/repairs/selling, trainer lists/filter/learning, flight, bank and auction. `TaxiFrame` metadata read-only; no flight/bank/auction positioning authorization. Camera frozen.
- **OTHER OPEN / DEFERRED:** live reward claims, known native quest completion flash, protected/secret/environment-only cases and full NPC family coverage stay OPEN until separately proven.

## Next Action
Apply P0273 from exactly c5ef384, run all **140** checker tests in shadow/prewrite and postwrite, then commit/push. Deploy with the mandatory WoW block; `/reload`; open developer panel; H `Native Auto Position (TEST)` ON, then interact with an ordinary gossip NPC with a **Train me** option. Verify stock Blizzard gossip centers, Train me opens centered native trainer, all Blizzard controls usable, close restores stock; H button OFF while gossip/trainer is open must restore, and subsequent opens remain stock. If an ordinary merchant is naturally near, inspect the same transition; otherwise DEFERRED. Run 0 `Run All`, exit normally for diagnostics. No additional command-line validation is required. Stop on Lua/taint/protected/restore/input failure; preserve FAIL.

## Success Criteria
P0273 uses **one existing** protected-gated, out-of-combat, opaque full-anchor controller for native gossip, merchant and trainer only, opt-in AUTO default OFF. Gossip/merchant/trainer stock controls, Blizzard transactions, safe stock fallback and no hidden click areas remain intact; no custom transaction or gossip renderer, no new H button, no timers/polls, no camera edits, no other service expansion. Includes migrated historical P0271/P0272 static contracts and missing P0272 records, explicitly retaining unavailable original P0272 manifest and unverified WSL gate. WoW runtime PASS requires user observation; unsupported/protected native gossip stays stock and DEFERRED.

## Do Not Reopen Without New Evidence
Do not infer addon installation from one guessed filesystem path or the presence/absence of a Lua global alone. No hard QuestieDB dependency, package bundling, unknown CurseForge project ID, global quest ID scans on updates, guessed quest availability, invented coordinates or native pin scraping. Do not hide the Blizzard minimap, alter user-accepted waypoint/focused-quest bearings, or treat missing locations as PASS. Baked flavor must not be guessed from a Source-only indicator. Keep negative and deferred evidence explicit.

## Relevant References
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
