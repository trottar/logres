## P0259 — accepted modularity-first all-NPC program (2026-10-18)

GitHub `main` `edec5eb` verifies P0258 pushed; the user reports Multiple reward preview looks good. **D-047 accepted:** comprehensive scope covers ALL NPC interactions; prioritize a cohesive DynamicCam NPC-session/camera experience and consistent Logres styling over unnecessary full Blizzard UI reimplementation. Use preview-first D-046 components, preserving live adapters, safeguarded transactions and fail-open stock UI; native-backed presentation and hybrid integration are valid endpoints. Banks and auction houses remain **DEFERRED PENDING POST-MODULARITY ASSESSMENT**, not rejected. Mandatory order: **P0259 durable memory -> P0260 source modularity audit -> evidence-led modularity extraction/fixes -> post-modularity feasibility reranking**. The audit must separate visual complexity, transactional safety, immersion benefit, and cost; don't assume every NPC service exists in Forever. No runtime code changed in P0259. See `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md` and `docs/memory/evidence/P0259_NPC_MODULARITY_SEQUENCE.md`. Real reward choices/claims, native frame flash and unspecified gameplay bugs remain OPEN/deferred.

## P0258 — multiple-reward preview action parity (2026-10-18)

Verified pushed P0257 `94635d3`. New user screenshot shows Multi sample four reward/choice cards correctly but unnecessary “Choose and complete in Blizzard quest window” footer and no Complete Quest visual. The user accepts other previews and requests the **same in-panel Complete Quest preview as Single**, with no extra text. P0258 updates only the Multi fixture and preview contract; both synthetic modes now use `action="preview-complete"` / `1050 XP | 7s`, retaining three non-interactive CHOICE cards. The existing shared view/button and preview-only click interception are unchanged. Actual multiple-choice selection/claim remains Blizzard-owned; native fallback/flash OPEN, quest237 reserved. **RUNTIME UNVERIFIED**; full D-046 preview coverage and NPC variants still OPEN. See `docs/memory/evidence/P0258_MULTI_PREVIEW_ACTION_PARITY.md`.

## P0257 — preview-first universal UI model pipeline; quest rewards first (2026-10-18)

Verified pushed P0256 `23307aa`. User screenshots show functional P tab and visually correct in-panel Accept/Decline preview but incorrect Single/Multiple reward preview parity: Single lacks the production Complete Quest control and both sample footers contain Blizzard guidance. P0257 adds separate fixture/guarded live reward models consumed by the same `RewardVisual:Present` view; Single uses the real in-panel Accept/Complete button as a **preview-only** interaction; Multiple remains non-interactive with stock choice fallback. D-046 makes preview-first modular source/model/view/controller mandatory for **every** Logres-owned UI element, with full domain coverage still OPEN. No native action or stock suppression modification. Quest237 reserved; actual claim and native flash unverified/OPEN. **P0257 RUNTIME UNVERIFIED**.

## P0256 — project-wide central visual preview gallery (2026-10-18)

P0255 pushed `fc74e14` (checked GitHub). **User requirement:** every Logres UI element needs a reproducible developer preview and **all preview controls must be collected in one new tab**. The current 94 action registry includes 26 visual previews scattered across phases, with at least 2 existing HUD preview commands lacking panel buttons. P0256 adds paginated P — Previews tab, migrating those 26 and registering the 2 HUD controls without changing game action semantics. Inventory and missing previews across every UI area are recorded in `docs/memory/evidence/P0256_UNIVERSAL_PREVIEW_GALLERY.md`; universal visual coverage remains OPEN, with NPC dialogue first. Recent user screenshot version `0.0.154-dev` predates pushed P0255 `0.0.155-dev`, so P0255 offer placement remains RUNTIME UNVERIFIED, not automatically FAIL/PASS. Native claim flash remains OPEN; user found many additional unspecified bugs in 20 min of play (DETAILS PENDING). No claim or protected-state change, quest 237 reserved. **P0256 RUNTIME UNVERIFIED**.

## P0255 — final-page quest actions and in-panel Accept/Decline (2026-10-18)

Verified pushed P0254 `2a7bc5d`, user screenshot of `0.0.154-dev` and “Much better!”: **Complete Quest inside panel VISUAL PASS (scoped)**, quest 237 preserved. Newly reported: completion rewards/action appear before narrative page 2/2; Accept/Decline remain below the panel. P0255 stages only addon-owned UI visibility and quest-offer layout corrections, without touching native claim logic. **RUNTIME UNVERIFIED**. The reported sub-second Blizzard reward-frame flash after Complete Quest is **OPEN**; code restores native frame before dispatching its handler as a safety invariant. Do not apply a timer/polling or conceal native controls without evidence and a safe replacement. See `docs/memory/evidence/P0255_FINAL_PAGE_AND_OFFER_ACTIONS.md`.

## P0254 — shared Complete Quest action outside the narrative panel (2026-10-18)

Verified pushed P0253 `3c0a017`, but user reports **visual still unchanged; P0253 VISUAL FAIL**. Source root geometry puts the shared Accept button ~26px below the reward panel over terrain. P0254 moves that same button within the narrative only after successful guarded stock suppression, shifts completion page controls to lower right, restores original offer position, and reserves panel height for zero-card rewards. No new visual asset, claim routing or native mutation. **RUNTIME UNVERIFIED**. Preserve quest 237; no claims. Evidence `docs/memory/evidence/P0254_COMPLETION_PANEL_ALIGNMENT.md`.

## P0253 — original Accept frame reuse; P0252 visual failure (2026-10-18)

Verified pushed P0252 `34274dc`: screenshot of reserved quest 237 confirms its dynamic reward card and XP/7 silver, duplicate instruction removed, but single Complete Quest action remains visually detached. **P0252 visual FAIL**, despite successful static changes. P0253 removes the separately created completion frame/button and reuses the actual Accept object and offer root, with guarded completion routing, exact same art and original offer restoration. Native claim logic and multi-choice fallback unchanged; final claim remains DEFERRED and quest 237 must not be completed. **P0253 runtime UNVERIFIED** pending offer/complete visual and OFF/ON validation. Evidence: `docs/memory/evidence/P0253_ACCEPT_CONTROL_REUSE.md`.

## P0252 — Complete Quest visual parity and P0251 R3 scoped acceptance (2026-10-18)

GitHub main `45d4654` confirms P0251 R3 pushed. Uploaded `0.0.151-dev`/load334 diagnostics and user "no issues" report: live quest237 completion is shown and native reward controls suppressed with captured snapshot after Immersion OFF→ON; `clicks=0 claimCalls=0`. **P0251 R3 restoration PASS (scoped)**; protected final claim and selectable reward selection remain UNTESTED/DEFERRED. User observes that Complete Quest still lacks visual coherence with the already-proven Accept/Decline button despite sharing its factory; the extra "Complete Quest below" reward footer is redundant. P0252 adjusts only completion rule draw layer and action-panel gap, removes that line only when Logres has a guarded actionable button, and keeps stock-owned guidance on all fallbacks. **P0252 visual runtime UNVERIFIED** until WoW test. Do not complete reserved quest 237. Evidence: `docs/memory/evidence/P0252_COMPLETION_ACTION_VISUAL.md`.

## P0251 R3 — quest completion Immersion OFF/ON recovery (2026-10-18)

User-provided screenshots and exported SavedVariables for `0.0.150-dev`/load332: natural quest 237, `questdialogue completioncontrol` reports `applied=true shown=true snapshot=true reason=applied clicks=0 claimCalls=0`. Blizzard was suppressed with Logres Complete Quest shown; after Immersion OFF, native Blizzard QuestFrame and Complete Quest control visibly returned. After Immersion ON, Logres panel did not return despite the same native completion being open. **RUNTIME FAIL (scope: toggling ON)**. Source cause: P0251 `HidePresentation()` clears `completionActive`; `ApplyPreferences()` re-presents only `activeDetail` quest offers, not completions, and ON does not emit another `QUEST_COMPLETE`. R3 caches an ordinary completion identity, requires native reward frame shown and a matching current ordinary quest identity before re-presenting, discards stale cache on lifecycle exit, preserves real event count, and promotes the existing button/underline layer. This is a proposed code correction, **runtime UNVERIFIED**. Claim clicks remain zero; the user explicitly retains quest 237. Remote GitHub main was P0250 `c17ef52` during R3 preparation, not a verified pushed P0251.

## P0251 — guarded quest completion control candidate (2026-10-18)

Verified `main` P0250 `c17ef52` and user live quest 237 screenshot `0.0.149-dev`/load330 show exact matching Logres/Blizzard Lesser Healing Potion x3, 1050 XP and 7s. This is scoped **live single guaranteed-item portrait presentation PASS**. User explicitly keeps quest uncompleted as a test fixture. P0251 adds Logres-styled Complete Quest button and capability-gated stock suppression, using the native reward completion handler only after complete native restoration and only for zero-choice/zero-payment ordinary nonprotected quests. Runtime and click execution UNVERIFIED; click must not be tested on quest 237. Native stock remains in place on any unsupported or secret-capable gate, and for all selectable/expensive completions. The earlier P0248 failures and intermittent reward name remain recorded.

## P0250 — P0249 preview runtime acceptance (2026-10-18)

Verified GitHub `main` P0249 `aaee288` and user-provided WoW `0.0.149-dev` / loadCount 328 screenshot plus diagnostics. Phase F `/logres questrewardpreview single` **PASS** (portrait, name, x3, sample 1050 XP / 7s) and `questrewardpreview multi` **PASS** (four cards, two columns, three `CHOICE` labels and x2 count). `questdialoguecheck` **PASS** with `shown=true`, `presentationReason=reward-preview`, `error=nil`. Therefore P0249 constructor-method repair is **RUNTIME ACCEPTED for synthetic preview rendering only**, correcting P0248's documented `Dialogue.lua:1258` error. Synthetic previews are not natural quest evidence; `rewardvisual cards=0` in quest dialogue diagnostic remains CANDIDATE, not an actual reward-source failure or live PASS. The developer panel obscures the right column in the screenshot; no independent intrinsic-clipping failure is established. Live guaranteed and selectable reward parity, native choice/claim behavior, previous intermittent missing name, and a fresh Phase 0 full-suite run remain OPEN/DEFERRED. See `docs/memory/evidence/P0250_REWARD_PREVIEW_RUNTIME_ACCEPTANCE.md`. Next: record scoped acceptance and await naturally available quest evidence or a distinct user-directed visual polish task, without requiring contrived gameplay.

## P0249 — Reward portrait runtime constructor repair (2026-10-18)

Verified GitHub `main` P0248 `cfd67be` (`0.0.148-dev`) was exercised in WoW loadCount 326. The exported diagnostic records `/logres questrewardpreview single` and `/logres questrewardpreview multi` both throwing `Dialogue.lua:1258: attempt to call a nil value`; after the failures, `questdialogue rewardvisual: CANDIDATE (cards=0 overflow=false stock=retained)`. This is a real P0248 runtime **FAIL**, not a passed preview. Diagnosis from the pushed source: `RewardVisual.New()` returned a plain `{root, objectiveText, slots}` table, whereas `Reset` and `Present` live on `Visual`; `PresentText` called `self.rewardVisual:Reset()` and failed. P0249 adds instance method lookup via `{ __index = Visual }` without changing reward source, choice/claim ownership, or geometry. A new static regression contract guards this invariant. R0/R1 prewrite failures and P0248 R2 runtime failure remain in evidence. P0249 runtime **UNVERIFIED**; next validate both synthetic previews and Quest Dialogue Check, without seeking a contrived quest. Earlier intermittent item-name failure and live multiple-choice parity remain OPEN/DEFERRED.

## P0248 R2 — Dynamic Logres reward portraits (2026-10-18)

Verified P0247 main `0f2d605`, 0.0.147-dev/load324 screenshot and Quest Dialogue Check: ordinary quest 237 `Lesser Healing Potion x3`, XP 1050, money 7s matching Blizzard; `gate=name-ordinary`, requests=0; accepted ordinary-source output, **not** proof item-data cache recovery. User wants Logres-consistent item portrait UI and dynamic multiple rewards. P0248 candidate builds up to six read-only source-derived item cards with icon, name, stack count, CHOICE label, XP/money footer, plus single/multi synthetic visual previews. Every Blizzard choice and Complete Quest control remains untouched; older intermittent missing source and multi-reward live scope stay OPEN/DEFERRED. Original P0248 R0 applier REFUSED prewrite because of ambiguous HidePresentation/OnInitialize anchor (no tracked writes); R1 narrowed the anchor, but added a local handler that violated the 60-local limit; R2 moves the preview runner onto the existing Logres namespace. Runtime acceptance **UNVERIFIED**. Evidence `docs/memory/evidence/P0248_REWARD_CARD_PRESENTATION.md`.

P0248 R0/R1 applier failures: R0 ambiguous Dialogue.lua source anchor; R1 shadow static audit detected 61 captured handleCommand locals versus limit 60. Both aborted before tracked writes. R2 namespaces reward preview runner; remains UNVERIFIED until full shadow suite and WoW tests.

## P0247 — P0246 item-data request not reached (2026-10-18)

Verified P0246 main `9eb711f`; natural quest 237 reward screenshot unchanged: stock potion x3 and Complete Quest, Logres fallback, XP1050/7s correct. Post-event diagnostics `0.0.146-dev` load321: completion=1/shown=1, reward item unavailable, `itemcache pending=false requests=0 signals=0 resolved=0 state=not-observed` despite both item-data events registered. This is a failed P0246 effectiveness result, **not** evidence that delayed data events failed; the request branch never ran. P0247 instruments the existing secret-safe source gates with developer-panel `gate=` without extra API reads or actions. Precise block reason requires in-client observation. See `docs/memory/evidence/P0247_REWARD_SOURCE_GATE_DIAGNOSTIC.md`.

## P0246 — P0245 immediate cache fallback still missing reward name (2026-10-18)

GitHub `main` P0245 R1 `1bf3423` verified. User screenshot on the **same quest 237** again shows Logres's "Review rewards in Blizzard quest window" while stock presents Lesser Healing Potion x3. Logres correctly retains 1050 XP, 7s, quest prose and the accessible native Complete Quest button. Latest diagnostics confirm `0.0.145-dev` loadCount 319, Quest Dialogue Check PASS and `checkall: complete`, but **completion counters were sampled before QUEST_COMPLETE**, so the log does not establish why the P0245 immediate GetItemInfo lookup was empty. Prior independent Quest Interaction Probe captures show ordinary itemID=858/count=3 while name/link may be empty, and some captures return the name. **Observed P0245 presentation failure: OPEN / INTERMITTENT.** Do not call R1 an effective live fix; no full Lua/taint log supplied.

Narrow hypothesis: immediate reward metadata and GetItemInfo cache are unavailable at the moment QUEST_COMPLETE is delivered, but item identity can become ordinary later. Public API describes GET_ITEM_INFO_RECEIVED (uncached GetItemInfo) and ITEM_DATA_LOAD_RESULT (explicit C_Item.RequestLoadItemDataByID); Forever 1.60.1 lists C_Item.RequestLoadItemDataByID. Both may carry secret-capable payloads, so guard before any inspection.

P0246 event-driven candidate (0.0.146-dev): only one guaranteed reward with ordinary itemID, bounded count and zero choices may be pending, and only when event registration succeeded. Preserve P0245 immediate read; if missing, send at most one guarded C_Item data-load request, register both item-data event sources, and update the **Logres-owned reward footer only** when the item ID, player-quest identity, active completion, presentation generation and ordinary resolved name all match. On missing/secret/failed/late event, clear or retain safe fallback. No timer, global polling, item assumptions, automatic claim/choice, stock mutation, or UI suppression. Existing XP and money remain in the footer. Developer panel records event registrations, requests, matching signals, resolutions and bounded state; no protected Blizzard UI inspection.

**Runtime UNVERIFIED:** static checks cannot prove the Forever item event response. Run F — Quest Experience -> Quest Dialogue Check, Phase 0 -> Run All, and on natural completion check post-event itemcache line and Logres item name. If no event, mark DEFERRED; if event returns ordinary but name remains absent, record FAIL with observed source, not a fabricated name. Blizzard Complete Quest retained until separately proven replacement.
## P0245 — P0244 money PASS and intermittent quest-item name (2026-10-17)

