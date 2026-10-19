---
memory_schema: 1
as_of: 2026-10-18
project: logres
---

# Current State

## Active Objective
Modularize proven Logres UI incrementally with D-046 fixture/model/view parity before all-NPC expansion. **Do not alter accepted camera or DynamicCam behavior.** Preserve existing quests, native controls, restoration and rendering during extraction; defer bank/auction feasibility until after reuse is proven.

## Current Work Item
**P0264 N4 — INTERACTIVE SYNTHETIC REWARD CHOICES (PREPARED / CLIENT UNVERIFIED).** Verified P0263 pushed `373c82b`; user diagnostics confirm `0.0.161-dev` loads and preview commands/checks pass but explicitly reports no visible progression, and Multiple rewards cannot be selected. Root cause verified in `Quest/RewardVisual.lua`: each row was a mouse-disabled Frame and the fixture documented choices as display-only. P0264 combines shared renderer input/selection state, controller-owned preview-only routing, visible selected-state art, Complete Quest feedback dependent on selection, and diagnostic evidence, in ONE patch. Does NOT claim live Blizzard reward selection/claim. Camera and all native quest controllers frozen. See P0264 evidence.

## Verified State
- **P0263 PUSHED / SCOPED RUNTIME DIAGNOSTICS:** main `373c82b` verified; user's `0.0.161-dev` diagnostics show narrative/reward previews and offer/dialogue checks PASS. However no new functional UI was added, and user explicitly rejects repeated no-op regression loops. **N3 user-visible progression unsatisfactory, not accepted as meaningful capability.**
- **P0264 PREPARED / RUNTIME PENDING:** preview Multiple choice rows become clickable with an obvious exclusive SELECTED highlight, ability to switch choice, reset in Single/new narrative, inert completion feedback, and read-only counters in F panel. No live claim/choice ownership or camera changed.
- **P0262 PUSHED / SCOPED VISUAL PASS:** main `36d43f6` verified; five authored long/short/generic/Single/Multi previews worked and looked as expected. Paginator arrows and in-panel final-page controls visually accepted. The exported `0.0.160-dev` Quest Dialogue/Offer Controls/Run All checks report PASS; `lastResult=preview-only`, `probeCallOK=false`. This does NOT establish live claims, multi-choice, generic gossip or all camera transitions.
- **P0263 N3 PREPARED / RUNTIME UNVERIFIED:** cosmetic decision-button factory extracted; same two button objects and owner OnClick, same accepted quest/reward view, native recovery and camera unchanged. Full WSL shadow checker suite and in-client visual regression required.
- **P0261 PUSHED / SCOPED VISUAL PASS:** verified `main` `b439d4f`; user confirms previews work as expected. Does not establish live gossip, choice claiming, or unobserved quest transitions. P0261 earlier R0/R1/R2 checker/guard failures remain preserved in evidence.
- **P0260 PUSHED / SOURCE AUDIT COMPLETE:** GitHub `main` `1251434` verified; 54 provisional NPC interaction variants and coupled UI boundaries mapped. No runtime changes; camera preserved. See `docs/memory/evidence/P0260_MODULARITY_SOURCE_AUDIT.md`.
- **P0261 N1 PREPARED / RUNTIME UNVERIFIED:** source-independent narrative/decision presentation model maps guarded live offer and authored long/short/generic fixtures to the same production `QuestDialogue:PresentText` renderer. Two new P-tab buttons. Preview controls inert, generic gossip not live-integrated.
- **P0258 PUSHED / PREVIEW VISUAL ACCEPTED (SCOPED):** `edec5eb`; user accepted Multiple reward preview, not real choice/claim. Earlier P0256 P-tab gallery and P0257 model/gallery work are pushed; universal element preview coverage remains incomplete.
- **Live NPC quest ownership remains bounded:** scoped Accept/Decline and no-choice completion control exist; player-triggered reward selection, full gossip, Continue and complex services are NOT accepted as Logres-owned. Maintain usable Blizzard controls and native restoration. Quest 237 is reserved.
- **OPEN / DEFERRED negative evidence:** P0257 R0 duplicated layout geometry and failed P0254 checker; R1 failed its own generated-source preview-model assertion; R2 corrected static checks. P0251 R2 immersion restore failed before R3 acceptance. P0248 preview failed due to a nil reward renderer method before P0249 repair. Reward item availability had intermittent failures. These results remain in their original evidence records; no new run reclassifies them as PASS.
- **OPEN runtime issues:** native Blizzard-frame flash during actual completion claim; real multi-choice/claim unverified; unspecified issues from the user's gameplay session remain DETAILS PENDING; quest 237 must not be completed solely to validate this patch.
- **FROZEN CAMERA:** existing camera/DynamicCam framing, transitions, event subscriptions, coexistence and zoom behavior are accepted and unchanged by P0261.

## Next Action
Apply P0264 from verified pushed P0263 `373c82b` only. After full WSL shadow static suite and deploy, in `/logres panel` → **P — Previews** page 1/2: press **Reward Preview: Multiple**; click second card (Sample travel cloak), third (Sample leather gloves), fourth (Sample healing potion), then click Complete Quest; confirm visible exclusive SELECTED highlight moves, no native quest claim. Press **Reward Preview: Single** and verify no selection / card click; press Multiple again and verify reset; press Quest Dialogue Preview and verify prior selection disappears. In **F — Quest Experience**, press **Quest Dialogue Check** and read `previewchoices` fields; in **H — Integration and Polish**, press **Quest Offer Controls Check** and confirm `lastResult=preview-only`. Do not press Quest Offer Accept/Decline Probes. No travel or real quest claim; quest237 reserved. **Do not treat preview selection as live reward selection**: that remains blocked/Blizzard owned pending independent safe action evidence.

## Success Criteria
User must observe each synthetic CHOICE card responding to a click, an exclusive visible selection that can move and reset across preview modes, Complete Quest feedback that says a choice is missing or selected, and diagnostic count/selected state. Renderer never calls any gameplay/native API; Dialogue owns the callback guard. Live rows remain mouse-disabled and Blizzard controls usable. Static full-suite PASS is not WoW PASS. Camera unchanged. Live choices/claim, native flash, generic gossip and full NPC service coverage remain OPEN.

## Do Not Reopen Without New Evidence
Do not infer addon installation from one guessed filesystem path or the presence/absence of a Lua global alone. No hard QuestieDB dependency, package bundling, unknown CurseForge project ID, global quest ID scans on updates, guessed quest availability, invented coordinates or native pin scraping. Do not hide the Blizzard minimap, alter user-accepted waypoint/focused-quest bearings, or treat missing locations as PASS. Baked flavor must not be guessed from a Source-only indicator. Keep negative and deferred evidence explicit.

## Relevant References
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
