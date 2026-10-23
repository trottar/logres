## P0316 — universal NPC gossip scope correction (2026-10-22)

Verified pushed P0315 `878235b` contains a nonquest-only restriction in its read-only source adapter. The user clarified gossip is a **current NPC interaction stage**, not an NPC-family whitelist: guards/directions, trainer/service preludes and mixed quest+gossip NPCs must be considered. **P0315 DESIGN FAIL** for mixed-source rejection. The P0315 R1 corrective ZIP was pinned to P0314 and refused on already-pushed P0315 with `unexpected commit baseline; no writes`: assistant **ARTIFACT BASELINE FAIL**, no source writes. P0316 **PREPARED / FULL STATIC+WOW UNVERIFIED** rolls forward on exact P0315, migrates the historical checker, adds 187th checker, classifies four gossip kinds, keeps native options disabled and Quest entries count-only, preserves Blizzard control and all trainer/Quest/camera code. Next: checker PREWRITE/POSTWRITE and user push, deploy, read-only H sampling, then stage-aware shared-renderer presentation gate. See `docs/memory/evidence/P0316_UNIVERSAL_GOSSIP_SCOPE.md`.

## P0315 — guarded live gossip source-model trial (2026-10-22)

GitHub main P0314 `f40a8e0` verified pushed; user reports latest single-window profession trainer change successful with no noticed issues (scope not exhaustively itemized). **P0315 PREPARED / WSL+WOW UNVERIFIED**: introduce one-shot H-panel **Gossip Source Check (READ-ONLY)** converting ordinary, bounded `C_GossipInfo` text/options into inert `NPCOptionModel.FromValidated` only when native active/available quest arrays are confirmed empty. Missing APIs, secret/truncated/ambiguous results or mixed quests leave Blizzard gossip entirely intact; no presentation or live click. Existing P option fixtures, trainer, quest 237, camera and transaction routes untouched. Next: 186/186 prewrite/postwrite checks, push, deploy, test a normal and mixed-quest gossip source; then gated shared-renderer read-only presentation. See `docs/memory/evidence/P0315_GOSSIP_SOURCE_MODEL.md`.

## P0314 — profession single-window restoration-backed trial (2026-10-22)

Verified pushed P0313 main `5824a1d`; user reports Enchanting and other profession source lists and class trainer stable, P current-trainer and complete Your professions sidebar accepted, Fishing owned Journeyman 61/150 shown. Remaining duplicate Blizzard profession window explicitly rejected. **P0314 PREPARED / WSL STATIC and WoW UNVERIFIED**: only after real Logres model, visible owned root and enabled **Blizzard UI** fallback control, permit one-shot guarded parking of the whole Blizzard trainer frame (still shown for source/API purchases). A normal left-click restores Blizzard anchors before Logres dismissal; parked profession Goodbye can restore then request one native CloseTrainer, but nonparked profession Goodbye stays Logres-only. Class router/transactions/opaque anchor semantics unchanged, no native alpha hide, timer or polling. Empty Fishing stock information remains reachable through one-click fallback. Purchased profession services may restore stock pending native update, so ongoing postpurchase single-window unverified. User asked to fix “See offered training” and “No listed training services” generic labels; replace focus detail wording without inferring a purchase offer. Next: full 185 checker PREWRITE/POSTWRITE, push verification and class/Cooking/Enchanting/Fishing runtime validation; after pass, begin guarded live gossip C_GossipInfo adapter over existing accepted P branching/overflow/locked/services UI. Evidence: `docs/memory/evidence/P0314_PROFESSION_SINGLE_WINDOW.md`.
## P0313 — separate current trainer and all player professions (2026-10-22)

Verified P0312 main `8776eb6`; user visual test confirms Enchanting and Cooking lists and the complete Your Professions block, class training stable, Fishing empty Logres fallback. P empty synthetic question-mark icon became bright yellow; **OPEN VISUAL REGRESSION**. User requests a distinct **Current trainer** summary *in addition to* all owned professions. **P0313 PREPARED / WSL STATIC and WoW UNVERIFIED**: source-backed trainer discipline from copied service requirements or guarded native NPC TooltipInfo/greeting on zero-service, known rank from P0312 owned-skill API, next rank threshold from native unavailable skill service; unknown remains unknown, no guessed profession identity. Shared P/live renderer holds two sidebar sections, unchanged action/layout semantics. Empty P fixture only adopts live dark-backed icon treatment, leaving regular P/live icons unchanged. Next guarded full static and runtime preview/Fishing/Cooking/Enchanting/class test, then trainer completion gate. Evidence: `docs/memory/evidence/P0313_TRAINER_FOCUS_ICON_PREVIEW.md`.
## P0312 — Profession sidebar context and source reconciliation (2026-10-22)

Verified main P0311 `8987489`. User screenshot at Thonys shows Blizzard five Enchanting services while Logres incorrectly displays ZERO: **P0311 RUNTIME FAIL**. User rejects P0311 profession Goodbye native close while Blizzard remains transaction/information fallback, requests informative Fishing Journeyman context and reusing blank area below search for ALL profession trainers. P0312 **PREPARED / FULL STATIC and WoW UNVERIFIED**: new guarded read-only GetProfessions/GetProfessionInfo adapter for known profession skill/cap and tier in left sidebar, same approved renderer and P — Trainer Empty Preview fixture, event-driven empty-to-nonempty native service reconciliation on TRAINER_UPDATE, profession Goodbye returns to Logres-only (class remains native close). Existing 36 P actions unchanged, source/TOC load-adjacency intact, no speculative profession learning or stock suppression. Historical P0311 native-close source/evidence retained and checker deliberately superseded. Requires 183-checker PREWRITE/POSTWRITE, push verification, WoW visual/function check. Evidence: docs/memory/evidence/P0312_PROFESSION_CONTEXT_RECOVERY.md.

## P0311 — profession native-close Goodbye and ordinary filter visibility (2026-10-22)

Verified P0310 main `cb1a83f`. User screenshots confirm the P — Previews empty fixture and live Grimnur Fishing empty-shell Logres renderer **PASS within visual/entry scope**; Blizzard retains the real `Journeyman Fishing — Already known` label while the native service count is 0. P0311 **PREPARED / WSL + WOW UNVERIFIED** separates an ordinary profession-only `CloseTrainer` Goodbye request (after successfully restoring Blizzard via Trial.Disable), from class close and all native purchases. A second read-only adapter copies `GetTrainerServiceTypeFilter` values and annotates a zero-row live explanation ONLY if Known filter is readable and OFF; nil/secret/unknown leaves generic copy. No native filter writes, no visual new P action, no native profession parking/transactions, no new ownable skill. Normal native profession UI remains visible prior to Goodbye. Runtime check: at profession (including zero-row Fishing), Goodbye closes both after a single request without stock flash, new interaction opens again, class unchanged. Historical P0303/P0307/P0310 static failures and P0304/P0306 runtime failures preserved. See `docs/memory/evidence/P0311_PROFESSION_CLOSE_FILTER_CONTEXT.md`. Then profession source coverage/safe presentation ownership; NPC gossip → merchants → flight masters.

## P0310 — shared zero-service NPC presentation for profession trainers (2026-10-22)

Verified P0309 main `5d27a06`, user confirms one real Logres-initiated Enchanting purchase PASS and class functionality unchanged. Fishing Grimnur remains source-empty (`services=0`, profession=yes) but should no longer be Blizzard-only visually. **P0310 R2 PREPARED / WSL and WoW UNVERIFIED**: shared data-only NPCServiceEmptyState, same production trainer renderer in an inert alternate empty fixture accessible from **P — Previews → Trainer Empty Preview** plus H zero-service profession model. One disabled informational display row, genuine `catalog={}`, no native service identity or actions. Blizzard remains shown for qualifications/learnability not provided by source; do not claim the character already knows or lacks the profession. Never synthesize a Learn Profession offer or park empty-source stock. Preserve all existing class/Enchantment/Cooking behavior, prior failures and D-046/D-047. R0 PREWRITE failed 9/181: 7 P-gallery inventory and 2 module adjacency contracts; **no tracked writes**. R2 preserves the existing 35 actions, authorizes a 36th P-panel action, and preserves exact P0303/P0304 TOC adjacency by placing the new data helper after the established service controller chain. Next inspect alternate inert preview and live Fishing after deployment; user reports runtime. Evidence: `docs/memory/evidence/P0310_TRAINER_EMPTY_CATALOGUE.md`.

P0310 R1 was NOT accepted: its slash-only preview violated the established P-panel workflow. P0310 R2 authorizes a dedicated **P — Previews → Trainer Empty Preview** action (36 total), deliberately migrates seven gallery inventory checkers, and preserves the existing native probe/catalogue/renderer load adjacency. R2 full static/WoW UNVERIFIED.

## P0309 — service-specific guarded profession one-skill training (2026-10-22)

Verified pushed main P0308 `78a0c03`. User P0308 runtime: class trainer Logres-only and native-close Goodbye **PASS**; Cooking/Enchanting readable Logres catalogue with Blizzard stock controls and Logres-only Goodbye **PASS within presentation scope**; Fishing source-empty **OPEN / BLIZZARD FALLBACK**. No Logres profession purchase or class purchase with native root parked was proven. P0309 **PREPARED / WSL + WOW UNVERIFIED** splits class single purchase from profession single purchase. Separate `NPCTrainerProfessionPurchaseTrial` revalidates ordinary profession family, trainer/source identity, skill prerequisites, money and extra cost fields, wallet and explicit one-click purchase; refuses unknown/positive extra resources and leaves native Blizzard visible. `NPCTrainerPurchaseTrial.Attempt` becomes class-only; bulk remains class-only. No UI art, camera, shared catalogue, native positioning or preview changes. Keep previous P0304 auto failure, P0306 profession fallback defect and P0307 R0 checker-count failure in historical evidence. After runtime proof, consider profession native parking only with safe replacement and rollback. Subsequent order: gossip → merchants → flight masters. See `docs/memory/evidence/P0309_PROFESSION_SINGLE_TRANSACTION.md`.

## P0308 — class Goodbye native-close request, profession source-empty evidence (2026-10-22)

Verified P0307 main `dad4c97`, user supplied one-shot trainer family output: Fishing Trainer Grimnur Stonebrand returned `type=7`, `profession=yes`, ordinary nonprotected/shown root and **zero native services**. Source `GetNumTrainerServices()` returned 0, so class catalogue is not a valid basis for profession replacement. **OPEN / SOURCE EMPTY** for this NPC; stock remains usable. The user also confirmed P0306 class native parking and exact Goodbye rollback: Blizzard native window visibly reappears, **RESTORE VISUAL PASS** (this was expected P0306 test behavior, not a regression). Native close was not implemented in P0306.

P0308 **PREPARED / FULL STATIC AND WOW RUNTIME UNVERIFIED**: implement a separate class-only `TrainerCloseTrial` guarded adapter using `CloseTrainer()` only on intentional Logres Goodbye after `Trial.Disable("goodbye")` restores native anchors successfully. Exclude profession/secret/protected/combat/deferred sessions; at most one request, no polling, stock fallback if capability absent/fails. Preserve existing class search/filter/selection/scroll/hover/single+bulk purchase and camera. A successful pcall is a request, not a confirmed native close. One historical R0 P0307 prewrite checker-count failure remains recorded; don't overwrite failures. D-046/D-047 and shared catalogue/session/parking architecture retained. Future service order: gossip, merchant, flight master after class trainer.

**Cross-family safety:** Enchanting and Cooking Logres read-only rows are visible, unlike the source-empty Fishing case. P0306 offscreen parking of profession stock leaves no usable learning control. P0308 gates parking on ordinary `IsTradeskillTrainer()==false`; profession/unknown families retain Blizzard visible alongside Logres until service-specific transaction controls earn runtime proof. This negative evidence remains OPEN, not falsely marked as profession transaction PASS.

## P0307 — trainer family classification before profession adapter (2026-10-22)

GitHub P0306 `5acc447` independently verified pushed. User screenshot and report show class trainer now using single visible Logres UI (**native parking visual PASS**) but profession Fishing Trainer Grimnur Stonebrand remains stock Blizzard. This is a **family-specific observed fallback**, not failure of class trainer. Exact profession `interactionType`, source API shape, and safe action eligibility remain **UNVERIFIED**. P0307 PREPARED: one-shot, read-only H-panel Trainer Family Check maps normalized NPC type, native root shown/protection, `IsTradeskillTrainer`, bounded native service count, first-row safe six-field shape and Logres session/visibility into addon-owned diagnostics. No class training/Train All, native parking, shared rendering, Quest or DynamicCam changes. No purchase and no parking change. After in-game result, route profession trainers through the existing approved Logres landscape where supported, with separate action and stock fallback gates. D-046/D-047 apply. User accepted sequence: trainer finalization, gossip, merchants, flight masters. Source evidence `docs/memory/evidence/P0307_TRAINER_FAMILY_DIAGNOSTIC.md`.

**P0307 R0 PREWRITE FAIL / R1 CONTENT REPAIR:** original applier incorrectly required >=179 checkers though verified P0306 contains 177 and P0307 adds one (178). Baseline/anchors/whitespace PASS; guard stopped before tracked writes. R1 compares exact checker filenames and runs all scripts, pending WSL and WoW verification. No in-client defect inferred.

## P0306 — trainer-only whole-root native parking and restoration (2026-10-22)

GitHub P0305 `c6ee091` independently verified pushed. User screenshot and report prove automatic Logres trainer entry and search/filter still work (scoped P0305 runtime PASS); Blizzard native trainer remains visibly duplicated. **P0306 PREPARED / WSL and WoW runtime UNVERIFIED.** Build `UI/NPCServiceNativeParking.lua` as a reusable but trainer-only authorized presentation primitive, borrowing established opaque-anchor snapshot/restore semantics from the guarded native-placement trial. Only after Logres is fully rendered, park the entire ordinary, nonprotected, shown Blizzard trainer offscreen while maintaining source and purchase APIs. Reject combat, unsafe root, competing native placement/skin, or missing hook; stock remains visible if parking cannot start. Restore original anchors BEFORE hiding Logres on Goodbye/OFF/native teardown; if restore is locked, keep Logres until an event-driven regen retry. No alpha-only hiding, invisible stock click regions, polling, native transactions, camera changes or trainer redesign. Test ordinary trainer entry with stock out of view, then Goodbye restoring stock, new-visit reopen and H OFF/ON. Native purchases while parked and native-closing Goodbye remain separate UNVERIFIED gates; prior P0304 auto-entry failure remains preserved. Order after trainer: gossip, merchants, flight. Evidence: `docs/memory/evidence/P0306_TRAINER_NATIVE_PARKING.md`.

## P0305 — correct missing automatic trainer readiness signal (2026-10-22)

Verified GitHub main P0304 `a493b9f` pushed; user confirms **P0304 AUTO ENTRY RUNTIME FAIL** (no Logres on normal trainer interaction), while H manual Live Trainer works. State-triggered P0304 session may have fired before lazy native frame visibility; initial native OnShow hook can miss that first presentation. P0305 **PREPARED / WSL STATIC AND WOW UNVERIFIED** adds narrowly scoped Forever `TRAINER_SHOW`/`TRAINER_UPDATE` event reconciliation and addon-owned readiness audit in the shared NPC session. No timers, broad hooks, native frame setters, camera or purchase changes. Stock remains visible until a separately verified recovery gate. Retest normal NPC opening before calling default entry PASS. Preserve P0304 negative evidence and older P0303 R0 static failures. See `docs/memory/evidence/P0305_TRAINER_READY_EVENT_REPAIR.md`.