P0244 main `1ce1de1` verified. User screenshot confirms quest 237 Logres completion money **7s** and XP 1050 alongside native Complete Quest, but **Logres item name is missing** although Blizzard shows Lesser Healing Potion x3. Diagnostics `0.0.144-dev` loadCount 318, panel checks PASS and later natural QUEST_COMPLETE probe with itemID 858/quantity 3 but name empty/link nil, failures=0, mutations=0. Treat as **OPEN / INTERMITTENT metadata availability**, not total reward completion. P0245 adds one secret-safe guarded `GetItemInfo(itemID)` name read only when the quest item name is absent; absent cache fails open to stock. No polling, claim mutation, reward choice UI, or new suppression. Runtime cache result UNVERIFIED, full check suite required. Evidence `docs/memory/evidence/P0245_QUEST_REWARD_ITEM_NAME_CACHE.md`.
## P0244 — P0243 visual reward acceptance; add source-gated money payout (2026-10-17)

Verified P0243 R1 main `e8455bc`. User screenshot confirms visible paged Logres quest 237 completion prose, Lesser Healing Potion x3, 1050 XP, and available Blizzard Complete Quest. The Blizzard pane also shows 7 silver **missing** from Logres; this is an OPEN monetary reward omission, not completed reward ownership. Diagnostics 0.0.143-dev/load316 show checkall PASS, Quest Interaction Probe natural QUEST_COMPLETE quest237 failures=0/quest mutations=0; at a later capture item name/link were temporarily unavailable despite the screenshot's correct item. P0244 adds guarded ordinary `GetQuestLogRewardMoney` by validated quest ID and optional `g s c` payout to the two-line footer; stock claim and all choices retained. Source and safety static test mandatory, runtime money rendering **UNVERIFIED**. Future player-triggered Complete/Claim and choice/gossip capabilities separate. Evidence `docs/memory/evidence/P0244_QUEST_MONEY_AND_COMPLETION_VISUAL_ACCEPTANCE.md`.
## P0243 — reward UI gap, bounded readout candidate (2026-10-17)

Verified P0242 `18b0fa0` on GitHub main. User reports the Logres quest appears but lacks Complete and rewards. Load 315 QuestDialogue registers completion, but its diagnostic predates the observed event; separate read-only QuestInteractionProbe naturally records quest 237 reward prose, XP 1050, zero choices and one now-resolved guaranteed `Lesser Healing Potion x3`. No mutation; no secret/failures. P0242's lack of Logres rewards or Complete was by design, but is now an explicit **OPEN incomplete capability**; native Blizzard visibility was not captured, so its availability may not be inferred. P0243 R0 prewrite FAIL: P0242 checker rejected the changed completion footer literal; no tracked writes. R1 repairs P0242 static contract without changing its safety bans, and must re-pass complete shadow suite. P0243 candidate adds only secret-checked read-only one-item/XP summary or stock-review fallback to existing 50px footer. Complete/Claim/selection/gossip remain Blizzard-owned; no new suppression or polling. Runtime reward presentation **UNVERIFIED**. Evidence `docs/memory/evidence/P0243_QUEST_REWARD_VISIBILITY_AND_STOCK_FALLBACK.md`.
## P0242 — natural completion evidence and additive narrative candidate (2026-10-17)

P0241 `ee1cbd3` verified on main. Latest user diagnostics `0.0.141-dev` loadCount 313 give questdialoguecheck PASS, progress source registered with **zero observed progress events**, and an independent natural QUEST_COMPLETE for quest 237 with ordinary title, reward prose, XP 1050, zero choices and one guaranteed item. Its item name is empty and link nil despite itemID 858: incomplete reward information prohibits taking Blizzard reward/claim ownership. **P0241 progress appearance remains DEFERRED**. P0242 candidate adds only secret-safe ordinary completion narrative via existing QuestDialogue paging and stock controls intact; no reward rendering/mutation, polling or new stock suppression. Runtime renderer **UNVERIFIED** until natural event; no contrived travel. Evidence `docs/memory/evidence/P0242_QUEST_COMPLETION_NARRATIVE.md`.

## P0241 — additive quest-progress narrative (2026-10-17)

Verified P0240 `048cd77`. Candidate `0.0.141-dev` extends the existing QuestDialogue event frame with ordinary `QUEST_PROGRESS` identity/title/text, displays the source text in the accepted paged renderer without Logres controls, and clears stale presentation on `QUEST_COMPLETE`/`GOSSIP_CLOSED`; all Blizzard progress/reward/gossip controls remain accessible. Read-only `QuestInteractionProbe` remains separate; no new timers, polling, quest mutations, or stock suppression. No natural progress state has been observed: **runtime UNVERIFIED / environmentally deferred until naturally available**. Quest Dialogue Check adds a progress diagnostic; source/contract PASS alone is not an in-game PASS. P0236 compass and P0238 settings unchanged. Evidence `docs/memory/evidence/P0241_ADDITIVE_QUEST_PROGRESS.md`.

## P0240 — Quest lifecycle source/ownership delta audit (2026-10-17)

Verified P0239 pushed `22ba7ab`. D-035 requires eventual Logres-owned NPC quest progress/Continue, completion/claim/reward, and quest-related gossip, but **existing P0128 source audit and P0129 runtime evidence already resolved API existence and offered/gossip read samples**. Current `Quest/InteractionProbe.lua` already captures `QUEST_PROGRESS`/`QUEST_COMPLETE` read-only and bounded choice/reward/gossip rows; `Quest/Dialogue.lua` only renders `QUEST_DETAIL`, and `Quest/OfferActionProbe.lua` intentionally limits mutations to player-initiated Accept/Decline. No natural progress/complete events or Logres Continue, GetQuestReward, or gossip selection have been accepted as runtime proof. `CompleteQuest()` advances progress; `GetQuestReward(choice)` finalizes. **P0240 docs/source audit only**; no control suppression, no new probes/polling, no WoW redeploy. Next P0241: narrow fail-open/additive progress reading/presentation gate using existing observer, validated when a natural event exists; keep completion/reward/gossip stock. Evidence `docs/memory/evidence/P0240_QUEST_LIFECYCLE_CAPABILITY_AUDIT.md`.

## P0239 — P0238 settings UI accepted; next quest-lifecycle source audit (2026-10-17)

GitHub `main` P0238 `0eb1976` verified. User reports no settings UI issues. Latest uploaded Logres `0.0.140-dev` / loadCount 312 records `/logres settings`, `/logres preferencecheck` PASS (callbacks=2 revision=8 immersionEnabled=true), and both saved preferences ON at export. Individual button clicks and intermediate OFF states were not logged; user observation is the basis for visual acceptance. No full taint/Lua log supplied. **Accept P0238 limited two-choice settings panel for observed runtime scope**; final accessibility/settings polish remains OPEN. Preserve P0236 accepted POI compass and deferred historical quest relevance. Next distinct H.3 task: P0240 **read-only/source audit of NPC quest progress/Continue, completion/Complete, rewards and quest-gossip transition capability** under D-035; do not invent API proof or suppress stock. Evidence `docs/memory/evidence/P0239_SETTINGS_UI_RUNTIME_ACCEPTANCE.md`. Docs only, no WoW redeploy.

## P0238 — minimal persisted-settings access (2026-10-17)

Verified GitHub main P0237 R1 `bb1f772`; user accepted broad P0236 compass and explicitly deferred filters/color/size polish until whole-interface work. Current source offers only two persisted user preference choices (`immersionEnabled`, `activeQuestEnabled`); a full settings/accessibility design has no dedicated approved sheet. P0238 introduces a bounded user-facing Settings frame with these two controls through existing `GetPreference`/`SetPreference` and preference subscription, accessible via `/logres settings` and Phase D **Settings UI**. No new preferences, database schema, protected mutation, minimap control, poller, user layout editor or change to compass. Runtime UNVERIFIED; test panel value reflection, both OFF/ON paths, Immersion stock restoration, and errors. See `docs/memory/evidence/P0238_PLAYER_SETTINGS_SCOPE.md`.

## P0237 — P0236 nearby POI runtime pass, refinements deferred (2026-10-17)

GitHub main P0236 `e6179b8` verified. User-approved in-game broad POI display; uploaded Logres `0.0.139-dev` loadCount 311: QuestieDB area 1432 -> 38 index ready, 13,392 NPC IDs scanned, 13 service role kinds supported in this provider runtime, 5 kinds nearby, 31 cached service spawns, 9 nearby service spawn matches, final compass 4 service + 2 historical quest candidates shown; 6 local glyphs sized 0.8366–1.1874; Compass Check PASS. These are bounded, addon-owned runtime results, not all-map or active quest-service proof; gossip probe remains DEFERRED. **Accepted working P0236 baseline**. User requests POI filters, historical quest-giver relevance, density, colors and size polish be combined with rest-of-UI refinement later, not immediate P0237 runtime edits. Next: resume remaining Phase H integration/polish work from approved roadmap. Evidence `docs/memory/evidence/P0237_P0236_RUNTIME_POI_ACCEPTANCE.md`. P0237 docs only, no WoW redeploy.

## P0236 — wide historical POI discovery and distance-sized glyphs (2026-10-17)

Verified P0235 pushed `5c77b1e`; latest 0.0.138-dev loadCount 310 gives `compass nearby ready 1/1`, `compass services ready 1/1`, base compasscheck PASS, and user visually found flight master/innkeeper/repair. User also reports historical quest NPCs without current quest availability and no local POI distance scaling. P0236 prepares **all provider-supported service-flag categories** (including vendor/trainer/banker/auction/stable and more) without reading minimap tracking preferences, keeps independent quest and service qualification, radius 50 yards, one category per NPC, per-type bounded cache and at most 32 service glyphs in the finite viewport. Adds distance-dependent size to ordinary nearby POIs/services/tracking vignettes, not focused quest or manual waypoint. No claim of active services, current quest offers, minimap herb/ore blips, or universal map coverage. Filter UI deferred until the user inspects these categories. **Runtime not tested until deployed.** Evidence `docs/memory/evidence/P0236_POI_COVERAGE_AND_PROXIMITY_TEST.md`.

## P0235 — Quest-independent historical flight/inn/repair roles (2026-10-17)

Main P0234 `e10c79a` verified. User clarified current QuestieDB markers represent historical `questStarts` NPCs only: flight masters with quests may be mislabeled, while service-only flight masters/innkeepers/etc. are wholly absent. Existing `ScanChunk` gates NPC spawn indexing under quests; source coverage FAIL, not a live service-negative. P0235 prepares a guarded runtime fix: gate `NpcDB.npcFlags`/provider `Enum.npcFlags` at contract 4 separately from the proven contract 1 quest feed, share the finite 96-ID/frame zone scan, independently cache 50-yard service candidates with category caps, display four separate tinted possible service glyphs, and give dual-role NPC one service glyph, never a duplicate possible quest giver. No Blizzard pin introspection, fixed flag integers, login polling, hard dependency, map guessing, or radius changes. Runtime **UNVERIFIED**. See `docs/memory/evidence/P0235_INDEPENDENT_SERVICE_ROLES.md`.

## P0234 — Native POI priority and QuestieDB v4 service-source audit (2026-10-17)

GitHub main P0233 `27e9e36` verified. Current Logres source routes ordinary native area POIs, quest-map points, and positioned vignettes into finite compass lanes, with accepted focused quest routing and native before historical QuestieDB quest-giver candidates. Tracking filter definitions are not coordinates (D-043). Audited upstream QuestieDB v1.0.6: `NpcDB.npcFlags` role mask, `NpcDB.spawns` zone percentages and provider `Enum.npcFlags` active-flavor masks guaranteed by `RequireContract(4)` (`src/config.lua` v4, `src/types/Npc.t.lua`, `src/types/LibQuestieDB.t.lua`, `docs/api.md`). **Source finding only**, no live service evidence, no service glyphs added. Next P0235: bounded optional possible flight master/innkeeper/repair markers in existing zone index with v4 gate, low priority and separate runtime counters. Preserve 50-yard scope, hidden native minimap during immersion, earlier P0230 negative and P0233 positive evidence. Source audit at `docs/memory/evidence/P0234_NEARBY_POI_SOURCE_AND_PRIORITY_AUDIT.md`.

## P0233 — Unassisted compass startup and quest-giver wayfinding (2026-10-17)

Verified GitHub P0232 `ca639c9`. New 0.0.137-dev loadCount 307: `/logres compasscheck` was run without prior QuestieDB panel retry in this load and reports `provider=ready candidates=4 shown=2`. User followed an actual displayed glyph to a quest giver; one physical destination match is user-observed. Startup/source/glyph readiness PASS in this map; no universal zone, NPC ID, quest eligibility, services or live tracking coverage claim. User perceived more markers than immediate proximity, acceptable for this initial iteration; exported count is a snapshot; no radius bug proven. Earlier load 305 failure and load 306 manual-retry limitation remain recorded. Next H.3: audit missing POI source categories and glyph priority, not polling or radius changes. P0233 docs only. Evidence `docs/memory/evidence/P0233_UNASSISTED_COMPASS_AND_PHYSICAL_QUEST_GIVER_PROOF.md`.

## P0232 — P0231 runtime nearby markers confirmed after panel retry (2026-10-17)

GitHub `main` P0231 `968675a` verified. Fresh 0.0.137-dev loadCount 306 (`questiedbprobe` then `compasscheck`): QuestieDB 1.0.6 compatible; `questiedbnearby index=ready map=1432 area=38 scanned=13392 ids=13392 zoneNPCs=153 questNPCs=30 spawns=38 nearby=5 radius=50 truncated=false`; map `requested=1432 chain=1432 entries=54 failure=- trigger=panel-map-diagnostic`; compass `provider=ready candidates=4 shown=2`. Nearby source/index and addon-owned renderer state **RUNTIME PASS in this observed map after panel-triggered retry**; no visual accuracy or universal map proof. Prior P0230 zero-scan FAIL remains historical evidence. Because Phase E provider probe calls a manual StartIndex retry, **autonomous login/map-change indexing is UNVERIFIED**. Next: fresh `/reload` then **E → Compass Check first** (no manual provider retry) to distinguish startup readiness from panel recovery. No travel/polling. Evidence `docs/memory/evidence/P0232_P0231_RUNTIME_NEARBY_EVIDENCE.md`.

## P0231 — First P0230 WoW map-bridge failure and bounded trace (2026-10-17)

P0230 pushed to main `92de16d`, 0.0.136-dev loadCount 305. QuestieDB 1.0.6 Forever Baked remained contract-compatible. New `questiedbnearby` recorded `map-not-in-provider-zone-table`, cleared map/area, `scanned=0 ids=0 spawns=0 nearby=0`. Compass near candidates/shown=0/0; `compasscheck: PASS` certifies heading/policy only, **NOT** nearby marker coverage. This is **FEATURE FAIL / MAP RESOLUTION UNREPRODUCED DETAILS**, not zero nearby NPCs. P0231 extends the bounded parent walk to 12 and records ordinary map leaf, full ancestor chain, table count, and termination reason in existing Phase E panel output; one explicit button press re-evaluates bridge. No fabricated mapping and no native minimap visible fallback. Evidence: `docs/memory/evidence/P0231_DYNAMIC_MAP_BRIDGE_FAILURE.md`. New runtime remains UNVERIFIED until user probe.

## P0230 — Dynamic zone-selecting 50-yard QuestieDB candidates (2026-10-17)

Fresh 0.0.135-dev loadCount 304 establishes P0228 **provider compatibility runtime PASS** (`QuestieDB` 1.0.6 registered/loaded, Forever baked, contract 1), not quest location accuracy. User explicitly rejected assistant's Loch Modan-only suggestion; that unsent design is **ABANDONED**. P0230 candidate derives current map and canonical AreaID from QuestieDB's own Forever mapping, asynchronously indexes bounded NPC quest-start spawn coordinates in the selected map, and projects muted possible quest giver glyphs within 50 yards. Native positioned feeds take precedence; no unverified availability claim or changes to native minimap policy. The native minimap is hidden in normal immersion and is not an acceptable visible fallback for missing Logres glyphs. Blizzard lacks a supported public interface for arbitrary live individual tracking blip coordinates. WoW glyph/runtime still **UNVERIFIED** until Phase E panel result and in-game observation. See `docs/memory/evidence/P0230_DYNAMIC_NEARBY_QUEST_CANDIDATES.md`.

