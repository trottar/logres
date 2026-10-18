---
memory_schema: 1
as_of: 2026-10-18
project: logres
---

# Current State

## Active Objective
Use a **preview-first modular UI pipeline** for every Logres-owned element: synthetic model and shared renderer before source-specific live adapters and separately guarded interactions. All previews reside in the P tab. NPC quest UI is first; preserve Blizzard fallback.

## Current Work Item
**P0257 — QUEST REWARD MODEL PARITY / UNIVERSAL PREVIEW-FIRST CONTRACT (RUNTIME UNVERIFIED).** GitHub main `23307aa` verifies P0256 pushed. User screenshots of `0.0.156-dev` confirm the P gallery and visually correct in-panel Accept/Decline preview, while Single and Multiple reward previews still show Blizzard fallback text and Single lacks the existing Complete Quest view. P0257 adds source-independent RewardModel fixtures and the same card renderer/guarded button visual for live and preview. D-046 applies this modular pipeline to EVERY future Logres UI element. No claim actions or protected-native handling change. Quest 237 remains reserved.

## Verified State
- **P0256 PUSHED / PREVIEW GALLERY SCOPED VISUAL PASS:** main `23307aa`, screenshots version `0.0.156-dev` show P tab page 2/2 and preview action outputs; the gallery is usable. Full universal per-element coverage remains OPEN.
- **P0257 R0/R1 FAILED STATIC / NO TRACKED WRITE:** R0 duplicated completion geometry and failed P0254 checker; R1 shared the geometry but its own P0257 checker incorrectly expected a single-result model binding. R2 corrects both historical issues and requires generated-source checker self-test. Runtime parity still UNVERIFIED.
- **NPC Accept/Decline PREVIEW VISUAL PASS (SCOPED):** newer screenshot of The Lost Standard shows buttons within panel; user says "This looks correct here". Live quest interaction remains unverified.
- **P0256 Single/Multiple reward previews VISUAL GAP:** both screens show Blizzard guidance instead of live-parity Complete Quest sample; P0257 corrects fixture/render path, not real completion claim. Runtime confirmation pending.
- **P0255 PUSHED / RUNTIME UNVERIFIED:** GitHub `main` `fc74e14`. The most recent uploaded screenshot of detached Accept/Decline displays `0.0.154-dev`, whereas P0255 changed source to `0.0.155-dev`; it is not proof of deployed P0255 behavior. User wants preview-first NPC fixes, and **universal** preview coverage across ALL UI elements. Previous page/offer defects remain OPEN until P0255 runtime can be distinguished from older builds. Further 20-minute play bugs are OPEN / DETAILS PENDING; do not invent failures.
- **P0256 PREPARED / STATIC AND LIVE RUNTIME UNVERIFIED:** central P-tab migration and 18-item page selector, preserving all preview commands and existing diagnostics. Other visual components have recorded coverage gaps; see `docs/memory/evidence/P0256_UNIVERSAL_PREVIEW_GALLERY.md`.
- **P0254 PUSHED / IN-PANEL COMPLETION VISUAL PASS (SCOPED):** `main` `2a7bc5d` and in-game `0.0.154-dev` screenshot show Complete Quest inside the dark panel with correct reward item x3 / 1050 XP / 7s. The user says “Much better!”; no claim action was validated. New page gating and offer location defects are P0255's narrow target. Blizzard flash after claim is **OPEN**, not fixed by P0255. See `docs/memory/evidence/P0255_FINAL_PAGE_AND_OFFER_ACTIONS.md`.
- **P0253 PUSHED / VISUAL FAIL:** verified `3c0a017`, user states that Complete Quest still visually floats below the panel. Source geometry confirms ~26px below panel; reusing the exact original Accept button did not change the shared root anchor. P0254 corrects the anchor and completion navigation overlap; runtime acceptance UNVERIFIED. See `docs/memory/evidence/P0254_COMPLETION_PANEL_ALIGNMENT.md`.
- **P0252 PUSHED / VISUAL FAIL (SCOPED):** verified `34274dc`; user screenshot after installation shows single Complete Quest action still visually detached. Duplicate guidance was removed and reward name/icon/XP/money remain visible. New P0253 eliminates a separate completion control frame and shares original Accept instance. Runtime acceptance UNVERIFIED.
- **P0251 R3 PUSHED / RESTORATION RUNTIME PASS (SCOPED):** verified `main` `45d4654`, user reported no issues and `0.0.151-dev` load334 shows an OFF→ON cycle followed by the same live quest237 completion `shown=true` and native control snapshot `applied=true shown=true snapshot=true`; `clicks=0 claimCalls=0`. Claim execution remains DEFERRED; user-reported Complete Quest visual mismatch persists and is P0252's target.
- **P0251 R2 local live FAIL / R3 corrective candidate:** 0.0.150-dev/load332 Logres completion button and stock snapshot applied; OFF restored native; ON failed to re-present Logres, despite the same quest 237 remaining open. Diagnostics show `applied=true shown=true snapshot=true` before OFF, `clicks=0 claimCalls=0`; no complete action occurred. Code cause: preferences only replay cached offers, while `HidePresentation` resets completionActive. R3 adds a guarded, lifecycle-invalidation-aware completion re-render, plus action layering; WoW retest needed. No GitHub push verified.
- **P0251 prepared / RUNTIME UNVERIFIED:** user kept quest 237 uncompleted; live ordinary guaranteed reward portrait/x3/1050XP/7s visually match native screenshot. P0251 adds scoped guarded completion control and stock suppression, but neither mutation nor restore is yet validated; click execution explicitly DEFERRED. See P0251 evidence.
- **P0249 PUSHED / PREVIEW RUNTIME PASS (SCOPED):** main `aaee288`, 0.0.149-dev load328 single and multi previews both PASS with item portraits, quantities and CHOICE labels; `questdialoguecheck` PASS (preview context). Natural quest/stock interaction parity DEFERRED. See `docs/memory/evidence/P0250_REWARD_PREVIEW_RUNTIME_ACCEPTANCE.md`.
- **P0248 PUSHED / RUNTIME FAIL:** main `cfd67be`, `0.0.148-dev` load326: two reward preview commands each errored at `Dialogue.lua:1258` (nil method); no visual cards validated. P0249 constructor-method repair pending validation. See `docs/memory/evidence/P0249_REWARD_VISUAL_INSTANCE_FAILURE.md`.
- **P0247 ordinary source P0248 baseline PASS (scoped):** main `0f2d605`, 0.0.147-dev/load324 screenshot and diagnostics show quest237 item x3 / XP1050 / 7s; `gate=name-ordinary` and `requests=0` is expected for the available name. Earlier missing reward name remains INTERMITTENT OPEN; P0248 portrait UI runtime UNVERIFIED.
- **P0246 PUSHED; ITEM STILL MISSING / REQUESTS ZERO:** GitHub `9eb711f`; 0.0.146-dev load321 natural QUEST_COMPLETE=1 shown=1, `guaranteed-item-unavailable`; P0246 registered both item events, but `requests=0 signals=0 resolved=0 pending=false`. XP1050/7s and native Complete Quest work. Source gate remains UNKNOWN; P0247 diagnostic RUNTIME UNVERIFIED.
- **P0245 R1 PUSHED / ITEM VISUAL STILL FAILING:** GitHub main `1bf3423`; screenshot shows native Lesser Healing Potion x3 while Logres keeps item-review fallback, with 1050 XP/7s and Blizzard Complete Quest intact. Latest 0.0.145-dev load319 checkall complete; dialogue counters collected pre-interaction so one-shot cache outcome not established. P0246 event-driven recovery RUNTIME UNVERIFIED.
- **P0244 SCOPED MONEY RUNTIME PASS; ITEM OPEN / INTERMITTENT:** main `1ce1de1`; user screenshot shows 7s, 1050 XP, native Complete Quest, but Logres item-review fallback while stock shows Lesser Healing Potion x3. Load318 probe captures itemID858/count3 with empty name/link and zero mutations; P0245 one-shot cache candidate remains UNVERIFIED.
- **P0243 RUNTIME VISUAL ACCEPTED (SCOPED):** pushed `e8455bc`, screenshot confirms quest 237 Logres prose, item x3, XP 1050 and usable Blizzard Complete Quest. Missing **7 silver** in Logres; P0244 adds money candidate. Latest 0.0.143-dev load316 checkall PASS; completion dialogue counters sampled before event.
- **P0243 CANDIDATE:** P0242 pushed `18b0fa0`, load 315 registered; user reports quest panel without Complete/rewards; natural quest 237 probe has ordinary guaranteed item and XP, but no post-event QuestDialogue check. Reward readout candidate only; R0 prewrite checker FAIL (empty footer expected), R1 corrected checker and full-suite prewrite gate; runtime UNVERIFIED.
- **P0242 CANDIDATE:** P0241 pushed `ee1cbd3`; load 313 questdialoguecheck PASS, natural QUEST_COMPLETE quest 237 observed but reward name/link incomplete; progress events zero. Additive completion text only; runtime appearance UNVERIFIED.
- **P0241 CANDIDATE:** Verified pushed P0240 `048cd77`; additive event-driven quest progress read/paging only; runtime UNVERIFIED until natural state; Blizzard Continue/claim/gossip stock. P0241 evidence.
- **P0240 SOURCE AUDIT:** P0239 `22ba7ab` verified. Existing event-owned read probe covers progress/complete but no naturally observed runtime state; Continue, final reward claim and quest gossip mutation remain gated. Details in P0240 evidence.
- **P0238 Settings UI RUNTIME ACCEPTED (2026-10-17):** pushed `0eb1976`; uploaded `0.0.140-dev` load 312 reports `/logres settings`, `preferencecheck` PASS (revision=8 callbacks=2), saved Immersion/Active Quest ON, and user-observed no UI issues. Per-button transitions and full error log not captured. See P0239 evidence.
- **P0237 R1 pushed and verified:** GitHub main `bb1f772` records the accepted P0236 POI result and the P0237 R0 prewrite manifest failure. P0238 settings access remains pending in-client validation.
- **P0236 broad POIs RUNTIME PASS (2026-10-17):** loadCount 311, nearby source ready, supportedKinds=13, nearbyKinds=5, final 4 service + 2 historical quest glyphs; 6 distance-sized glyphs with distinct scales, user visually accepted. Not all-map or current-quest proof; fine polish deferred. See P0237 evidence.
- **P0235 live result**: user saw flight masters, innkeepers and repair services with different colors; 0.0.138-dev loadCount 310 `compass nearby ready candidates=1 shown=1`, `compass services ready candidates=1 shown=1`, compasscheck PASS. Distinct categories observed by user over movement, not simultaneous count. P0236 follow-up fixes breadth/size; historical quest starts still not current offers.
- **User-identified P0235 classification gap (2026-10-17):** flight masters may be shown as possible quest givers only if they have any historical quest start, while service-only flight masters and innkeepers are missing entirely. Confirmed by inspecting `QuestieDBNearby:ScanChunk` quest-only spawn gate; this is a feature coverage FAIL in P0234, not proof service NPCs are absent. P0235 adds service-only support but remains live UNVERIFIED. Evidence `docs/memory/evidence/P0235_INDEPENDENT_SERVICE_ROLES.md`.
- **P0233 runtime evidence (load 307):** `compasscheck` without preceding `questiedbprobe` in this load reports `provider=ready candidates=4 shown=2`. User-followed glyph reached a real quest giver; one physical path validated. Exact NPC identity, eligibility, broad map coverage, and all service/tracking markers not established. See P0233 evidence.
- **P0231 new runtime proof (0.0.137-dev loadCount 306):** QuestieDB 1.0.6 loaded Forever baked contract-compatible; nearby `index=ready map=1432 area=38 scanned=13392 ids=13392 zoneNPCs=153 questNPCs=30 spawns=38 nearby=5 radius=50 truncated=false`; canonical map trace `requested=1432 chain=1432 entries=54 failure=- trigger=panel-map-diagnostic`; Compass Check `provider=ready candidates=4 shown=2`. This establishes in-game indexing and addon-owned marker show state **after manual panel retry**. Autonomous startup, general map coverage, visual accuracy and eligible quest offers remain unverified. Evidence: `docs/memory/evidence/P0232_P0231_RUNTIME_NEARBY_EVIDENCE.md`.
- **P0230 FAIL, new 0.0.136-dev runtime evidence**: loadCount 305, QuestieDB v1.0.6 compatible, near index `map-not-in-provider-zone-table`, `map=- area=- scanned=0 ids=0`, compass `candidates=0 shown=0`. Native compasscheck PASS checks heading/waypoint policy, not nearby glyphs. A missing map mapping aborts index before positions are read; no evidence of zero nearby NPCs. No new Lua error is recorded by these panel lines, but a full WoW Lua/taint log was not provided. See P0231 evidence.
- **P0228 runtime provider PASS, newly observed**: uploaded 0.0.135-dev diagnostics loadCount 304 show QuestieDB registered=yes loaded=yes tocVersion=1.0.6 tocFlavor=Forever tocMode=baked contract=1 mode=baked provider=contract-compatible in two panel runs. Quest location/gossip remains DEFERRED; no compass glyph results were part of P0228.
- **P0230 scope corrections**: discarded hardcoded Loch Modan-only suggestion; use dynamic current-zone mapping and 50-yard candidate radius. The user reports the Blizzard minimap is HIDDEN during normal immersion: it must NOT be used as the visible fallback to justify missing compass features. Database-only spawns never establish quest availability.