## P0304 — shared NPC session and default trainer entry (2026-10-22)

Verified GitHub P0303 `4f7f9b5` pushed. User confirms P0303 catalogue extraction introduced no observed trainer regression; P0301 Train All purchase, P0302 hover, search/filters/selection/scroll/Goodbye previously PASS within tested scopes. **P0304 PREPARED / full WSL static and WoW runtime UNVERIFIED.** Add service-neutral `UI/NPCServiceSession.lua` for event-driven NPC opening, one native OnShow hook per ordinary nonprotected service frame, guarded state matching and per-visit Goodbye/OFF dismissal. Register trainer as first default-on consumer; leave stock `ClassTrainerFrame` VISIBLE and interactive, because `TrainerPurchaseTrial` still validates native `IsShown()==true`. No native suppression, geometry mutation, camera changes, input redirects, transaction changes, timers or polling. Preserve historical `.toc` trainer adjacency by loading session at end of addon list. Existing H ON/OFF remains. Test auto opening without panel, dismissal, fresh session and native fallback before attempting production stock suppression/restoration. Then native gossip, merchant, flight master. Evidence: `docs/memory/evidence/P0304_NPC_SESSION_AUTO_TRAINER.md`.

## P0303 — source-neutral NPC catalogue extraction and trainer completion order (2026-10-22)

Verified P0302 baseline retained. P0303 R0 PREWRITE FAIL 2/174: historical P0288 TOC adjacency broken by placing catalogue between native skin and live trial; new checker rejected missing uppercase UNVERIFIED marker in evidence. No tracked files written. R1 moves the catalogue before the intact trainer sequence and repairs evidence wording; full WSL suite and WoW runtime remain UNVERIFIED. Verified GitHub P0302 `05f8afc` pushed. User confirms all currently offered spells were purchased through Logres Train All (**scoped bulk runtime PASS**) and all hover feedback works. This supersedes prior quote-only status without fabricating purchase audit fields. P0303 **PREPARED / STATIC+WOW PENDING** extracts copied-record `Filter`, `Window` and `Find` to `UI/NPCServiceCatalogue.lua`, with trainer-specific search/eligibility callback and source-index purchase guard unchanged. No native writes, UI geometry, fixture, camera, transaction logic or stock hiding added. The accepted portrait-free parchment trainer is the sole visual authority; earlier generic merchant/flight mockups were rejected and must not be reused. Once no-regression tests PASS: automatic trainer presentation and safely recoverable Blizzard fallback, then native gossip, then merchant, then flight master. Full lifecycle and all client edge cases still unverified. See `docs/memory/evidence/P0303_NPC_SERVICE_CATALOGUE.md`.

## P0302 — live trainer pointer feedback (2026-10-22)

Verified pushed P0301 `07bc028`. User screenshot shows Logres's `Train all (4, 39s)` quote matching stock; **quote visual PASS, bulk purchase UNVERIFIED**. User requests interaction hover like Quest Accept/Decline. P0302 **PREPARED / FULL WSL AND WOW UNVERIFIED** adds gold-toned row hover wash (on owned row art), filter and scroll-arrow hover, and eligible-only Train selected / Train All hover wash, underline and brightened action label. Disabled/inert actions remain neutral; recycled/hid rows clear hover. Exact Quest visual system examined in `UI/DecisionVisual.lua`. Synthetic P, Blizzard stock, native data/geometry, all quote and transaction controllers unchanged. Guarded full-check, memory/version/whitespace and manifest gates apply. See `docs/memory/evidence/P0302_TRAINER_HOVER_FEEDBACK.md`; final native UI replacement and actual bulk purchase remain unverified and separate.

## P0301 — guarded class-trainer Train All (2026-10-22)

GitHub P0300 `73e3396` independently verified pushed; user confirmed trainer Goodbye works. Remaining user-requested items are bulk training and final stock-UI integration. **P0301 PREPARED / STATIC AND WOW RUNTIME UNVERIFIED.** A working third-party Forever Train All pattern establishes that explicit `BuyTrainerService(index)` iteration is feasible but does not replace independent safety checks. Add a complete bounded (≤384) ordinary class-trainer quote and one-click, revalidated set of at-most-once native requests, with total affordability and identity gates; stop on any mid-batch change and preserve partial result in audit. P fixture and earlier search/selection/single-purchase paths remain intact. Blizzard Train All stays available. Native presentation replacement/suppression is a separate immediate gate once in-game bulk behavior is known, not deemed complete by static code. Evidence: `docs/memory/evidence/P0301_TRAINER_BULK_TRANSACTION.md`.

## P0300 — match Quest Goodbye in live trainer (2026-10-22)

Verified pushed P0299 `b33bba2`; user screenshots show `curse`/`CURSE` yielding eight sampled matches, combined Available-only yielding one, and user reports all current live features functioning: **P0299 SEARCH RUNTIME PASS** within shown scope. User requested **Goodbye** matching Quest. `Quest/Dialogue.lua` already has an accepted upper-right 78×24 visual and presentation-hide semantic; `TrainerLiveTrial.Disable` clears search focus and owned interactions. P0300 **PREPARED / WSL and WOW UNVERIFIED** adds visually matched live-only top-right Goodbye hit region (owned Frame, ordinary LeftButton gate), calls `Trial.Disable("goodbye")` and leaves Blizzard's native trainer open and functional. Synthetic P, selection, scroll, filter, native service data, single purchase and camera unaffected. Native trainer closing and Train All are NOT authorized by this change; Train All remains DEFERRED. Test H trial on, hover, Goodbye, no stale hits, native stock usable, reopen search and OFF/close. See `docs/memory/evidence/P0300_TRAINER_GOODBYE.md`.

**P0300 R0 static failure / R1 repair:** User WSL PREWRITE reported 170/171 checkers PASS; `check_memory_health.py` rejected missing `## Do Not Reopen Without New Evidence` in generated CURRENT.md. No tracked source writes occurred. R1 restores that section and adds required-heading preflight to applier. P0300 Goodbye remains unverified in WoW; rerun full PREWRITE/POSTWRITE suites before staging.

## P0299 — live trainer local search, independent Train All gate (2026-10-22)

P0298 GitHub main `be13ce1` verified pushed. User screenshot/report establish **P0298 live trainer ICON VISUAL PASS** with visible list/detail art and working local skill selection, scrolling and local filter; one P0296 single-spell purchase was previously observed. The user identifies **Search and Train All NOT IMPLEMENTED**. Source confirms Search (stock) is inert text and `Visible services` is an inert category placeholder, while Train All is deliberately disabled. P0299 **PREPARED / WSL AND WOW UNVERIFIED** installs a live-only bounded case-insensitive name EditBox over the existing local search field, composes search with All/Available and scroll, retains selected service identity across hidden matches, clears focus safely on OFF, and relabels the noninteractive sidebar `Sampled skills`. Synthetic P and native APIs unchanged. Training of an excluded selection is locally disabled until filters include it again; native single-service guard remains independent. **Bulk Train All stays Blizzard-owned** pending a separately justified transaction/eligibility gate; never infer it is safe from one single-skill purchase. Full prewrite/postwrite checks and runtime search validation pending. See `docs/memory/evidence/P0299_TRAINER_LOCAL_SEARCH.md`.

## P0298 — separate live trainer icon texture layers (2026-10-22)

Verified pushed P0297 `aea974a`. User screenshot and statement establish **P0297 RUNTIME ICON VISUAL FAIL**: list and detail icon imagery nearly disappears under the live dark backplate; Blizzard native icons remain visible. The P0297 helper paints backing, image and subsequent edge textures on the same ARTWORK layer with no explicit priority. P0298 **PREPARED / STATIC AND WOW UNVERIFIED** isolates live texture layers (BACKGROUND fill, OVERLAY source art, higher OVERLAY edge) without editing native icon IDs, the reusable selected-detail painter, live selection, scrolling, filters, single-skill purchase or Blizzard controls. Synthetic P and reagent icons retain their fixture painter. If live artwork still fails, record FAIL and pursue a source-backed read-only diagnostic, not speculative recoloring. P0296 yellow-box failure, P0296 successful user-reported single-skill purchase, slider-drag deferral and the inert `Visible services` placeholder remain recorded. See `docs/memory/evidence/P0298_TRAINER_ICON_DRAW_LAYERS.md`.

## P0297 — live trainer icon backplate repair (2026-10-22)

P0296 `1a75351` verified pushed. User reports successful single-spell trainer purchase; before/after screenshot balances 1g20s58c → 1g14s58c and native available-list change corroborate one purchase (not Train All or general native replacement). **New P0296 runtime ICON VISUAL FAIL:** in the live trainer, Curse of Recklessness and Unending Breath appear as tan/yellow squares with faint icon imagery. The common live icon painter unconditionally places a filled `iconBorder` gold rectangle beneath each texture, allowing transparent/partial art to expose the fill; whether native IDs/alpha are independently at fault is UNVERIFIED. P0297 narrows the live-only painted backing to dark parchment plus four 1px gold outlines. Fixture P retains original art; no trainer source, selection, scrollbar, transaction, API, protected state or camera changes. PREPARED / WSL+WOW UNVERIFIED until user applies and tests. Current P0296 slider drag/track evidence is still unverified; `Visible services` remains inert. See `docs/memory/evidence/P0297_TRAINER_ICON_BACKPLATE.md`.

## P0296 — live trainer slider and single-service purchase trial

Prepared against verified pushed P0295 `7b1a459` on 2026-10-22. P0295 local selection has a user screenshot/runtime PASS; P0295 gold scrollbar thumb has user-reported **FAIL** (nonmoving, no click); category placeholder remains OPEN. This patch converts only the live rail to an addon-owned synchronized Slider and retains the accepted P fixture. A separate `TrainerPurchaseTrial.lua` capability-gates one physical user-initiated Train selected (TEST) click, checking live Forever six-tuple identity, cost, native service count, NPC, combat and Blizzard stock fallback before a single `BuyTrainerService` request. It never touches Train All or native selection/filter setters, does not retry, and cannot treat a successful `pcall` as training proof. Purchases/slider interactions await WoW validation. See evidence, CURRENT and D-046/D-047.

## P0295 — repair live trainer row click priority (2026-10-22)

P0294 `43802394` verified pushed. User screenshots show **RUNTIME SELECTION FAIL**: All sampled (64) / Available only (5) local filters and scrolling work, but clicking Logres skills does not change local selection or detail. P0294 drew independent wheel and row-hit siblings over the same input area without explicit priority. P0295 PREPARED / WSL AND WOW UNVERIFIED: seven row-hit frames become children of the addon-owned wheel and sit at a higher frame level; the wheel sits above inert rendered row art. Input geometry, native serviceIndex mapping, detail bindings, owner teardown, synthetic P and stock trainer remain unchanged. This frame-stack hypothesis requires WoW retest, not static success claims. The inert live sidebar `Visible services` remains an OPEN category/source UX placeholder, not real grouping. No native setter, protected mutation or purchase. See `docs/memory/evidence/P0295_TRAINER_ROW_HIT_PRIORITY.md` and `docs/memory/patches/P0295_TRAINER_ROW_HIT_PRIORITY.md`.

## P0294 — local selection and live detail binding (2026-10-21)

P0293 GitHub main `5e50fd2` verified pushed; user confirmed local All sampled/Available only filtering, seven rows and native selected-detail correspondence, but scrolling beyond seven is not conclusively verified. P0294 PREPARED / WSL AND WOW UNVERIFIED: seven narrow, live-only addon-owned click regions resolve sampled native service indices, preserve local selection through filter/scroll changes, and update reusable detail icon/name/requirements/description bindings in the accepted portrait-free landscape. Synthetic P remains inert. Blizzard trainer selection, source filters, purchase, Train All, geometry and stock controls remain unchanged. No native selection/purchase setter, polling or source reread is introduced. See `docs/memory/evidence/P0294_TRAINER_LOCAL_SELECTION.md` and `docs/memory/patches/P0294_TRAINER_LOCAL_SELECTION.md`. WoW OFF/close, empty state, click accuracy, scroll beyond seven and combat teardown require runtime proof.

## P0293 — local filtering and scrolling of captured trainer services (2026-10-21)

GitHub P0292 `a58cf78` verified. User screenshots with Blizzard's Unavailable filter OFF and ON show P0292 live source fidelity, not Logres-native filtering or scrolling. P0293 PREPARED / WSL AND WOW UNVERIFIED replaces the seven-row truncation with a bounded (64-sample maximum) one-shot catalogue and reusable seven-slot Logres painter. The only new mouse input belongs to narrow addon-owned filter, list-wheel and scroll-rail controls. "All sampled" does NOT override Blizzard's currently active source filter; Available only is a local view of the already-captured rows. Index identities, accepted parchment, source secret gates, native Trainer/Train All, selection and stock UI are preserved; no polling or native filter writes. Preview fixture is unchanged. P0285 sample-bound checker is migrated intentionally. Static tests and in-game result pending. See `docs/memory/evidence/P0293_TRAINER_LOCAL_BROWSE.md`.

## P0292 — trainer name, ability prerequisites and textual status (2026-10-21)

GitHub P0291 `0afc236` verified pushed; user runtime screenshot from `0.0.192-dev` confirms five Druid trainer skills with correct icons, ranks, level requirements, costs and selected description, with `live-read-only-visible`, three displays, no deferrals and zero reported native writes. **LIVE READ-ONLY DATA PARTIAL PASS**: Blizzard's `Wrath (Rank 2)` row includes prerequisite `Wrath (Rank 1)` absent from Logres. Logres heading remains generic; status is unclassified despite Forever's textual service type. P0292 independently reads bounded (`<=4`) ability prerequisites and safely available `UnitName("npc")`, and presents source-backed textual availability in the same mouse-inert view. Blizzard's selection, filtering, Train and Train All remain authoritative. Never use textual availability as purchase authorization. No general audit, polling, trainer purchase or visual refinement. STATIC/WSL/WOW P0292 UNVERIFIED pending checks and in-game evidence. See `docs/memory/evidence/P0292_TRAINER_INFORMATION_COMPLETENESS.md`.

## P0291 — Forever trainer six-field source correction (2026-10-21)

P0290 R2 `61838ba` verified on main; screenshot shows **LIVE 5-NAME DISPLAY PARTIAL PASS**, with icons/costs/requirements missing. Independent Blizzard Forever Mainline trainer UI source uses `name, serviceType, texture, reqLevel, serviceSubText, category = GetTrainerServiceInfo(index)`; previous Logres Classic interpretation of third/fourth returns as category/expansion was **WRONG**. P0291 prepared: independently secret-gated Forever branch copies valid texture file ID, requirement level/rank/skill, optional cost and description to the accepted read-only landscape. Classic fallback and Blizzard-owned action/stock UI retained. No numeric service enum guessing, purchase, filter or selection mutation; P/H interaction gates remain separate. WSL/WoW UNVERIFIED. Evidence: `docs/memory/evidence/P0291_FOREVER_TRAINER_DATA.md`.

## P0290 R2 — prewrite whitespace verification and EOF repair (2026-10-21)

R1 user WSL: pinned P0289 R1 baseline PASS; PREWRITE **161/161 PASS**, POSTWRITE **161/161 PASS**, final `git diff --check` FAILED (`docs/memory/CURRENT.md:38: new blank line at EOF`). R1 applier entered its rollback handler; no commit/push or WoW proof. The cause was `section()` appending an extra terminal newline at final CURRENT heading and shadow PREWRITE omitting Git whitespace validation. R2 fixes terminal newline generation, adds a candidate EOF assertion and prewrite `git diff --no-index --check` for every modified or added file. Keeps all R0/R1 failure evidence and identical native trainer Lua correction. Static/WoW results R2 pending.