## P0229 — QuestieDB assistant failure and panel-first validation rule (2026-10-17)

User reports QuestieDB visible in WoW; assistant's `not-installed` assertion from one WSL directory and older loadCount 300 probe was not justified. It repeated an unchanged `/logres questiedbprobe`, failed to explain that **P0228 provider checks add no compass markers**, initially shipped P0228 with a pre-write EOF blank-line error, and omitted the existing Phase E developer-panel action. Source inspection confirms `/logres panel` → **E — Compass and Navigation** → **QuestieDB Location Probe** (fifth button). P0228 R1 provider runtime remains UNVERIFIED until fresh diagnostics. Future handoffs must be panel-first with expected result, no-change scope, export method, and evidence criteria. Canonical failure record: `docs/memory/evidence/P0229_QUESTIEDB_DIAGNOSTIC_HANDOFF_FAILURE.md`. P0229 is docs-only; no WoW redeploy.

## P0228 — QuestieDB optional load ordering and Baked flavor correction (2026-10-17)

User reports QuestieDB visible in WoW AddOns; previous `provider=not-installed` claim inferred installation absence incorrectly from an unrelated WSL path and an older 0.0.134-dev diagnostic. Official v1.0.6 Baked `ModeIndicator.GetStatus().expansion` is intentionally nil; package TOC `X-Flavor: Forever` is the source of baked flavor, and existing PlateSmith consumer uses `OptionalDeps: QuestieDB`. P0228 adds that optional load order and independently reports addon registry/load, provider contract and correct Source/Baked flavor before map/gossip checks. No additional compass production markers or UI removal. This is **PREPARED / WoW UNVERIFIED**; source positive proof remains DEFERRED. Evidence: `docs/memory/evidence/P0228_QUESTIEDB_LOAD_FLAVOR_REPAIR.md`.

## P0227 — QuestieDB manual install and future public dependency distribution (2026-10-16)

P0225+P0226 pushed in `45bbd0e`; the latest user 0.0.134-dev runtime shows `questiedbprobe: DEFERRED provider=not-installed`, gossip not observed, positive deferred, accepted-quest exclusion negative. No new compass items were expected: P0226 is diagnostic only and P0225 native POI feeds were ordinary-empty. User authorized QuestieDB as supplemental navigation data and requested an automated WSL install and public-release dependency documentation. Official v1.0.6 Forever package SHA-256, safe manual install, update/rollback and missing-provider policy now live in `docs/DEPENDENCIES.md`. This is optional today (not a hard TOC dependency), QuestieDB is distinct from CurseForge LibQuestDB, and the upstream package must not be bundled or auto-declared as a CurseForge requirement without project identity and license/redistribution proof. Database-only spawn coordinates do not establish currently available or hidden quests; preserve native Blizzard data priority and minimap fallback. Evidence: `docs/memory/evidence/P0227_QUESTIEDB_DEPENDENCY_DISTRIBUTION_CHECKPOINT.md`. Docs-only patch; no WoW redeploy.

## P0226 — QuestieDB candidate coverage and compatibility probe (2026-10-16)

P0225 live test: native force-visible/task/hub feeds each returned zero; no POIs on compass. User selected QuestieDB for external location coverage but fears hidden quests disappearing. QuestieDB 1.0.6 Forever supplies historical quest-start/spawn coordinates, not a live eligibility feed, so it CAN miss hidden, newly patched, phased or server-specific quests. P0226 adds a bounded read-only positive/negative QuestieDB public-API probe, gated on Forever flavor and a real gossip quest offer; no QuestieDB dependency or icon yet. Native position feeds and Blizzard minimap remain available. Evidence: `docs/memory/evidence/P0226_QUESTIEDB_SOURCE_ACCEPTANCE_GATE.md`.

## P0225 — Native-first optional map quest offers and quest hubs (2026-10-16)

P0224 source audit committed at `d4a39d1`; user prefers consistent Blizzard-fed dynamic navigation to QuestieDB updates. P0225 candidate adds read-only, bounded public force-visible quest, task-start and quest-hub positions to the existing NavigationSourceProbe. Current waypoint/focused quest renderer untouched. Only observed in-game markers can be accepted; native tracking/service engine blips remain source-blocked and the minimap remains stock. Evidence: `docs/memory/evidence/P0225_NATIVE_MINIMAP_OFFER_SOURCE_EXPANSION.md`.

## P0224 — QuestieDB optional navigation source feasibility (2026-10-16)

P0223 pushed/verified `27505f1`: focused quest bearing/name and some distance-scaling user PASS; close-range visual tuning deferred. POI/available quest/tracking position feeds remain zero or unavailable. Read QuestieDB public `docs/api.md` and Forever/support documentation: `QuestDB.startedBy`, `NpcDB.spawns`, contract version and zone data offer candidate positions, **not live quest availability**. Spawn AreaIDs differ from current UiMapIDs; public contract has no verified direct current-zone join, and client/game flavor, eligibility, phasing and enumeration budget remain blockers. P0224 records this as docs-only source research; third-party dependency and data are NOT added. Next: exact one-positive/one-negative real provider and map compatibility proof; if no viable provider, keep unsupported POIs omitted and Blizzard minimap available. Evidence: `docs/memory/evidence/P0224_QUESTIEDB_NAVIGATION_PROVIDER_AUDIT.md`.

## P0223 — First live quest markers; focused quest and distance-depth correction (2026-10-16)

P0222 pushed and verified `b1fa844`. User screenshot and 0.0.131-dev loadCount 295 confirm actual accepted quest markers and contextual name for three ordinary quest-map positions on map 1432; super-tracked focus quest 237. Positive live quest source is a PARTIAL PASS. Defects: all accepted quests show, and the major glyph has fixed size despite distances 663, 967 and 733 yards. P0223 candidate limits major quest drawing to the source-proven current super-track ID and reuses the existing waypoint's distance/size interpolation; source rows remain intact. Available quest starts, AreaPOIs and vignettes still returned zero; local POI and tracking are OPEN / SOURCE LIMITED. No native pin scanning, generic filter-as-position, polling, combat/secret UI reads, or minimap removal. Evidence: `docs/memory/evidence/P0223_COMPASS_FOCUS_DEPTH_RUNTIME.md`.

## P0222 — Native-position compass integration; P0221 negative result (2026-10-16)

P0220 `09175bc` verified. P0221 `0.0.130-dev` loadCount 293 was applied **locally, not pushed**: user still sees **no non-waypoint compass markers** even with a visible available quest giver. Navigation Source Probe returned availableQuestLines=0 after one `RequestQuestLinesForMap` attempt/event, AreaPOIs=0, four active *tracking filters* but no tracked object positions; no source failures/secrets. Preserve this as **OPEN / VERIFIED NEGATIVE**, not marker PASS. P0222 candidate uses distinct optional public positions from `C_QuestLog.GetQuestsOnMap` (`isQuestStart`, acceptance/completion gates) and `C_VignetteInfo` plus captured AreaPOIs, and shares the existing manual-waypoint bearing projection for multiple approved visual roles. Only location-qualified ordinary data can render; generic herb/ore tracking detections remain SOURCE LIMITED; native minimap stays available. See `docs/memory/evidence/P0222_COMPASS_NATIVE_MAP_PROVIDERS.md`.


## P0221 — Compass missing markers: zero-source and optional request (2026-10-16)

P0220 pushed GitHub `main` `09175bc` yet user reports no quest/POI/tracking live glyphs; source probe 0.0.129-dev loadCount 291 map 1432, radius 133.33y, AreaPOI count 0 and availableQuestLines API present but **ordinary zero rows**, with 0 secret skips and source errors; four tracking flags are choices, not detected positions. Result OPEN / SOURCE EMPTY / PRODUCTION MARKER NOT ACCEPTED. `compasscheck: PASS` covers heading/manual, not live POI coverage. P0221 optionally requests available quest lines once per ordinary current map and uses existing event/manual refresh to observe post-request counts; no timer, retry loop, source mutation/Blizzard presentation inspection or invented markers. Quest-line-only coverage remains limited; if still empty, different genuine source required. See `docs/memory/evidence/P0221_NAVIGATION_EMPTY_SOURCE_AND_REQUEST.md`.

# Project Logres Roadmap

## P0214 — Approved action asset family / bounded scaling policy (2026-10-15)

P0213 pushed as `18dee5f`; user found contrast fine but corrected the process: the twelve `docs/design/approved/` reference sheets are the **approved visual implementation contract**. P0214 candidate replaces only the five shared `Logres/Media/Action/` RGBA textures with sheet-03-derived default/hover/press/checked/flash art at existing size. Native icons/cooldowns, action routes/pet controls, 42px hitboxes, 5px gap, and D-045 v4 layout are untouched. No shadowing of native controls or speculative resizing. User permits limited size/placement adjustments **if actual in-client fidelity requires it**; such changes need separate geometry and click-surface proof. Latest P0213 `0.0.122-dev` loadCount 280 final Run All/Compass/Layout checks PASS in ordinary world; user visual `fine` is not full asset validation. P0214 remains WoW UNVERIFIED. See `docs/memory/evidence/P0214_APPROVED_ACTION_ASSET_FIDELITY.md`.


## P0213 — H.3 narrow compass contrast candidate (2026-10-15)

GitHub main `018ea0a` (P0212 including P0211) verified. Scope: Theme-driven brighter compass direction labels and dark, fixed pixel-offset FontString shadows; no change to compass texture, geometry, bearing, edge fade, manual waypoint, data source, action or pet state. P0202 screenshot reports faint labels/ticks over bright sky; this only addresses **labels**. 0.0.122-dev is a candidate requiring in-game visual and panel tests; do not label visual PASS from static source. Use Phase E Compass Check, Phase H H.2 Map Layout Check/Overlay, Phase 0 Run All; compare light and dark scenery. P0211 pet behavior remains accepted for tested paths, secure interactions/taint still deferred. Evidence `docs/memory/evidence/P0213_H3_COMPASS_CONTRAST_EVIDENCE.md`.

## P0212 — Pet visibility accepted for tested paths; panel-first and established addon research (2026-10-15)

User-confirmed P0211 `0.0.121-dev` loadCount 279: no native PetFrame/PetActionBar on Immersion-ON reload, return on OFF, disappear on ON, no duplicate in observed combat. P0211 diagnostics show first-world `worldArmed=no` while probe unavailable and subsequent `firstArmEvent=pet-probe-armed`, `armed=true`, driver failures=0. Close tested pet duplication/reload **presentation** defect; secure clicks, autocast, PET STOCK interaction, fresh Edit Mode exit and taint checks remain unverified. Do not modify working pet driver absent new failure. **Development process:** panel actions are the default for runtime checks; Bartender4/Dominos plus exact Blizzard Forever APIs should be reviewed before custom secure action/UI engineering (references only, no dependency or wholesale copying). P0211 GitHub push had not been confirmed when this docs checkpoint was authored (latest observed `main` `4076d25` P0210). See `docs/memory/evidence/P0212_PET_ACCEPTANCE_AND_WORKFLOW.md`; H.3 approved art/interaction integration is next.

## P0211 — Startup pet reconciliation
**P0211 INITIAL PET RELOAD FAIL (2026-10-14; NEW CANDIDATE, RUNTIME UNTESTED):** Correction to P0210: user reports Blizzard PetFrame/PetActionBar **visible immediately after `/reload`** despite saved Immersion ON. Explicit Immersion OFF -> ON hides both (PASS, user-observed), native stock stays suppressed in observed combat (PASS, user-observed), and Edit Mode displays native controls (PASS, user-observed). Full stock clicks/autocast/taint and Edit Mode exit remain unverified. P0209 R8 diagnostic loadCount 278 has `armed=true nativeDriver=true activations=7 failures=0` only AFTER OFF->ON, not at initial reload: startup failure mechanism UNATTRIBUTED. P0211 0.0.121-dev adds two one-shot addon-owned readiness handoffs from secure probe Arm and pet interaction setup to the existing Reconcile, plus first-world/first-arm source diagnostics. No polling, native Show/Hide, native visibility inspection, combat protected mutation, or change to secure hide/show driver. Validate on fresh reload BEFORE any Immersion toggle; do not claim startup PASS from static check. Evidence `docs/memory/evidence/P0211_PET_STARTUP_RECONCILIATION.md`.

## P0209 R8 — Correct-direction immersive native pet policy (2026-10-14)

**P0209 R7 RUNTIME MECHANICS CONFIRMED BUT DESIGN REJECTED / R8 LOCAL CANDIDATE.** LoadCount 276: native bar moved on first ON, Logres controls disappeared on second ON, OFF reversed that handoff (`activations=1 restores=1 failures=0`), which inverted user-required UX. R8 reuses R2 client-observed secure state driver, but uses a constant `hide` for BOTH Blizzard PetFrame/PetActionBar and NEVER hides Logres secure pet buttons. Immersion OFF / PET STOCK release drivers; native Blizzard owner methods refresh after release. Runtime still UNVERIFIED, including unit frame driver, combat, interaction, Edit Mode and fallback; no commit/push. Prior P0209 R0-R7 and P0206/P0197 problems remain.

## P0209 R7 — Explicit staged native pet handoff (2026-10-14)

P0209 R7 LOCAL / MANUAL TWO-STEP NATIVE HANDOFF (2026-10-14): R6 0.0.118-dev loadCount 275 user-confirmed ON/OFF staging/restoration **PASS** (activations=1 restores=1 failures=0), with both native and Logres pet buttons retained in the ON visual. Interaction, combat, Edit Mode and native ownership still UNVERIFIED. R7 default-OFF candidate: first ON reproduces R6 staging without suppression; second ON (only outside combat, after explicit human visual inspection) calls existing addon-owned `PetActionExecutionProbe:HideProbe`; it never hides Blizzard buttons or invents a second action executor. OFF restores stock anchor and re-arms Logres. Repeat R5 visual disappearance is an explicit FAIL, not acceptance. Historical P0209 R0/R1 prewrite, R2 combat swap, R3/R4 activation, R5 visual and original R5 prewrite, and P0206/P0197 problems remain recorded. No commit/push. Evidence: `docs/memory/evidence/P0209_R7_TWO_STEP_HANDOFF_EVIDENCE.md`.

## P0209 R6 — Native anchor visibility isolation (2026-10-14)

P0209 R6 LOCAL / STAGED NATIVE VISIBILITY (2026-10-14): `0.0.117-dev` R5 R1 loadCount 274 activated ON (`requested=true armed=true activations=1`) and restored OFF (`restores=1`), but the user observed Logres pet buttons disappearing on ON and returning on OFF, with no native replacement visibly established. Source cause: R5 `Acquire()` called `probe.HideProbe` unconditionally after only `PetActionBar:SetPoint`. Blizzard native root has independent show policy. R6 (`0.0.118-dev`) retains the functional Logres cluster and allows rearm while attempting only out-of-combat native-bar anchor relocation. Default OFF; visibility proof and combat/click restoration UNVERIFIED. No commit/push; P0209/P0206/P0197 failures OPEN. Refer to `docs/memory/evidence/P0209_R6_NATIVE_ANCHOR_VISIBILITY_ISOLATION.md`.

## P0209 R5 — Initial Edit Mode nil state (2026-10-14)

