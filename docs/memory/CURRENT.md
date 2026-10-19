---
memory_schema: 1
as_of: 2026-10-18
project: logres
---

# Current State

## Active Objective
Modularize proven Logres UI incrementally with D-046 fixture/model/view parity before all-NPC expansion. **Do not alter accepted camera or DynamicCam behavior.** Preserve existing quests, native controls, restoration and rendering during extraction; defer bank/auction feasibility until after reuse is proven.

## Current Work Item
**P0268 — COMBINED NPC SERVICE CATALOGUES (PREPARED / CLIENT UNVERIFIED).** Verified pushed P0267 `8e1e6f8` on main and the user's 0.0.165-dev screenshot and diagnostics. P0267 interactions are accepted for tested scope (11 option clicks, 8 branches, 4 backs, 2 page moves, 8 Goodbye clicks, nativeActions=0; F/H/Run All PASS); user identifies remaining corner-art overlap with header Back/Goodbye. P0268 builds four shared synthetic service-catalogue states (merchant, trainer, flight and unavailable) through the existing option renderer/controller, with sample prices, requirements, option paging, Back, inert preview-only confirmation and F diagnostics. Both header buttons move inward symmetrically to clear artwork. No live source/transaction, protected UI or camera change. See P0268 evidence.

## Verified State
- **P0267 PUSHED / TESTED INTERACTIONS PASS, CORNER INSET OPEN:** main `8e1e6f8` verified. User confirms all panel steps worked; screenshot shows matching-height Back/Goodbye overlap with decorative top corners. Diagnostics 0.0.165-dev: options clicks=11 branches=8 backs=4 pageMoves=2 nativeActions=0, Goodbye clicks=8; Quest Dialogue Check, Offer Controls Check and Run All PASS for performed cases. Static/pushed status cannot resolve this visual defect.
- **P0268 PREPARED / CLIENT UNVERIFIED:** four genuine service state fixtures via existing shared model/view/session, catalogue overflow, locked states, safe quote confirmations and native fallback; matched header insets. Static and WoW gates pending. Native transactions remain Blizzard-owned.
- **P0266 PUSHED / SCOPED RUNTIME INTERACTION PASS WITH OPEN VISUAL DEFECT:** GitHub main `2270e84` verified. User confirms option branches, root Back, services, overflow, locked state and Goodbye work; screenshot proves Back overlaps narrative pagination. `0.0.164-dev` diagnostics report clicks=20, branches=20, backs=14, goodbyes=10, nativeActions=0; checks F/H/Run All PASS for performed checks. Farewell still requires a second exit; both visual/UX failures OPEN pending P0267.
- **P0265 PUSHED / SCOPED VISUAL FAILURE:** GitHub `main` `99c7294` verified. User screenshot shows services rail crowding; user reports inaccessible root Back after branching, and no Goodbye. Preview entrypoint PASS is not functional PASS. P0265 R0 static adjacency failure and R1 correction preserved in P0265 evidence.
- **P0264 PUSHED / SCOPED FUNCTIONAL VISUAL PASS:** main `6b3ed96` verified; user reports preview reward card selections worked. `0.0.162-dev` export reports 8 choice clicks, `Quest Dialogue Check` and `Quest Offer Controls Check` PASS and native `probeCallOK=false`. Last `previewchoices state=inactive` follows Run All reset; no real choice/claim acceptance is implied. Historical P0264 R0 checker-version pin and R1 CURRENT_HANDOFF pointer errors remain recorded in P0264 evidence.
- **P0265 PREPARED / CLIENT UNVERIFIED:** one multi-function patch implements four realistic option preview scenarios through new shared option model/view/session, gated branching/Back, disabled entries, overflow paging, and F-tab diagnostics. No live gossip selection, stock suppression or camera changes.
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
Apply P0268 to verified P0267 `8e1e6f8`, run full static checkers, then deploy and use the numbered P/F/H/0 checklist in P0268_README. Inspect header Back/Goodbye inset; Merchant two-page catalogue, locked stock, sample quote/confirmation; Trainer level and prerequisite locks, preview confirmation; Flight destination and fare locks, preview confirmation; Unavailable fallback; existing Branching/Reward regression. Confirm F npcservice previewConfirms >0 and nativeActions=0, H probeCallOK=false, Run All no FAIL. Do not perform real merchant purchases, training, travel, gossip selection, native quest 237 claim or camera manipulation.

## Success Criteria
All four catalogue fixtures use the *same* NPCOptionList and NPCOptionSession without duplicate frames; at least one available quote can be inspected/confirmed as an explicit no-op, with Back history and option page restored. Locked actions are unavailable with clear requirements. Unavailable service visibly preserves native fallback. Symmetric header 45px insets clear decorative art in WoW. No protected action, claim, gossip, service transaction, camera or native fallback behavior changes. Static PASS is not runtime PASS.

## Do Not Reopen Without New Evidence
Do not infer addon installation from one guessed filesystem path or the presence/absence of a Lua global alone. No hard QuestieDB dependency, package bundling, unknown CurseForge project ID, global quest ID scans on updates, guessed quest availability, invented coordinates or native pin scraping. Do not hide the Blizzard minimap, alter user-accepted waypoint/focused-quest bearings, or treat missing locations as PASS. Baked flavor must not be guessed from a Source-only indicator. Keep negative and deferred evidence explicit.

## Relevant References
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