## P0290 R1 — memory health limit repair (2026-10-21)

P0290 R0 failed WSL PREWRITE: user SHA verification and exact P0289 R1 baseline PASS; check suite 161, 1 failure in `check_memory_health.py` (CURRENT.md over 20,000 bytes). Refused before tracked write. R1 replaces overlong CURRENT state/history with a concise current-action summary, preserves all historical evidence in this ledger, and adds an explicit 10 KB memory-size candidate gate. Runtime source correction unchanged; WSL and WoW outcomes pending.

## P0290 — partial trainer source recovery after live-screen failure (2026-10-21)

P0289 R1 verified pushed `aee3f9d`. User `0.0.190-dev` H panel screenshot confirms both Live Trainer actions, but the live trial repeatedly returns `unsafe-or-incomplete-service-row` with displays=0 and purchases/filter/selection/geometryWrites=0. **LIVE PRESENTATION FAIL / OPEN**, row-specific source cause unproven. P0290 PREPARED / WSL AND WOW UNVERIFIED changes only guarded source copying and read-only model admission: independently ordinary service names survive unrelated field deferral, and four known probe row states render safe placeholders rather than suppressing the entire UI. No guessed numeric eligibility, native writes, reflow, purchase or polling. Existing D-046 shared renderer and D-047 stock fallback preserved. See `docs/memory/evidence/P0290_TRAINER_PARTIAL_SOURCE_RECOVERY.md`.

## P0289 R1 — repair P0289 R0 PREWRITE historical action counts (2026-10-21)

R0 verified archive and baseline but PREWRITE **FAIL: 6 of 160** linked static
checkers froze total 108 / H20, whereas the developer-panel H actions are now
110 / H22 / P35. No tracked writes; R1 candidate migrates nine checker
files in the full checker dependency graph to enforce minimum former inventory
while retaining exact 35 P previews. Native read-only trial unchanged.
WSL/WoW validation DEFERRED pending user apply. See P0289 evidence.

## P0289 — P0288 live trainer trial missing from H developer panel (2026-10-21)

Verified pushed P0288 `2e4b509`. **ASSISTANT IMPLEMENTATION/HANDOFF FAIL:** its read-only shared-landscape trial had slash `nativetrainerlive on|off` only; no `RegisterDevPanelAction` in existing H developer panel despite required in-panel validation. User explicitly flagged this. P0289 PREPARED / WSL AND WOW UNVERIFIED registers Live Trainer ON (TEST) and OFF in H and prioritizes these alongside existing H trainer skin actions on first page. No runtime source, renderer, native layout, stock transaction, selection or filter change. In WoW validate through H panel rather than another generic audit. See `docs/memory/evidence/P0289_TRAINER_LIVE_PANEL_ROUTING.md`.

## P0288 — read-only native trainer snapshot in shared landscape renderer (2026-10-21)

Verified pushed P0287 R1 `e80d2e8`, but latest user WoW diagnostic still P0286: known name/selection/wallet and numeric category type, **numeric semantic meaning still DEFERRED**. The repeated P0285–P0287 one-field audits did not deliver a usable trainer UI and P0287 R0 PREWRITE failed version-policy checker (no tracked writes). P0288 **PREPARED / WSL AND WOW UNVERIFIED** implements the bounded read-only source-to-model adapter using the same P0284 accepted 896×712 `NPCTrainerLandscape.Build/Render` and `PanelSurface.Paint`. `/logres nativetrainerlive on|off` is an explicit no-purchase visual trial. It displays live spell names, native indices, safely known costs, selected index and funds; category trainability stays unclassified, icons generic and Train/Train All disabled. Stock controls remain visible/functional; no native layouts, selection, filters, purchases, hooks or polling are changed; addon-owned panel hides on context exit/combat/world entry. See `docs/memory/evidence/P0288_TRAINER_LIVE_READONLY_TRIAL.md` and D-046/D-047.

## P0287 — raw numeric trainer category after P0286 runtime evidence (2026-10-21)

Verified pushed P0286 `cb8b756`. User's open-trainer H diagnostic from Forever 1.60.1 reads total=1, selected=1, wallet=12058, name `Enchant Chest - Minor Absorption`, and tuple types `string/string/number/number`. **NUMERIC CATEGORY SEMANTICS OPEN**, despite the documented Classic string category API. P0285/86 string-only interpretation is not applicable to this observed tuple. P0287 R0 **PREWRITE FAIL (user WSL, 1/158)**: `check_checker_version_policy.py` rejected a historical development-version literal frozen by the newly generated P0287 feature checker. ZIP and baseline passed; no tracked writes or runtime tests. P0287 R1 **PREPARED, WSL/WOW UNVERIFIED** repairs the checker only and adds a bundled-checker version gate. It captures ordinary bounded raw numeric category and expansion and optional safe cost/icon without assigning trainability; numeric rows keep status `numeric-category-unclassified` and entire source DEFERRED. No native mutation, polling, controller, stock suppression, camera, quest or accepted P preview change. See `docs/memory/evidence/P0287_TRAINER_NUMERIC_CATEGORY.md`.

## P0286 — native trainer service schema diagnosis after client negative result (2026-10-21)

Verified P0285 pushed `bbc9045`. User's current client H audit returned `total=1 selected=1 walletCopper=12058` with native APIs present and zero native writes, but row id=1 `unexpected-service-shape`: **SOURCE MODEL FAIL / OPEN**. P0285 did not record return field type signatures, so no shape hypothesis is proven. P0286 **PREPARED, WSL/WOW UNVERIFIED** retains one-shot trainer/out-of-combat/ordinary-secret gates and emits only safe type names and short ordinary category for rejected tuple returns. Any rejected sample marks the source status `service-row-shape-deferred`. No native layout, stock fallback, filtering, training, camera, quest or fixture changes. See `docs/memory/evidence/P0286_TRAINER_SERVICE_SHAPE_DEFERRAL.md`.

## P0285 — native trainer source feasibility, independent addon audit (2026-10-21)

Verified pushed P0284 `c773a94` and user screenshot: portrait-free Logres trainer P fixture visually accepted, deferred polish still OPEN. **Visual PASS is not native functionality PASS.** M highlights native control owners, but does not map stable service IDs to filtered/recycled slots, source costs or interaction permissions. ElvUI Forever's ScrollBox and `FilterDropdown` source, Aurora Classic fixed rows, Class Trainer Plus's separation of service index/filtered display position, and Skinner Forever directory were audited as external inspiration, not copied. P0285 **PREPARED, WSL/WOW UNVERIFIED** adds a one-shot bounded, secret-gated READ-ONLY service source sample through the existing H — Native Service Frame Audit. No Blizzard filter/selection/Train calls, no geometry/protected mutation, no hooks/polling. Real native service data availability, group/row identity and stock fallback remain **DEFERRED** pending client evidence. See `docs/memory/evidence/P0285_NATIVE_TRAINER_SOURCE_FEASIBILITY.md`.

## P0284 — trainer preview filters, funds and Train All (2026-10-21)

Verified pushed P0283 `b6d818b`; user screenshot and “Looks good” support **P-only VISUAL PASS** for selected vs ordinary spell hierarchy, warm parchment and no-portrait Logres design. Remaining native utility analogues — filter option, money display and Train All cost/count — are **OPEN / NOT PRESENT IN P**. P0284 **PREPARED, WSL+WOW UNVERIFIED** extends the existing pure fixture/model/renderer with synthetic Filters/Categorize, denominated Funds and a disabled Train All button. The five P component decorations use fixture-only recipes; native H continues its four mapped controls and Blizzard-owned transactions unchanged. Screen validation is required; no fabricated real funds or verified native Train All route. Single-fixture reagent-row overflow and true live adapter remain DEFERRED. See `docs/memory/evidence/P0284_TRAINER_UTILITY_PREVIEW.md`.

## P0283 — P trainer row color-state correction (2026-10-21)

Verified pushed P0282 `39acd57`; user screenshot: **VISUAL NEAR-PASS / ROW EMPHASIS FAIL**. Warm parchment layout, categories and integrated details now look very close to the approved reference, but all spells appear yellowish. Source establishes both indiscriminate `p.goldText` for every enabled name and default gold row motif for every P row. P0283 **PREPARED / WSL+WOW UNVERIFIED** adds explicit preview-only `normal`, `selected`, `disabled` wash/rule palettes and uses the SAME `paintRow` painter with optional fixture colors. Only selected row gets bright gold title/highlight; ordinary text ivory and wash neutral; disabled remains muted. Native H calls `paintRow(row, recipe)` without overrides; no Blizzard transaction, source, frame or geometry change. P visual screenshot proof still required. See `docs/memory/evidence/P0283_TRAINER_SELECTION_EMPHASIS.md`.

## P0282 — P parchment visual-fidelity correction (2026-10-21)

Verified pushed P0281 R2 `6b0501f`; user screenshot confirms the 896x712 landscape composition draws but reports **VISUAL FIDELITY FAIL**. Two full-size near-black child surfaces cover the sidebar and catalogue and can visually suppress parent-owned category labels, while P0280 selection fill creates an oversized bright brown slab. An earlier assistant recommendation to increase panel opacity was **incorrect and expressly withdrawn**; the user identifies the DARK BLOCKS as the defect. P0282 **PREPARED / WSL+WOW UNVERIFIED** replaces intrusive child washes with low-opacity warm owner artwork, keeps the shared parchment asset and geometry, adds a narrowly fixture-only recipe parameter to the existing component renderer (H native path unchanged), and fixes reagent quantity visual order. Visual acceptance requires a new P screenshot. Blizzard controls, training transactions, camera, Quest visuals and H geometry remain unchanged. Evidence: `docs/memory/evidence/P0282_TRAINER_PARCHMENT_VISUAL_FAILURE.md`.

## P0281 — complete landscape trainer fixture, after P0280 visual failure (2026-10-20)

Verified pushed P0280 `38cf5fc`. **P0281 R0 PREWRITE REFUSAL:** malformed 38-character Bootstrap hash embedded in applier; user's clean P0280 status and correct 40-character blob prove a patch artifact defect, not local source drift. No tracked files changed. R1 repaired the hash but PREWRITE ran 152 checkers and failed the newly introduced P0281 checker: it demanded `frame:EnableMouse(false)` while Lua used `f:EnableMouse(false)` in the same helper. This is a contract/source defect, not a UI runtime failure. R2 asserts created fixture frames are mouse-disabled independent of the local name. Both refusals wrote no tracked files; full R2 static and WoW validation pending. In-client screenshot and component diagnostics establish **P0280 VISUAL FAIL**: four painted controls and a free-floating small P shell do not deliver the approved landscape. P0281 first renders a complete 896×712 fixture with header, category sidebar, seven rows, selection, reagents and Train under one layout renderer, reusing shared P0278/P0280 paint paths and P0277 nine-slice. **PREPARED / WoW UNVERIFIED**; Blizzard-native H interactions, geometry, restoration and transactions remain untouched. D-046 preview acceptance is required before any guarded live adapter; native reflow viability and dynamic rows remain DEFERRED. See `docs/memory/evidence/P0281_LANDSCAPE_TRAINER_PREVIEW.md`.

## P0280 — shared trainer component styling, preview/live parity first tranche (2026-10-20)

Verified pushed P0279 R3 R1 `30e6af3`; user confirms portrait highlight Works now, newest `0.0.180-dev` diagnostics HIGHLIGHTED (highlight-visible-mapped-owner). This is scoped portrait mapping PASS, not automatic close restoration or a full trainer visual acceptance. P0280 adopts an identical addon-owned component art renderer for P fixtures and four indexed native controls (filter, selection, status, Train). Fails open for hidden/secret/protected/unavailable native controls; no native actions/text/geometry changed, no landscape reflow, no guessing about dynamic ScrollBox row identity or design-only controls. Source remains independent of ElvUI/Aurora. PREVIEW and live H appearance are WoW UNVERIFIED until user test; full PREWRITE/POSTWRITE static suite required. See `docs/memory/evidence/P0280_SHARED_TRAINER_COMPONENT_TRANCHE.md`. Existing P0274/P0275 VISUAL FAIL and P0279 R3 R0 checker failure remain authoritative historical negatives.

## P0279 R3 R1 — explicit portrait owner mapping after verified size-gate deferral (2026-10-20)

Original R3 PREWRITE refused before any tracked write: checker `27/150 check_checker_version_policy.py` flagged an exact historical dev-version literal in the new R3 contract checker; all other 149 static checks passed in user's WSL, not a runtime failure. R3 R1 removes the forbidden literal from checker source, retains the historical version in evidence, and preserves all R3 Lua/native behavior. See `docs/memory/evidence/P0279_R3_R1_PREWRITE_VERSION_POLICY_FAILURE.md`.

Verified pushed R2 `90198c5` (full `90198c5c26ca38e7a642e69e0ae5575c88ad38e4`). User's Forever `0.0.179-dev` M export returned `native-root-unavailable` before trainer availability, then twice `native-owner-outside-size-gate` with open trainer. This is not proof the parent is protected, nor that it is UIParent: its exact identity/dimensions were not exported. P0279 prior runtime also highlighted `trainer.frame` successfully, so a safe, candidate explicit overlay owner is the independently verified, ordinary unprotected visible `ClassTrainerFrame`. R3 makes that single service association declarative (`overlayOwnerPath`) and uses it ONLY if the immediate owner failed the size gate and the mapped root itself still passes the original Frame eligibility/protection/visibility/size checks. The original Texture remains the outline anchor. No global gate relaxation, native writes, hook/poll, action transaction or trainer UI reflow. R3 is not runtime accepted until WoW shows precise portrait highlighting and safe close restoration. Preserve R1 and R2 deferrals. See `docs/memory/evidence/P0279_R3_EXPLICIT_PORTRAIT_OWNER.md`.

## P0279 R2 — portrait owner gate diagnostic (2026-10-20)

Verified pushed P0279 R1 `e7c4430` (full `e7c443043fb018167bc32206e11bb5ca3bd56703`). User-provided `0.0.178-dev` M runtime shows title `trainer.title` and detail icon `trainer.detailIcon` HIGHLIGHTED, plus explicit Hide Highlight PASS. With native trainer open, `trainer.portrait` still DEFERRED (`native-owner-unverified-or-protected`); closed/unloaded portrait returns `native-root-unavailable` and is not a defect. No failure cause (protected/hidden/unavailable/dimensions) can be inferred from this combined result. This checkpoint keeps the exact native owner eligibility gate, adds only one-shot read-only reason labels on failure, and does not call native setters, add polling, relax protection, or reskin the trainer. Runtime reason unknown until next client diagnostic; previously successful mappings do not require retest. See `docs/memory/evidence/P0279_R2_PORTRAIT_OWNER_GATE.md`.

## P0279 R1 — observed mapping result and texture-owner repair (2026-10-20)