**P0209 R5 local candidate / WOW UNVERIFIED (2026-10-14):** R4 (`0.0.116-dev`, loadCounts 272–273) **RUNTIME FAIL**: `petbardriver on` rejected `editmode-manager-state-invalid`, `activations=0`. Blizzard's verified `IsEditModeActive()` returns an uninitialized `nil` before the first Edit Mode entry; R4 misclassified it. R5 accepts only ordinary nonsecret initial `nil` as inactive, still rejects active/restricted/unknown states, and changes no pet-action ownership or combat logic. **R5 initial ZIP PREWRITE FAILED** before any tracked-file write: its generator wrongly required `docs/memory/investigations/ACTIVE.md` to start with `# `, despite the valid `## P0209 R4` heading inherited from R3/R4. This R5 R1 archive corrects that heading expectation with an exact R4 section anchor; runtime behavior is unchanged. P0209 R0/R1 static failures, R2 combat-swap failure, R3/R4 activation failures, and P0206/P0197 protected/combat defects remain recorded. No push. Evidence: `docs/memory/evidence/P0209_R5_EDITMODE_INITIAL_NIL_EVIDENCE.md`.

## P0209 R4 — Unloaded Edit Mode manager gate (2026-10-14)

**P0209 R4 local corrective / UNVERIFIED (2026-10-14):** P0209 R3 (`0.0.115-dev`, loadCounts 270–271) **RUNTIME FAIL — activation never armed**. Repeated `/logres petbardriver on` rejected `editmode-unavailable-or-active`, `requested=false armed=false activations=0`, including after `/reload` and outside combat. The guard required an initialized `EditModeManagerFrame`; that Blizzard_EditMode frame can be absent when the manager is not loaded, which also means its Edit Mode is not active. R4 treats ONLY an absent manager as inactive; a loaded manager still must explicitly and ordinarily report inactive. No native pet move has yet been runtime proven. Evidence: `docs/memory/evidence/P0209_R4_EDITMODE_GATE_EVIDENCE.md`. Keep P0209 R0/R1 static failures, R2 swap failure and P0206/P0197 failures OPEN. No push.
## P0209 R3 — Native secure pet-button reuse trial (2026-10-14)

P0209 R0 memory-health PREWRITE FAIL; R1 61/60 Lua upvalue PREWRITE FAIL; R2 applied and ran in WoW (`0.0.114-dev`, loadCount 269) but **RUNTIME FAIL for intended combat behavior**: pressing trial ON removed the Blizzard pet bar out of combat, then the `[combat] show; hide` native / `[combat] hide; show` Logres state drivers removed Logres pet actions and showed Blizzard's bar during combat. This was the authored reciprocal policy and contrary to user intent. No push. P0208 `f6b9a3a` remains the verified HEAD. P0197 combat duplicate remains OPEN. See `docs/memory/evidence/P0209_R3_NATIVE_REUSE_EVIDENCE.md`.

R3 (0.0.115-dev) is an **opt-in / default-OFF / runtime-UNVERIFIED** source-based native-button reuse trial. In the manner of Dominos, use Blizzard's own secure pet buttons, but unlike Dominos do **not** reparent secure children or hide their native ancestor. Instead move the intact stock `PetActionBar` to the existing Logres classPet layout anchor only out of combat, and hide the duplicate Logres pet-action probe. The native bar and buttons remain active through combat; no reciprocal driver and no stock Show/Hide. OFF, Immersion OFF, PET STOCK and Edit Mode enter attempt restoration of the original native anchor (captured and passed as opaque GetPoint(1) token). PetFrame remains fully Blizzard-owned. Existing 18 Phase H actions preserved. If a protected operation fails, retain native controls and mark RUNTIME FAIL; do not commit.

Sources reviewed: https://github.com/tullamods/dominos/blob/main/Dominos/bars/petBar.lua and https://github.com/Nevcairiel/Bartender4/blob/master/PetBar.lua . Native stock frame is deliberately **not** reparented or hidden; control of native anchor is a new out-of-combat experiment, unverified in Forever. Full native editing/restoration and any protected taint still require user runtime proof.


## P0209 — Reciprocal PetActionBar secure driver trial (2026-10-13)

P0209 R1 **PREWRITE FAIL / NO TRACKED WRITES**: `check_ui_ownership_audit_contract.py` rejected 61 captured locals in `handleCommand` (Forever cap 60). P0208 HEAD already uses 60; R1 added local `runPetBarDriverCheck` and missed the existing budget. R2 makes the diagnostic a `Logres` namespace method, reusing an existing captured local. R1 had no WoW runtime test. Full static and runtime validation remain separate.

R0 **PREWRITE FAIL / NO TRACKED WRITES**: generated `CURRENT.md` omitted required `## Verified State`; `CURRENT_HANDOFF.md` omitted the mandatory `CURRENT.md` authority pointer. The full shadow suite stopped at `check_memory_health.py`. R1 repairs these source-generation failures; the secure driver remains UNVALIDATED in WoW.

P0208 pushed `f6b9a3a`; stock pet frame/action visible in user loadCount 268 screenshots, but redundant native controls persist with Immersion ON. Source audit proves native PetActionBar event-driven Show and existence of secure visibility driver, not safe coexistence in Edit Mode. P0209 opt-in session-only default-OFF driver candidate uses paired `[combat] show; hide` Blizzard native and `[combat] hide; show` Logres pet cluster; only out-of-combat registration/release, native first on release. Separate PetFrame remains stock. Repurpose existing 18-button Phase H trial slots; legacy P0206 reparent remains QUARANTINED. **STATIC CANDIDATE / RUNTIME UNVALIDATED**. Edit Mode while driver ON is not approved; turn OFF before edit. Preserve R0-R6 P0206, R0/R1 P0208 and P0197 negative evidence. `docs/memory/evidence/P0209_RECIPROCAL_PETBAR_DRIVER_CANDIDATE.md` is authority. No claim of full combat-duplicate resolution until tested.


## P0208 — Fail-open Blizzard pet unit and action stock ownership (2026-10-13)

P0207 is PUSHED on `main` `f080661b`. R6 0.0.112-dev remained UNCOMMITTED / NOT ACCEPTED: loadCount 265 showed `petFrame:folded petActions:stock` and the user reported intermittent missing native UI even with Immersion OFF. P0208 R0 falsely rejected unchanged P0207 PATCH_INDEX due to an outdated author blob pin; R1 validated the correct HEAD blob but failed its uppercase-only quarantine predicate; R2 checks the actual R6 Lua file hash and preserves both failures. P0208 `0.0.113-dev` now prevents **both** stock pet domains from being folded in NativeSurfaceReplacement; world PET dock clearly labels `PET STOCK` and triggers only a one-shot reconciliation; Phase H Native Access Check reports `petPolicy=stock/stock` and `petVisual=UNVERIFIED` (snapshot policy, not Blizzard screen proof). No protected native visibility inspection, stock Show/Hide, reparent, new hooks or polling added. Full runtime visual/interaction validation is PENDING; do not mark PASS from source or `uiownershipcheck`. Preserve all 18 Phase H actions, P0206 R0–R6 failures and P0197 combat duplicate as OPEN. Evidence `docs/memory/evidence/P0208_PET_STOCK_FAIL_OPEN_EVIDENCE.md`.

## P0207 — Pet UI full ownership / restoration audit (2026-10-13)

Docs-only; LAST PUSHED main P0205 `79a8e230`, local uncommitted P0206 R6 `0.0.112-dev`. Latest loadCount 265 demonstrates **petFrame:folded** while **petActions:stock** and trial QUARANTINED; stock UI Ownership labels mean policy (`observed=not inspected`), not visible/clickable proof. User reports intermittent missing pet frames/ability bar despite Immersion OFF, temporary reappearance via Edit Mode/PET; no OFF-state native diagnostic. Exact Forever 70338 source: secure PetFrame belongs to PlayerFrame and has independent `UpdateShownState`; native PetActionBar is Edit Mode-owned, reacts to pet events. R6 did not release PetFrame; existing saved shown tokens can become stale. R0/R3/R4 delivery, R1 panel regression, R2 protected/restore, R5 and R6 native restore failures remain preserved. **Next**: narrow fail-open release of PetFrame plus existing PetActionBar stock-first, independently validate visually and with secure interaction, retain 18 Phase H actions. See `docs/memory/evidence/P0207_PET_UI_FULL_LIFECYCLE_AUDIT.md`. P0197 combat duplicate remains OPEN.


## P0206 R6 — stock PetActionBar fail-open safety (2026-10-11)

P0206 R5 runtime **FAIL**: `0.0.111-dev` loadCount 262 trial QUARANTINED/armed=false, but NativeSurfaceReplacement recorded `petActions:folded`, `folded=4`, `restores=0` at initial audit, with later `onShow=4 immediateRefolds=4`. User reported Blizzard pet bar still absent after Immersion OFF (no post-OFF native snapshot in diagnostics). The R5 correction disabled only the hidden-parent trial and left earlier stock fold active. R6 `0.0.112-dev` makes `Native:Ready("petActions")` return false, preserving Blizzard pet-action bar in both Immersion modes without new protected mutation. **RUNTIME UNTESTED / FAIL-OPEN CANDIDATE**; P0197 combat duplicate remains OPEN. Preserve R0 panel overflow, R1 rejected slash-only control, R2 protected/restoration failure, R3 version-pin failure, R4 missing payload, R5 restoration failure. Evidence `docs/memory/evidence/P0206_R5_STOCK_PET_RESTORE_FAILURE.md`; patch `docs/memory/patches/P0206_R6_STOCK_PET_FAIL_OPEN.md`.

## P0206 R5 — quarantined pet restoration after R3 and R4 prewrite delivery failures (2026-10-11)

P0206 R2 `0.0.110-dev` loadCount 261 produced an observed **FAIL**: stock pet bar was suppressed during combat, but Immersion OFF did not restore functional Blizzard pet controls; BugCatcher displayed generic `ADDON_ACTION_PROTECTED` text (specific function/addon/stack unavailable). Native parent arm/disarm counters (2/2, failures 0) were not proof of restoration. **DO NOT COMMIT R2.** R3 failed PREWRITE at `check_checker_version_policy.py`: the candidate checker froze `0.0.111-dev`. R4 failed PREWRITE with `FileNotFoundError`: the baseline R2 checker was omitted from the archive while still required by `r2.NEW`. R5 (`0.0.111-dev`) quarantines the hidden-parent trial, restores the P0205 native pet-fold code, retains all 18 Phase H controls but explicitly blocks ON. Exact native frame reparenting is rejected pending supported secure proof. After deployment `/reload`, validate manual PET, Immersion OFF stock fallback and no protected-action errors in ordinary play before committing. The original P0197 combat duplicate remains OPEN. Canonical evidence `docs/memory/evidence/P0206_R2_RUNTIME_FAILURE.md`; corrective record `docs/memory/patches/P0206_R3_CORRECTIVE_QUARANTINE.md`; R3 prewrite failure and correction `docs/memory/patches/P0206_R4_CHECKER_POLICY_REPAIR.md`; R4's failed payload and R5 correction `docs/memory/patches/P0206_R5_PAYLOAD_DEPENDENCY_REPAIR.md`.

## P0206 — opt-in pet-bar combat hidden-ancestor trial (2026-10-11)

GitHub P0205 baseline `79a8e230` verified. P0206 R0 failed prewrite (18 Phase H controls against 15 max); R1 slash-only workaround rejected by user because the panel is the required workflow. R2 retains all 18 Phase H controls in a six-row grid (3x6) and moves diagnostics down to prevent overlap. Candidate `0.0.110-dev` introduces a **DEFAULT-OFF, session-only** PetCombatCandidate trial, activated explicitly via `/logres petcombat on` when out of combat. After native pet-fold and secure Logres pet readiness, stock PetActionBar may be parented to a hidden addon-owned holder; PET open, Immersion OFF, candidate OFF, and lost readiness restore the captured parent (opaque token) outside combat. The existing P0197 OnShow counters and deferred recovery remain unchanged. Combat requests reject, no protected state inspection, no polling, no blanket state driver, no D-045 movement. **Source/planned checks only; in-game combat, PET interaction, fallback and Edit Mode behavior NOT YET VALIDATED.** Any restore error is a real FAIL. Pet bar duplicate remains OPEN / REPRODUCED until runtime proof. Canonical records: `docs/memory/patches/P0206_PET_COMBAT_CANDIDATE.md` and `docs/memory/evidence/P0206_RUNTIME_CANDIDATE_EVIDENCE.md`. NPC green name overlay, aura provenance, ObjectiveTracker flash and H.3 contrast remain separate OPEN items.

## P0205 — Exact Forever 70338 PetActionBar ownership source audit (2026-10-11)

P0204 verified pushed `566bb8b5`. Exact upstream `Gethe/wow-ui-source@943764493e6b16d63ded3ab304150d1f05e58b57` (`1.60.1.70338`) establishes Blizzard PetActionBar's pet-event `Show()`, interactive Edit Mode-owned `UIParent` root and secure visibility state-driver infrastructure. P0197 post-combat recovery PASS (one trace) but duplicate in combat remains FAIL/OPEN/REPRODUCED. Insecure combat Hide, periodic reassertion and blanket stock-driver takeover are rejected; a hidden-ancestor/reversible secure handoff is **source-plausible but not runtime proven** and must remain **default OFF** in any candidate, preserving manual PET access, stock fallback and precise restoration. Next: one capability-gated, reversible runtime prototype plus diagnostics; do not claim source-only runtime success. NPC label/quest overlap, ObjectiveTracker flash, target aura native ownership and H.3 contrast remain separate OPEN items. Source details: `docs/memory/evidence/P0205_FOREVER_PET_COMBAT_SOURCE_AUDIT.md`. **P0205 docs-only, Logres `0.0.109-dev` unchanged.**

## P0204 — P0197 combat deferral reproduced, post-combat recovery observed (2026-10-11)

P0203 pushed GitHub `main` `5c28c2df`. User's `0.0.109-dev` loadCount 260 trace: Phase H Native Access Check recorded `onShow=2 combatDeferred=1 immediateRefolds=1 recovered=0 awaiting=true` (native reconciliation deferred); later Phase 0 Run All recorded the same OnShow/deferral but `recovered=1 awaiting=false`, native pending=false, no errors. **P0197 post-combat recovery PASS in this one transition; combat dual Blizzard/Logres PetActionBar FAIL / OPEN / REPRODUCED.** Do not misread stored `petActions:folded` as stock visibility, and do not infer original native show event from `lastReconcile=PLAYER_TARGET_CHANGED`. Next narrow technical task is source/API audit for secure combat-safe interaction ownership/fallback, with no combat-time protected Hide, broad hooks, polling or v4 anchor motion. NPC green overhead-label quest occlusion, target harmful icon provenance and ObjectiveTracker flash remain separately OPEN. Canonical evidence: `docs/memory/evidence/P0204_P0197_COMBAT_RECOVERY_2026-10-11.md`. P0204 docs-only; `0.0.109-dev` unchanged.

## P0203 — combat stock PetActionBar REPRODUCED; dialogue-label occlusion observed (2026-10-11)

Two user screenshots show an extra small stock pet-action row overlaying the larger Logres pet grid during combat, plus green NPC overhead label text across the authored quest parchment. The user explicitly identifies the smaller row as **Blizzard PetActionBar** and reports the bar **returns in combat**: P0197 symptom now **OPEN / REPRODUCED IN COMBAT**, not unreproduced. Existing P0197 `OnShow` handling defers native Hide while InCombatLockdown and offers post-combat recovery; exact current `OnShow` counters are not yet supplied. Visible target status icons also occur in this combat image but their secure/ordinary owner and 2-column packing are unproven; no native aura-fit PASS/FAIL. Quest label occlusion is visually confirmed, render owner unresolved. Next: Phase H Native Access Check while stock row visible and after leaving combat, with no reload, and save addon-owned `petbar-reshow` counters. No protected visibility reads, polling, forced combat, suppression of native controls, source alteration, or v4 position change. Docs-only `0.0.109-dev` unchanged. Evidence: `docs/memory/evidence/P0203_COMBAT_PET_DIALOGUE_EVIDENCE.md`.


## P0202 — H.3 screenshot visual review (2026-10-11)