- P0229 process correction: user reported QuestieDB visible in WoW; prior `not-installed` claim inferred absence from one path and old loadCount 300 diagnostics despite loadCount 302. The first P0228 applier failed pre-write `CURRENT.md` EOF hygiene, then R1 repaired the generator. The existing developer panel already offers **E — Compass and Navigation → QuestieDB Location Probe** (fifth action); open with `/logres panel`. The assistant omitted these steps and repeatedly requested unchanged diagnostics. This is documented assistant failure, not proof that QuestieDB is absent or that any new glyphs should appear. P0228 runtime remains UNVERIFIED. Evidence: `docs/memory/evidence/P0229_QUESTIEDB_DIAGNOSTIC_HANDOFF_FAILURE.md`.
- GitHub main P0227 `7c6850b` verified. Existing waypoint and focused accepted quest direction are P0223 user-accepted. Additional native POI feeds remain empty in tested Loch Modan environment; additional POI glyphs remain OPEN.
- P0226 0.0.134-dev last recorded `provider=not-installed` meant unavailable `_G.LibQuestieDB` in that run; it does **not** prove absent installation or failure of newer load count 302. Prior lack of proper state separation is an integration defect.
- `Questie/QuestieDB` v1.0.6 Source `ModeIndicator.GetStatus().expansion` is nil for Baked; generated baked TOC declares `X-Flavor: Forever`; Questie checks `RequireContract`, PlateSmith optional companion uses `OptionalDeps: QuestieDB`. Those are source findings, not yet new WoW runtime proof.
- QuestieDB remains optional for Logres as a whole; third-party data may miss hidden, patch-specific and phased quests. Redistribution/license unresolved; do not bundle it or claim CurseForge-managed dependency.