Verified pushed P0279 `7660395`; user reports most highlights worked. `0.0.177-dev` diagnostic export shows nine trainer HIGHLIGHTED, with texture portrait `overlay-anchor-deferred`, title/detail-icon outdated native globals unavailable, dynamic row identity DEFERRED and five explicit design-only UNMAPPED. Earlier root-unavailable attempts occurred before the native trainer loaded. The portrait failure is narrow: attempting to parent an addon Frame to a Blizzard Texture, which is not a Frame. R1 parents the mouse-inert addon outline to the eligible native Frame owner while keeping its anchor on the original Region; no native texture, geometry, action or owner is mutated. New paths `ClassTrainerFrameTitleText` and `ClassTrainerFrameSkillStepButton.icon` are upstream SOURCE_CANDIDATES, Forever runtime UNVERIFIED. M logs distinguish HIGHLIGHTED, UNMAPPED and DEFERRED reasons. All 9 prior successful mappings remain positive scoped evidence; outstanding row, Hide Highlight and UI layering remain OPEN. See `docs/memory/evidence/P0279_R1_MAPPING_RUNTIME_RECONCILIATION.md`.

## P0279 — durable service element index / M mapping verification (2026-10-20)

Verified pushed P0278 R1 `41826a9`; user-reported visual progress is PARTIAL, not final landscape trainer acceptance. Approved Enchanting landscape composition is a DESIGN TARGET. Before further native reskinning, P0279 adds declarative trainer/merchant/flight and future NPC service role-to-native candidate index (`Quest/ServiceElementIndex.lua`, `docs/ui/SERVICE_ELEMENT_MAPPING_INDEX.md`) and dedicated **M — UI Mapping** developer tab. Each entry records upstream/Logres source and SOURCE_CANDIDATE or UNMAPPED. M inspector resolves only ordinary, unprotected, shown native elements out of combat, draws removable mouse-inert addon-owned outlines, saves PASS/DEFERRED diagnostic evidence. Hide clears ONLY addon overlay; Blizzard controls/transactions unchanged. Dynamic Forever ScrollBox row identity and design-only sidebar/search/reagents/Train All remain DEFERRED/UNMAPPED. Global HUD/native overlap deferred to shared UI layering refinement. Full WSL and WoW verification pending. See `docs/memory/evidence/P0279_SERVICE_MAPPING_INDEX_AND_INSPECTOR.md`.

## P0278 R1 — historical trainer TOC assertion PREWRITE failure (2026-10-20)

User WSL P0278 R0: artifact SHA-256 verified; extraction succeeded; exact P0277 baseline, candidate memory/architecture and whitespace passed. Full PREWRITE 146 checker scan reported 1 failure: `check_p0276_r1_native_trainer_skin_contract.py` checker 109 required `NativeTrainerRegionAudit.lua` immediately followed by `NativeTrainerSkin.lua`, which rejected intentional insertion of `TrainerMotif.lua`. **R0 wrote no tracked files.** R1 updates the historical checker to preserve ordering without accidental adjacency, while new P0278 checker requires motif-before-skin; status remains WSL/WoW UNVERIFIED. No native behavior, protected actions or camera changed by this repair. See `docs/memory/evidence/P0278_R1_PREWRITE_ORDER_FAILURE.md`.

## P0278 — source-guided Forever trainer ScrollBox/row motif (2026-10-20)

Verified pushed P0277 `f042f311`; user screenshot of real Enchanting trainer shows a mostly BLACK Blizzard frame, not accepted Logres visual identity (**VISUAL FAIL**). ElvUI's Forever trainer skin addresses `.ScrollBox` and rows using `ForEachFrame`; Aurora Classic uses a structurally different fixed-index row template. Original P0278 `TrainerMotif.lua` paints mouse-inert, addon-owned ScrollBox parchment/rules and per-row gold accents with parameterized shared Logres palette. It never writes Blizzard control/geometry/transactions. H ON requires supported ordinary, unprotected ScrollBox and at least one row and otherwise rolls back stock, with explicit DEFERRED rather than a half-applied root skin. P preview draws the same row painter on inert fixtures. Row recycling proof OPEN; no polling/update hooks or landscape reflow. WSL static gate and WoW visuals/restore UNVERIFIED. Source code studied, not copied. See `docs/memory/evidence/P0278_FOREVER_TRAINER_MOTIF.md`.

## P0277 — shared panel art with separate Quest/Trainer parameters (2026-10-20)

Verified P0276 R4 pushed `b01cecf`; user's screenshots show two incompatible placements and independent painters despite the same texture asset. The prior assistant representation that sharing assets meant D-046 component parity was INCORRECT. New `UI/PanelSurface.lua` provides configurable stretch/nine-slice background and divider; quest and trainer each load their own geometry/input file; Logres Theme remains common visual vocabulary. Preserves accepted Quest position and stock native trainer controls/transactions, and does not claim native skin runtime success. Full WSL/WoW validation remains UNVERIFIED. See `docs/memory/evidence/P0277_PARAMETERIZED_PANEL_SURFACE.md`.

## P0276 R4 — R3 memory health PREWRITE failure (2026-10-20)

R3 shadow suite executed 144 checks and reported only 1 failure: `check_memory_health.py` rejected a generated handoff lacking `CURRENT.md` (checker 55/144). R3 wrote no tracked files. R4 fixes the exact handoff contract, adds a candidate preflight guard and preserves R0 byte-exact baseline reconciliation. R1/R2/R3 failures remain OPEN historical evidence; new WSL static and WoW runtime/visual checks remain UNVERIFIED. See `docs/memory/evidence/P0276_R4_MEMORY_HEALTH_FAILURE.md`.

## P0276 R3 — PREWRITE static checker self-mismatch (2026-10-20)

User R2 run: exact local R0 accepted, PREWRITE hygiene passed, checker 109/144 FAILED. Obsolete checker required unsafe `region ~= nil and ordinary(region)` while Lua and a later checker assertion correctly require ordinary-first. **R2 not installed; no WoW PASS**. R3 reconciles token, validates source/contract parity and collects ALL checker errors; R1/R2 workflow failures retained. WSL + in-client acceptance remain pending. See `docs/memory/evidence/P0276_R3_CHECKER_SELF_MISMATCH.md`.

## P0276 R2 — local guarded baseline reconciliation (2026-10-20)

P0276 R2 resolves a local-baseline guard mismatch: the R1 applier was designed only for clean P0275 even when an exact R0 local candidate may already be present. The observed R1 attempt refused on 13 tracked changes before making any writes. R2 also corrects the native texture creation call signature and guards a secret-capable region before nil comparison. R2 independently reconstructs R0 from pinned P0275 and permits upgrade only when every previous patch-owned file matches exactly, with no staged/unrelated tracked changes. WoW visual and runtime acceptance remain PENDING.

## P0276 R1 — native trainer skin / dedicated developer controls (2026-10-20)

Verified pushed P0275 `75e8024` visually FAILED: giant nine-slice wrapper leaves a native opaque trainer in an empty shell. Previous P0276 R0 diagnostic ZIP was uninstalled in reported WSL attempt and omitted dedicated tester controls — **assistant workflow FAILURE**, superseded by R1. R1 retires wrapper; P **Trainer Skin Art Preview** uses the exact same bounded nine-slice renderer as live; new H **Trainer Skin ON (TEST)** and **Trainer Skin OFF** opt into reversible native ClassTrainerFrame root decorative BACKGROUND/BORDER alpha snapshots only, with no geometry writes, no native child input/transaction edits and out-of-combat/unprotected gating. H now paginates without deleting its existing 18 actions. Existing H native frame audit becomes a read-only trainer region inventory. P0274/P0275 failure evidence retained. WSL and WoW visual safety/results PENDING. **Landscape reflow not authorized yet**. See `docs/memory/evidence/P0276_R1_TRAINER_SKIN_VISUAL_TRIAL.md`.

## P0276 — P0275 visual FAIL; native trainer read-only region feasibility (2026-10-19)

Verified pushed P0275 `75e8024`; user's trainer screenshot proves the large 640x540 additive quest-art shell produces a disjoint, empty wrapper around an opaque Blizzard trainer. **P0275 VISUAL FAIL**. P0274 small accent was visually insufficient despite activation counters. P0276 removes all live additive art (retired API shim) and extends existing H native frame audit with bounded secret-safe reads of actual Forever trainer controls and up to 16 direct regions, only while an ordinary unprotected trainer is open and out of combat. Blizzard lists, filters, money, Train, restoration and transaction machinery remain intact. No geometry, alpha, texture or hook writes. Historical P0274/P0275 negative records retained and checker contracts migrated; external Aurora/ElvUI patterns are evidence only. WSL shadow/postwrite and in-game runtime acceptance remain UNVERIFIED. In-client diagnostic controls + screenshot are required before any integrated native reskin or landscape layout. D-046/D-047; see `docs/memory/evidence/P0276_NATIVE_TRAINER_FEASIBILITY.md`.

## P0275 — actual quest-art merchant/trainer shell (2026-10-19)

Verified P0274 pushed `ac3f199`; user screenshot shows tiny accent visually insufficient. Subsequent 0.0.172-dev counters `accentShows=3`, `accentHides=2`, `accentFailures=0` prove activation, **not visual fidelity**. P0275 replaces ornament with 640x540 nine-slice true quest narrative panel + divider behind native merchant/trainer when opt-in placement is active. Native opaque core and all Blizzard controls stay visible, unmodified; panel uses BACKGROUND strata, mouse-disabled, restores on OFF/close. No native child resizing/reparenting/filter/search/spend logic, no gossip visual change, camera/other services frozen. Full 142 checker shadow/postwrite plus WoW panel-only screenshot required. P0272 original WSL proof still unavailable. See P0275 evidence.

## P0274 — additive native merchant/trainer accent; P0273 runtime accepted (2026-10-19)

Verified pushed P0273 `591ed52`; 0.0.171-dev client screenshots and saved diagnostics confirm native gossip/trainer centered, 3 starts/3 restores, gossip 2/2, autoDeferred=0, failures=0, pending=false, no native transaction, Run All complete with no reported FAIL. No separate panel-closed cosmetic validation. P0274 introduces one addon-owned, mouse-disabled gold accent on real merchant/trainer frames only while opted-in native placement is active, using the same restoration controller. Stock controls/textures/transactions stay Blizzard-owned; decoration failure is fail-open and separately counted; native gossip remains stock fallback. **Next** gated live gossip source/action adapter to existing D-046 Logres renderer; previews alone do NOT authorize native gossip action ownership. No camera, flight, bank or auction edits. WSL 141 checker and WoW runtime checks pending. P0272 original WSL static proof still unknown; do not fabricate. See P0274 evidence.

## P0273 — native gossip-to-service placement continuity and P0272 record repair (2026-10-19)

Verified remote main `c5ef384` contains 0.0.170-dev P0272 opt-in AUTO controller; 0.0.170-dev client diagnostics show 2 starts/2 restores/0 failures, while user screenshots show stock-left GossipFrame before centered ClassTrainerFrame. Type 3 gossip omitted from P0272 CANDIDATES: observed discontinuity OPEN. P0273 adds gossip using the same P0271/P0272 guarded anchor snapshot, OnHide, transition and OFF restoration; retains actual Blizzard gossip/service input, transaction and camera ownership. H panel action count unchanged 105/18/34. Native gossip movement runtime UNVERIFIED; use existing H AUTO TEST and 0 Run All. **Repo integrity finding:** P0272 runtime was pushed in commit labeled P0271, without original P0272 checker/evidence/patch record/manifest; P0273 restores missing checker/records with honest provenance; original generated manifest and original WSL gate remain UNVERIFIED. See `docs/memory/evidence/P0273_NATIVE_GOSSIP_CONTINUITY.md`.

## P0272 — opt-in automatic native service handoff (2026-10-19)

Verified P0271 main `993d9fb`, user merchant/trainer screenshots and 0.0.169-dev diagnostics: real native manual center/restore worked, starts=3 restores=3 native-hide=2 failures=0; Run All no reported FAIL. This is **not automatic positioning proof**. P0272 reuses the same guarded P0271 controller, adding an opt-in H AUTO ON/OFF TEST. Event-driven addon-owned interaction state and a scoped native OnShow hook trigger the same reversible merchant/trainer trial, with native OnHide/interaction-end/auto-OFF restoration. No polling, transaction/UI ownership expansion, permanent automatic default, bank/auction/flight move, camera edit or unrelated hooks. `TaxiFrame` present/unprotected in screenshot is frame metadata only. Historical P0270 R0 checker regression and P0268 D-047 deviation remain in their records. 139+ static checks + WoW auto lifecycle validation required. See `docs/memory/evidence/P0272_NATIVE_AUTO_HANDOFF.md`.

## P0271 — native service positioning trial and flight alias (2026-10-19)

Verified pushed P0270 `b33fdf6`, 0.0.168-dev metadata-only evidence: native MerchantFrame, ClassTrainerFrame, BankFrame and AuctionHouseFrame load, unprotected with GetPoint/SetPoint present; FlightMapFrame still not-loaded at a Flight Master (type=6); bank=67, auction=21. **Methods alone are not permission for mutation.** P0271 adds an explicit H TEST toggle for reversible whole-frame centering **merchant/trainer only**, gated on current addon-owned normalized context, `IsProtected`/`IsShown` safely readable, noncombat, complete opaque native anchor snapshot and restoration hook. OnHide restores, combat defers event-only. No automatic styling/move, no native child mutation, no transactions, no camera change. Add TaxiFrame to P0270 **read-only** alias audit; unknown until observed. Bank/auction/flight stay stock. All P0256/P0261/P0269/P0270 gallery contracts synchronized 105 total, P34, H18. P0271 runtime evidence pending; failure to restore/taint is a real failure. See `docs/memory/evidence/P0271_NATIVE_SERVICE_PLACEMENT_TRIAL.md`.

## P0270 — native service frame capability audit (2026-10-19)

Verified pushed P0269 `1588fb9` and user's 0.0.167-dev diagnostics: mock catalogue removal visually accepted, H policy reports Blizzard native ownership/mutations=0, Quest Dialogue and Offer Controls scoped PASS, 0 Run All no reported FAIL. However P0269 is **source-only** and does not establish real Blizzard frame availability, layout, protected status or styling safety. P0270 builds one on-demand, read-only H frame metadata audit for gossip, merchant/repairs/sales, trainer, flight, bank, auction, stable, tabard. It distinguishes unknown/restricted/lazy-loaded, checks only method presence and guarded IsProtected metadata; does NOT invoke SetPoint/GetPoint, IsShown, purchase/training/flight, protected mutation, timer, hook, polling, or change accepted camera. Frame identity and safe styling still OPEN until client verification. User need not travel; unavailable trainer/other NPC evidence is DEFERRED. No fake service preview. See `docs/memory/evidence/P0270_NATIVE_FRAME_CAPABILITY_AUDIT.md`.

## P0269 — D-047 native-service ownership restoration (2026-10-19)

Verified pushed main P0268 `53fe8ae`. User confirms 0.0.166-dev synthetic previews worked and provided F/H/Run All PASS within tested scope, but objected to replacing Blizzard merchant/trainer/service interfaces with Logres purchase quantity, filters, repairs or Sell Junk. Accepted D-047 already forbids rebuilding complete transaction UI when stock works. **ASSISTANT DESIGN FAILURE**: prioritized expanding a speculative P0268 mock catalogue rather than adhering to D-047. P0269 removes those four P demo actions/model/preview confirmations, retains actual NPC generic/quest/reward UI, adds read-only source-only native-service ownership policy and H action. Merchant/buy/sell/buyback/repair/Sell Junk, trainer filters/learning, flight travel, bank, auction are Blizzard-owned; optional Logres styling/positioning is UNVERIFIED pending safe in-client capability proof, not silently declared achieved. No Blizzard-frame mutation, camera, protected inputs, native transactions or quest 237 changes. Historical P0268 evidence retained. See `docs/memory/evidence/P0269_D047_NATIVE_SERVICE_RESET.md`.