The user-supplied 1907x1192 (16:10) ordinary screenshot shows the implemented top-center compass, upper-right Active Quest parchment, separate/native access dock, lower action/pet clusters, sparse pet/target percentage bars, bottom-center resource, and retained single authored player buff. No obvious action clipping or quest/dock overlap in this still. **Observed concerns:** the compass glyphs/ticks are faint on pale sky; many empty gilded action slots create considerable visual weight. These are polish candidates, not proven runtime failures or permission to change hitboxes/source/anchors. The image does not show naturally populated harmful aura icons, native tooltip/click or combat/restoration states; these are DEFERRED. P0197 pet reappearance and ObjectiveTracker flash remain OPEN. H.3 whole-sheet visual acceptance remains OPEN. Exact evidence: `docs/memory/evidence/P0202_H3_SCREENSHOT_VISUAL_EVIDENCE.md`. No Lua/TGA/layout changes; `0.0.109-dev` unchanged.


## P0201 — P0200 R1 bounded diagnostic acceptance; H.3 visual review still open (2026-10-11)

GitHub `main` `9776cf9` verifies P0200 R1 `0.0.109-dev`. Uploaded loadCount 256: Phase 0 Run All complete, Layout 19/29/0 and v4 13/13 measured, Status Aura Preview ON/OFF PASS with secure native harmful inactive during preview and active afterward, Native Access PASS and 35-row UI Ownership 17 PASS / 18 STOCK / 0 FAIL. No new runtime Lua/protected failure reported. Native harmful membership and populated multi-aura fit remain DEFERRED; no new full-screen screenshot or direct visual acceptance. PetActionBar OnShow=0 this session does not close prior intermittent duplication; ObjectiveTracker flash and combat/special-control deferrals remain OPEN. **No code/art changes in P0201.** R0 prewrite failed on an invalid 39-character `docs/ROADMAP.md` SHA pin; R1 corrected it against the verified GitHub 40-character blob before writes. Next: one coherent screen-level H.3 visual review; no speculative new polish. Canonical evidence: `docs/memory/evidence/P0201_P0200_H3_RUNTIME_EVIDENCE.md`.

## P0200 R1 — coordinated H.3 visual implementation CANDIDATE (2026-10-11)

Verified P0199 R1 GitHub `main` `7064ea88` (docs-only audit). P0200 R1 **runtime UNTESTED** (`0.0.109-dev` proposed) aligns native harmful 25px artwork/target two-column fit with the approved aura frame, strengthens percentage and target/ally name readability, and quiets the native-access dock while retaining all action/secure hooks. No approved v4 anchor change, no player helpful artwork replacement, no new stock UI suppression or secret-value access. R0 failed safely in the shadow stage: check_h2_unified_placement_contract.py still demanded the obsolete 18px literal; no tracked files were changed. R1 updates that checker to test H.2 anchor and H.3 grid geometry. In-client multi-effect density, screen contrast, dock click/restoration, Phase 0 Run All and Phase H checks are PENDING; missing natural populated states are DEFERRED. PetActionBar duplication and ObjectiveTracker flash remain OPEN / INTERMITTENT / UNREPRODUCED. See `docs/memory/patches/P0200_H3_VISUAL_IMPLEMENTATION.md`.



## P0199 — approved-sheet visual fidelity audit, H.3 planning (2026-10-11)

Verified P0198 GitHub push `ed6ca7b`, ordinary runtime remains `0.0.108-dev`. P0199 compares all twelve D-039 approved sheets, current `Logres/Media/Theme.lua`, TGA production media, concrete module render paths and user screenshot. **No runtime change.** `docs/design/H3_APPROVED_ART_RUNTIME_FIDELITY.md` distinguishes art translated vs partial state/source capability. Highest mismatch: native harmful aura 18px/2px and generic `UI-Quickslot2` border, vs approved sheet-04 visual language and existing 25px framed target status / 36px framed player buffs. Plan ONE integrated H.3 candidate for restricted-aura-safe art/fit, text/percentage contrast, and action/native-access hierarchy, with no layout or owner-policy change. P0197 intermittent pet bar and ObjectiveTracker flash remain open; special/pet/aura runtime gaps remain deferred. See `docs/memory/patches/P0199_H3_VISUAL_FIDELITY_CHECKPOINT.md`.


## P0198 — P0197 ordinary refolding observed; intermittent trigger still open (2026-10-11)

P0197 verified pushed on `main` `0a20eef`, version `0.0.108-dev`, loadCount 253. User did not see the duplicate pet bar. Four actual stock PetActionBar OnShow events were met by four immediate Logres refolds, no combat deferrals or deferred recoveries, no pending recovery, no native-surface error. Native Access PASS and Phase 0 Run All completed twice within observed scope; latest Layout 19/34/0. **Do not claim combat-recovery runtime PASS or permanent fix**: the prior duplicate stock bar remains OPEN / INTERMITTENT / UNREPRODUCED, cause unknown. Preserve event-driven counters, native PET access and protected fallbacks. Small target debuff icons join coordinated H.3 visual polish after H.2 observed-layout integration. See `docs/memory/patches/P0198_P0197_RUNTIME_OBSERVATION.md` and `docs/memory/evidence/P0197_PET_BAR_RESHOW_EVIDENCE.md`.


## P0197 — intermittent Blizzard PetActionBar duplication, post-combat recovery candidate (2026-10-11)

Verified P0196 R4 commit `c89692b`; user confirms target buffs and debuffs correct. Screenshot shows stock PetActionBar occasionally visible under Logres pet cluster, exact trigger unknown. Latest `0.0.107-dev` loadCount 251 `native-surfaces` reported `petActions:folded`, `pending=false`, `error=nil` despite user visual failure; this measures only addon-owned snapshot state, not stock frame visibility. Source of `NativeSurfaceReplacement.lua`: PetActionBar `OnShow` during combat sets pending without Hide; post-combat `Reconcile` calls `Fold` but its existing snapshot causes early success without re-hide. Blizzard PetActionBar also explicitly calls Show on PET_BAR_UPDATE, UNIT_PET, PET_UI_UPDATE, UPDATE_VEHICLE_ACTIONBAR. P0197 adds only event-verified deferred recovery and counters. Combat as trigger is INFERRED / UNREPRODUCED, not proven. No polling or blanket suppression. Runtime test OPEN; see `docs/memory/patches/P0197_PET_BAR_DEFERRED_RESHOW_RECOVERY.md` and `docs/memory/evidence/P0197_PET_BAR_RESHOW_EVIDENCE.md`.


P0196 R4 is an **UNPUSHED RUNTIME CANDIDATE** addressing the R3 verified visual residual: the small Blizzard contextual target aura icon remains despite correct Logres player/target buffs. R3 `0.0.106-dev` loadCount 250 native-surfaces reported targetAuras:stock; Logres helpful and secure harmful lanes remain. Forever 1.60.1.70338 TargetFrameMixin:ConfigureAuraContainer source supports native 0/0 aura limits and restores, without the R1 forbidden OnShow hook. Existing pet/player buff replacement is untouched. TARGET opens the native aura container; Damage Meter and beta reporter unchanged. R1 visual/hook failure and R2 delivery failure remain recorded. Details: `docs/memory/patches/P0196_R4_TARGET_AURA_NATIVE_CONFIG.md` and `docs/memory/evidence/P0196_R4_TARGET_AURA_RUNTIME_EVIDENCE.md`. No R4 runtime PASS yet.


P0196 R3 is the next **OPEN / RUNTIME UNTESTED** checkpoint after R1 visual/target-hook runtime FAIL and R2 pre-write memory-health FAIL. The original crafted `PlayerHelpfulAuras` art and old StatusAuras/native harmful sizing are restored; new native 18px helpful icons and override takeover removed. Pet secure replacement candidate retained. Stock BUFFS is manually accessible beyond four authored Logres slots. Target contextual aura suppression is DEFERRED because the R1 OnShow hook failed. Damage Meter and Issue Reporter untouched. See `docs/memory/patches/P0196_R2_BUFF_PRESENTATION_CORRECTION.md` and `docs/memory/evidence/P0196_R2_REGRESSION_EVIDENCE.md`. P0196 R1 and R2 were NOT pushed. R2 passed whitening/own contract and earlier repository checks, then `check_memory_health.py` rejected CURRENT_HANDOFF.md because it omitted CURRENT.md; no tracked R2 writes occurred. See `docs/memory/patches/P0196_R3_PREWRITE_MEMORY_REPAIR.md`.


Project Logres is an immersive, world-first interface addon for World of Warcraft Forever.

The roadmap is capability-gated. A phase advances only when its success criteria are satisfied and repository memory is synchronized.

## Phase 0 — Foundation

**Status: COMPLETE.**

## Phase A — Core State Engine

**Status: COMPLETE.**

## Phase B — Core HUD

**Status: COMPLETE.**

## Phase C — Action Interface

**Status: COMPLETE.**

## Phase D — Immersion Controller

**Status: COMPLETE.**

## Phase E — Compass and Navigation

**Status: COMPLETE.**

## Phase F — Quest Experience

**Status: COMPLETE.**

## Phase G — Cinematic Camera

**Status: COMPLETE — P0162 REACTIVE MOUSE-WHEEL ZOOM RUNTIME PASS; ENVIRONMENTAL DEFERRALS PRESERVED.**

G.1 through G.5 are runtime-proven for their observed scopes.

P0159 R1 provides captured context/priority ownership. P0160 R2 provides the source-backed LibCamera zoom engine and accepted Taxi convergence.

P0161 is durable at `2a959094` / `0.0.80-dev` and runtime-accepted for the observed Taxi/settings/shoulder-offset scope: target `50`, Taxi yaw `-20`, City return about `4.97-5.01`, rotate-back completion, City max-distance factor `1` with original `4`, and zero profile/camera secret/runtime failures.

Teleport/NPC/Fishing/Gathering and unobserved AFK behavior remain environmental deferrals.

P0162 R3 is durable at `4628f49e` / `0.0.81-dev` and runtime-accepted. The bounded reactive gate passed with active/hooked `OutQuad`, quick accumulation, direction reset, same-context manual persistence, OFF/ON restoration, user-confirmed native wheel while OFF, and zero conflicts/secrets/failures.

Phase G is complete for claimed observed scope. Hearth/Teleport, NPC Interaction, Fishing, Gathering, and unobserved AFK priority behavior remain environmental deferrals. DynamicCam UI fades remain a Phase H presentation/suppression policy question rather than an implicit camera-engine side effect.

Canonical phase record:
`memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`

## Phase H — Integration and Polish

**Status: ACTIVE — P0189 automatic normal Main replacement accepted for observed Immersion ON scope; special combat/mode evidence environmentally deferred. H.2 authored geometry ACTIVE; H.3 later.**

P0192 follows verified P0191 `57c3112` with a **read-only Phase H Layout Check geometry audit** of the thirteen Logres-owned frame proxies against the approved v4 rectangles. Existing Primary 4x3 and Utility 3x4 require deliberate layout-shape choices before coordinates can be safely translated. P0192 changes no authored anchor, Blizzard fallback or secure control. In-game measurements/collision evidence are pending; P0193 bounded placement is next after acceptance. See `memory/evidence/P0192_H2_GEOMETRY_AUDIT_2026-10-11.md`.

P0196 R1 is the next H.2 native duplication checkpoint, following user screenshot acceptance of P0195 `9097f43`: capability-gated PetFrame, PetActionBar, BuffFrame, and target contextual Auras replacement with Logres secure pet unit controls and native aura rendering; PET/BUFFS/TARGET dock restoration and fail-open behavior remain mandatory. P0196 docs-only native-retention recommendation was rejected and not pushed. Damage Meter and Issue Reporter are not suppressible by this checkpoint. In-game proof must precede acceptance. See `memory/patches/P0196_R1_NATIVE_PET_AURA_GATE.md`.

P0195 implements the first coordinated full-screen H.2 runtime placement candidate after user visual verification of P0194 R3 (`f7a67bc`). All D-045 regions share central UIParent-percent anchors, with action cluster reflow and separate aura/native controls; no additional stock suppression. One full-screen runtime screenshot, input-path and error check are required before accepted geometry, and special modes remain deferred. See `memory/patches/P0195_H2_UNIFIED_V4_LAYOUT.md`.

P0194 R3 resolves the user-rejected slash-only H2 overlay UX: developer panel Phase H opens a **dedicated H.2 Map view**, preserving its original fifteen actions, with blue planned and gold actual regions plus controls. The first whole-screen screenshot and runtime checks remain required before any coordinated placement pass. **No gameplay geometry moves in P0194 R3.** R0 visual and R1 prewrite failure retained. See `memory/patches/P0194_R3_H2_PANEL_SCREEN_MAP.md`.

P0194 R0 isolated player-stack placement was visually rejected; user directs **one complete in-game coordinate map and one coordinated whole-screen move**, not repeated per-widget trials. P0194 R1 failed during shadow validation because its checker requested nonexistent viewport field expressions; R2 fixes this and first overlays ALL thirteen approved v4 regions (blue) and P0192 actual named-frame rectangles (gold) at the real UIParent viewport via the Phase H developer panel; it does not reposition any UI or suppress native fallbacks. After one full-screen screenshot, one coherent whole-screen anchor/reflow patch must handle Primary/Secondary/Utility/extra bars and native Quest/status/access collision risks together. See `memory/patches/P0194_R2_H2_UNIFIED_SCREEN_MAP.md`.

P0193 records measured P0192 R1 actual Logres frame geometry after verified `main` `3777620`: Layout Check 16 anchors/23 binds/0 failures, H.2 13/13 observed, existing Run All PASS in tested ordinary scope (`0.0.102-dev`, loadCount 242). **No approved v4 geometry has been applied to live anchors yet.** First bounded placement/reflow P0194 follows; target aura physical width, variable Quest/native access and separate native/deferred stock surfaces require collision-safe handling, not blanket suppression. See `memory/evidence/P0193_H2_GEOMETRY_RUNTIME_2026-10-11.md`.

P0191 publishes the user-approved 13-rectangle **H.2 v4 screen-map design baseline** at `design/layout/SCREEN_MAP_V4.json` and `.md` (D-045). The final agreed adjustment makes both Main and Secondary Bar Y=60.4%; target/debuff/buff center alignment and bottom-center Player Debuffs → Resource are explicit. **No in-game anchor positions have changed.** P0192 will evaluate real geometry and fallbacks before bounded runtime translation; H.3 later.

P0190 accepts P0189 after `main` verified at `bd0c36a` (`0.0.101-dev`). LoadCount 239 proves fresh auto-armed CANDIDATE, explicit OFF STOCK, manual ON CANDIDATE, Run All Main 7 activations/6 restores without error, Primary 12/12, ownership 17 PASS/18 STOCK/0 FAIL, and user reports intended behavior. H.1 observed ordinary-screen scope accepted; secure vehicle/override/possess/form/petbattle/combat are **ENVIRONMENTALLY DEFERRED**, not universally passed. `main_action` STOCK row remains policy, not a visual measurement. P0191 begins H.2 spacing/collision calibration using P0166 integration anchors, with retained native fallbacks; H.3 visual polish follows. See `memory/evidence/P0190_P0189_AUTO_MAIN_RUNTIME_2026-10-11.md`.

P0188 verified P0187 R2 on `main` `41c7d97`, `0.0.100-dev`: user accepted manual ON/OFF/ON/restore; Run All shows 7 activations/6 restores with no Main error, Primary routing and 35-row ownership check pass for tested scope. Original R0 re-arm runtime failure and R1 delivery failure are preserved. H.1 remains open: the secure gate starts OFF every reload, and special/vehicle/combat modes are environmentally untested; P0189 addresses safe default Immersion ON integration before H.2/H.3. See `memory/evidence/P0188_P0187_R2_NORMAL_RUNTIME_2026-10-10.md`.

D-039 preserves the approved twelve-sheet World Ghost / Selective Hybrid E visual
baseline. D-040 defines `Logres/Media/` plus `Theme.lua` as the runtime asset/token
boundary.

P0158 sets the Phase H execution order after G.5:
1. surface-by-surface Blizzard ownership/suppression and coexistence, only where
   replacement/restoration is already capability-proven;
2. authored integration anchors and proper default UI positions;
3. final whole-screen polish, residual visuals, settings/accessibility, and only
   then remaining capability-proven additions.

This is not authorization for blanket hiding. Stock fallbacks remain wherever the
replacement gate is incomplete.

