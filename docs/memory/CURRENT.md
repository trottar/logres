---
memory_schema: 1
as_of: 2026-10-18
project: logres
---

# Current State

## Active Objective
Modularize proven Logres UI incrementally with D-046 fixture/model/view parity before all-NPC expansion. **Do not alter accepted camera or DynamicCam behavior.** Preserve existing quests, native controls, restoration and rendering during extraction; defer bank/auction feasibility until after reuse is proven.

## Current Work Item
**P0275 — QUEST-ART NATIVE MERCHANT/TRAINER SHELL (PREPARED / WoW UNVERIFIED).** Verified P0274 pushed `ac3f199`; user `0.0.172-dev` screenshot shows P0274 ornament is visually indistinguishable from stock. Saved diagnostics later show `accentShows=3`, `accentHides=2`, `accentFailures=0`, so activation happened; cosmetic effectiveness FAILED/INSUFFICIENT despite successful counters. User approved the existing Logres quest renderer as the exact visual reference and accepted **Stage 1**: draw real quest-panel art around Blizzard-owned merchant/trainer before attempting any native child reshaping. P0275 replaces tiny P0274 art with a 640x540 nine-slice quest-panel and divider behind native service windows during existing opt-in positioning only; Blizzard opaque interior, controls and transactions are retained. NEXT if runtime verified: separately audit native child layout/texture feasibility for closer quest-style visual fidelity. Live gossip adapter remains separate; no camera, bank, auction or flight edits.

## Verified State
- **P0274 PUSHED / VISUAL INSUFFICIENCY (2026-10-19):** `ac3f199`, 0.0.172-dev client shows original Blizzard trainer despite tiny gold accent. Later actual activation logs `accentShows=3`, hides=2, failures=0; therefore not a rendering failure but *not* visually accepted. Preserve the rejected 105x2 gold line/6x6 seal as a negative design result.
- **QUEST RENDERER SOURCE:** `Theme.questDialogue` uses `Quest/quest_narrative_panel.tga`, `quest_narrative_divider.tga`, a 640x320 base, cream title/body text and fine gold details; accepted quest screenshot confirms this is the design target. Native merchant/trainer opaque backing remains stock until future proven safe changes; Stage 1 will not fake full mockup fidelity.
- **P0273 PUSHED / SCOPED CLIENT PASS:** `591ed52`; gossip→trainer placement and restoration start/restore=3/3, gossip=2/2, failures=0; original P0272 WSL full-suite proof remains unknown.
- **D-047 NATIVE OWNERSHIP:** Blizzard retains quantities, merchant sales/repairs, trainer filters/learning, taxi, bank/auction; stage 1 draws behind stock and changes no native child/control/transaction.
- **OTHER OPEN/DEFERRED:** live reward claims, completion flash, secret/protected issues, broader NPC action ownership, live gossip adapter and Stage 2 native texture/child feasibility.

## Next Action
Apply P0275 from pushed P0274 `ac3f199` via guarded WSL applier (142 shadow PREWRITE + 142 postwrite checkers and `git diff --check`), commit/push. Deploy. In WoW H `Native Auto Position (TEST)` ON, open a naturally available merchant/trainer with panel closed; confirm visible widened **original quest-art** shell surrounding native window without obstructing Blizzard controls. Test close, reopen, H OFF restore and shell hidden; H Native NPC Services Check and 0 Run All. Save screenshot and diagnostics. A shell audit count without a perceptible visual difference is **not** a visual PASS. On any native taint, blocked control or failed restoration: stop. Do not implement fake search, filters, native texture removal or camera changes.

## Success Criteria
Quest-derived addon-owned BACKGROUND shell shows around Blizzard merchant/trainer only during opt-in placement, using 9 slices of the **actual quest panel art**, separate existing divider and a small category caption. The native window and its opaque contents remain stock, accessible and untouched; a visual resemblance limited by the native center is explicitly documented. Auto OFF/close hides all addon art before restoring native anchors. Existing H toggle and 105/18/34 panel inventory unchanged, no live transaction/access changes, no camera or other service edits. WoW proof REQUIRED; no invented UI feature or mockup-equivalence claims.

## Do Not Reopen Without New Evidence
Do not infer addon installation from one guessed filesystem path or the presence/absence of a Lua global alone. No hard QuestieDB dependency, package bundling, unknown CurseForge project ID, global quest ID scans on updates, guessed quest availability, invented coordinates or native pin scraping. Do not hide the Blizzard minimap, alter user-accepted waypoint/focused-quest bearings, or treat missing locations as PASS. Baked flavor must not be guessed from a Source-only indicator. Keep negative and deferred evidence explicit.

## Relevant References
- `docs/memory/evidence/P0275_NATIVE_QUEST_ART_SHELL.md`
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