## P0268 — multi-service catalogue states and symmetric header clearance (2026-10-19)

Verified pushed `main` P0267 `8e1e6f8`. User reports all P0267 interaction tests work, with 0.0.165-dev diagnostics showing option clicks=11/branches=8/backs=4/pageMoves=2/nativeActions=0, Goodbye=8, F/H/Run All PASS. Screenshot still shows Back/Goodbye intersect panel corner art at x inset 21px; this is OPEN visual evidence. P0268 integrates four authored service models (merchant 8 rows, trainer 6, flight 7, unavailable) via ONE shared `ServiceCatalogModel -> NPCOptionSession -> NPCOptionList` path: price/requirements, list paging, quote inspection, Back, inert confirmation result and safe Blizzard fallback. Preview-only confirmations can never invoke gameplay. Symmetric 45px inset with same vertical header location; historical checkers retain clearance/safety enforcement. Client runtime unverified until screenshot and P/F/H/0 tests. No protected transaction, stock action or camera change; quest 237 reserved. See `docs/memory/evidence/P0268_MULTI_SERVICE_CATALOGUE.md`.

## P0267 — combined NPC header navigation and one-step exit correction (2026-10-19)

Verified pushed main `2270e84` contains P0266. New user screenshot shows Back directly above/over narrative `1/2` paginator at lower center, while Goodbye is top-right. User accepts other tested buttons, but Farewell navigates to a redundant farewell screen instead of leaving, requiring another click. `0.0.164-dev` diagnostics show 20 branches, 14 Back actions, 10 Goodbye actions, no native option actions; F/H and Run All pass the checks actually run. P0267 aligns Back at upper-left (matching existing top-right Goodbye), keeps both paginator families in their existing bottom rails, and routes Farewell/Leave the watch to controller-owned Goodbye with one click. Preserve native stock restoration and untouched camera/claim behavior. P0266 is scoped functional PASS with remaining layout/semantic UX FAIL; P0267 runtime awaits explicit visual proof. See `docs/memory/evidence/P0267_NPC_NAVIGATION_AND_EXIT.md`.

## P0266 N6 — P0265 UI/session runtime failure and bundled correction (2026-10-19)

**Verified main `99c7294` contains P0265.** User screenshot at `0.0.163-dev` Services: 3rd option row near/overlaps `Options 1/2` pager and nav. User cannot return to original branch choices after selecting an option; no Goodbye across shared Logres NPC dialogue/reward previews. P0265 is PUSHED but user-visible RUNTIME FAIL, not accepted merely because preview commands show PASS. Root cause: `UI/OptionList.lua` originally hides entire frame during nonfinal narrative pages, removing Back along with choices; separate option/footer lanes insufficient (`y=-353` last row, `y=-351` pager, `y=-373` nav). P0266 moves pager to y=-391 and nav to y=-423, maintains Back on all narrative pages, remembers root navigation returns, and adds one universal shared-dialogue Goodbye that passes through existing HidePresentation/stock restoration. Synthetic actions inert; all native gossip, claims, transactions, camera/DynamicCam files frozen. Static candidate and WoW validation separate. See P0266 evidence.

## P0265 N5 — combined NPC interaction previews (2026-10-19)

Verified P0264 pushed `6b3ed96`, with user-observed reward-choice selection behavior and `0.0.162-dev` diagnostics (8 authored choice clicks, PASS quest/offer, native calls none). User explicitly requires larger coherent functional patches. P0265 introduces shared source-independent OptionModel/OptionList/OptionSession and FOUR P-tab experiences in one runtime checkpoint: branch/Back with long narrative, 7 service information choices, 11-entry option list with paging and back-to-page, and disabled/locked conditions. F read-only diagnostic audit; former P0256 gallery counts updated. Static shadow suite and in-client visual proof pending. Real gossip selection, bank/auction transactions, choice claiming, camera modifications remain unimplemented/deferred. Evidence: `docs/memory/evidence/P0265_NPC_OPTION_SESSION.md`.

## P0264 N4 — functional multiple-reward preview selection (2026-10-18)

Verified P0263 pushed `373c82b`. User `0.0.161-dev` export shows P tab previews and diagnostic checks PASS but reports **Multiple cards cannot be clicked** and no visible advancement. Root cause: `RewardVisual.lua` used mouse-disabled `Frame` cards. P0264 combines synthetic choice input on shared Button rows, renderer highlight, controller ownership/preview-only gates, choice-aware inert completion feedback, reset behavior, diagnostics and full-source checker in ONE patch. Live choice cards remain mouse-disabled and Blizzard owns native selection/claim; camera, native stock controllers and quest237 frozen. WSL / WoW regression pending. See `docs/memory/evidence/P0264_PREVIEW_REWARD_CHOICE.md`.

## P0263 N3 — shared decision-button visual extraction (2026-10-18)

GitHub `main` `36d43f6` verified P0262 pushed. User confirms long/short/generic narrative and Single/Multiple reward preview appearances, bidirectional page navigation and final-page action placement all expected. `0.0.160-dev` Quest Dialogue/Offer Controls/Run All exports PASS, with action click `preview-only` and no production probe call. **P0262 SCOPED VISUAL PASS**, not live quest claiming or all gameplay/camera contexts. P0263 relocates the ORIGINAL two shared Accept/Decline/Complete visual factory and cosmetic color/hover/press callbacks into `UI/DecisionVisual.lua`, with no new UI elements. `Dialogue.lua` continues to own all `OnClick` and action routing plus existing page geometry. No camera/native controllers/QuestieDB changed. N3 candidate needs full static and P-tab visual checks; generic option action fixtures and N4 integration remain pending. P0262 R0 static-checker failure remains historical. Evidence: `docs/memory/evidence/P0263_N3_DECISION_VISUAL_EXTRACTION.md`.

## P0262 N2 — shared narrative pagination view extraction (2026-10-18)

**R0 STATIC FAIL / NO TRACKED WRITE:** the P0255 quest action checker still required `-115,78` and `-115,17` page-indicator positions inside Dialogue.lua after they were moved verbatim into the shared painter. R1 follows both positions and ownership gates into the actual renderer; other P0255 action and stock safety checks retained.

Verified P0261 pushed `b439d4f`; user reports the five P-tab narrative/reward previews work as expected (scoped visual PASS). P0262 mechanically extracts page building and text/indicator painting from `Quest/Dialogue.lua` into `UI/NarrativePages.lua`; the exact production/preview `PresentText` path stays shared. Page-frame creation, geometry, offer/completion state, native restoration and **all camera source** remain unchanged. Historical P0130/P0254 checkers follow the relocated visual rail, and the new P0262 checker guards equivalence and safety. RUNTIME UNVERIFIED until P-tab long/short/generic and Single/Multiple reward tests, optional F/H diagnostic checks and no camera regression. No in-game action is required beyond existing inert previews. No bank/auction/native claim work. Details: `docs/memory/evidence/P0262_N2_NARRATIVE_PAGE_EXTRACTION.md`.

## P0261 N1 — narrative and decision model parity (2026-10-18)

Verified P0260 `1251434` pushed. First narrow modularity extraction: `Quest/NarrativeModel.lua` holds source-independent authored long/short/generic fixtures and plain narrative/visual decision fields; the live quest offer uses the same model before reaching the **unchanged** `QuestDialogue:PresentText` frame renderer. Short offer and generic text-only preview actions join P tab; existing long and reward fixtures stay available. Generic selection is NOT implemented and no false buttons are drawn. No changes to stock offer suppression, quest action probes, completion/claim, native frames, camera source, DynamicCam configuration or camera event handling. Full static shadow suite and WoW preview regression are REQUIRED; no client PASS yet. Source audit and all-NPC feasibility remain OPEN for later slices. Evidence `docs/memory/evidence/P0261_N1_NARRATIVE_MODEL.md`.

## P0260 — comprehensive UI/NPC modularity source audit (2026-10-18)

Verified `main` `669ec77` contains P0259 D-047. Docs-only P0260 inventories all 56 addon Lua modules by domain (with targeted source review), 54 provisional NPC interaction variants, current shared renderers and preview gaps, data/action/stock boundaries, and the separation between `Core/State` interaction type and existing camera frame/event predicates. **Result: PARTIALLY MODULAR.** Real reusable `Quest/RewardModel.lua` plus `RewardVisual.lua` exist, while `Quest/Dialogue.lua` still combines narrative, paging, source reads and action presentation. There is no shared NPC-session/service/catalog implementation yet. **Camera is explicitly FROZEN; no `Logres/Camera/*.lua` changes or revised DynamicCam behavior.** Proposed narrow next work is N1 plain narrative/decision model + deterministic read-only preview fixture contract, with no gameplay mutations. Bank/auction remain deferred to the POST-modularity feasibility assessment, not ruled out. No WoW runtime change/test is claimed. Read `docs/memory/evidence/P0260_MODULARITY_SOURCE_AUDIT.md` and `P0260_ALL_NPC_INTERACTION_ATLAS.md`; preserve quest 237, native claim flash and other OPEN bugs.

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

## P0214 — Approved action asset family / bounded scaling policy (2026-10-15)

P0213 pushed as `18dee5f`; user found contrast fine but corrected the process: the twelve `docs/design/approved/` reference sheets are the **approved visual implementation contract**. P0214 candidate replaces only the five shared `Logres/Media/Action/` RGBA textures with sheet-03-derived default/hover/press/checked/flash art at existing size. Native icons/cooldowns, action routes/pet controls, 42px hitboxes, 5px gap, and D-045 v4 layout are untouched. No shadowing of native controls or speculative resizing. User permits limited size/placement adjustments **if actual in-client fidelity requires it**; such changes need separate geometry and click-surface proof. Latest P0213 `0.0.122-dev` loadCount 280 final Run All/Compass/Layout checks PASS in ordinary world; user visual `fine` is not full asset validation. P0214 remains WoW UNVERIFIED. See `docs/memory/evidence/P0214_APPROVED_ACTION_ASSET_FIDELITY.md`.

## P0213 — H.3 narrow compass contrast candidate (2026-10-15)

GitHub main `018ea0a` (P0212 including P0211) verified. Scope: Theme-driven brighter compass direction labels and dark, fixed pixel-offset FontString shadows; no change to compass texture, geometry, bearing, edge fade, manual waypoint, data source, action or pet state. P0202 screenshot reports faint labels/ticks over bright sky; this only addresses **labels**. 0.0.122-dev is a candidate requiring in-game visual and panel tests; do not label visual PASS from static source. Use Phase E Compass Check, Phase H H.2 Map Layout Check/Overlay, Phase 0 Run All; compare light and dark scenery. P0211 pet behavior remains accepted for tested paths, secure interactions/taint still deferred. Evidence `docs/memory/evidence/P0213_H3_COMPASS_CONTRAST_EVIDENCE.md`.

## P0212 — Pet visibility accepted for tested paths; panel-first and established addon research (2026-10-15)

User-confirmed P0211 `0.0.121-dev` loadCount 279: no native PetFrame/PetActionBar on Immersion-ON reload, return on OFF, disappear on ON, no duplicate in observed combat. P0211 diagnostics show first-world `worldArmed=no` while probe unavailable and subsequent `firstArmEvent=pet-probe-armed`, `armed=true`, driver failures=0. Close tested pet duplication/reload **presentation** defect; secure clicks, autocast, PET STOCK interaction, fresh Edit Mode exit and taint checks remain unverified. Do not modify working pet driver absent new failure. **Development process:** panel actions are the default for runtime checks; Bartender4/Dominos plus exact Blizzard Forever APIs should be reviewed before custom secure action/UI engineering (references only, no dependency or wholesale copying). P0211 GitHub push had not been confirmed when this docs checkpoint was authored (latest observed `main` `4076d25` P0210). See `docs/memory/evidence/P0212_PET_ACCEPTANCE_AND_WORKFLOW.md`; H.3 approved art/interaction integration is next.

## P0211 — Native pet reload startup defect
**P0211 INITIAL PET RELOAD FAIL (2026-10-14; NEW CANDIDATE, RUNTIME UNTESTED):** Correction to P0210: user reports Blizzard PetFrame/PetActionBar **visible immediately after `/reload`** despite saved Immersion ON. Explicit Immersion OFF -> ON hides both (PASS, user-observed), native stock stays suppressed in observed combat (PASS, user-observed), and Edit Mode displays native controls (PASS, user-observed). Full stock clicks/autocast/taint and Edit Mode exit remain unverified. P0209 R8 diagnostic loadCount 278 has `armed=true nativeDriver=true activations=7 failures=0` only AFTER OFF->ON, not at initial reload: startup failure mechanism UNATTRIBUTED. P0211 0.0.121-dev adds two one-shot addon-owned readiness handoffs from secure probe Arm and pet interaction setup to the existing Reconcile, plus first-world/first-arm source diagnostics. No polling, native Show/Hide, native visibility inspection, combat protected mutation, or change to secure hide/show driver. Validate on fresh reload BEFORE any Immersion toggle; do not claim startup PASS from static check. Evidence `docs/memory/evidence/P0211_PET_STARTUP_RECONCILIATION.md`.

## P0210 — Local worktree and bounded runtime-evidence reconciliation (2026-10-14)

**P0210 WORKTREE RECONCILIATION (2026-10-14; LOCAL, DOCS/IGNORE ONLY):** GitHub main is P0208 `f6b9a3a`; P0209 R8 `0.0.120-dev` remains uncommitted. User confirms Blizzard PetFrame/PetActionBar absent after initial Immersion-ON `/reload` and again after Immersion OFF -> ON: ordinary visible behavior observed. Combat, PET STOCK, Edit Mode, native secure interaction and taint remain UNVERIFIED by this report. Preserve prior pet failures and candidate source/checkers/evidence. P0210 ignores temporary patch extraction/Windows sidecars without deletion or staging. See `docs/memory/evidence/P0210_WORKTREE_RECONCILIATION.md`.

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

Verified P0199 R1 GitHub `main` `7064ea88` (docs-only audit). P0200 R1 **runtime UNTESTED** (`0.0.109-dev` proposed) aligns native harmful 25px artwork/target two-column fit with the approved aura frame, strengthens percentage and target/ally name readability, and quiets the native-access dock while retaining all action/secure hooks. No approved v4 anchor change, no player helpful artwork replacement, no new stock UI suppression or secret-value access. R0 failed safely in the shadow stage: check_h2_unified_placement_contract.py still demanded the obsolete 18px literal; no tracked files were changed. R1 updates that checker to test H.2 anchor and H.3 grid geometry. In-client multi-effect density, screen contrast, dock click/restoration, Phase 0 Run All and Phase H checks are PENDING; missing natural populated states are DEFERRED. PetActionBar duplication and ObjectiveTracker flash remain OPEN / INTERMITTENT / UNREPRODUCED. See `../patches/P0200_H3_VISUAL_IMPLEMENTATION.md`.

## P0198 — P0197 ordinary refolding observed; intermittent trigger still open (2026-10-11)

P0197 verified pushed on `main` `0a20eef`, version `0.0.108-dev`, loadCount 253. User did not see the duplicate pet bar. Four actual stock PetActionBar OnShow events were met by four immediate Logres refolds, no combat deferrals or deferred recoveries, no pending recovery, no native-surface error. Native Access PASS and Phase 0 Run All completed twice within observed scope; latest Layout 19/34/0. **Do not claim combat-recovery runtime PASS or permanent fix**: the prior duplicate stock bar remains OPEN / INTERMITTENT / UNREPRODUCED, cause unknown. Preserve event-driven counters, native PET access and protected fallbacks. Small target debuff icons join coordinated H.3 visual polish after H.2 observed-layout integration. See `docs/memory/patches/P0198_P0197_RUNTIME_OBSERVATION.md` and `docs/memory/evidence/P0197_PET_BAR_RESHOW_EVIDENCE.md`.