Parallel translation has accepted:
- P0120 shared percentage/resource bar;
- P0121 player cast cue;
- P0122 Context messages;
- P0123 heading/manual-waypoint Compass;
- P0124 organic player-health tunnel;
- P0126 Active Quest one-focus presentation (`89b0c563`, `0.0.58-dev`).

P0126 is runtime + visual PASS. P0128 resolves the D-035 source/API layer:
narrative/reward/gossip reads and expected action functions exist, but mutation
ownership is not runtime-proven.

P0129 is durable at `e50676b9` / `0.0.59-dev` and passes the naturally observed
read-only offer/gossip scope: real offer narrative, available-gossip quest
identity, and one two-choice reward metadata sample were ordinary/non-secret while
all mutation groups remained `invoked=0`.

P0130 is runtime + visual PASS on `0.0.61-dev`: approved bounded/paged NPC
quest-offer narrative is production-proven, including same-conversation Immersion
OFF -> ON restoration, while Blizzard controls remain available.

P0131 now proves both player-triggered offer mutations on the tested Forever
path: Decline via `QUEST_FINISHED`, and Accept via matched `QUEST_ACCEPTED` after an
intermediate `QUEST_FINISHED` on `0.0.63-dev`.

P0132 production offer controls pass. P0133 `f2feead6` / `0.0.65-dev` is
runtime + visual PASS for the corrected Accept-left / Decline-right arrangement
while Blizzard fallback remains visible.

Continue / Complete, reward selection, progress/completion presentation, gossip
mutation, and Blizzard offer-control suppression remain separately gated.

P0164 resolves the first Phase H ownership audit. Existing Quiet Mode, selective Player/Target, and conditional Bar 2–3 suppression are already proven; the minimap, Party/CompactPartyFrame, target aura/status and target-of-target, Main/Override/special action surfaces, PetActionBar/PetFrame, class/resource/special surfaces, full quest tracking/log, persistent XP, nameplates, and unsupported quest states remain stock.

P0165 R1 is durable at `0e83af06` / `0.0.82-dev` and runtime-accepted. Exact Forever `1.60.1.70245` source backs alpha+mouse suppression/restoration of the **stock quest-offer Accept/Decline controls only** for ordinary non-PvP/non-auto-accept offers. PvP-confirmation, auto-accept, hidden/gamepad, missing/secret/unreadable, and unsafe protected/combat states remain Blizzard/fail-open. H.1 is closed for currently replacement-proven stock surfaces.

P0166 R1 is durable at `a67e0cce` / `0.0.83-dev` and structurally runtime-accepted: all 13 semantic anchors bind with zero failures/missing/mismatches, integrated Run All is clean, and pet actions report the `classPet` anchor. Whole-screen visual spacing/collision calibration remains open.

P0167 fixes the missing Phase H developer-panel registration for Layout Check. To stay within the existing 15-action panel limit, the legacy quest-offer Accept/Decline TEST probes move to Phase F. No geometry, ownership, suppression, secure routing, or camera behavior changes.


P0135 resolves the aura/status source + priority-policy layer against the exact
Forever `1.60.1.70205` source generation. D-041 preserves stock/private/group aura
fallback and requires secret-first per-aura reads.

P0136 `0.0.66-dev` passes as a read-only runtime probe with environmental
deferrals: ordinary populated player helpful data is proven; player harmful and
populated target categories remain deferred; no runtime secret branch was
encountered.

P0137 `2b578759` / `0.0.67-dev` is runtime + visual PASS for the proven player
`HELPFUL|PLAYER` category: a passive peripheral native-icon lane with approved
minimal framing, ordinary stack metadata, and event-driven updates.

Player harmful/urgent and populated target aura data remain environmental
deferrals. Private/group ownership and stock aura suppression remain gated.

P0139 resolves the world-target source + fallback policy against the exact
Forever `1.60.1.70205` source generation and is durable at `b0122136`.

D-042 permits only a conditional accessible nameplate candidate using
`includeForbidden=false`, preserves the existing screen-space Logres target as
fallback, keeps Blizzard target/nameplate UI available, uses ordinary reaction
state only, and limits relative-danger policy to `UnitIsTrivial` low-danger
de-emphasis without exact difficulty inspection.

P0140 `f7e2c31d` / `0.0.68-dev` passes the observed read-only runtime scope
with environmental anchor/attachment deferrals: safe no-nameplate fallback,
ordinary friendly reaction, ordinary `UnitIsTrivial=false`, zero recorded probe
failures/secret skips, and integrated checks. No accessible target nameplate was
observed, so production world-attached placement remains blocked.

P0142 resolves the D-037 navigation/minimap source layer against the exact
Forever `1.60.1.70205` generation and accepts D-043. Tracking filter state is
multi-select, but individual detected tracking-result and service-instance
positions are not exposed by the audited public source surface. Current-map
`C_AreaPoiInfo`, `C_Minimap.GetViewRadius`, broader current navigation, and
same-map geometry survive as runtime candidates.

P0143 is durable at `b9b2f90b` / `0.0.69-dev` and passes the observed
read-only source scope. Current map/player geometry, map world size, minimap view
radius, and all 23 tested tracking selector rows were ordinary with zero secret
skips/failures; four selector states were independently active. The tested state
had no AreaPOI rows and no current/quest/user-waypoint destination, so those paths
and actual destination distance remain DEFERRED. Integrated `Run All` passed.

P0145 `60244841` / `0.0.70-dev` proves ordinary same-map manual-waypoint
distance plus clean clear-state fallback.

P0147 `c274a9d1` / `0.0.71-dev` proves live
`C_Minimap.GetViewRadius()` close/near/medium/far mechanics but fails visual
calibration because `1.05 -> 0.90` is too subtle on the 12x20 marker.

P0148 `6f381a77` / `0.0.72-dev` is runtime + visual PASS with
`1.20 / 1.05 / 0.85 / 0.70` anchors and final clamp `0.70–1.28`. The size cue is
accepted; further refinement is deferred to later polish.

P0149 resolves the class/pet/special-control source layer against exact Forever
`1.60.1.70205` source and accepts D-044. Pet secure casting has a supported secure
source path, while stance/totem mutation, discrete class-resource ownership,
alternate power, PetFrame, and possess/override/vehicle/extra-action replacement
remain runtime/capability-gated.

No stock class/pet/special surface is suppressed by P0149. P0150 read-only runtime
proof is next.

P0150 prepares candidate `0.0.73-dev` as a bounded read-only runtime probe for the P0149/D-044 class/pet/special source families. It observes naturally available pet/form/totem/resource/rune/special-mode state with secret-first sanitization and source-owned invalidation only. It does not mutate controls or suppress Blizzard surfaces. Contextual absence remains environmental DEFERRED; production ownership remains separately gated.

P0150 initial runtime on `0.0.73-dev` reached the intended read-only probe but failed on an isolated diagnostic contract: six pet rows returned numeric `isToken` values while the probe assumed boolean. P0150 R3 corrects that assumption and false-to-nil special-mode summary extraction without widening ownership or mutation scope. Separate Run All was clean. The first R1 delivery artifact refused before writes because it expected pre-P0150 HEAD `dbe468f7` after P0150 was already durable at `c7ea3638`. R2 rebased correctly but also refused before writes because it incorrectly required the raw `"classpetspecialprobe"` token to occur once; the durable file contains it twice by design (dispatch + panel registration). R3 removes that brittle baseline assertion and runtime retest remains required.

P0151 records the accepted P0150 R3 read-only result. `0.0.73-dev` passes on
client `1.60.1.70235` with all 22 expected events, required APIs, populated pet
state (10 scanned / 7 occupied), one safely secret-skipped Warlock power value,
ordinary false special-mode flags, zero failures, and a separate clean Run All.
Stance/forms, active totems, DK runes, active special modes, and meaningful nonzero
class-resource presentation remain environmental deferrals.

Matching Forever 70235 source is `a84e2b1b41d3d4137127c07e4da448aa3251d6f1`,
the direct child of the P0149 70205 pin with only `version.txt` changed. The audited
secure pet source files are unchanged.

P0152 is durable at `00aef4a90e5999140dc9082e68e934cfc854cb05` / `0.0.74-dev` and is accepted for the bounded pet-action control/state-presentation slice. After the preserved correction history, R12 resolves effective click-specific pet bindings for presentation. Runtime evidence shows ten pet bindings, seven naturally readable/occupied slots, two active-state indicators, one autocast indicator, successful default-on arming, and user-confirmed pet button execution. Stock PetActionBar remains available.

This does not authorize pet edit/reorder, binding replacement, PetActionBar suppression/restoration, PetFrame ownership, or unrelated class/special ownership. Exact pet-button visual refinement is deferred to later whole-interface polish.

P0153 is durable at `7ad9be7e` and preserved the initial `PLAYER_ENTERING_WORLD` camera timeout without speculating about a fix. Its targeted normal `/reload` retest reproduced the failure: the direct Phase G check started near `8.524`, targeted `5`, and ended near `12.632`; separate Run All repeated the same timeout.

P0154 is durable at `40dec187` / `0.0.75-dev` and is a diagnostic PASS. Normal world entry again timed out: start about `23.148`, target `5`, final `50`, observed range `0 -> 50`, final/max easing error `45`, and command counts `142` inward / `1` outward.

The single outward correction exposes a concrete P0119 defect: crossed-target correction can reverse MoveView direction without stopping the previously active direction. P0155 R1 prepares a bounded stop-before-reverse correction on `0.0.76-dev`. The external origin of the world-entry `0/50` displacement remains unproven. No positional rebase, arbitrary delay, polling, CVar mutation, target change, Taxi rotation, or Taxi UI fade is authorized by this correction.


P0155 R1 is durable at `e9be312d` / `0.0.76-dev`, but its runtime retest exposed an earlier timebase defect rather than exercising direction switching. The camera entered at zoom `50`; the first camera OnUpdate did not occur until about `23.523s` after the `PLAYER_ENTERING_WORLD` transition was armed. The transition therefore timed out on sample 1 before issuing any MoveView command (`0` inward, `0` outward, `0` switches), leaving the user visibly max-zoomed out.

P0156 prepares candidate `0.0.77-dev` to start the transition motion/timeout clock on the first actual drivable OnUpdate frame and to use that frame's zoom as the transition start baseline. Event-time arm zoom and first-update delay remain diagnostic. No timer, arbitrary delayed reconcile, polling, CVar mutation, target/duration change, or Taxi-policy expansion is included.


P0156 is durable at `e1be731b` / `0.0.77-dev` and passes the observed normal-world-entry retest. Phase G Camera World/Combat Check reported start/current/final about `5.0795` against target `5`, targetReached=true, failures=0, secret=false, error=nil; separate Run All repeated the PASS.

The accepted sample reported `firstDelay=0` and `switches=0`, so the previously observed large first-update delay and P0155 direction-switch branch were not naturally re-exercised. They remain branch-level deferrals, not claimed runtime PASSes.

The world-entry regression is closed for observed scope. Phase G.5 now returns to the still-pending P0119 normal-Taxi landing retest; no further world-entry camera code is authorized without new failure evidence.

P0157 had two rolled-back memory-schema delivery failures: the initial candidate omitted one canonical CURRENT section, while R1 triggered a false duplicate because memory health counted a literal inline mention as if it were another heading. R2 hardens the checker to count actual Markdown heading lines and preflights the full candidate in a temporary checkout before writing the user's worktree.


### P0159 — consolidated captured-profile context/zoom parity

The canonical DynamicCam RPG profile remains the migration target. The user
explicitly chose to finish Camera parity before Phase H.

P0159 broadens production context/zoom ownership from World/Combat/City/Taxi to
all nine enabled captured situations, adding source-backed Teleport, AFK,
Gathering, NPC Interaction, and Fishing behavior. It does not yet import
rotation, shoulder/CVar mutation, reactive zoom, or UI fades.

After this runtime layer is accepted, Phase G continues with one consolidated
rotation/shoulder/camera-setting ownership-restoration layer. DynamicCam UI fade
behavior is reconciled with Phase H presentation/suppression policy.

P0158's high-level order remains: Camera -> safe suppression/coexistence ->
authored layout -> final polish.

### P0168 correction to H.1 sequencing

P0167 is runtime-confirmed at `0.0.84-dev`; all panel/layout checks passed. The user's explicit requirement is to finish safe Blizzard duplication removal *before* visual positioning. P0164's H.1 closure was premature. P0168 is a candidate to suppress the entire **ordinary quest-offer shell presentation** using the already accepted Logres offer surface, while preserving Blizzard's QuestFrame lifecycle/escape and every unsupported quest state. No broader removal is implied until a specific replacement/fallback is proved.

### P0169 — screenshot-backed consolidation candidate (2026-10-08)

The user-provided 1916×1198 screenshot documents unsuppressed native surfaces despite domain-level check PASSes. P0169 `0.0.86-dev` prepares one runtime trial combining source-supported secure Bar 4/5 matching, reversible native Bar 2–5 suppression, and a five-cluster lower-position layout. The MainActionBar/Override, pet editing/action fallback, minimap, full Objective Tracker, XP bar, menu, party and special/class controls remain native, deliberately; broad hiding would remove unproven information/controls. H.1 stays active until the screenshot-visible gaps are addressed safely; the new layout is an intermediate calibration candidate, not completed H.2.

### P0170 — corrected startup gate for P0169 stock bars (2026-10-08)

P0169 reached verified main `74ff4156` / `0.0.86-dev`; user reported provisional functional success. Uploaded logs prove its first post-login Bar 4/5 configuration was unreadable, stock replacement OFF, yet `stockreplacecheck` erroneously PASS. After Run All-induced preference reconciliation, Bar 2–5 suppression/routing and layout passed. P0170 candidate `0.0.87-dev` defers early settings unreadability without dropping the Immersion request, retries only on relevant lifecycle events, and requires stock diagnostic state to match Immersion truthfully. The clean-login test must run before Run All; H.1 remains ACTIVE and no additional stock domains are being suppressed in this correction.

### P0171 — reset after assistant H.1 scope and delivery failures (2026-10-08)

P0170 `95aaa593` / `0.0.87-dev` is verified and the observed first-login Bars 2–5 deferral/retry is now a narrow runtime PASS (1 deferral, 1 retry, expected/requested/applied=true, Layout 15/17). It did not remove Main/Override, pet, minimap, full tracker, persistent XP or micro-menu. Repeated assistant claims equating partial replacement/check PASS with near-total native UI disappearance, repeated one-surface redirections after a request for one consolidated pass, and preflight-defective P0167/P0168/P0170 ZIPs are preserved in `memory/evidence/P0171_H1_SCOPE_AND_DELIVERY_FAILURES_2026-10-08.md`. **H.1 remains OPEN**. Next runtime objective: one coordinated completion of missing Logres controls or deliberate on-demand stock access, safe reversible suppression of remaining duplicated presentation, and semantic positioning, validated together on a real full screen. No blanket hide, protected readback or premature art-polish transition.

### P0172 — native information-access dock (2026-10-08)

P0171 main `26fa1ef7` corrected project memory; H.1 remains open. P0172 `0.0.88-dev` candidate adds a world-first native-access dock and reversible Immersion presentation treatment of four source-identified domains: minimap, full objective tracker, status/XP and micro-menu/bags. All underlying native navigation/quest/progress/menu controls remain accessible through direct dock toggles or Immersion OFF; no alpha-only invisible-click suppression. This is an *in-game gated integration candidate*, not complete suppression proof. MainActionBar/Override/vehicle and pet secure actions remain stock until complete protected/interaction coverage is proven. Source and runtime limitations recorded in `memory/evidence/P0172_NATIVE_SURFACE_SOURCE_AND_RUNTIME_GATE_2026-10-08.md`. Full screen and real on-demand interaction determine acceptance; H.2 final art remains blocked by outstanding H.1.

### P0173 — primary stock ownership gate