## Next Action
Apply P0257 transactionally from exact `23307aa` with complete shadow/postwrite static checks and `git diff --check`. User commits and pushes; verify GitHub. Deploy, `/reload`, then P — Previews: Single reward must show the identical in-panel Complete Quest button and normal icon/count/XP/money with NO Blizzard completion instruction; clicking the preview button must report preview-only and never claim a quest. Multiple reward cards must remain visual and retain Blizzard choice fallback. Inspect Quest Dialogue Preview for unchanged Accept/Decline placement. Next add full NPC-page/choice/Continue fixtures; then extend preview-first coverage to every other Logres UI element. Native claim flash, full choice handling and unspecified gameplay bugs remain OPEN; quest 237 unclaimed.

## Success Criteria
Static suite and in-client preview clean with no Lua/taint/protected/secret errors. No fixed quest item mappings. Dynamic guaranteed and selectable items use ordinary guarded `GetQuestItemInfo` icon, name, count; if missing/secret/overflow, retain fail-open Blizzard rewards. The two-column reward cards do not overlap prose/paging, and Blizzard claim and choice controls remain actionable. Multiple-item natural source parity remains DEFERRED if no relevant quest; no claim of completion until observed.

## Do Not Reopen Without New Evidence
Do not infer addon installation from one guessed filesystem path or the presence/absence of a Lua global alone. No hard QuestieDB dependency, package bundling, unknown CurseForge project ID, global quest ID scans on updates, guessed quest availability, invented coordinates or native pin scraping. Do not hide the Blizzard minimap, alter user-accepted waypoint/focused-quest bearings, or treat missing locations as PASS. Baked flavor must not be guessed from a Source-only indicator. Keep negative and deferred evidence explicit.

## Relevant References
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