## P0197 — intermittent Blizzard PetActionBar duplication, post-combat recovery candidate (2026-10-11)

Verified P0196 R4 commit `c89692b`; user confirms target buffs and debuffs correct. Screenshot shows stock PetActionBar occasionally visible under Logres pet cluster, exact trigger unknown. Latest `0.0.107-dev` loadCount 251 `native-surfaces` reported `petActions:folded`, `pending=false`, `error=nil` despite user visual failure; this measures only addon-owned snapshot state, not stock frame visibility. Source of `NativeSurfaceReplacement.lua`: PetActionBar `OnShow` during combat sets pending without Hide; post-combat `Reconcile` calls `Fold` but its existing snapshot causes early success without re-hide. Blizzard PetActionBar also explicitly calls Show on PET_BAR_UPDATE, UNIT_PET, PET_UI_UPDATE, UPDATE_VEHICLE_ACTIONBAR. P0197 adds only event-verified deferred recovery and counters. Combat as trigger is INFERRED / UNREPRODUCED, not proven. No polling or blanket suppression. Runtime test OPEN; see `docs/memory/patches/P0197_PET_BAR_DEFERRED_RESHOW_RECOVERY.md` and `docs/memory/evidence/P0197_PET_BAR_RESHOW_EVIDENCE.md`.

## Historical H.1 reopening checkpoint — P0168 (superseded for current planning)

## P0196 R3 residual stock target aura — OPEN; R4 candidate (2026-10-11)

P0196 R4 is an **UNPUSHED RUNTIME CANDIDATE** addressing the R3 verified visual residual: the small Blizzard contextual target aura icon remains despite correct Logres player/target buffs. R3 `0.0.106-dev` loadCount 250 native-surfaces reported targetAuras:stock; Logres helpful and secure harmful lanes remain. Forever 1.60.1.70338 TargetFrameMixin:ConfigureAuraContainer source supports native 0/0 aura limits and restores, without the R1 forbidden OnShow hook. Existing pet/player buff replacement is untouched. TARGET opens the native aura container; Damage Meter and beta reporter unchanged. R1 visual/hook failure and R2 delivery failure remain recorded. Details: `docs/memory/patches/P0196_R4_TARGET_AURA_NATIVE_CONFIG.md` and `docs/memory/evidence/P0196_R4_TARGET_AURA_RUNTIME_EVIDENCE.md`. No R4 runtime PASS yet.


P0168 R0 failed in the shadow checker before tracked writes: the new contract demanded a non-existent `visualSnapshot =` assignment while generated source correctly used `local visualSnapshot, visualError =`. R1 corrects the self-mismatch and removes the unneeded `QUEST_ITEM_UPDATE` restore trigger, because Blizzard processes that event without leaving an ordinary quest offer. The prior failed delivery is preserved as negative evidence.

The user correctly identified that the previous closure counted D/C suppression as if Phase H itself had finished hiding the UI. P0165 suppressed only Accept/Decline. P0168 now targets the remainder of *supported ordinary quest-offer* presentation, not an unsupported quest state. This is candidate work; no runtime PASS until manually observed. Main/override/special actions, pet, party, minimap, persistent XP, full tracker, nameplates, class-resource, unsupported auras, and reward/continue/complete/gossip remain source/capability gated per D-023/D-031/D-044. No blanket frame hider is authorized. The existing P0164 matrix remains a blocker inventory, not a completed-removal claim.

# Active Investigations

## P0196 R1 native aura takeover — FAIL; R2 prewrite FAIL; R3 correction OPEN (2026-10-11)

P0196 R3 is the next **OPEN / RUNTIME UNTESTED** checkpoint after R1 visual/target-hook runtime FAIL and R2 pre-write memory-health FAIL. The original crafted `PlayerHelpfulAuras` art and old StatusAuras/native harmful sizing are restored; new native 18px helpful icons and override takeover removed. Pet secure replacement candidate retained. Stock BUFFS is manually accessible beyond four authored Logres slots. Target contextual aura suppression is DEFERRED because the R1 OnShow hook failed. Damage Meter and Issue Reporter untouched. See `docs/memory/patches/P0196_R2_BUFF_PRESENTATION_CORRECTION.md` and `docs/memory/evidence/P0196_R2_REGRESSION_EVIDENCE.md`. P0196 R1 and R2 were NOT pushed. R2 passed whitening/own contract and earlier repository checks, then `check_memory_health.py` rejected CURRENT_HANDOFF.md because it omitted CURRENT.md; no tracked R2 writes occurred. See `docs/memory/patches/P0196_R3_PREWRITE_MEMORY_REPAIR.md`.


## P0196 R1 — stock pet/buff/target-aura removal candidate (2026-10-11)

OPEN / RUNTIME UNTESTED. P0195 user visual composition PASS with native duplicate exceptions. User explicitly rejects assistant's P0196 R0 docs-only assertion that PetFrame should remain the intended UI; R0 not pushed. Logres pet name/percentage-health and ten secure pet buttons exist but pet actions were manual probe-only, right-click/menu replacement missing, and editing/bindings still need on-demand stock. HelpfulAuras previously limited to four HELPFUL|PLAYER; StatusAuras target helpful priority is partial, native HARMFUL is bounded. P0196 R1 creates source-gated full native helpful groups (24 icon limit) and standalone safe stock folds, pet secure interaction, pet auto-arm, PET/BUFFS/TARGET dock restore. Blizzard Damage Meter and beta Issue Reporter remain untouched. Target icon source in screenshot could include nameplate content; only contextual TargetFrame Auras explicitly targeted. Native secret/protected and combat rollback checks mandatory. See `../patches/P0196_R1_NATIVE_PET_AURA_GATE.md` and `../evidence/P0196_R1_NATIVE_PET_AURA_EVIDENCE.md`.

## H.2 P0194 R3 runtime panel map verified / P0195 unified placement (2026-10-11)

Status: **P0194 R3 USER-VISUAL PANEL PASS, P0195 PLACEMENT UNTESTED**. GitHub `main` `f7a67bc`; uploaded `0.0.103-dev` loadCount 245: Phase H map blue vs gold shown in full-screen capture; Layout Check 16/23/0 PASS, H2 13/13 measured, Run All complete in ordinary tested scope. Blue quest planning box intersects retained top-right native access; old bottom actions overlap intended bottom-center resource territory. R3 changed no gameplay positions. P0195 reflows all supported action clusters and translates anchors once, retains 2 separate native HARMFUL paths, keeps Bar4/5 in distinct satellites and relocates usable native-access dock below the quest box. It does not prove all native/stock overlaps safe. Requires in-client single-map screenshot, panel Layout Check and Run All before acceptance. Earlier R0 visual failure/R1 delivery failure/R2 user-rejected slash-only interaction remain negative history.


## H.2 P0194 R3 developer-panel integration (2026-10-11)

**R3 candidate / runtime OPEN.** P0194 R0 visual placement rejected (root cause not proven); R1 failed pre-write checker/source self-mismatch, R2 addressed checker but exposed the map only through slash, rejected by user. Phase H already holds 15 actions; R3 adds a dedicated H.2 Map subview without removing controls. Both viewport overlay and in-panel miniature use approved D-045 planning boxes and P0192 secret-safe actual named Logres proxy geometry. Next full screenshot and integrated in-game test, then ONE coherent screen-wide placement/reflow. Historical special/secure/native/Quest/Bar4-5 hazards remain OPEN.

## H.2 P0194 R0 visual rejection / R1 unified in-game map (2026-10-11)

Status: **R0 VISUAL FAIL / R1 SHADOW CHECKER DELIVERY FAIL / R2 READ-ONLY MAP CANDIDATE, RUNTIME PENDING**. User screenshot from P0194 iteration still shows resource percentage beside earlier action clusters rather than accepted v4 bottom-center; harmful lane not visibly established. Screenshot does not prove which Lua artifact was installed, so root cause is unproven. User explicitly rejects sequential one-widget layout experiments. P0194 R2 provides one in-game UIParent-percent blue-v4/gold-observed overlay for all 13 named Logres proxies, no protected/native control mutation, combat-deferred activation, mouse transparent. R1 failed before writing because its new checker demanded nonexistent `viewport.width`/`viewport.height` snippets instead of actual `viewportWidth`/`viewportHeight`; R2 repairs that self-mismatch. Accept exact prior R0 tree or clean P0193; preserve delivery/runtime failures. **Next:** one full-screen overlay screenshot, then one coherent supported whole-screen placement/reflow; no individual element trial series. Bar4/5, secure native harmful, dynamic Quest/native access, party/pet/special fallback remain capability gated.

## H.2 P0192 measured / P0194 implementation constraints (2026-10-11)

Status: **13/13 READ-ONLY GEOMETRY MEASURED, PLACEMENT/COLLISION OPEN**. Verified `main` `3777620`, user `0.0.102-dev` loadCount 242 Layout Check 16/23/0 PASS; Phase 0 Run All existing checks PASS. Canonical actual/planned pairs in `../evidence/P0193_H2_GEOMETRY_RUNTIME_2026-10-11.json`, caveats in paired Markdown. Primary 4x3 and Utility 3x4 must be coherently reflowed; target actual 16.9% width and aura 11.1% each cannot be centered in 13% + 6%+6% planning boxes without overlap. Quest/native dock not jointly probed; secure native HARMFUL anonymous containers and Blizzard special/group fallback remain unmeasured. P0192 R0 pre-write delivery FAIL retained. **P0193 R0 prewrite delivery FAIL** (historical version pin in evidence checker, corrected in R1 before tracked writes). **P0193 R1 delivery FAIL after shadow checks** (`git diff --check`: `docs/memory/CURRENT.md:79: new blank line at EOF`); transactional applier restored original tracked files and removed new files. R2 strips extra terminal newlines and checks candidate diffs before writing. **Next after P0193 docs checkpoint push: P0194 bounded, out-of-combat/fail-open placement beginning with eligible action and player reaction frames; do not call H.2 complete.**

## Historical H.2 P0192 diagnostic preparation (superseded by P0193 results)

Status: **SOURCE AUDIT COMPLETE / IN-CLIENT MEASUREMENT OPEN.** Verified user push P0191 `57c3112` makes D-045 and 13 literal v4 percentages durable. P0192 prepares a read-only `0.0.102-dev` extension to **existing Phase H Layout Check**, reporting actual normalized addon-frame geometry with MISSING/DEFERRED for absent/secret-capable/hidden/unlaid-out data; no combat measurement, protected/native visibility inspection, or geometry mutation. Source shows Primary 4x3 183x136, Secondary/Utility 3x4 136x183, pet 5x2 230x89, anonymous native harmful containers beyond named-frame probe, variable Active Quest height and stock native-access dock collision concerns. Source and mapping table: `../evidence/P0192_H2_GEOMETRY_AUDIT_2026-10-11.md`. Next: WoW Layout Check, Run All, screenshot and export; do not claim layout PASS. Historic ObjectiveTracker flash and special combat/vehicle/mode deferrals remain OPEN.

## H.2 approved v4 design geometry — P0191 (2026-10-11)

Status: **USER-APPROVED DESIGN / RUNTIME GEOMETRY OPEN**. The 13 percent rectangles, exact source export and last agreed Main Y 60.4% correction are canonical at `docs/design/layout/SCREEN_MAP_V4.json`; details and meanings in `.md` and D-045. Target fallback is right-offset with symmetrical left debuffs/right buffs; bottom-center Player Debuffs sit above Player Resource; left class/totem strip sits above Secondary/Main. Assistant's earlier wrong left-side resource/debuff and centered-target map interpretations are superseded design failures, not runtime evidence. This is a **docs-only** P0191 candidate with no Lua changes, actual collision PASS or WoW deploy. Next after verified push: P0192 map boxes to Logres P0166 anchors, assess full density and native fallback collisions, then narrow fail-open implementation/runtime proof. Preserve H.1 special environmental deferrals.

## H.2 authored whole-screen layout calibration (P0190 handoff)

Status: **OPEN / NEXT P0191.** Verified `main` P0189 `bd0c36a`; loadCount 239 and user confirm automatic Main normal screen, OFF restoration, ON reactivation and integrated checks. H.1 is accepted in observed ordinary scope; special combat/vehicle/possess/override/form/petbattle remain separate environmental deferrals. P0166 integration anchors are already implemented, but realistic crowded-screen default positions and collision/spacing remain uncalibrated. Start from existing `Integration/Layout.lua`, approved D-032/D-034 and actual screen evidence; preserve required Blizzard fallbacks. No broad hide, secure combat mutation or generic layout editor. Canonical P0190 evidence records bounded acceptance.


## P0189 — automatic normal Main startup (runtime candidate)

Status: **CLOSED FOR OBSERVED ORDINARY AUTOMATIC STARTUP / SPECIAL MODES ENVIRONMENTALLY DEFERRED**. GitHub `main` P0189 `bd0c36a` verified and user reports all tests worked. LoadCount 239 confirms fresh automatically armed `CANDIDATE` (1/0), manual OFF `STOCK` with optOut=true (1/1), manual ON `CANDIDATE` (2/1), and final integrated `CANDIDATE` 7/6 `error=nil` with 12/12 Primary routing and ownership 17 PASS / 18 STOCK / 0 FAIL. No intervening `mainreplacecheck` proves opt-out persistence after the toggle, but user accepted the instructed sequence. No direct Edit Mode/geometry/native special-mode trace was exported. Vehicle, override, possess, form, petbattle and combat transitions remain ENVIRONMENTAL DEFERRALS; fallback stays stock as required. Prior P0187 R0/R1 and P0188 R0 negative evidence remains recorded. P0190 evidence is authoritative for bounded acceptance.

## Phase H.1 — P0187 R2 manual Main re-arm accepted; startup integration OPEN (2026-10-10)

Latest P0188 evidence: verified `main` `41c7d97`; user confirms the `0.0.100-dev` fix worked. Fresh STOCK → ON CANDIDATE → OFF STOCK → repeat ON CANDIDATE → OFF STOCK; Run All final 7 activations / 6 restores, `error=nil`, Primary keys 12/12, 35-row ownership 17 PASS / 18 STOCK / 0 FAIL. R0 repeat-ON runtime failure and R1 original delivery mismatch remain recorded below, not erased. This CLOSES the observed manual re-arm regression only. Main remains STOCK in the existing policy-only audit. Persistent startup normal-mode ownership and secure special/combat/EDIT fallback remain OPEN / ENVIRONMENTALLY DEFERRED as appropriate; P0189 next. See `../evidence/P0188_P0187_R2_NORMAL_RUNTIME_2026-10-10.md`.

## G.5 — Taxi camera ownership

Status:
**CLOSED FOR OBSERVED TAXI ZOOM SCOPE — P0160 R2 RUNTIME PASS.**

Canonical Taxi investigation:
`G5_TAXI_CAMERA_OWNERSHIP.md`

P0160 R2 is durable at `ae75989b` / `0.0.79-dev`.

Observed normal Taxi:
- start about `4.0096`;
- requested/effective target `50`;
- final `50`;
- 347 samples;
- 346 toward / 0 away;
- 0 direction switches;
- 2 source rebases;
- failures=0.

After landing:
- World start `50`;
- target `5`;
- final about `4.9806`;
- 158 samples;
- 156 toward / 1 away;
- 0 direction switches;
- 2 source rebases;
- failures=0.