Verified P0172 `0.0.88-dev` commit `3a5028c8` adds reversible stock navigation/objectives/status/menu access with a user-reported clean normal screen except Main primary and functioning dock controls. P0173 `0.0.89-dev` candidate instruments the remaining Main/Logres Primary mode, secure-page, and optional key-routing ownership boundary. The source contract requires stock Main edit/page and vehicle/override/possess availability, so this read-only gate never hides Main; H.1 remains OPEN. Next actual integration must demonstrate secure combat/special-mode fallback and replacement/edit interactions before suppressing the native Main primary bar. Screenshot and hardware input required, not static PASS alone.

### P0174 — action interaction, native cast and tracker coexistence (2026-10-08)

P0173 verified at `f9c99685` / `0.0.89-dev`: Primary read-only normal ownership PASS, optional routing ON `candidate=true`, routing OFF stock restored, all four original native domains folded, Run All clean. New user-reported limitations: action drag rearrangement absent, native cast bars still displayed, intermittent quest tracker return, Logres actions/aura tooltips absent. P0174 `0.0.90-dev` combines source-backed drag/swap and hover tooltips with reversible CAST native-access domain and event-targeted objective/cast re-fold; runtime candidate, all newly changed behaviors untested. Qualitative cast glyphs do not replace cast duration, so native on-demand CAST access is mandatory. No Main secure suppression or H.1 closure.

### P0174 R1 — failed pre-write shadow memory check (2026-10-08)

P0174 R1 SHA-256 `91146e93ad9c01a297976da316327ffc5325ea149cdff4b39aaca2b14f808c8d` reached the shadow static checker suite, then failed at `check_memory_health.py`: the generated `docs/memory/CURRENT.md` contained zero `## Success Criteria` and zero `## Relevant References` headings. User provided full terminal output proving this failure. R1 refused before tracked writes; the user's P0174 local changes remained in place. R1 is SUPERSEDED by P0174 R2; do not stage/reset/reapply R1. R2 restores canonical headings, validates the same combined candidate, and preserves the runtime issues as OPEN.

### P0174 R2 — tracker/cast native reappearance correction (2026-10-08)

P0174 `0.0.90-dev` was applied locally and its static manifest uploaded, but remote main remained P0173 `f9c99685`. First screenshot shows the native Objective Tracker visibly back over the native-access dock; user reports the tracker intermittently vanishes/reappears, while native player/target cast bars return in combat and Blizzard auras remain. The user's explicit report is negative runtime evidence, not a PASS. P0174's `Fold()`/`Refold()` policy holds an existing snapshot but event-only invalidation can miss later native `Show()` calls. R2 makes source-specific OnShow re-folds outside lockdown, preserving intentional manual dock opens and restoration, and adds accurate reappearance/combat-deferral counters. **No secure combat cast suppression is claimed.** Comprehensive player harmful/private and target aura visuals and suppression remain OPEN under D-041; no unsafe blanket aura hide. R2 runtime not yet tested. P0174 and R2 are one checkpoint, with no intervening Git push.

### P0174 R3 — combat cast visibility gate (2026-10-08)

The user tested P0174 R2 `0.0.90-dev`: the native Objective Tracker no longer reappears, accepted for the observed quest-update scope. **Native player/target cast/channel bars still reappear during combat.** Uploaded `LOGRES_DIAGNOSTICS_LATEST.lua` shows `nativeuicheck` 5 folded/0 open, source-specific tracker `onshow-refold`, `nativeShows=30/20`, `combatDeferred=2`, and `pending=0` after combat. The out-of-combat PASS does not prove combat-time native presentation. Remote main remains P0173 `f9c99685`; P0174 and R2/R3 are local, unpushed candidates. Preserve this negative evidence.

Pinned Forever Blizzard source `Gethe/wow-ui-source@15666a6e67938a1ab5caf041406464251db111ca` (`Blizzard_UIPanels_Game/Shared/CastingBarFrame.lua`, `Blizzard_UnitFrame/Mainline/TargetFrame.lua`) implements `CastingBarMixin:ShouldShowCastBar()` through `self.showCastbar` and offers `SetAndUpdateShowCastbar(showCastbar)`. R3 arms each of the three exact P0174 native cast sources' native show policy **out of combat**, before folding them; captures original flags only as opaque restoration tokens; and restores them through Blizzard's own setter when CAST is manually opened, Immersion turns OFF, or the module is disabled. No SetCVar, combat-time Hide/alpha, secure-handler snippets, reparenting, global hooks, or polling. If the setter is unavailable or fails, no cast folding authorization is granted, and stock remains the fallback. Native `OnShow` during combat while armed is recorded as a persistent escape, not a PASS after release. The existing CAST access dock is the explicit opt-in native casting-detail fallback (open before combat if exact progress is needed); Logres's production cast cue remains symbolic-only. Special-mode and combat-time CAST toggle are not claimed complete; full D-041 enemy/player aura replacement remains OPEN. Runtime validation of the new gate is PENDING; a source-backed hypothesis is not a PASS.

## P0175 — additive priority status lanes (2026-10-08)

Remote main verified at `996f6099` / `0.0.90-dev`, completing combined P0174/R2/R3 as a user-accepted observed runtime checkpoint. The post-R3 diagnostic records native access 5 folded/0 open, `castGate=true/true`, `gateEscapes=0`, integrated PASS. Earlier R1 shadow memory failure and R2 combat reappearance stay preserved as negative results. P0175 `0.0.91-dev` is an untested candidate providing real additive player urgent and target harmful/helpful priority aura icon lanes near authored screen-space fallback with native hover inspection and static preview. It does not hide stock auras, own private/group auras, prove world target attachment, or close H.1. D-041 and D-042 remain gates. In-game visual, natural source and safety tests required before acceptance.

### P0175 R1 — panel validation and target helpful coverage correction (2026-10-08)

The first P0175 delivery omitted the Status Aura Check/Preview controls from the developer panel despite panel-centric established validation; this was an integration failure. User also reports no visible enemy buff/debuff icons; P0175 source lacked an unqualified target `HELPFUL` fallback, while whether naturally populated enemy status was available remains unverified. R1 registers Status Aura Check, Preview ON, Preview OFF in Phase H and relocates the unchanged three pet-action execution probe buttons to Phase C (both phases stay within 15 buttons). It adds a general target `HELPFUL` fallback after urgent/priority target filters and distinguishes preview, populated live evidence, and environmental deferral in the status diagnostic. Blizzard aura frames remain stock, with D-041/D-042 gates unchanged. R1 is a corrective candidate until in-game validation; do not count static preview as populated runtime coverage.
### P0175 R2 — target debuff separation and loot flash (2026-10-08)

The user saw buffs on player and enemy but no debuffs after R1, plus one short quest-frame flash while looting. Runtime diagnostics proved preview icons (`2/3`) but did not prove populated live harmful data (player empty, target absent). A five-icon shared enemy status capacity could allow helpful effects to crowd out harmful effects. R2 splits target helpful/harmful into independent event-driven rows with separate category diagnostics, retains the existing player harmful row, source secret preflights, Blizzard aura fallback and Phase H status panel controls. It records the brief loot-associated Objective Tracker flash as OPEN / INTERMITTENT / UNREPRODUCED, not fixed by repeating Hide or polling; targeted cause and live harmful proof remain next acceptance gates. No blanket native aura or tracker suppression is authorized.

### P0175 R3 — preference-transition resource-bar regression (2026-10-08)

R2 failed in WoW: Phase 0 Run All stopped after Sensor Check with `StatusAuras.lua:273: attempt to index local 'rows' (a nil value)`, and persisted `immersionEnabled=false` hid the Logres mana resource bar. The R2 disabled aura snapshot omitted target `harmfulRows` / `helpfulRows` while the renderer always indexed those tables. P0175 R3 adds empty row tables on this disabled path and a new regression checker, retains player/target status visual features and Blizzard aura fallback. Runtime proof pending; no push. See `docs/memory/evidence/P0175_R3_PREFS_RESOURCE_RESTORE_2026-10-08.md`.

### P0176 — event-latched aura evidence and R3 runtime acceptance (2026-10-08)

P0175 R3 is now verified on `main` at `c55b6d7` / `0.0.91-dev`. Latest in-client `checkall` reached completion: Preference/Lifecycle/HUD and Status Aura checks passed; saved Immersion ON and HUD `visible=true`; no repeated nil-rows error. This closes R2's diagnosed Run All failure within its observed scope without erasing that failure. Live harmful samples remained empty/target absent and are DEFERRED, not PASS; brief looting quest flash remains OPEN/INTERMITTENT. P0176 `0.0.92-dev` is an untested read-only, event-latched per-category evidence candidate exposed in the existing Phase H Status Aura Check. Native aura fallback and all secure/protected boundaries remain unchanged.

### P0176 R1 — prewrite checker-compatibility correction (2026-10-08)

The original P0176 applier FAILED SAFELY before tracked writes after `check_status_aura_disabled_contract.py` could no longer isolate the disabled snapshot. The live-history instrumentation had been inserted within the active `elseif` branch. This prewrite failure is preserved, not counted as a WoW test or a successful patch. R1 moves the history call after the completed snapshot branch, gated on active/non-preview state, without modifying the R3 regression checker, rendering or aura sources. R1 requires fresh full-suite and WoW validation; original P0176 is superseded.

### P0177 — Independent Logres aura-source engine comparison (2026-10-08)

P0176 R1 is verified on main at `5379a9f` (`0.0.92-dev`). Runtime loadCount 224 confirmed two clean Run All completions and preview-excluded history; target helpful max=1 / positiveReads=4, player/target harmful max=0, final aggregate 456 secret skips across 53 scans (not unique auras), no source failures. Harmful-source capability is still DEFERRED. A source audit of WeakAuras (AuraUtil enumeration/trigger pipeline) and Plater (helpful/harmful separation, slot enumeration) informs P0177's *independently written* source engine, but their full code and restricted-source read strategies are not copied. Candidate `0.0.93-dev` adds a strictly read-only, per-index secret-preflight comparison of canonical HARMFUL/HELPFUL versus priority filters through the existing Phase H Status Aura Check. Preview and unsupported/absent targets defer; production renderers, stock aura coverage, native cast gate and quest native access remain unchanged. No renderer promotion or live harmful PASS until in-client evidence. The loot quest-tracker flash remains OPEN/INTERMITTENT.

### P0177 R1 — Recover uncommitted source files (2026-10-09)

The user pushed P0177 but GitHub `main` at `a2eed84` contains only the 12 modified tracked files: the TOC and Commands refer to a source engine not present on GitHub. The new `AuraSourceEngine.lua`, checker, patch/evidence and manifest were omitted. This is a real durability failure, not an in-game failure: client loadCount 225 at `0.0.93-dev` ran the local reader and completed Run All. Source compare observed target HELPFUL base ordinary=1 vs priority=0; HARMFUL remained empty/secret-restricted and hostile-only target proof remains deferred. P0177 R1 reconstructs missing files from the original ZIP and updates memory; no runtime logic changes. Verify the complete new-file set in the next user push before advancing. Loot quest flash and primary secure ownership remain open.

## P0178 — permanent Blizzard/Logres UI ownership checker (2026-10-09)

After GitHub verified P0177 R1 at `0f3f0b7`, the user requested a **flag-aware, expandable whole-interface** checker instead of repeated single-domain diagnostics, explicitly noting existing diagnostics already cover most behavior. P0178 adds a centrally registered, read-only inventory of Blizzard surfaces and Logres replacement/fallback (including deliberately stock domains), and displays the matrix in Phase 0 plus Run All. It consumes existing module debug snapshots; no new direct Blizzard presentation reads, polling or frame mutation. Classifications are PASS/FAIL/DEFERRED/STOCK; STOCK means intended retained fallback, not empirically verified visibility. Existing harmful-source limits, primary secure action fallback, and loot ObjectiveTracker flash remain open. Candidate `0.0.94-dev` requires full static and WoW validation before acceptance.

## P0178 R1 — Lua command-dispatch startup regression (2026-10-09)

Original P0178 `0.0.94-dev` failed in-client: `/logres` unavailable and another addon recorded `Commands.lua:4921: function at line 4566 has more than 60 upvalues`. Cause: added locally captured `runUIOwnershipCheck` exceeded Forever Lua's handler upvalue limit. The static checker and mock tests had missed whole-file compatibility. Preserve this as FAIL. Corrective R1 candidate `0.0.95-dev` dispatches via already-captured `Logres:RunUIOwnershipCheck()` instead, enhances the permanent audit checker to reject the local capture, and retains the same 35 ownership registrations. R1 requires exact-base/mixed-original-source validation, shadow static suite, deployment, `/reload`, restored `/logres`, UI Ownership Check, and Run All. This is a candidate, not runtime PASS. See `docs/memory/evidence/P0178_R1_SLASH_UPVALUE_FIX_2026-10-09.md`.

## P0179 — P0178 R1 verified ownership audit runtime (2026-10-09)

GitHub `main` `fd0dc88` contains corrected P0178 R1 `0.0.95-dev`. Uploaded loadCount 229 diagnostics confirm `/logres` registered, Phase 0 `uiownershipcheck` and Run All completed in Immersion ON and OFF (and ON again), plus lifecycle/preference PASS. Ownership matrix: ON **35 total / 17 PASS / 18 STOCK / 0 FAIL / 0 DEFERRED**; OFF **35 total / 16 PASS / 19 STOCK / 0 FAIL / 0 DEFERRED**. Five native fold domains and cast gate matched expected ON/OFF states; observed HUD visibility and player/target/chat/secondary action ownership cohered. `STOCK` means deliberately retained ownership and often `not inspected`, **not** verified Blizzard-frame visibility or replacement completeness. The original P0178 `0.0.94-dev` compile failure (`handleCommand` >60 upvalues; `/logres` absent) is still FAIL history; R1 fixes the observed startup regression.

The UI ownership registry must expand with future Logres UI ownership changes; existing specialized checks and Run All remain active. No new code or native suppression in P0179. Phase H.1 remains OPEN: naturally populated player/target harmful aura live/visual evidence still deferred, hostile-target buff classification unknown, loot-linked ObjectiveTracker flash intermittent/unreproduced, and primary/special/pet/party/minimap/full-quest stock coverage capability-gated. Canonical evidence `docs/memory/evidence/P0179_ACCEPT_P0178_R1_RUNTIME_2026-10-09.md`.

## P0180 — event-driven harmful-aura evidence checkpoint (2026-10-09)

GitHub `main` verified at `8f5d94f`: P0179 docs-only runtime acceptance durable; P0178 R1 `0.0.95-dev` UI ownership registry is an accepted ongoing regression gate (35 surfaces; Immersion ON 17/18 PASS/STOCK, OFF 16/19, zero FAIL for observed checks). P0180 candidate `0.0.96-dev` adds event-latched canonical-versus-priority aura *diagnostic* via existing `StatusAuras` events, with ordinary-safe friendly/attackable/unknown target classification. Preview and Immersion OFF excluded. No new renderer ownership, native mutation or polling; no harmful-aura runtime proof claimed. Stock fallback remains. Original P0178 >60-upvalue startup FAIL remains historical. Loot ObjectiveTracker flash remains intermittent/unreproduced and primary/special action ownership remains incomplete.

## P0181 — P0180 runtime acceptance and panel-only workflow correction (2026-10-09)

GitHub `main` `d45097c` contains P0180 (`0.0.96-dev`). User-uploaded `LOGRES_DIAGNOSTICS_LATEST.lua`, loadCount 232, has a complete Phase 0 **Run All** with no recorded Lua/command errors, and the 35-row UI Ownership summary ON **17 PASS / 18 STOCK / 0 FAIL / 0 DEFERRED**. Event history correctly distinguishes ordinary-empty, restricted, and one friendly-target HELPFUL general-filter candidate: prior P0180 session samples playerHarmful 2 empty, targetHarmful 9 with 6 restricted (8 hostile-classified/1 friendly), targetHelpful 9 with 1 ordinary positive on a friendly target and 6 restricted. No ordinary hostile target HELPFUL positive or player/target HARMFUL positive was proven. Restriction skips are not hidden-aura counts. P0180 is accepted **only for its observed diagnostic and regression scope**, with Blizzard aura fallbacks preserved; Phase H.1 remains OPEN.

