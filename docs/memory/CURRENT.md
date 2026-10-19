---
memory_schema: 1
as_of: 2026-10-18
project: logres
---

# Current State

## Active Objective
Modularize proven Logres UI incrementally with D-046 fixture/model/view parity before all-NPC expansion. **Do not alter accepted camera or DynamicCam behavior.** Preserve existing quests, native controls, restoration and rendering during extraction; defer bank/auction feasibility until after reuse is proven.

## Current Work Item
**P0271 — NATIVE NPC SERVICE POSITIONING TRIAL AND FLIGHT ALIAS (PREPARED / WoW UNVERIFIED).** Verified pushed P0270 on `b33fdf6`. User's `0.0.168-dev` read-only native audit in Ironforge confirms ordinary MerchantFrame and ClassTrainerFrame are loaded/unprotected with placement methods; separate Flight Master `interactionType=6` retained FlightMapFrame=not-loaded, bank `type=67` showed BankFrame, auction `type=21` showed AuctionHouseFrame (unprotected/methods). These source names are not blanket relocation authority. P0271 explicitly gates a **manual native-frame Center (TEST) / Restore** for merchant/trainer only, requires complete opaque anchor snapshot and protected/visible/lockdown gates, auto-restores on the exact native OnHide, and defers restoration until regen when needed. No automatic repositioning, native child suppression, transactions, or camera changes. The existing read-only H audit adds a TaxiFrame name candidate; unknown until tested. Bank/auction/flight stay stock. D-047 remains controlling. See `docs/memory/evidence/P0271_NATIVE_SERVICE_PLACEMENT_TRIAL.md`.

## Verified State
- **P0270 PUSHED / SCOPED READ-ONLY CLIENT PASS (2026-10-19):** verified main `b33fdf6`; on-client 0.0.168 audit invoked at idle/merchant/trainer/Flight Master/bank/auction. `nativeMutations=0`, styling/placement none, Run All no FAIL in tested scope. MerchantFrame, ClassTrainerFrame, BankFrame, AuctionHouseFrame loaded/unprotected with methods; `FlightMapFrame` not-loaded during flight NPC type=6; **TaxiFrame unverified**. These results prove metadata availability only, not frame placement safety.
- **P0271 PREPARED / RUNTIME PENDING:** one H TEST toggle for manual merchant/trainer center and restore, targeted native-hide restoration, event-only combat restore. Requires in-game prove placement, stock controls, manual and auto restore, no Lua/taint error. Static suite does not certify safe WoW mutation.
- **P0269 PUSHED / SCOPED USER ACCEPTANCE (2026-10-19):** verified GitHub `main` `1588fb9`. User confirmed fake service catalogue P previews removed and remaining interaction previews worked. 0.0.167-dev H native policy audit reports `mode=native-stock`, `families=7`, `ownership=Blizzard-owned`, `nativeMutations=0`, `identity=not-observed`. F Quest Dialogue and H Offer Controls PASS (`probeCallOK=false`); 0 Run All completes without reported FAIL. This does not prove any live merchant/trainer frame behavior or styling.
- **P0270 PREPARED / IN-CLIENT PENDING:** one read-only, explicitly invoked native frame capability audit shared by eight candidate stock surfaces; method availability and protection are metadata only, never a styling permission. Native service identity remains unverified; missing frames may be lazy-loaded. No client result may be marked PASS until observed.
- **P0268 PUSHED / SYNTHETIC SCOPED PASS, DESIGN DIRECTION REJECTED:** verified `main` `53fe8ae`. User confirms mock catalogue controls work; diagnostics 0.0.166-dev show Quest Dialogue, Offer Controls and Run All PASS within performed scope, with no confirmed native service transactions. User explicitly requires Blizzard merchant, trainer, flight and related service functionality with selective Logres styling/placement, NOT a custom replacement. Historical proof preserved; mock catalogue path retired by P0269.
- **D-047 NATIVE SERVICE OWNERSHIP RECONFIRMED:** Merchant purchases/quantity, selling/buyback, repairs, Sell Junk, trainer learning/filtering, flight routes/travel, bank and auction remain native Blizzard controls. Style/location optional only after supported frame capability and safe reversible, fail-open design are proven.
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
Apply P0271 against exactly verified P0270 `b33fdf6`, passing all 138+ static checkers in the prewrite candidate and postwrite. Deploy to WoW. In H use `Native Service Frame Audit` (now includes TaxiFrame) at idle, then open naturally available merchant/trainer if convenient; use **Native Service Center / Restore (TEST)** once to center the *existing* Blizzard window and again to restore. Check native quantity/repair/trainer controls remain usable, close and reopen to verify stock anchor/automatic close restore; do not need to spend gold. Only a naturally accessible Flight Master warrants another read-only `TaxiFrame` audit; otherwise DEFERRED, no travel. Run 0 Run All, exit WoW and attach saved diagnostics. Stop on Lua, taint, secret/protected errors, failed restore or any invisible click region. Do not touch camera or full quest.

## Success Criteria
P0271 keeps all stock transaction/data/control functionality, no custom catalogue, no automatic native mutation, and protects all native frame changes with explicit TEST intent, noncombat, unprotected/visible checks and opaque full-anchor restoration. It adds TaxiFrame read-only audit without claiming flight identity. Shadow+postwrite full checker suite and git diff --check must pass; in WoW, successful reversible native positioning and nonbroken Blizzard input must be observed before any automatic integration is considered. Missing services and inability to inspect remain DEFERRED; failed restoration is a real FAIL requiring repair. Camera unchanged.

## Do Not Reopen Without New Evidence
Do not infer addon installation from one guessed filesystem path or the presence/absence of a Lua global alone. No hard QuestieDB dependency, package bundling, unknown CurseForge project ID, global quest ID scans on updates, guessed quest availability, invented coordinates or native pin scraping. Do not hide the Blizzard minimap, alter user-accepted waypoint/focused-quest bearings, or treat missing locations as PASS. Baked flavor must not be guessed from a Source-only indicator. Keep negative and deferred evidence explicit.

## Relevant References
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