The user visually confirmed outbound zoom and return after landing.

The P0159 `0 <-> 50` / 80-switch failure does not recur. G.5 Taxi zoom convergence is therefore closed for observed scope.

## G.6 — Captured DynamicCam profile parity

Status:
**CLOSED FOR CLAIMED OBSERVED SCOPE — P0162 RUNTIME PASS.**

Canonical:
`G6_DYNAMICCAM_PROFILE_PARITY.md`

P0161 is durable at `2a959094` / `0.0.80-dev` and runtime-accepted for the observed Taxi/settings/shoulder-offset scope: Taxi target `50`, continuous yaw `-20`, City landing return about `4.97-5.01`, rotate-back completion, City max-distance factor `1` with original factor `4` retained, and zero profile settings/rotation/secret/runtime failures.

Teleport/NPC/Fishing/Gathering and unobserved AFK behavior remain environmental deferrals.

P0162 R3 is durable at `4628f49e` / `0.0.81-dev` and runtime-accepted. The bounded wheel gate exercised quick accumulation and direction reset, preserved same-context manual zoom, restored/reacquired CameraZoom ownership across OFF/ON, and ended with zero hook conflicts, secret skips, or reactive failures.

Phase G is closed for claimed observed scope. Teleport/NPC/Fishing/Gathering and unobserved AFK behavior remain explicit environmental deferrals. DynamicCam UI fades remain a Phase H presentation boundary.

### Current world-entry timeout regression

Status:
**CLOSED FOR OBSERVED NORMAL WORLD ENTRY — P0156 RUNTIME PASS.**

P0156 is durable at `e1be731b` / `0.0.77-dev`. LoadCount `187` passed Phase G Camera World/Combat Check at world zoom about `5.0795` toward target `5`, with `targetReached=true`, `failures=0`, `secret=false`, and `error=nil`. Separate Run All repeated the PASS and completed cleanly.

The accepted P0156 sample reported `firstDelay=0` and `switches=0`.

P0159 subsequently exercised the direction-switch branch heavily during the real Taxi landing failure (`80` switches). That newer evidence supersedes the earlier “unexercised” branch status while preserving the older P0154/P0155 failures.

No additional world-entry-specific patch is justified. P0160 R2 addresses the reproduced shared zoom-engine defect instead.

Canonical investigation:
`CAMERA_WORLD_ENTRY_TRANSITION_TIMEOUT_2026-10-06.md`.

## Active Quest

Status:
**CLOSED — P0126 RUNTIME + VISUAL PASS.**

P0126 is durable at `89b0c563d1ff5e12c61baa3e407725a90d9cefd4`
on `0.0.58-dev`.

The initial hover tooltip failure is preserved in evidence; R1 corrected it and
the final R3 composition passed. Whole-screen polish remains later calibration,
not an open Active Quest capability issue.

## NPC quest interaction ownership

Status:
**OPEN — OFFER SLICE ACCEPTED THROUGH P0133; LATER D-035 STATES REMAIN GATED.**

Canonical investigation:
`NPC_QUEST_INTERACTION_CAPABILITY.md`

P0129 runtime proves the naturally observed offer/detail path, one available
gossip quest row, and one two-choice reward metadata sample without secret/call
failures. Mutation function presence remained `invoked=0`.

`QUEST_PROGRESS` / `QUEST_COMPLETE` and other unobserved categories remain
environmentally deferred.

P0130 R1 closes the narrative lifecycle defect: OFF -> ON restores the same active
quest offer with `presentationReason=immersion-on-restore`, and integrated checks
remain clean.

P0131 final runtime evidence proves both tested offer mutations:
- Decline: `QUEST_FINISHED`, event-confirmed;
- Accept: matched `QUEST_ACCEPTED` after intermediate `QUEST_FINISHED`, with
  `finishedObserved=true` and no polling/timer.

P0131 is durable at `68233e64` / `0.0.63-dev`.

P0132 is durable at `671f9836` / `0.0.64-dev`.

Runtime/control behavior passes, including production Decline, production Accept,
non-mutating preview, Blizzard-visible fallback, and integrated checks.

P0133 is durable at `f2feead6` / `0.0.65-dev` and runtime + visual PASS:
Accept-left / Decline-right matches Blizzard while the fallback remains visible,
and integrated checks remain clean.

P0165 R1 is durable at `0e83af06` / `0.0.82-dev` and runtime-accepted for ordinary offer-control suppression/restoration. Stock Accept/Decline suppression applied with exact snapshot/restoration and zero observed suppression failures/secrets; production Decline remained event-confirmed. PvP-confirmation and auto-accept remain Blizzard-owned. Continue / Complete, rewards, gossip selection, and all broader Blizzard quest suppression remain separate gates.

P0166 moves the active Phase H work to integration-owned semantic layout anchors; it does not expand any suppression or quest mutation boundary.

## Closed Phase G investigations

G.1 DynamicCam profile capture:
**CLOSED — PASS.**

G.2 World/Combat camera zoom capability:
**CLOSED — RUNTIME + INTEGRATION PASS.**

G.3 production World/Combat camera ownership:
**CLOSED — RUNTIME + INTEGRATION PASS.**

G.4 City camera ownership:
**CLOSED — RUNTIME + INTEGRATION PASS on `0.0.43-dev`.**

G.5 target-50 without CVar mutation:
**CLOSED — CLEAN NEGATIVE on `0.0.44-dev`.**

G.6 captured DynamicCam profile parity:
**CLOSED FOR CLAIMED OBSERVED SCOPE — P0162 RUNTIME PASS on `0.0.81-dev`.**

## Other tracked non-blocking defects / deferred domains

- `D4_TARGETFRAME_REASSERTION_INTERMITTENT.md`
- `FUTURE_AURA_STATUS_PRESENTATION.md`
- `FUTURE_NAVIGATION_POI_TRACKING_CAPABILITY.md`

## Aura / status ownership

Status:
**OPEN — P0137 PLAYER HELPFUL PRODUCTION BASELINE ACCEPTED; HARMFUL/TARGET AURA CATEGORIES REMAIN DEFERRED.**

Canonical investigation:
`FUTURE_AURA_STATUS_PRESENTATION.md`.

No stock aura/status suppression is authorized.

P0135 resolves the source/policy layer and accepts D-041:
- `C_UnitAuras` is the source family;
- per-index aura secrecy preflight is mandatory;
- `UNIT_AURA` is invalidation only;
- urgent player harmful status outranks passive helpful status;
- target actionable status remains gated by world-target placement;
- private/group aura surfaces remain Blizzard-owned;
- no stock suppression is authorized.

P0136 is now implemented as a bounded secret-first diagnostic on
`0.0.66-dev`. It discards `UNIT_AURA` payload arguments, never queries a
secret/indeterminate aura index, and does not mutate or suppress Blizzard UI.

Runtime evidence now establishes ordinary populated player helpful data and safe
empty-state target scans with zero failures.

Populated player harmful and populated target categories remain environmental
DEFERRED, and no secret-skip branch was encountered.

Production implementation may therefore advance only for player helpful status,
with Blizzard completeness fallback preserved.

P0136 is durable at `ef769f6` / `0.0.66-dev`.

P0137 `0.0.67-dev` prepares only `HELPFUL|PLAYER` presentation:
- maximum four passive icons from a six-index bounded scan;
- native icon unchanged;
- minimal sheet-04 frame;
- ordinary lower-right stack count when >1;
- no duration/timer sweep/polling;
- event-driven `UNIT_AURA` invalidation;
- Blizzard player aura presentation untouched.

P0137 is durable at `2b578759` / `0.0.67-dev` and runtime + visual PASS.

The passive player-helpful lane is accepted. Populated player harmful/urgent,
populated target aura/status, private, and group ownership remain separately
gated/deferred. Do not manufacture those states solely to advance sequencing.

## World-attached target presentation

Status:
**OPEN / ENVIRONMENTALLY DEFERRED POSITIVE ANCHOR — P0140 FALLBACK/REACTION RUNTIME PASS.**

Canonical investigation:
`FUTURE_WORLD_TARGET_PRESENTATION.md`.

P0139 / D-042 source policy remains authoritative. P0140 is durable at
`f7e2c31d` / `0.0.68-dev`.

Runtime evidence proves:
- safe no-target/no-nameplate fallback;
- ordinary friendly reaction;
- ordinary `UnitIsTrivial=false`;
- zero probe failures / secret skips in the recorded samples;
- integrated `Run All` PASS.

No accessible target nameplate was observed, so behind-camera and hidden
addon-owned attachment paths remain environmental DEFERRED. Production relocation
remains blocked and the screen-space target remains canonical fallback.

## Navigation / minimap capability

Status:
**OPEN WITH ACCEPTED MANUAL-WAYPOINT BASELINE — P0148 RUNTIME + VISUAL PASS; QUEST/AREA-POI DEFERRED; TRACKING RESULTS BLOCKED.**

Canonical investigation:
`FUTURE_NAVIGATION_POI_TRACKING_CAPABILITY.md`.

P0142 / D-043 source policy remains authoritative.

P0143 proves current-map/player geometry, map world size, minimap view radius, and
multi-select tracking selector metadata/state. AreaPOI/current/quest destination
paths remain environmental DEFERRED; tracking-result/service-instance positions
remain source-blocked.

P0145 proves same-map manual-waypoint distance and clear fallback.

P0147 proves the live minimap-radius band mechanics but fails visual calibration.

P0148 is durable at `6f381a77` / `0.0.72-dev` and is runtime + visual PASS:
the stronger `1.20 / 1.05 / 0.85 / 0.70` scale anchors make close/medium/far depth
perceptible. Further amplitude tuning is deferred to later whole-interface polish.

P0123 remains off-tape runtime authority. Stock minimap ownership and unproven
quest/POI/tracking roles remain unchanged.

## Class / pet / special-control ownership

Status:
**P0152 R12 PET-ACTION RUNTIME + CONTROL + STATE-PRESENTATION PASS; FINAL VISUAL POLISH DEFERRED.**

Canonical investigation:
`FUTURE_CLASS_PET_SPECIAL_CONTROL_CAPABILITY.md`.

P0149 / D-044 source policy remains authoritative. P0150 R3 remains the accepted read-only source baseline.

P0152 is durable at `00aef4a90e5999140dc9082e68e934cfc854cb05` / `0.0.74-dev` and is accepted for the bounded pet-action slice. The final pet-state diagnostic recognized ten click-specific pet bindings, seven naturally readable/occupied slots, two active-state indicators, and one autocast indicator. Default-on arming succeeded, and the user confirmed both the visible state treatment and working pet button presses.

Stock PetActionBar remains available. Pet edit/reorder, binding replacement, PetActionBar suppression/restoration, PetFrame ownership, stance/form, totem, rune, alternate-power, discrete class-resource, and unsupported special-control ownership remain separately gated.

Exact pet-button ornament/contrast refinement is deferred to later whole-interface polish rather than treated as an open control defect.


## H.1 — Blizzard stock-surface ownership / suppression

Status:
**AUDIT COMPLETE — P0164; P0165 QUEST-OFFER CONTROL SUPPRESSION NEXT.**

P0164 classifies the current coexistence surface-by-surface. Existing runtime-proven suppression remains valid for Quiet Mode passive chat/social presentation, selective Player and Target shells, and conditional stock Bar 2–3 replacement. All incomplete information/control domains remain stock.

External UI-hider guidance was used narrowly: Hide Anything as a broad product reference and public MoveAny source for inspectable hide/restore mechanics. This does not authorize blanket hooks, parent locks, timer retries, or polling in Logres.

The next narrow investigation/implementation is P0165: identify the exact Forever stock quest-offer Accept/Decline controls and lifecycle, then suppress/restore only those controls while the proven Logres offer surface is ready. Progress/Continue, completion/Complete, rewards, gossip, and the QuestFrame root remain stock.

## P0166 — H.2 integration-owned anchors

Status:
**STRUCTURAL RUNTIME PASS — `a67e0cce`, `0.0.83-dev`.**

The integrated runtime reports 13 anchors, 15 binds, zero failures/missing/mismatches, clean Run All, and pet actions on the integration-owned `classPet` anchor. Objective Progress no longer depends on the detached target fallback.

Whole-screen visual spacing/collision calibration remains open.

Post-push tooling defect:
Layout Check was not registered in the Phase H developer panel even though the slash command and Run All integration existed. P0167 corrects the panel registration only; anchor geometry and capability policy are unchanged.

P0167 R0 delivery failure:
The first P0167 artifact failed during candidate construction before the checker suite or any tracked write because its applier assumed this P0166 section already existed in `ACTIVE.md`. The authoritative baseline did not contain that section. R1 used this append-only absence-gated update instead, but its own applier then failed before checker execution or tracked writes because an evidence `write()` call passed four positional arguments to a three-argument helper. R2 corrects that delivery-only defect and preserves both failures as evidence.

## P0169 — H.1 screenshot-backed stock Bar 4–5 integration (candidate, 2026-10-08)

A 1916×1198 production screenshot contradicts any claim that previous domain-level diagnostics established a visually clean interface. Previous assistant assertions that the Blizzard UI had almost entirely disappeared were inaccurate. Stock Main, PetFrame/PetActionBar, additional action bars, minimap, Objective Tracker, permanent XP, micro-menu are present; DPS/Issue Reporter may be addon surfaces. The lower-left conventional portrait is the pet and must not be classified as failed PlayerFrame suppression. Preserve this negative screenshot observation even if a later patch succeeds.

P0169 targets only source-backed and safely coverable ordinary native extra Bar 4/5 slots, matching secure button+binding+feedback and conditional stock visual/mouse restoration. Native source: Forever 70245 `Gethe/wow-ui-source@15666a6e67938a1ab5caf041406464251db111ca`, `Blizzard_ActionBar/Shared/MultiActionBars.xml` / `MultiActionBars.lua`. P0169 does not authorize blanket suppression of Main/Override/special action, PetFrame, tracker, minimap, XP, menu, party, class resource, or target status. Geometric move is an initial candidate, not approved visual final. Runtime result is pending; no Lua/protected/secret errors acceptable.

## P0170 — P0169 clean-login source readiness regression (OPEN — runtime candidate)

Verified main `74ff4156` / P0169 `0.0.86-dev`. In the uploaded 2026-10-08 diagnostics, immediately after `PLAYER_LOGIN`/reload, `stockreplacecheck` said PASS while stock replacement was `requested=false applied=false pending=false`, with `lastError=Bar 4/5 source configuration unreadable`; Bar 4 and Bar 5 Logres clusters were initially hidden. This was an actual startup regression, not a passing stock suppression state. After a `checkall` lifecycle/preference exercise, `requested=true applied=true`, native Bar 2–5 alpha/mouse and matching routing were correct, and the 15-anchor layout passed. The recovery was **induced by diagnostics**, not clean-login convergence.

Source cause: `StockReplacement:EnableReplacement()` cleared requested state when `Settings.GetValue(PROXY_SHOW_ACTIONBAR_4/5)` was not yet readable; `StockReplacement:HandleEvent()` retried only combat deferrals, not initial settings readiness; Stock Replace Check validated suppressed alpha/mouse only **if already applied**, then erroneously returned PASS for unapplied Immersion. `SecondaryUtility:RefreshExtraVisibility()` also replaced last-known true with nil on transient settings unavailability. P0170 corrects these narrow paths with event-driven retry and last-known safe visibility, plus a fail-closed diagnostic. Runtime CLEAN LOGIN GATE PENDING; no passive success inference from `Run All`.