**Process failure:** the assistant repeatedly gave slash commands despite the user requiring the developer panel and treated a not-yet-persisted Run All result as if the user had not run the test, wasting a duplicate test/reload. Correct future practice: use actual Phase 0 **Run All / UI Ownership Check**, Phase H **Status Aura Check/Preview** buttons; never demand repeated testing merely because an older SavedVariables snapshot lacks the run. P0181 changes documentation only. Historical P0178 >60-upvalue crash, P0175 R2 nil-rows, intermittent loot ObjectiveTracker flash, incomplete Main/special secure ownership, pet/party/class/minimap/full-quest/auras remain explicitly open as applicable. After P0181 acceptance, prioritize targeted Main/Override/special-action ownership capability review, not another generic aura scan.

## P0182 — restore target nameplate-only debuff filter coverage (2026-10-09)

Verified `main` `2adce36` contains P0181; event-history diagnostics passed but real player/hostile-target debuffs remain unproven, and user reports missing debuff display. Code review identified one concrete production filtering omission: target `HARMFUL|PLAYER` and `HARMFUL` omit the API's `INCLUDE_NAME_PLATE_ONLY` flag, excluding a legitimate nameplate-only class of effects. P0182 candidate `0.0.97-dev` adds nameplate-inclusive target harmful descriptors ahead of the existing fallbacks (which are retained), with bounded existing source enumeration, secret-first index preflight, deduplication and separate harmful/helpful rendering unchanged. No new diagnostics, unrelated action-bar work, native suppression or gameplay PASS is claimed. Existing player harmful lane remains separate; it may have additional unproven issues. Future verification exclusively through Phase H Status Aura panel actions and Phase 0 Run All / UI Ownership Check. Live harmful rendering and protected restrictions remain DEFERRED until observed. The P0181 Main/Override next-step prioritization was a planning error and is superseded by this debuff-first task; action work remains OPEN for afterward.

## P0183 — native secure-rendered Logres debuffs (2026-10-09)

P0181 is verified on GitHub `main` `2adce36` / `0.0.96-dev`. The user reports **Blizzard debuffs visible but no Logres debuffs**; P0182 nameplate-only filter trial did not resolve that. Prior P0176–P0180 scans filtered restricted indexed harmful auras out *before* Logres icon creation; repeated diagnostics alone cannot provide a rendered debuff. Source inspection of pinned Forever `Blizzard_CustomAuraContainer` and Forever-compatible WeakAuras/Musca-Auras shows a separate native aura-rendering route: addon-owned `CustomAuraContainerTemplate` with native aura buttons. P0183 `0.0.98-dev` implements player and target native HARMFUL containers in Logres's semantic positions while preserving the existing preview and ordinary-read fallback, target helpful / player helpful, private/group/native stock auras, and 35-row ownership audit. Native readiness ≠ live icon proof; in-game visual/runtime acceptance remains PENDING. Phase H.1 stays on functioning debuffs; Main/special secure actions remain open later. Validation is via developer panel only. P0182 failed to establish visual debuff coverage and must not be declared an accepted fix.

## P0183 R1 — prewrite packaging failure, corrected

The first P0183 delivery failed before reading the Git baseline or writing tracked files: `P0183 PAYLOAD missing/corrupt __pycache__/P0182_APPLY.cpython-313.pyc`. The packaging manifest had included a development-only Python bytecode cache that was not shipped. This is an artifact-delivery FAIL, not a WoW runtime test and not a gameplay result. P0183 R1 rebuilds the payload hash list from an explicit allowlist of shipped source files, disables bytecode creation during its internal P0182 candidate import, and includes an archive/hash integrity smoke test. Source, native debuff design, candidate version and runtime acceptance gate are unchanged. The corrected archive must still pass its prewrite complete checker suite before any tracked change; actual Logres debuff visibility remains unproven until the in-game panel/visual gate.

## P0184 — native Logres debuff delivery accepted (2026-10-09)

Verified `main` `11a342b` contains P0183 R1. User visually confirms Logres debuffs now appear, with polish deferred to general Phase H composition. `0.0.98-dev` loadCount 234 Run All is complete, native HARMFUL containers `ready=true active=true`, UI Ownership 17 PASS / 18 STOCK / 0 FAIL; prior Lua-indexed harmful scan emptiness does not contradict secure native rendering. Keep Blizzard stock/private/group fallback, no suppression or completeness claims for unobserved units/modes. Phase H.1 proceeds to protected Main/Override/special action routing, editing and restoration boundaries; remain capability-gated. P0184 is documentation-only and needs no WoW redeploy.

## P0185 — current Phase H.1 remaining visible-bar gate (2026-10-09)

Remote `main` `4e999b1` accepts the user-confirmed P0183 R1 native Logres debuff appearance in P0184, on `0.0.98-dev`; Run All complete, ownership ON 35/17 PASS/18 STOCK/0 FAIL. User reports **normal MainActionBar is the only remaining persistent Blizzard action bar to remove** in the intended normal Immersion screen. That is a visual observation, not permission to eliminate intentional 18 STOCK fallback/control domains. Next H.1 integration work is normal Main secure route/edit/control coverage plus reversible stock presentation/mouse suppression only where proven; retain Override/vehicle/possess/extra and other intentional native access, exact restoration and no invisible click areas. No new debuff work. H.2 layout and H.3 whole-screen polish, including debuff polish, remain next after normal Main gate. Prior P0168/P0183 pending labels are chronological history, superseded for current planning.

## P0186 — source gate before secure Main replacement (2026-10-09)

GitHub `main` `60886bb` verifies P0185 docs-only memory reconciliation, with runtime still `0.0.98-dev`. The pinned Forever native `Blizzard_ActionBarController/ActionBarController.lua` reuses MainActionBar for unskinned vehicle, override, bonus and temporary-form pages, and can re-show it in the controller transition. Logres Primary has normal-only secure paging and always-on override bindings when armed; out-of-combat stock alpha/mouse suppression alone cannot guarantee correct special action keys or combat restoration. **P0186 records direct-hide as source-blocked, not implemented or runtime-tested.** Next implementation must coordinate secure mode-aware key routing with native Main normal-only presentation, stock edit/special access and exact fail-open restoration. No WoW redeploy for this documentation-only source checkpoint.

## P0187 — Main normal secure replacement candidate (2026-10-09)

Verified P0186 remote `2421040` established direct Main alpha/mouse hide is unsafe in special modes. P0187 candidate `0.0.99-dev` installs a bounded manual/session-only `SecureHandlerStateTemplate` gate: native Main is a protected child hidden entirely only for secure normal mode, with Primary secure ACTIONBUTTON keys redirected to genuine Blizzard stock buttons in the native special modes. Preserve all native special/dedicated controls and exact original parent/key route on OFF, Immersion OFF, edit lifecycle, with combat deferral. No default persistence and no blanket UI mutation. **Runtime and visual PASS are pending**; test Phase D Main Replace ON/OFF/Check and Phase 0 Run All/UI Ownership, preserve environmental special-mode deferral and historical failures. H.1 closure and H.2/H.3 remain pending.

## P0187 R0 in-client ON/OFF/ON failure and R1 correction (2026-10-09)

User evidence (`LOGRES_DIAGNOSTICS_LATEST.lua`, loadCount 236, `0.0.99-dev`): initial `mainreplace on` CANDIDATE (`applied=true`, activations 1); `mainreplace off` STOCK (`applied=false`, restorations 1); subsequent ON repeatedly FAILED with `MainReplacement.lua:200: secure normal mode gate not established` (`armed=true`, `applied=false`, activations 1, restores 1). OFF afterward reported stale FAIL despite native stock already restored. This establishes a **reproducible re-arm failure, NOT a failed first release**. No special/combat mode was tested; no Lua traceback outside the intentional secure-gate assertion appears in the supplied panel diagnostics. This is not a test that stock was physically clickable afterward.

Narrow inferred cause, supported by secure state-driver implementation: unregistering `state-logresmode` stops updates but retains the `normal` attribute. After OFF explicitly shows the reusable gate, re-registering the same `normal` value does not trigger `_onstate-logresmode`, so Main remains visible under the gate and the fail-open assertion at line 200 fires. R1 clears only its own secure handler `state-logresmode` attribute out of combat when releasing and immediately before re-registering. Original Main parent restoration precedes release reset; routing release remains after native restoration. Failed-ON rollback also clears the addon state. OFF clears a stale failed-ON diagnostic if stock is already released. R1 adds order-sensitive static checker assertions for re-arm safety, without polling/hooks/native attribute mutation.

R1 `0.0.100-dev` is an **untested corrective runtime candidate** against the **P0187-applied but uncommitted** checkout at `HEAD` `2421040`. It has no runtime PASS until panel ON → OFF → ON → OFF is repeated and normal native visibility/click, Primary keys, Immersion OFF and Edit Mode recover. Native special states remain environmentally DEFERRED unless naturally observed. The earlier R0 runtime failure remains durable negative evidence; do not classify H.1 complete until restoration re-test.

## P0215 — Approved percentage + Active Quest media candidate (2026-10-16)

P0214 pushed `1ae5948`; user observed coherent approved action frames and functioning button presses, with Action/Layout/Run All PASS in latest `0.0.123-dev` diagnostics loadCount 282. This is bounded P0214 visual acceptance, not universal hover/combat or protected proof. P0215 (runtime `0.0.124-dev`) derives 5 production TGA textures from approved sheets 02 and 10: one shared normal/compact percentage fill + diamond (resource/target/pet/ally/objective), and aged Active Quest panel/divider/glyph. No Lua behavior/Theme geometry/click/Blizzard/pet driver modification. New image hashes are guarded by the two existing canonical static contracts and a dedicated sheet-02/10 checker. **P0215 UNTESTED in WoW**, including dynamic panel sizing, text overlap and neutral-fill tint. Confirm in client before acceptance; retain any FAIL/DEFERRED result. Refer to `docs/memory/evidence/P0215_APPROVED_BAR_QUEST_MEDIA.md`.

### P0215 R0 PREWRITE FAIL / R1 corrective delivery

The original P0215 applier failed before tracked writes: `check_memory_health.py` rejected generated CURRENT.md, missing the three required headings `Success Criteria`, `Do Not Reopen Without New Evidence`, and `Relevant References`. User-reported `git status` showed only two unrelated/untracked PNG previews; original TGA source remained unmodified. **R1** corrects generated memory and asserts all seven heading contracts prewrite, preserves identical media payload. No WoW art or control PASS follows from fixing package delivery. Keep this negative result; see the P0215 evidence record.

## P0216 — H.3 resource-focus and completion distinction (2026-10-16)

P0215 pushed `8386e91`; user accepted the sheet-10 parchment and sheet-02 bar artwork, but screenshot/feedback exposed oversized opaque action cluster backing, under-scaled player-resource bar and weak ready-vs-in-progress contrast. P0216 removes ONLY the shared cluster backplate, retains individual approved action art/secure hitboxes, adds a dedicated wider player-resource bar style and a conditional ready/complete heraldic rule/seal/title/phrase in the already source-proven ActiveQuest renderer. Does not change global normal/compact bars, original assets, v4 anchors, pet/native visibility, secret-safe arithmetic, data or Blizzard fallbacks. Candidate until panel checks + WoW visual/interaction review. See `docs/memory/evidence/P0216_H3_SCREEN_COMPOSITION_POLISH.md`. Previous P0215 R0 prewrite CURRENT-heading failure remains recorded.

## P0217 — Approved dock and sparse target/pet/ally visual translation (2026-10-16)

P0216 pushed `905c847` and user accepted the visual result, but clarified that many approved H.3 elements remain unimplemented: do not declare H.3 near completion or repeatedly polish accepted resource/action/quest art. P0217 is a *bounded candidate*: two horizontal bronze dock TGA skins derived from accepted sheet-03 frame, six flat native-access tabs plus three generic red PET STOCK/BUFFS/TARGET addon-owned fallback buttons converted to this art, and quiet Theme-driven target/ally/pet title hairlines. All click surfaces, callback routing, unit sources/secret transport, Blizzard fallback policies, P0216 bar geometry, and v4 anchors unchanged. WoW proof is required via panel Native Access/HUD/Action/Layout/Run All and direct button/Immersion checks. See `docs/memory/evidence/P0217_H3_NATIVE_DOCK_TARGET_ALLY_ART.md`. P0215 R0 prewrite memory failure and historical pet/aura/runtime negatives remain recorded.

## P0218 — H.3 sheet-04 compact aura urgency and stack presentation (2026-10-16)

GitHub main P0217 `b841afa` verified, user reports native dock/target/pet/ally visual controls functioning as expected; latest `0.0.126-dev` loadCount 287 out-of-combat Run All PASS with 13/13 v4 envelopes and 35 ownership results (17 PASS, 18 deliberately STOCK, 0 FAIL). The test has positive target helpful source evidence but no populated harmful aura; do not count restricted aura transport or unavailable environments as visually passed. P0218 is a presentation-only sheet-04 candidate: add a small existing approved aura count-plate texture behind stacks and a restrained urgent-only top rule in addon-owned StatusAuras slots, via Theme. Keep native harmful renderer, secure membership, restricted data handling, player helpful and Blizzard fallback unchanged. No new aura inspection, changes to labels/sources, position, action bar, pet driver or stock controls. The existing approved P0200 frame and player-helpful count plate are reused, no speculative source/geometry redesign. P0218 R0 PREWRITE FAIL: prepared CURRENT_HANDOFF.md omitted the mandatory CURRENT.md authority pointer; check_memory_health.py rejected shadow candidate before tracked writes. R1 repairs the handoff and checks this contract explicitly. WoW status-preview, Native Access, Layout Check and Run All required. Historical failures remain. See `docs/memory/evidence/P0218_H3_AURA_STATE_PLATES.md`.

## P0219 — Compass approved sheet-12 art roles and missing capability correction (2026-10-16)

GitHub `main` P0218 `157e09c` verified; user corrects assistant's premature treatment of compass as mostly complete. P0219 visual-only candidate introduces approved quest pennon, local POI seal and tracking pip textures in distinct sheet-12 vertical lanes with explicit developer-only preview. Runtime compass still has real heading/manual waypoint only; the preview is NOT evidence that real quest/POI/tracking bearings exist. P0142/P0143 confirmed tracking-selection metadata and map geometry but no enumerated tracking result locations or observed safe quest/AreaPOI positions. Existing `NavigationSourceProbe.lua` remains the next source investigation action; full center focus/name fade/multiple real marker ownership also remain incomplete. Preserve stock minimap D-030, D-037/D-038 approved design, source secrecy, and protected interaction. No polling, fabricated bearings, or Gameplay/UI suppression. Validate Phase E Compass Art ON/OFF/Compass Check, Phase H Navigation Source Probe/H.2 Map/Layout, Phase 0 Run All; WoW UNVERIFIED. See `docs/memory/evidence/P0219_COMPASS_SHEET12_AND_CAPABILITY_GAP.md`.

## P0220 — Available unaccepted quests as local compass POIs (2026-10-16)

P0219 `63a7557` pushed and `0.0.128-dev` loadCount 290 Phase E Compass Art ON/OFF and Compass Check passed. Navigation Source Probe: map 1432, radius 133.33 yards, 23 tracking categories/4 active, no positioned AreaPOIs, no quest waypoint and zero reported failures. User extends D-037 local POI semantics to **nearby available but unaccepted quests**, separate from accepted/current quest major destinations. Forever 1.60.1 documents `C_QuestLine.GetAvailableQuestLines(mapID)` with quest-line x/y, name and questID; it is NOT an exhaustive quest-giver database. P0220 candidate (`0.0.129-dev`) adds optional, bounded (24), secret-gated read-only available quest-line capture with `C_QuestLog.IsOnQuest`/`IsQuestFlaggedCompleted` eligibility and ordinary view-radius checks. The live compass may render *only* ordinary, eligible, same-map, within-radius quest-line coordinates as tiny sheet-12 local POIs, with a source-backed name near exact center. No fabricated markers, new polling, or minimap hiding. Source population/accuracy/runtime safety remain UNVERIFIED. See `docs/memory/evidence/P0220_COMPASS_AVAILABLE_QUEST_POI_SOURCE.md`.