## P0171 — repeated H.1 scope/delivery failures (OPEN, 2026-10-08)

Verified main `95aaa593` / P0170 `0.0.87-dev` fixes the observed first-login stock Bars 2–5 recovery (one deferral/one event retry; expected/requested/applied=true). It does **not** close screenshot-wide H.1. The user again rejected serial micro-slices and inaccurate claims that already-proven surfaces meant the remaining native interface was addressed. Current work is a **consolidated remaining-stock-UI capability, on-demand fallback, reversible suppression and Logres positioning integration**; require one whole-screen/interaction test. Open domains: normal/special Main, pet controls/frame/edit/bindings, minimap/navigation, full objectives/log, persistent XP, micro-menu; see canonical evidence `../evidence/P0171_H1_SCOPE_AND_DELIVERY_FAILURES_2026-10-08.md`. Do not suppress required/protected surfaces without safe replacement. Preserve P0169 initial false diagnostic PASS and P0167/P0168/P0170 preflight delivery failures. Status: **OPEN, not an audit-only task and not a runtime PASS**.

## P0172 — four native domains with on-demand stock access (2026-10-08)

P0171 is verified main `26fa1ef7`; the screenshot-wide H.1 objective remains open. One coordinated P0172 candidate `0.0.88-dev` folds actual Blizzard frame roots for minimap, all watched objectives, status/XP and micro-menu/bags, while providing a persistent small Logres dock that restores each stock information/control source on demand. `Hide()` is used instead of alpha-only hide to avoid invisible click regions; source snapshot and combat-safe restoration are required. Logs alone cannot prove that Blizzard never re-shows a managed root. Main/override/special action and pet secure/edit units are explicitly *unfinished* and stay stock; do not pretend this is all-UI completion. See `../evidence/P0172_NATIVE_SURFACE_SOURCE_AND_RUNTIME_GATE_2026-10-08.md`. In-game test pending; negative events and protected failures must be preserved, not treated as PASS. The next work stays part of one integrated H.1 objective, not independent polish.

### P0173 — primary stock ownership gate

After verified P0172 main `3a5028c8` / `0.0.88-dev`, the user reports dock controls working and primary Blizzard bar still visible. Source audit confirms native Main includes secure page/edit and MKB/gamepad/attachment behavior, with dedicated possess/vehicle/override/special controls; normal Primary secure button and manually available key routing alone do not imply complete Main ownership. Simple `MainActionBar:Hide()` without combat-safe special-mode restoration is a **DEFERRED/UNSAFE path**, not an accepted UI cleanup. Candidate P0173 `0.0.89-dev` records explicit read-only native source/mode gate and permits existing temporary Action Keys manual proof without default routing or suppression. Gameplay/runtime proof pending, H.1 OPEN.

### P0174 — action interaction, native cast and tracker coexistence (2026-10-08)

P0173 verified at `f9c99685` / `0.0.89-dev`: Primary read-only normal ownership PASS, optional routing ON `candidate=true`, routing OFF stock restored, all four original native domains folded, Run All clean. New user-reported limitations: action drag rearrangement absent, native cast bars still displayed, intermittent quest tracker return, Logres actions/aura tooltips absent. P0174 `0.0.90-dev` combines source-backed drag/swap and hover tooltips with reversible CAST native-access domain and event-targeted objective/cast re-fold; runtime candidate, all newly changed behaviors untested. Qualitative cast glyphs do not replace cast duration, so native on-demand CAST access is mandatory. No Main secure suppression or H.1 closure.

### P0174 R1 — failed pre-write shadow memory check (2026-10-08)

P0174 R1 SHA-256 `91146e93ad9c01a297976da316327ffc5325ea149cdff4b39aaca2b14f808c8d` reached the shadow static checker suite, then failed at `check_memory_health.py`: the generated `docs/memory/CURRENT.md` contained zero `## Success Criteria` and zero `## Relevant References` headings. User provided full terminal output proving this failure. R1 refused before tracked writes; the user's P0174 local changes remained in place. R1 is SUPERSEDED by P0174 R2; do not stage/reset/reapply R1. R2 restores canonical headings, validates the same combined candidate, and preserves the runtime issues as OPEN.

### P0174 R2 — tracker/cast native reappearance correction (2026-10-08)

P0174 `0.0.90-dev` was applied locally and its static manifest uploaded, but remote main remained P0173 `f9c99685`. First screenshot shows the native Objective Tracker visibly back over the native-access dock; user reports the tracker intermittently vanishes/reappears, while native player/target cast bars return in combat and Blizzard auras remain. The user's explicit report is negative runtime evidence, not a PASS. P0174's `Fold()`/`Refold()` policy holds an existing snapshot but event-only invalidation can miss later native `Show()` calls. R2 makes source-specific OnShow re-folds outside lockdown, preserving intentional manual dock opens and restoration, and adds accurate reappearance/combat-deferral counters. **No secure combat cast suppression is claimed.** Comprehensive player harmful/private and target aura visuals and suppression remain OPEN under D-041; no unsafe blanket aura hide. R2 runtime not yet tested. P0174 and R2 are one checkpoint, with no intervening Git push.

### P0174 R3 — combat cast visibility gate (2026-10-08)

The user tested P0174 R2 `0.0.90-dev`: the native Objective Tracker no longer reappears, accepted for the observed quest-update scope. **Native player/target cast/channel bars still reappear during combat.** Uploaded `LOGRES_DIAGNOSTICS_LATEST.lua` shows `nativeuicheck` 5 folded/0 open, source-specific tracker `onshow-refold`, `nativeShows=30/20`, `combatDeferred=2`, and `pending=0` after combat. The out-of-combat PASS does not prove combat-time native presentation. Remote main remains P0173 `f9c99685`; P0174 and R2/R3 are local, unpushed candidates. Preserve this negative evidence.

Pinned Forever Blizzard source `Gethe/wow-ui-source@15666a6e67938a1ab5caf041406464251db111ca` (`Blizzard_UIPanels_Game/Shared/CastingBarFrame.lua`, `Blizzard_UnitFrame/Mainline/TargetFrame.lua`) implements `CastingBarMixin:ShouldShowCastBar()` through `self.showCastbar` and offers `SetAndUpdateShowCastbar(showCastbar)`. R3 arms each of the three exact P0174 native cast sources' native show policy **out of combat**, before folding them; captures original flags only as opaque restoration tokens; and restores them through Blizzard's own setter when CAST is manually opened, Immersion turns OFF, or the module is disabled. No SetCVar, combat-time Hide/alpha, secure-handler snippets, reparenting, global hooks, or polling. If the setter is unavailable or fails, no cast folding authorization is granted, and stock remains the fallback. Native `OnShow` during combat while armed is recorded as a persistent escape, not a PASS after release. The existing CAST access dock is the explicit opt-in native casting-detail fallback (open before combat if exact progress is needed); Logres's production cast cue remains symbolic-only. Special-mode and combat-time CAST toggle are not claimed complete; full D-041 enemy/player aura replacement remains OPEN. Runtime validation of the new gate is PENDING; a source-backed hypothesis is not a PASS.

## H.1 P0175 — player harmful / target status presentation (2026-10-08)

P0174 R3 verified pushed at `996f6099`; user observed no issues, and native diagnostics show five folded domains and zero cast-gate escapes. This resolves the observed R2 combat-cast recurrence; preserve earlier R1/R2 failures. P0175 is additive prioritized aura presentation and not yet proven in client. D-041 stock/private/group aura preservation and D-042 world attachment gates stay open. P0136 missing populated player harmful/target evidence remains environmental deferral until naturally encountered; static sample preview does not resolve it. Main/special secure action bar remains a separate H.1 blocker.

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

## P0184 — P0183 R1 visual/runtime acceptance (2026-10-09)

Verified `main` `11a342b` includes P0183 R1 / `0.0.98-dev` native Logres HARMFUL containers. User confirms **Logres debuffs now appear**; icon polish may wait for full Phase H visual calibration. Uploaded loadCount 234 Phase 0 Run All completed, `native debuffs: ready=true active=true`, UI Ownership 35/17 PASS/18 STOCK/0 FAIL, no recorded command errors. Ordinary-indexed harmful snapshot still reports no selected aura; native restricted aura membership is deliberately not inspected, so that is not evidence against observed secure rendering. **P0183 PASS in observed visual/setup/regression scope; do not claim full player-vs-hostile-target, combat or Blizzard aura suppression completeness.** Blizzard aura stock fallback remains. P0182 filter-only negative result and original P0183 prewrite ZIP `__pycache__` failure remain preserved. P0184 docs-only acceptance pending user push. The next separate H.1 gate is secure Main/Override/special action editing/routing/restoration; cosmetic debuff styling deferred to whole-screen Phase H polish. Preserve intermittent post-loot ObjectiveTracker flash as OPEN/INTERMITTENT/UNREPRODUCED.

## P0185 — current normal-screen H.1 MainActionBar-only delivery gate (2026-10-09)

GitHub `main` **`4e999b1`** contains accepted P0184; P0183 R1 Logres native harmful icons visibly appear, and `0.0.98-dev` loadCount 234 Phase 0 Run All and 35-row ownership audit passed (17 PASS/18 STOCK/0 FAIL). User says **only the normal Main action bar remains to remove**. This is current user-observed unwanted persistent normal-screen presentation; earlier P0168/P0183 entries above are historic checkpoint descriptions, **not** active work. Stock policy entries are intentional fallback and often `not inspected`, not additional visibility defects. H.1 next is capability-gated Main normal-mode replacement/suppression, edit/bind or accessible stock edit fallback, special/Override/vehicle/possess modes stock-retained, combat-safe exact restoration, and no hidden clickable stock buttons. No broad suppression, no scope creep to class/pet/party/aura/quest/native dock, no new debuff diagnostics. P0185 only reconciles memory; no WoW change. Earlier P0182/P0183 packaging failures and intermittent loot flash remain preserved.

## P0185 R0 packaging/baseline failure; R1 correction (2026-10-09)

The first P0185 ZIP passed its own synthetic transform/integrity tests but failed on the user's clean pinned P0184 checkout **before any tracked writes**: `P0185 APPLY FAIL — unexpected source blob docs/memory/investigations/ACTIVE.md: 29b3e0b4d347395c5e06214f23cb7df66c4aae97`. Re-query of the **same** GitHub `main` commit `4e999b1` established that P0185 R0 had pinned stale blob IDs for seven memory files changed by P0184. R0's `ACTIVE.md` expectation `1896d955...` was wrong; the committed blob is `29b3e0b4...`. The original pre-write check rejected this, correctly preventing partial edits. **R0 is INVALID / SUPERSEDED, not a runtime FAIL.** No Git reset, WoW change, or repeat acceptance test is justified.

P0185 R1 corrects all seven blob IDs, additionally verifies each expected blob against both `HEAD:path` and the worktree, preserves the existing exact-head/clean-tree and candidate-shadow full-checker gates, and retains the same documentation-only scope. This is a source-locking/delivery correction; no addon behavior changed.

## P0186 — pinned Main secure-transition gate (2026-10-09)

Verified GitHub `main` `60886bb` contains P0185 docs-only reconciliation; runtime remains `0.0.98-dev`. Against the pinned Forever 70245 `Blizzard_ActionBarController/ActionBarController.lua`, Main is the active actionpage host for multiple *unskinned* special states, and native `ValidateActionBarTransition` calls Main Show/Hide. Current Logres Primary `PRIMARY_PAGE_DRIVER` handles only bars 1–6 while overriding `ACTIONBUTTON1`–`12`, and cannot refresh bindings in combat. This specifically falsifies the hypothesis that extending Bar 2–5 alpha/mouse suppression alone is a safe normal Main replacement. **Source blocker / direct hide NOT AUTHORIZED; no WoW runtime probe or implementation claimed.** Next exact code: integrated secure mode-aware route + normal Main presentation and special/edit/combat/OFF restoration, with stock fail-open on incomplete capability. Other intentional STOCK domains and P0183 aura acceptance unchanged. See P0186 patch/evidence.

## P0187 — Main normal secure replacement session candidate (2026-10-09)

Verified P0186 at `2421040`. Direct Main alpha/mouse suppression remains source-blocked because native Main handles unskinned special states and secure Primary normal override keys would hijack them. Candidate `0.0.99-dev` instead temporarily reparents native Main to an addon-owned `SecureHandlerStateTemplate` gate (native alpha/mouse/page unchanged), secure-hides the entire stock subtree in ordinary mode, and secure-opens it while Primary secure keys delegate to stock ActionButtons in special modes. Outside combat, OFF/Immersion OFF/edit entry restores original Main parent *before* route release, with exact prior routing. Session explicitly OFF after reload; panel-only arming/test. Native special mode driver, taint and protected parent behavior need actual WoW validation. No standalone special proof from an ordinary check; missing mode is DEFERRED, any protected/Lua/taint error is FAIL. No broad stock suppression or aura reopening.

## P0187 R0 in-client ON/OFF/ON failure and R1 correction (2026-10-09)

User evidence (`LOGRES_DIAGNOSTICS_LATEST.lua`, loadCount 236, `0.0.99-dev`): initial `mainreplace on` CANDIDATE (`applied=true`, activations 1); `mainreplace off` STOCK (`applied=false`, restorations 1); subsequent ON repeatedly FAILED with `MainReplacement.lua:200: secure normal mode gate not established` (`armed=true`, `applied=false`, activations 1, restores 1). OFF afterward reported stale FAIL despite native stock already restored. This establishes a **reproducible re-arm failure, NOT a failed first release**. No special/combat mode was tested; no Lua traceback outside the intentional secure-gate assertion appears in the supplied panel diagnostics. This is not a test that stock was physically clickable afterward.

Narrow inferred cause, supported by secure state-driver implementation: unregistering `state-logresmode` stops updates but retains the `normal` attribute. After OFF explicitly shows the reusable gate, re-registering the same `normal` value does not trigger `_onstate-logresmode`, so Main remains visible under the gate and the fail-open assertion at line 200 fires. R1 clears only its own secure handler `state-logresmode` attribute out of combat when releasing and immediately before re-registering. Original Main parent restoration precedes release reset; routing release remains after native restoration. Failed-ON rollback also clears the addon state. OFF clears a stale failed-ON diagnostic if stock is already released. R1 adds order-sensitive static checker assertions for re-arm safety, without polling/hooks/native attribute mutation.

R1 `0.0.100-dev` is an **untested corrective runtime candidate** against the **P0187-applied but uncommitted** checkout at `HEAD` `2421040`. It has no runtime PASS until panel ON → OFF → ON → OFF is repeated and normal native visibility/click, Primary keys, Immersion OFF and Edit Mode recover. Native special states remain environmentally DEFERRED unless naturally observed. The earlier R0 runtime failure remains durable negative evidence; do not classify H.1 complete until restoration re-test.

## P0187 R1 package baseline failure / R2 delivery (2026-10-10)

The initial R1 applier **FAILED before tracked writes** with `unexpected P0187 applied source: tools/check_main_replacement_contract.py`. R1 had a correct hash for the R0 ZIP checker but the user's working copy differed; the local difference is not proven semantic. The user's checkout also has unrelated untracked files and `:Zone.Identifier` attachments; R1's blanket untracked-state rejection would have been an additional incorrect gate. R2 checks all 12 transformed tracked files against the exact R0 applier and the checker AST against shipped R0, preserves formatting-only differences, and ignores unrelated untracked files. R2 is a delivery correction, not an additional runtime PASS. If checker AST differs, abort and preserve it.

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
