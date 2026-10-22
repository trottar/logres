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

# Patch Index

| ID | Date | Result | Description |
| --- | --- | --- | --- |
| P0284 | 2026-10-21 | PREPARED / WSL+WOW UNVERIFIED | P-only Filters/Categorize, denominated Funds and disabled Train All; native transaction ownership unchanged. |
| P0283 | 2026-10-21 | PREPARED / WSL+WOW UNVERIFIED | P-only selected vs ordinary vs disabled trainer row text and gold motif; native H unchanged. |
| P0282 | 2026-10-21 | PREPARED / WSL+WOW UNVERIFIED | P-only low-alpha parchment material and overlay-order repair after user-confirmed P0281 dark-block VISUAL FAIL; H/native unchanged. |
| P0281 R2 | 2026-10-20 | PREPARED / WSL+WOW UNVERIFIED | Repair R1 false-positive fixture mouse contract via constructor-local check, preserve all native H and preview behavior. |
| P0281 R1 | 2026-10-20 | PREWRITE FAILURE / NO TRACKED WRITES | 151/152 checkers passed; new contract asserted `frame:EnableMouse(false)` but source uses local `f`. Source/contract mismatch. |
| P0281 R0 | 2026-10-20 | PREWRITE REFUSAL / NO TRACKED WRITES | ZIP SHA matched but assistant applier held invalid 38-character Bootstrap Git SHA; user proved correct clean HEAD/index/worktree. |
| P0280 | 2026-10-20 | PUSHED 38cf5fc / VISUAL FAIL | Four native control decorations attach, but screenshot shows fragmented 560x430 P fixture and narrow stock trainer; not landscape acceptance. |
| P0275 | 2026-10-19 | PREPARED / CLIENT UNVERIFIED | Quest-art nine-slice shell behind native merchant/trainer; P0274 visually insufficient despite activation. Stock opaque controls and fallback unchanged. |
| P0274 | 2026-10-19 | PUSHED ac3f199 / VISUAL INSUFFICIENT | Tiny accent activated in 0.0.172-dev (3 shows, no failures), but user screenshot looks stock; preserve negative visual outcome. Superseded by P0275 quest-art shell trial. |
| P0273 | 2026-10-19 | PUSHED (591ed52) / SCOPED CLIENT PASS | Native gossip→trainer center continuity accepted, starts/restores 3/3 gossip 2/2 failures=0; controls native. P0272 archival reconstruction remains honest; original WSL static gate unknown. |
| P0272 | 2026-10-19 | SOURCE PUSHED c5ef384 (MISLABELED P0271) / SCOPED CLIENT PASS; WSL GATE UNVERIFIED | User 0.0.170-dev AUTO tests: starts=2 restores=2 failures=0; screenshot reveals left gossip → centered trainer discontinuity. Original checker/records absent on main, reconstructed by P0273; original P0272 manifest absent, not fabricated. |
| P0271 | 2026-10-19 | PREPARED / RUNTIME UNVERIFIED | Explicit reversible merchant/trainer native center TEST + close/regen restoration; TaxiFrame read-only alias; D-047 stock transactions/camera retained. |
| P0270 | 2026-10-19 | PREPARED / RUNTIME UNVERIFIED | D-047 guarded native stock frame metadata audit across eight services; no native styling, position or transactions; on-demand H panel. |
| P0269 | 2026-10-19 | PREPARED / RUNTIME UNVERIFIED | Restore D-047: retire speculative service catalog/confirm previews, preserve native transaction ownership; add read-only native-service policy and H check; styling/placement deferred to safe proof. |
| P0268 | 2026-10-19 | PREPARED / CLIENT UNVERIFIED | One shared service catalogue with merchant, trainer, flight, unavailable fixtures; quote/requirement/confirmation interactions; P/F diagnostics; matched decorative-header clearance. |
| P0267 | 2026-10-19 | PREPARED / CLIENT UNVERIFIED | Combined NPC header Back/Goodbye alignment and one-step Farewell/Leave exit, grounded in P0266 screenshot and diagnostics. |
| P0266 | 2026-10-19 | PREPARED / CLIENT UNVERIFIED | Combined fixes for option pager/row overlap, branch Back/navigation, and universal Goodbye; P0265 screenshot runtime FAIL preserved. |
| P0265 | 2026-10-19 | PREPARED / RUNTIME UNVERIFIED | Combined branching NPC options, Back, 7 service previews, 11-entry overflow, locked states, diagnostics; all synthetic/no native mutations. |
| P0264 | 2026-10-19 | PUSHED (6b3ed96) / SCOPED FUNCTIONAL PASS | User accepted preview reward selection, highlighting and reset; 8 selection clicks and Quest checks PASS; R0 and R1 static delivery failures preserved in evidence; native claim remains stock. |
| P0263 | 2026-10-18 | PUSHED (373c82b) / PREVIEW DIAGNOSTIC PASS; NO NEW PLAYER FUNCTION | Shared original decision button artwork/cosmetics, no new UI behaviors; user reported insufficient progression; N4 choice cards still inert. |
| P0262 | 2026-10-18 | PUSHED (36d43f6) / SCOPED VISUAL PASS | Shared narrative pagination, five previews and pager arrows visually accepted; preview-only controls; R0 static failure preserved; live claims deferred. |
| P0261 | 2026-10-18 | PUSHED (b439d4f) / SCOPED PREVIEW VISUAL PASS | N1 shared source-independent narrative/decision model, live offer + long/short/generic previews in same original renderer; no camera/action changes. |
| P0260 | 2026-10-18 | PUSHED (1251434) / SOURCE AUDIT | Code-level modularity map + all 54 provisional NPC variants, camera-frozen regression policy and N1-N6 extraction sequence; no runtime changes. |
| P0259 | 2026-10-18 | PUSHED (669ec77) / DOCS-ONLY | D-047 modularity-first all-NPC program, DynamicCam/NPC-session continuity, selective native/hybrid/full integration and deferred bank/auction feasibility. |
| P0258 | 2026-10-18 | PUSHED (edec5eb) / PREVIEW VISUAL ACCEPTANCE (SCOPED) | Multi reward preview uses the same in-panel Complete Quest visual and amount-only footer as Single; choice cards remain inert, live native fallback untouched. |
| P0257 | 2026-10-18 | PUSHED (94635d3) / PARTIAL PREVIEW VISUAL ACCEPTANCE | D-046 preview-first pipeline; shared reward model and in-panel inert Single preview, stock-choice fallback unchanged. |
| P0256 | 2026-10-18 | PUSHED (23307aa) / GALLERY VISUAL PASS (SCOPED) | Central 28-control paginated preview tab, universal UI preview coverage audit, NPC dialogue first; no gameplay mutation. |
| P0255 | 2026-10-18 | PUSHED (fc74e14) / RUNTIME UNVERIFIED | Final-page completion reward/action visibility, in-panel Accept/Decline; native claim flash OPEN and untouched. |
| P0254 | 2026-10-18 | PUSHED (2a7bc5d) / VISUAL PASS (SCOPED) | In-game Complete Quest inside narrative visually accepted; actual claim and choice interactions deferred. |
| P0253 | 2026-10-18 | PUSHED (3c0a017) / VISUAL FAIL | Original Accept button reused, but action still appears outside panel because the shared root remains anchored below the narrative. |
| P0252 | 2026-10-18 | PUSHED (34274dc) / VISUAL FAIL | Duplicate guidance removed, but separate Complete Quest button remained visually detached; shared original Accept planned in P0253. |
| P0251 | 2026-10-18 | PUSHED (45d4654) / RESTORATION RUNTIME PASS (SCOPED) | R2 ON restoration failure corrected by R3; user reports no issues, load334 OFF/ON re-present and stock re-suppressed; claim still untested. |
| P0250 | 2026-10-18 | DOCS-ONLY / PREPARED | Record pushed P0249 preview runtime PASS, keep natural quest and historical errors OPEN/DEFERRED. |
| P0249 | 2026-10-18 | PUSHED (aaee288) / PREVIEW RUNTIME PASS (SCOPED) | Single and multiple synthetic reward previews rendered without nil-method errors; natural reward source/choice/claim still unverified. |
| P0248 R2 | 2026-10-18 | PUSHED (cfd67be) / RUNTIME FAIL | Two preview commands error at Dialogue.lua:1258 (missing instance method); cards=0, stock retained. Earlier R0/R1 prewrite failures preserved. |
| P0247 | 2026-10-18 | PREPARED / RUNTIME UNVERIFIED | Read-only diagnostic for the source gate preventing P0246 item data request. |
| P0246 | 2026-10-18 | INSTALLED / PUSHED (9eb711f); ITEM NOT RESOLVED, REQUESTS=0 | Item-data events registered but request path never entered; natural quest 237 still shows fallback. |
| P0245 | 2026-10-17 | INSTALLED / PUSHED (1bf3423); ITEM STILL MISSING | Cache one-shot did not improve quest 237 item readout in screenshot; XP/7s and stock Complete Quest intact. |
| P0244 | 2026-10-17 | INSTALLED / PUSHED (1ce1de1); MONEY VISUAL PASS, ITEM INTERMITTENT | Quest 237 7s and 1050 XP match stock with native Complete Quest visible; Logres item name fallback despite stock potion x3. |
| P0243 | 2026-10-17 | INSTALLED / PUSHED (e8455bc); VISUAL PASS LIMITED | Quest 237 completion prose, item x3 and XP match Blizzard; native Complete Quest visible. Cash 7 silver missing; P0244 evidence. |
| P0242 | 2026-10-17 | INSTALLED / PUSHED (18b0fa0); PARTIAL / NARRATIVE ONLY | Load 315 registered; Logres quest shown, no Logres Complete/rewards; completion prose not independently checked post-event (P0243 evidence). |
| P0241 | 2026-10-17 | INSTALLED / PUSHED (ee1cbd3); REGISTRATION PASS / PROGRESS DEFERRED | Load 313 questdialoguecheck PASS; zero natural progress; QUEST_COMPLETE read-only event observed (P0242 evidence). |
| P0240 | 2026-10-17 | INSTALLED / PUSHED (048cd77); DOCS-ONLY | Quest lifecycle source gate: progress, completion, gossip runtime conditions still deferred. |
| P0239 | 2026-10-17 | INSTALLED / PUSHED (22ba7ab); DOCS-ONLY | P0238 settings UI runtime acceptance; next quest lifecycle source delta audit. |
| P0238 | 2026-10-17 | INSTALLED / RUNTIME ACCEPTED (0eb1976) | First player settings panel; load 312 user-observed PASS, preferencecheck PASS; detailed UI toggles not independently logged (P0239 evidence). |
| P0237 | 2026-10-17 | INSTALLED / PUSHED (bb1f772); DOCS-ONLY | P0236 runtime acceptance and preserved R0 manifest EOF failure; compass polish deferred. |
| P0001 | 2026-09-30 | INSTALLED / PUSHED | Initial repository-native memory bootstrap (`353c5b0`) |
| P0002 | 2026-09-30 | INSTALLED / PUSHED | I-001 source audit + runtime probe (`48a7d28`) |
| P0003 | 2026-09-30 | INSTALLED / PUSHED | First Forever runtime evidence + Lua compatibility fix (`ad3a660`) |
| P0004 | 2026-09-30 | INSTALLED / PUSHED | Runtime pass 02, close I-001, advance to Phase 0.3 (`477df5b`) |
| P0005 | 2026-09-30 | INSTALLED / PUSHED | First real addon skeleton + deployment/static-check tooling (`ce4f1b0`) |
| P0006 | 2026-09-30 | INSTALLED / PUSHED | Record Phase 0.3 proof, close Foundation, open Phase A (`25bc9da`) |
| P0007 | 2026-09-30 | INSTALLED / PUSHED | A.1 private state + snapshot/subscription consumer contract (`e2f3d17`) |
| P0008 | 2026-09-30 | INSTALLED / PUSHED | Record A.1 proof; advance to A.2 context sensors (`c7dd8e8`) |
| P0009 | 2026-09-30 | INSTALLED / PUSHED | A.2 current source review and sensor selection (`dd6c4d7`) |
| P0010 | 2026-09-30 | INSTALLED / PUSHED | Implement A.2 mounted/resting/taxi/interaction sensors (`a1f119a`) |
| P0011 | 2026-09-30 | INSTALLED / PUSHED | Record A.2 proof; close A.2 and open A.3 (`7ff61b0`) |
| P0012 | 2026-09-30 | INSTALLED / PUSHED | A.3 separate persisted user-preference contract (`6a01f85`) |
| P0013 | 2026-09-30 | INSTALLED / PUSHED | Record A.3 proof; deployment workflow lesson; open A.4 (`73a8494`) |
| P0014 | 2026-09-30 | INSTALLED / PUSHED | A.4 lightweight module lifecycle contract (`2b40d0c`) |
| P0015 | 2026-09-30 | INSTALLED / PUSHED | Fix lifecyclecheck cleanup-count false negative (`f5a12d4`) |
| P0016 | 2026-09-30 | INSTALLED / PUSHED | Record A.4 proof; close A.4 and open A.5 (`7296d1f`) |
| P0017 | 2026-09-30 | INSTALLED / PUSHED | Record PvP transition; close Phase A; open Phase B (`840b40f`) |
| P0018 | 2026-09-30 | INSTALLED / PUSHED | B.1 production HUD root + secret-safe health vignette (`fa342ad`) |
| P0019 | 2026-09-30 | INSTALLED / PUSHED | Record P0018 visual failure; strengthen vignette + add preview (`5ae500d`) |
| P0020 | 2026-10-01 | INSTALLED / PUSHED | Record B.1 proof; close B.1 and open B.2 (`893ab6c`) |
| P0021 | 2026-10-01 | INSTALLED / PUSHED | B.2 secret-safe primary resource percentage (`66b27a3`) |
| P0022 | 2026-10-01 | INSTALLED / PUSHED | Record B.2 proof; close B.2 and open B.3 (`f89f43f`) |
| P0023 | 2026-10-01 | INSTALLED / PUSHED | B.3 sparse target name + secret-safe health percentage (`67acfa9`) |
| P0024 | 2026-10-01 | INSTALLED / PUSHED | Record B.3 proof; correct B.4 player + target cast scope (`8fb567f`) |
| P0025 | 2026-10-01 | INSTALLED / PUSHED | B.4 event-driven player + target cast/channel cues (`4c27c6c`) |
| P0026 | 2026-10-01 | INSTALLED / PUSHED | Record B.4 proof/target deferral; close B.4 and open B.5 (`8a89a35`) |
| P0027 | 2026-10-01 | INSTALLED / PUSHED | B.5 compact pet + party1–party4 name/health rows (`42aa8d6`) |
| P0028 | 2026-10-01 | INSTALLED / PUSHED | Record B.5 proof; close B.5 and open B.6 (`22e1ff1`) |
| P0029 | 2026-10-01 | INSTALLED / PUSHED | B.6 reusable in-game developer/control panel (`90491fe`) |
| P0030 | 2026-10-01 | INSTALLED / PUSHED | Record B.6 integrated proof; close Phase B; open Phase C; clarify stock-UI suppression ownership (`74ccfc3`) |
| P0031 | 2026-10-01 | INSTALLED / PUSHED | Resolve C.1 secure action architecture; open C.2 primary action cluster (`6d0a5b1`) |
| P0032 | 2026-10-01 | INSTALLED / PUSHED — RUNTIME FAILED | C.2 secure primary action cluster + P0029 slash fallback fix (`9f9f97d`) |
| P0033 | 2026-10-01 | INSTALLED / PUSHED | Fix C.2 secure execution; add fail-open key routing (`405c599`) |
| P0034 | 2026-10-01 | INSTALLED / PUSHED | Record C.2 secure execution proof; cast-cue color debt; open C.3 (`daf6a56`) |
| P0035 | 2026-10-01 | INSTALLED / PUSHED | Resolve C.3 secondary/utility slot, binding, reuse, and layout contract (`fccaabd`) |
| P0036 | 2026-10-01 | INSTALLED / PUSHED | C.3 shared action primitive + Secondary/Utility secure clusters (`f192557`) |
| P0037 | 2026-10-01 | INSTALLED / PUSHED | Record C.3 proof; add action-layout customization direction; open C.4 (`d1a6527`) |
| P0038 | 2026-10-01 | INSTALLED / PUSHED | Resolve C.4 contextual alpha and secure Primary paging contract (`1dbc3cf`) |
| P0039 | 2026-10-01 | INSTALLED / PUSHED — CONTEXT PASS | C.4 context alpha + secure normal Primary paging (`9ca10a7`) |
| P0040 | 2026-10-01 | INSTALLED / PUSHED — RUNTIME VISUAL FAIL | Add per-button pressed/activation feedback (`6c21344`) |
| P0041 | 2026-10-01 | INSTALLED / PUSHED — RUNTIME PASS | Fix activation feedback with independent overlay + manual diagnostic (`c020ab1`) |
| P0042 | 2026-10-01 | INSTALLED / PUSHED | Close C.4; record routed-key proof; open C.5 stock replacement (`8f5326a`) |
| P0043 | 2026-10-01 | INSTALLED / PUSHED | Resolve selective stock Bar 2–3 replacement contract (`66ea513`) |
| P0044 | 2026-10-01 | INSTALLED / PUSHED — RUNTIME PASS | Implement session-only selective stock Bar 2–3 replacement (`1d4f811`) |
| P0045 | 2026-10-01 | INSTALLED / PUSHED | Close C.5; record live editing gap; open C.6 integration validation (`e3c8602`) |
| P0046 | 2026-10-01 | INSTALLED / PUSHED | Close Phase C; open Phase D / D.1 (`8ad0f01`) |
| P0047 | 2026-10-01 | INSTALLED / PUSHED | Resolve D.1 immersion orchestration and unit-frame capability gates (`d24fcba`) |
| P0048 | 2026-10-01 | INSTALLED / PUSHED — RUNTIME PASS | Add Immersion Controller and automatic proven action replacement (`ed5af75`) |
| P0049 | 2026-10-01 | INSTALLED / PUSHED | Close D.2; resolve D.3 Quiet Mode runtime suppression contract (`c06d9cd`) |
| P0050 | 2026-10-01 | INSTALLED / PUSHED — RUNTIME PASS | Implement D.3 runtime Quiet Mode without saved chat mutation (`57c682c`) |
| P0051 | 2026-10-01 | INSTALLED / PUSHED | Close D.3 with instance deferral; open D.4 unit-frame source review (`d25430f`) |
| P0052 | 2026-10-01 | INSTALLED / PUSHED | Resolve D.4 selective unit-frame contract; open Player shell implementation (`f5bda1e`) |
| P0053 | 2026-10-01 | INSTALLED / PUSHED — RUNTIME PASS | Implement secure Player interaction and selective PlayerFrame shell suppression (`361cea7`) |
| P0054 | 2026-10-01 | INSTALLED / PUSHED | Record Player shell runtime PASS; open Target selective suppression review (`d971459`) |
| P0055 | 2026-10-01 | INSTALLED / PUSHED | Resolve Target selective suppression contract and open runtime implementation (`0c46f19`) |
| P0056 | 2026-10-01 | INSTALLED / PUSHED — RUNTIME DIAGNOSTIC FAIL | Target selective replacement (`4d7b6b1`); Target Frame Check hit secret boolean branch |
| P0057 | 2026-10-01 | INSTALLED / PUSHED — RUNTIME PASS | Make TargetFrame restoration/diagnostics secret-safe (`fc848b9`) |
| P0058 | 2026-10-01 | INSTALLED / PUSHED | Record P0057 pass; close D.4; track Target reappearance and aura domain; open D.5 (`eba9998`) |
| P0059 | 2026-10-01 | INSTALLED / PUSHED | Resolve D.5 orthogonal context/PvP/instance orchestration matrix (`b245170`) |
| P0060 | 2026-10-01 | INSTALLED / PUSHED — RUNTIME PASS | Add integrated D.5 Context Policy Check (`9608634`) |
| P0061 | 2026-10-01 | INSTALLED / PUSHED | Record P0060 runtime PASS; close D.5; open D.6 restoration validation (`01665d1`) |
| P0062 | 2026-10-01 | INSTALLED / PUSHED | Resolve D.6 integrated restoration/recovery validation design (`13c5339`) |
| P0063 | 2026-10-01 | INSTALLED / PUSHED — USER-REPORTED RUNTIME PASS | Add integrated D.6 Restoration Check and addon-owned recovery diagnostics (`20b1bf55`) |
| P0064 | 2026-10-01 | INSTALLED / PUSHED | Record assistant delivery workflow failures; restore standard patch procedure (`770f9f30`) |
| P0065 | 2026-10-01 | INSTALLED / PUSHED | Record P0063 runtime PASS; close Phase D; open Phase E / E.1 (`46271f97`) |
| P0066 | 2026-10-01 | INSTALLED / PUSHED | Resolve E.1 compass/navigation capability contract; open E.2 heading compass (`586d188d`) |
| P0067 | 2026-10-01 | INSTALLED / PUSHED — USER-REPORTED RUNTIME PASS | Implement E.2 heading-only world compass + Compass Check (`931f068e`) |
| P0068 | 2026-10-01 | INSTALLED / PUSHED | Record P0067 runtime PASS; close E.2; open E.3 waypoint-bearing proof (`740ebe15`) |
| P0069 | 2026-10-01 | INSTALLED / PUSHED — RUNTIME PROOF PENDING | Add E.3 temporary waypoint capability probe (`9e637d5a`) |
| P0070 | 2026-10-01 | PREPARED — RUNTIME PROOF PENDING | Integrate E.3 waypoint probe with developer panel |
| P0071 | 2026-10-01 | INSTALLED / PUSHED — VERSION METADATA DEFECT | Auto-persist developer-panel diagnostics (`7976d34e`) |
| P0072 | 2026-10-01 | INSTALLED / PUSHED | Correct P0071 version mismatch and record E.3 runtime evidence (`1fc48777`) |
| P0073 | 2026-10-01 | INSTALLED / PUSHED — RUNTIME PASS | Correct E.3 bearing proof to current-map coordinates (`4d4ea878`) |
| P0074 | 2026-10-02 | INSTALLED / PUSHED | Record P0073 PASS; close E.3; open E.4 (`04d79317`) |
| P0075 | 2026-10-02 | INSTALLED / PUSHED — RUNTIME + VISUAL PASS | Implement manual user-waypoint compass marker (`51763025`) |
| P0076 | 2026-10-02 | INSTALLED / PUSHED | Record P0075 PASS; close E.4; open E.5 (`ebb4bbc7`) |
| P0077 | 2026-10-02 | INSTALLED / PUSHED | D-030 minimap stays stock; close Phase E; open Phase F / F.1 (`bf73fcf4`) |
| P0078 | 2026-10-02 | INSTALLED / PUSHED — CAPABILITY EVIDENCE; RESTORATION FAIL | Accept D-031; F.2 quest/XP probe (`8b38fe64`) |
| P0079 | 2026-10-02 | INSTALLED / PUSHED — TARGETED PASS / PRIOR FAILURE UNREPRODUCED | Detail P0078 Restoration Check settle failure (`1aad7bad`) |
| P0080 | 2026-10-02 | INSTALLED / PUSHED — XP RUNTIME PASS / RESTORATION FAIL | Close F.2; implement F.3 contextual XP pulse (`cde9b726`) |
| P0081 | 2026-10-02 | INSTALLED / PUSHED — TARGETED PASS / FAILURE NOT REPRODUCED | Expose TargetFrame restoration reason/error (`ef8fa310`) |
| P0082 | 2026-10-02 | INSTALLED / PUSHED | Record P0081 repeated targeted PASS; F.3 visual acceptance pending (`c6395f10`) |
| P0083 | 2026-10-02 | INSTALLED / PUSHED — F.4 RUNTIME PASS / RESTORATION FAIL | Close F.3 visual PASS; implement F.4 additive NPC quest detail presentation (`484323bb`) |
| P0084 | 2026-10-02 | INSTALLED / PUSHED — RUNTIME PASS | Replace secret IgnoreParentAlpha restoration with selective contextual alpha restoration (`a74329a`) |

| P0085 | 2026-10-02 | INSTALLED / PUSHED | Close F.4 after P0084 runtime + user visual PASS; open F.5 objective/progress proof (`f6a30d8`) |

| P0086 | 2026-10-02 | INSTALLED / PUSHED — PARTIAL F.5 PASS | Record populated incomplete/completed objective rows; same-quest transition pending (`d4e8c39`) |

| P0087 | 2026-10-02 | INSTALLED / PUSHED | Close F.5 same-quest refresh proof; open F.6 contextual objective progress pulse (`4aecb22`) |

| P0088 | 2026-10-02 | INSTALLED / PUSHED — RUNTIME/INTEGRATION PASS; VISUAL FAIL | Implement F.6 contextual objective progress pulse (`228b467`) |

| P0089 | 2026-10-02 | INSTALLED / PUSHED — LIVE SOURCE PASS; PREVIEW REGRESSION; PRODUCTION PULSE UNPROVEN | Move F.6 pulse off action cluster; live source verified (`1781c038`) |

| P0090 | 2026-10-02 | INSTALLED / PUSHED — LIVE PREVIEW PASS; DUPLICATE-COUNT VISUAL FAIL | Show current live objective rows without baseline mutation (`afcc37c`) |

| P0091 | 2026-10-02 | INSTALLED / PUSHED — INTEGRATION PASS; PRODUCTION IDENTITY DEFECT EXPOSED | Normalize objective progress labels (`a2c5e863`) |

| P0092 | 2026-10-02 | INSTALLED / PUSHED — RUNTIME + VISUAL PASS | Use stable count-prefix-free objective identity for production change detection (`5f8e9e96`) |

| P0093 | 2026-10-02 | INSTALLED / PUSHED — DOCS-ONLY | Record P0092 PASS; close Phase F; open Phase G / G.1 (`de30c6f3`) |

| P0094 | 2026-10-02 | INSTALLED / PUSHED — G.1 PASS | Capture current DynamicCam RPG profile; close G.1; open G.2 (`9db11d2b`) |

| P0095 | 2026-10-02 | INSTALLED / PUSHED — OOC CAMERA PASS; COMBAT CLASSIFIER FAIL | Correct DynamicCam zoom semantics; add isolated Camera Zoom Probe (`b65ea1af`) |

| P0096 | 2026-10-02 | INSTALLED / PUSHED — G.2 RUNTIME + INTEGRATION PASS | Use DynamicCam-equivalent live combat classification in camera probe (`a556a19a`) |

| P0097 | 2026-10-02 | INSTALLED / PUSHED — DOCS-ONLY | Record world-first layout, target, status, Active Quest, and action-role direction (`86d062d3`) |

| P0098 | 2026-10-02 | INSTALLED / PUSHED — DOCS-ONLY | Record parallel World Ghost art direction and visual-system workflow (`903e65c8`) |

| P0099 | 2026-10-02 | INSTALLED / PUSHED — DOCS/EVIDENCE ONLY | Record P0096 PASS; close G.2; open G.3 production World/Combat camera ownership (`10c7255f`) |


| P0100 | 2026-10-02 | INSTALLED / PUSHED — FIRST RUNTIME OBSERVATION DEFERRED | Implement G.3 production World/Combat camera ownership (`31a2a7f`) |

| P0101 | 2026-10-02 | INSTALLED / PUSHED — DOCS-ONLY | Record Selective Hybrid E, percentage-bar direction, and full visual component inventory (`86660959`) |
| P0102 | 2026-10-02 | INSTALLED / PUSHED — RUNTIME UI CORRECTION | Organize developer diagnostics by roadmap phase tabs; remove camera checker global version pin (`20ad55ba`) |
| P0103 | 2026-10-03 | INSTALLED / PUSHED — DOCS/EVIDENCE ONLY | Record G.3 runtime + integration PASS; open G.4 City camera ownership review (`4adf400a`) |
| P0104 | 2026-10-03 | INSTALLED / PUSHED — DOCS/SOURCE EVIDENCE ONLY | Resolve G.4 City camera contract; authorize narrow City zoom implementation (`0b676083`) |
| P0105 | 2026-10-03 | INSTALLED / PUSHED — G.4 RUNTIME + INTEGRATION PASS | Extend production camera ownership with City/resting conditional target 5 (`69560080`) |
| P0106 | 2026-10-03 | INSTALLED / PUSHED — DOCS-ONLY | Make full player-facing quest interaction an intended Logres-owned domain; retain Blizzard fail-open fallback until capability-proven (`b2fce832`) |
| P0107 | 2026-10-03 | INSTALLED / PUSHED — DOCS/EVIDENCE ONLY | Record G.4 runtime + integration PASS; open G.5 Taxi camera ownership contract review (`ab83882f`) |
| P0108 | 2026-10-03 | INSTALLED / PUSHED — DOCS/SOURCE EVIDENCE ONLY | Resolve G.5 Taxi source/profile contract; gate production ownership on target-50 capability proof (`19efaad6`) |
| P0109 | 2026-10-03 | INSTALLED / PUSHED — CLEAN NEGATIVE CAPABILITY RESULT | Add Phase G Taxi target-50 read-only-CVar capability probe; target 50 unavailable at factor 1.2 / ceiling 18 (`affb1ace`) |
| P0110 | 2026-10-03 | INSTALLED / PUSHED — DOCS/EVIDENCE ONLY | Record P0109 clean negative; open G.5 camera-distance CVar ownership review (`51c6fbc`) |
| P0111 | 2026-10-03 | INSTALLED / PUSHED — DOCS-ONLY | Freeze health-tunnel visible-field contract; record four-role future navigation/minimap direction and deferred POI/tracking capability audit (`bd0a9da3`) |
| P0112 | 2026-10-03 | INSTALLED / PUSHED — READ-ONLY RUNTIME PASS | Camera Distance Info: current/default 1.2/1, ceilings 18/15, target-50 support false/false (`dea48e04`) |
| P0113 | 2026-10-03 | INSTALLED / PUSHED — DOCS-ONLY | Record D-038 compass visual focus/depth contract (`19c0d1ff`) |
| P0114 | 2026-10-03 | INSTALLED / PUSHED — DOCS/EVIDENCE ONLY | Record P0112 default negative; open above-default account-scoped ownership policy (`f89efd53`) |
| P0115 | 2026-10-03 | INSTALLED / PUSHED — DOCS / DESIGN ASSETS / STATIC CHECKER ONLY | Preserve twelve approved visual sheets; accept D-039; add visual implementation audit (`4ba63931`) |
| P0116 | 2026-10-03 | INSTALLED / PUSHED — CORE RUNTIME + VISUAL PASS; STATE COVERAGE DEFERRED | Establish production media/tokens and wire approved action-button state assets (`c64fcc97`, `0.0.46-dev`) |
| P0117 | 2026-10-03 | INSTALLED / PUSHED — RUNTIME PROOF PENDING | Correct DynamicCam target-50 parity semantics; add production Taxi zoom (`82bdb4f3`, `0.0.47-dev`) |
| P0118 | 2026-10-03 | INSTALLED / PUSHED — RUNTIME + VISUAL PASS | Polish action keybind tag contrast/modifier labels and increase buttons to 42 px (`6fad23f`, `0.0.48-dev`) |
| P0119 | 2026-10-03 | INSTALLED / PUSHED — RUNTIME RETEST PENDING | Replace constant-rate camera motion with frame-shaped MoveView driver (`c342bc17`, `0.0.49-dev`) |
| P0120 | 2026-10-04 | INSTALLED / PUSHED — CORE RUNTIME + VISUAL PASS; ORNAMENT DEFERRED | Add reusable normal/compact percentage-bar primitive (`6c5f8901`, `0.0.50-dev`) |
| P0121 | 2026-10-04 | INSTALLED / PUSHED — PLAYER CAST RUNTIME + VISUAL PASS; TARGET DEFERRED | Translate approved cast-state cue frame/glyph family (`fc928d99`, `0.0.51-dev`) |
| P0122 | 2026-10-04 | INSTALLED / PUSHED — RUNTIME + PREVIEW PATH PASS; COMPLETION VARIANT DEFERRED | Translate approved Context line/diamond visual primitive (`62353ecf`, `0.0.52-dev`) |
| P0123 | 2026-10-04 | INSTALLED / PUSHED — RUNTIME + VISUAL PASS | Assetize approved heading/manual-waypoint Compass treatment while preserving proven source scope (`1721eb4d`, `0.0.53-dev`) |
| P0124 | 2026-10-04 | INSTALLED / PUSHED — RUNTIME + VISUAL BASELINE ACCEPTED; FINAL POLISH DEFERRED | Replace procedural player-health rectangles with organic tunnel masks and deterministic D-036 preview matrix (`1e7e27e`, `0.0.54-dev`) |
| P0125 | 2026-10-04 | INSTALLED / PUSHED — DOCS-ONLY | Synchronize authoritative state through accepted P0124; Active Quest next (`72d2f040`) |
| P0126 | 2026-10-04 | INSTALLED / PUSHED — RUNTIME + VISUAL PASS | Active Quest one-focus presentation; count-free objective labels + bar-only progress + hover exact detail (`89b0c563`, `0.0.58-dev`) |
| P0127 | 2026-10-05 | INSTALLED / PUSHED — DOCS-ONLY | Record P0126 acceptance; open D-035 NPC quest-interaction capability audit (`ef56075d`) |
| P0128 | 2026-10-05 | INSTALLED / PUSHED — DOCS / SOURCE EVIDENCE ONLY | Resolve NPC quest-interaction source layer; P0129 read-only runtime probe next (`0ec74fe5`) |
| P0129 | 2026-10-05 | INSTALLED / PUSHED — READ-ONLY RUNTIME PASS FOR OBSERVED SCOPE | Read-only NPC quest interaction probe; offer/gossip/reward-choice reads PASS, progress/complete deferred, mutation `invoked=0` (`e50676b9`, `0.0.59-dev`) |
| P0130 | 2026-10-05 | INSTALLED / PUSHED — RUNTIME + VISUAL PASS | Bounded/paged quest-offer narrative; R1 restore correction accepted (`ab6473b2`, `0.0.61-dev`) |
| P0131 | 2026-10-05 | INSTALLED / PUSHED — ACCEPT + DECLINE RUNTIME CAPABILITY PASS | Decline proven on `0.0.62-dev`; Accept proven on corrected `0.0.63-dev` with matched event correlation (`68233e64`) |
| P0132 | 2026-10-05 | INSTALLED / PUSHED — RUNTIME + CONTROL PASS; VISUAL ORDER CORRECTION REQUIRED | Production quest-offer controls; mutation/fallback path passes, left/right order opposite Blizzard (`671f9836`, `0.0.64-dev`) |
| P0133 | 2026-10-05 | INSTALLED / PUSHED — RUNTIME + VISUAL PASS | Align offer controls to Blizzard fallback order: Accept left / Decline right (`f2feead6`, `0.0.65-dev`) |
| P0134 | 2026-10-05 | INSTALLED / PUSHED — DOCS-ONLY ACCEPTANCE CHECKPOINT | Record P0133 acceptance and open P0135 aura/status source + priority-policy audit (`93b43d4`) |
| P0135 | 2026-10-05 | INSTALLED / PUSHED — SOURCE + PRIORITY-POLICY LAYER RESOLVED | Pin Forever aura/secrecy source contract, accept D-041, open P0136 read-only runtime probe (`b69eb109`) |
| P0136 | 2026-10-05 | INSTALLED / PUSHED — RUNTIME PROBE PASS WITH ENVIRONMENTAL DEFERRALS | Player helpful ordinary payload/metadata proven; player harmful and populated target categories deferred (`ef769f6`, `0.0.66-dev`) |
| P0137 | 2026-10-05 | INSTALLED / PUSHED — RUNTIME + VISUAL PASS | Production player `HELPFUL|PLAYER` passive aura lane accepted at real UI scale (`2b578759`, `0.0.67-dev`) |
| P0138 | 2026-10-05 | INSTALLED / PUSHED — DOCS-ONLY ACCEPTANCE CHECKPOINT | Record P0137 acceptance; preserve aura deferrals; open P0139 world-attached target source + anchoring/fallback audit (`6392b2e4`) |
| P0139 | 2026-10-05 | INSTALLED / PUSHED — SOURCE + FALLBACK POLICY LAYER RESOLVED | Pin conditional nameplate anchor/reaction/triviality policy; accept D-042; open P0140 read-only runtime probe (`b0122136`) |
| P0140 | 2026-10-05 | INSTALLED / PUSHED — RUNTIME PASS WITH ENVIRONMENTAL ANCHOR/ATTACHMENT DEFERRAL | Safe no-nameplate fallback + ordinary friendly reaction proven; no accessible plate/attachment observed (`f7e2c31d`, `0.0.68-dev`) |
| P0141 | 2026-10-05 | INSTALLED / PUSHED — DOCS/EVIDENCE ONLY; INITIAL ARTIFACT FAILURE PRESERVED | Record P0140 runtime result; preserve world-anchor deferral; open P0142 navigation/minimap source audit (`44720c22`) |
| P0142 | 2026-10-05 | INSTALLED / PUSHED — DOCS / PRIMARY-SOURCE EVIDENCE ONLY | Resolve D-037 navigation/minimap source layer; accept D-043; open P0143 read-only runtime probe (`82682ece`) |
| P0143 | 2026-10-05 | INSTALLED / PUSHED — RUNTIME PASS WITH ENVIRONMENTAL DESTINATION/AREA-POI DEFERRALS; INITIAL ARTIFACT FAILURE PRESERVED | Current-map/player geometry, view radius, and 23/23 tracking selector metadata PASS (`b9b2f90b`, `0.0.69-dev`) |
| P0144 | 2026-10-05 | INSTALLED / PUSHED — DOCS / RUNTIME-EVIDENCE CHECKPOINT | Record P0143 result; open P0145 manual-waypoint comparable-distance / bounded-depth slice (`47534363`) |
| P0145 | 2026-10-05 | INSTALLED / PUSHED — DISTANCE + CLEAR-STATE PASS; DEPTH VARIATION LATER REOPENED | Same-map manual-waypoint distance and clear-state PASS; all accepted samples hit only old near endpoint; cross-band visual depth superseded by P0147 (`60244841`, `0.0.70-dev`) |
| P0146 | 2026-10-05 | INSTALLED / PUSHED — DOCS / RUNTIME-EVIDENCE CHECKPOINT; DEPTH ACCEPTANCE PARTIALLY SUPERSEDED | Record raw P0145 runtime result; depth acceptance later corrected by P0147 (`9606379c`) |
| P0147 | 2026-10-05 | INSTALLED / PUSHED — RUNTIME/MECHANICAL PASS; VISUAL FAIL | Live minimap-radius depth bands work across real samples, but `1.05 -> 0.90` scale is barely perceptible (`c274a9d1`, `0.0.71-dev`) |
| P0148 | 2026-10-05 | INSTALLED / PUSHED — RUNTIME + VISUAL PASS; LATER POLISH DEFERRED | Stronger `1.20 / 1.05 / 0.85 / 0.70` depth amplitude accepted (`6f381a77`, `0.0.72-dev`) |
| P0149 | 2026-10-05 | INSTALLED / PUSHED — SOURCE/CAPABILITY LAYER RESOLVED | Resolve class/pet/special-control source/fallback policy; accept D-044 (`dbe468f7`) |
| P0150 | 2026-10-05 | INSTALLED / PUSHED — R3 RUNTIME PASS WITH ENVIRONMENTAL DEFERRALS | `46e06295`, `0.0.73-dev`: 22/22 events/APIs, pet 10/7 populated, one safe secret skip, zero failures, Run All PASS; initial runtime fail plus R1/R2 pre-write artifact refusals preserved |
| P0151 | 2026-10-05 | INSTALLED / PUSHED — DOCS / RUNTIME-EVIDENCE CHECKPOINT | Record P0150 R3 PASS, 70235 source continuity, and open P0152 secure pet-action execution probe (`b62397b1`) |
| P0152 | 2026-10-06 | INSTALLED / PUSHED — R12 RUNTIME + CONTROL + STATE-PRESENTATION PASS; FINAL VISUAL POLISH DEFERRED | `00aef4a9`, `0.0.74-dev`: default-on pet controls; 10 bindings / 7 readable; 2 active + 1 autocast indicators; user-confirmed button execution; stock PetActionBar retained |
| P0153 | 2026-10-06 | INSTALLED / PUSHED — DOCS / EVIDENCE CHECKPOINT | Record P0152 acceptance and preserve initial world-entry camera timeout (`7ad9be7e`) |
| P0154 | 2026-10-06 | INSTALLED / PUSHED — DIAGNOSTIC PASS; DIRECTION-SWITCH DEFECT IDENTIFIED | `40dec187`, `0.0.75-dev`: timeout preserved; 145 samples, range 0->50, 142 inward + 1 outward command |
| P0155 | 2026-10-06 | INSTALLED / PUSHED — RUNTIME FAIL; REVERSAL PATH NOT EXERCISED | `e9be312d`, `0.0.76-dev`: camera remained at 50; first OnUpdate after ~23.523s; 1 sample, 0 commands, 0 switches |
| P0156 | 2026-10-06 | INSTALLED / PUSHED — OBSERVED NORMAL WORLD-ENTRY RUNTIME PASS | `e1be731b`, `0.0.77-dev`: world ~5.0795 -> target 5, targetReached=true, failures=0; Run All clean |
| P0157 | 2026-10-06 | INSTALLED / PUSHED — DOCS / EVIDENCE + MEMORY-SCHEMA CHECKER HARDENING; TWO DELIVERY FAILURES PRESERVED | `328f1543`: record P0156 observed pass; count actual CURRENT heading lines; temporary-checkout preflight; return G.5 to normal-Taxi landing retest |
| P0158 | 2026-10-06 | INSTALLED / PUSHED — DOCS / ROADMAP SEQUENCING CHECKPOINT | `27670624`: Camera -> Phase H safe suppression/coexistence -> authored positions -> final polish |
| P0159 | 2026-10-06 | INSTALLED / PUSHED — PROFILE/BASE + TAXI ENTRY PASS; DESTINATION ZOOM FAIL | `8ddcf098`, `0.0.78-dev`: Taxi ~49.756/50 PASS; landing City -> 0 with 80 switches; initial pre-write delivery failure preserved |
| P0160 | 2026-10-07 | INSTALLED / PUSHED — RUNTIME PASS; G.5 TAXI ZOOM CONVERGENCE CLOSED FOR OBSERVED SCOPE | `ae75989b`, `0.0.79-dev`: Taxi ~4.01->50 PASS; landing 50->~4.98 PASS; 0 switches; source rebase exercised both ways; delivery failures preserved |
| P0161 | 2026-10-07 | PREPARED — CAPTURED PROFILE ROTATION + CAMERA-SETTING PARITY | Candidate `0.0.80-dev`: five source-backed rotations + rotate-back; dynamic-pitch/focus; shoulder curves; City max factor 1; exact CVar restoration |
| P0187 R0/R1/R2 | 2026-10-09/10 | R0 RUNTIME FAILED ON/OFF/ON; R1 DELIVERY FAILED; R2 CORRECTIVE CANDIDATE, WoW PENDING | First ON/OFF succeeded, repeat ON failed stale `state-logresmode` / Main gate; R1 resets addon-owned secure state out of combat, `0.0.100-dev`; preserve failure and retest |
| P0188 | 2026-10-10 | DOCS ACCEPTANCE — P0187 R2 MANUAL NORMAL-MODE RUNTIME PASS | P0187 R2 verified `41c7d97`, `0.0.100-dev`; repeat ON/OFF succeeds, Run All Main 7/6 no errors; special/default H.1 still gated; P0188 R0 whitespace prewrite FAIL, R1 repaired; preserve P0187 R0/R1 failure |
| P0189 | 2026-10-11 | INSTALLED / PUSHED — OBSERVED AUTOMATIC NORMAL MAIN RUNTIME PASS | `bd0c36a`, `0.0.101-dev`, loadCount 239: automatic CANDIDATE, OFF STOCK/ON CANDIDATE; Run All Main 7/6 error=nil, Primary 12/12; special/combat modes deferred |
| P0190 | 2026-10-11 | PREPARED — DOCS ACCEPTANCE; H.2 OPEN | Accept bounded P0189 normal startup, preserve special deferrals/history; next P0191 realistic whole-screen layout spacing/collision audit |
| P0191 | 2026-10-11 | INSTALLED / PUSHED — APPROVED V4 DESIGN, NO RUNTIME GEOMETRY | Save exact v4 13-rectangle percent map, D-045, layout contract + memory; Main Y=60.4 matches Secondary; runtime translation P0192 pending user push |

| P0192 | 2026-10-11 | INSTALLED / PUSHED — R1 READ-ONLY GEOMETRY MEASUREMENT PASS; R0 DELIVERY FAIL RETAINED | `3777620` / `0.0.102-dev`, loadCount 242; Phase H Layout Check 16/23/0 PASS, H2 13/13 actual geometry measured, Run All complete; no anchor mutation or collision proof |
| P0193 | 2026-10-11 | INSTALLED / PUSHED — R2 EVIDENCE ACCEPTED; R0/R1 DELIVERY FAILS RETAINED | `213c526`: P0192 13/13 runtime measurement durable; no geometry moved; R0 version policy/R1 EOF fail kept |
| P0194 R0/R1/R2/R3 | 2026-10-11 | R0 VISUAL FAIL / SUPERSEDED; R1 CHECKER DELIVERY FAIL / R2 SLASH-ONLY VIEW REJECTED / R3 PANEL MAP CANDIDATE | User screenshot rejected isolated player-only placement; R1 shadow checker expected wrong viewport variable names (no tracked writes); R3 integrates all 13 approved+actual regions in Phase H panel without removing any existing actions; fullscreen overlay remains mouse-transparent; R0 visual/R1 prewrite failures retained |

This index is initially maintained manually. If patch volume grows, replace manual transcription with a generated index and record that decision.
| P0195 | 2026-10-11 | PREPARED — ONE-PASS H2 V4 GEOMETRY / RUNTIME PROOF OPEN | `f7a67bc` panel-map PASS; viewport anchor translation and action/aura reflow; secure/native fallback retained; WoW screenshot / interaction checks pending |
| P0196 R0/R1 | 2026-10-11 | R0 DOCS-ONLY REJECTED/UNPUSHED; R1 NATIVE GATE CANDIDATE | `9097f43` v4 user visual accepted; suppress stock pet/auras only with Logres secure/native replacement; native restore buttons; no Damage Meter changes; runtime OPEN |
| P0196 R2 | 2026-10-11 | PREWRITE FAIL — check_memory_health.py missing handoff CURRENT.md / NOT PUSHED | Intended: Restore P0195 authored Logres player buffs and target lanes, remove 18px native takeover; target contextual fold deferred, pet candidate retained, user acceptance OPEN |
| P0196 R3 | 2026-10-11 | CORRECTIVE CANDIDATE — R2 checker-memory prewrite FAIL / NOT PUSHED | Preserve R1 runtime failures and R2 prewrite failure, fix handoff authority pointer, restore P0195 authored buff art; runtime acceptance OPEN |
| P0196 R4 | 2026-10-11 | INSTALLED / PUSHED c89692b — TARGET AURA VISUAL PASS; PET RESHOW OPEN | R3 player/target buffs visually restored but Blizzard contextual target aura persisted; replace failed OnShow approach with target native ConfigureAuraContainer 0/0 and opaque restore; tests OPEN |
| P0197 | 2026-10-11 | INSTALLED / PUSHED `0a20eef` — ORDINARY RE-FOLD OBSERVED; COMBAT RECOVERY UNTESTED | `0.0.108-dev` loadCount 253 four OnShow/four immediate refolds, zero combat deferrals/recoveries, user no duplicate; original intermittent issue OPEN. |
| P0198 | 2026-10-11 | PUSHED `ed6ca7b` — DOCS-ONLY OBSERVATION RECORDED | P0197 ordinary refolds observed; combat recovery not exercised and original intermittent pet-bar recurrence remains open. |
| P0199 R0/R1 | 2026-10-11 | R0 PREWRITE FAIL / R1 PUSHED `7064ea88` — DOCS-ONLY FIDELITY AUDIT | R0 truncated expected PATCH_INDEX blob SHA (39 instead of 40 hex chars), no tracked writes; R1 corrects SHA and guards pinned hashes. Audit all 12 approved sheets; no runtime edits. |
| P0200 R0/R1 | 2026-10-11 | R0 SHADOW PREWRITE FAIL / R1 PUSHED `9776cf9` — NORMAL DIAGNOSTIC PASS, VISUAL REVIEW OPEN | `0.0.109-dev` loadCount 256 Run All complete, Layout 19/29/0, Status Aura Preview ON/OFF, Native Access PASS, UI Ownership 17/18/0; no screenshot/multi-harmful visual proof; R0 obsolete 18px checker prewrite FAIL retained |
| P0201 R0/R1 | 2026-10-11 | R0 PREWRITE FAIL / R1 PUSHED `826ff576` — DOCS-ONLY P0200 BOUNDED RUNTIME RECORD | `9776cf9` pushed; accept actual diagnostic checks only, preserve H.3 visual and harmful-population deferrals; R0 truncated 39-digit ROADMAP blob pin rejected before writes; R1 fixed; no code/art/coordinate change or redeploy |
| P0202 | 2026-10-11 | PUSHED `3aa21829` — DOCS-ONLY H.3 SCREENSHOT VISUAL REVIEW | P0201 R1 `826ff57` baseline; 1907x1192 ordinary visual evidence: quest/dock separated, player-buff art intact, no obvious clipping/duplicate pet bar; faint compass labels and visually heavy vacant action slots are bounded polish candidates. Harmful native two-column fit and interaction still DEFERRED; no runtime change. |
| P0203 | 2026-10-11 | PUSHED `5c28c2df` — DOCS-ONLY COMBAT PET BAR REPRODUCTION + DIALOGUE OBSERVATION | P0202 `3aa21829` baseline. User combat screenshot and report confirm smaller Blizzard PetActionBar row reappears in combat over Logres controls: P0197 OPEN / REPRODUCED IN COMBAT. Existing native OnShow hook defers Hide in combat; exact event/counters unknown. NPC green label obscures dialogue text, ownership unknown; target effect icons visible but native two-column provenance untested. Request Phase H Native Access Check during visible overlap and post-combat; no runtime change/deploy. |
| P0204 | 2026-10-11 | PUSHED `566bb8b5` — DOCS-ONLY P0197 COMBAT RECOVERY EVIDENCE | P0203 `5c28c2df` baseline; loadCount 260 nativeuicheck DEFERRED with onShow=2/combatDeferred=1/immediate=1/recovered=0/awaiting=true, later Run All recovered=1/awaiting=false. Recovery PASS bounded; combat duplicate FAIL/OPEN, secure combat-safe source audit next; no runtime changes. |
| P0205 | 2026-10-11 | PUSHED `79a8e230` — DOCS-ONLY EXACT FOREVER PET COMBAT SOURCE AUDIT | P0204 `566bb8b5` baseline, exact upstream Forever `943764493e6b` build 70338: native PetActionBar OnEvent Show, Edit Mode protected root, secure visibility driver available; unsafe combat Hide rejected, hidden-parent or visibility handoff requires default-OFF runtime proof and fallback. No Lua/art/version change. |
| P0206 R0–R6 | 2026-10-11 | R0 PREWRITE FAIL / R1 REJECTED / R2 RUNTIME FAIL / R3 CHECKER PREWRITE FAIL / R4 PAYLOAD PREWRITE FAIL / R5 RUNTIME RESTORE FAIL / R6 RUNTIME FAIL / INTERMITTENT PET RESTORE | Last pushed P0205 `79a8e230`. R5 loadCount 262 trial quarantined/armed=false but older NativeSurfaceReplacement still petActions:folded; user reports no Blizzard pet bar after Immersion OFF. R6 returns false for petActions native readiness to stop folding stock bar; source-only candidate `0.0.112-dev`, complete static and WoW confirmation still needed. Preserves six-row Phase H and all failures. Original P0197 duplicate OPEN. |
| P0207 | 2026-10-13 | PUSHED `f080661b` — DOCS-ONLY PET UI FULL LIFECYCLE AUDIT | P0205 pushed baseline, P0206 R6 local uncommitted runtime failure; exact 70338 PetFrame and PetActionBar / Edit Mode source, user loadCount 265, intermittent native restoration and all P0206 R0–R6 negatives preserved. Next fail-open PetFrame+PetActionBar and visual interaction proof. No runtime edits. |
| P0208 | 2026-10-13 | R0 PREWRITE FAIL (WRONG HEAD PATCH_INDEX BLOB PIN) / R1 PREWRITE FAIL (INCORRECT QUARANTINE SOURCE CHECK) / R2 PUSHED `f6b9a3a` — STOCK PET FALLBACK VISUALLY RETURNED; IMMERSION ON DUPLICATE OPEN | Based on pushed P0207 `f080661b` and local uncommitted R6; 0.0.113-dev disables both stock pet surface folds, retains 18 Phase H controls and separate dock PET STOCK label, records native source policy but physical visibility UNVERIFIED. R6 intermittent pet restore and P0197 combat duplicate remain OPEN; no native protected mutation added. |
| P0209 | 2026-10-13 | R0 PREWRITE FAIL (INVALID MEMORY SCHEMA) / R1 PREWRITE FAIL (61/60 LUA UPVALUES) / R2 RUNTIME FAIL (COMBAT SWAP REJECTED) / R3 RUNTIME FAIL (EDIT MODE GATE) / R4 RUNTIME FAIL (EDITMODE INITIAL NIL) / R5 RUNTIME VISUAL FAIL / R6 STAGING PASS / R7 MECHANICS PASS BUT WRONG DIRECTION / R8 PREPARED CORRECT DIRECTION | Parent pushed P0208 `f6b9a3a`; native bar `[combat] show; hide`, Logres pet cluster `[combat] hide; show`; no direct Hide, no hidden ancestor, preserved native PetFrame. Reuse 3 of 18 Phase H trial buttons; no auto-arm or protected mutation in combat. Native release, Edit Mode, clicks and combat remain runtime UNVERIFIED. All prior failures preserved. |
| P0210 | 2026-10-14 | LOCAL / DOCS+GITIGNORE ONLY — R8 VISIBILITY OBSERVED, OTHER RUNTIME UNVERIFIED | Ignore temporary appliers/payload/Zone.Identifier files without deleting any source; preserve all P0209 implementation, evidence and manifest files; R8 stock already absent after immersion-on reload and after OFF/ON; combat and full interaction unverified. |
| P0211 | 2026-10-14 | PREPARED / RUNTIME UNTESTED — RELOAD PET VISIBILITY FAIL OBSERVED | Correct P0210 false reload-PASS; R8 off/on, combat, Edit Mode presentation preserved. Add readiness-edge handoff + startup reason diagnostics, without native protected-state inspection or polling. See P0211 evidence. |
| P0212 | 2026-10-15 | PREPARED DOCS-ONLY — P0211 VISUAL ACCEPTANCE | Accepted P0211 tested reload/Immersion/combat pet visibility; recorded first-world readiness evidence and panel-first/Bartender4-Dominos source-first process; no runtime mutation. Upstream P0211 push still unverified at preparation. |
| P0213 | 2026-10-15 | PREPARED / H.3 RUNTIME UNTESTED | Compass label contrast/shadow polish; preserves geometry and pet-state ownership |
| P0214 | 2026-10-15 | PREPARED ASSET CANDIDATE — WoW UNVERIFIED | Derived five shared 64px action state assets from approved sheet 03, no hitbox/layout/pet changes; P0213 pushed `18dee5f`, source-first visual fidelity required; panel validation pending. |
| P0215 | 2026-10-16 | R1 REPAIRED CANDIDATE — R0 PREWRITE FAIL, WoW UNVERIFIED | Approved sheet 02 neutral shared percentage bar fill/diamond and sheet 10 one-focus parchment/divider/glyph derivatives; P0214 pushed and visually accepted in observed scope; 5 existing TGA assets, no gameplay/geometry/pet changes. |
| P0216 | 2026-10-16 | PREPARED VISUAL CANDIDATE — WoW UNVERIFIED | User-directed removal of cluster-wide backplate; separate 268px player resource style without target/quest bar growth; clear ready/complete Active Quest rail/seal/title, secure/stock policy unchanged. |
| P0217 | 2026-10-16 | PREPARED VISUAL CANDIDATE — WoW UNVERIFIED | Sheet-03-derived bronze dock and native fallback skins; sparse target/pet/ally identity accents; no native interaction, bar, secure source or v4 geometry changes. |
| P0218 | 2026-10-16 | PREPARED VISUAL CANDIDATE — WoW UNVERIFIED | Approved sheet-04 StatusAuras: lower-right stack backing plate and urgent-only thin accent; existing assets reused; no aura membership/secret/stock controls change. |
| P0219 | 2026-10-16 | PREPARED COMPASS VISUAL/CAPABILITY GATE — WoW UNVERIFIED | Add approved sheet-12 quest/POI/tracking glyphs + developer-only vertical-lane art preview; no unproven production positions, stock minimap unchanged. |
| P0220 | 2026-10-16 | PREPARED NAVIGATION SOURCE PROBE — WoW UNVERIFIED | Classify nearby available unaccepted quests as local POIs; optional bounded quest-line API and live compass local-POI candidate; no invented location, unsupported quest offers, or minimap suppression. |
| P0221 | 2026-10-16 | PREPARED SOURCE-EMPTY CORRECTION — WoW UNVERIFIED | P0220 loadCount 291 returned 0 availableQuestLines/AreaPOIs and user saw no live markers; one guarded map-keyed quest-line request, no polling, explicit negative-evidence and fallback. |
| P0222 | 2026-10-16 | PREPARED MULTI-SOURCE NAVIGATION CANDIDATE — WoW UNVERIFIED | P0221 locally showed no non-waypoint markers after quest-line request; add GetQuestsOnMap and vignette position providers, consume AreaPOIs and quest line fallback with exact waypoint bearings; no native pin inspection, timers or minimap suppression. |
| P0223 | 2026-10-16 | PREPARED RUNTIME CANDIDATE — WoW UNVERIFIED | First user-verified accepted quest bearings and quest name from P0222; fix excess major quests by rendering only supertracked focused ID and add waypoint-derived distance scale; POI/tracking source coverage remains OPEN. |
| P0224 | 2026-10-16 | INSTALLED / PUSHED (`d4a39d1`) | QuestieDB source feasibility audit; no runtime dependency. |
| P0225 | 2026-10-16 | INSTALLED / PUSHED WITH P0226 (`45bbd0e`); LIVE POIs NOT PROVEN | Native force/task/hub feeds returned ordinary-empty in live test; no visible POI markers. |
| P0226 | 2026-10-16 | INSTALLED / PUSHED (`45bbd0e`); QUESTIEDB DEFERRED | Optional read-only database source compatibility probe; 0.0.134-dev reports provider not installed and no gossip positive proof; no markers expected. |
| P0227 | 2026-10-16 | INSTALLED / PUSHED (`7c6850b`); DOCS-ONLY | Document exact QuestieDB Forever installation, optional-dependency status, hidden-quest coverage limitations and CurseForge/license/public packaging gates. |
| P0228 | 2026-10-17 | INSTALLED / PUSHED WITH P0230 (92de16d); PROVIDER RUNTIME PASS | QuestieDB optional load ordering, standalone provider state, and Baked X-Flavor verification; no new compass markers. |
| P0229 | 2026-10-17 | INSTALLED / PUSHED (d010f64); DOCS-ONLY | Record QuestieDB installed-state misdiagnosis, stale/no-op probe, missing Phase E panel handoff, P0228 R0 failed pre-write hygiene, and panel-first instruction rule. |
| P0230 | 2026-10-17 | INSTALLED / PUSHED (92de16d); INITIAL MAP FAIL, LATER SOURCE PASS AFTER PANEL RETRY | Dynamic QuestieDB canonical-map 50-yard possible-quest-giver source; abandon Loch Modan-only proposal, native-first fail-open, no live blip claim. |
| P0231 | 2026-10-17 | INSTALLED / PUSHED (968675a); LIVE SOURCE / RENDER STATE PASS AFTER PANEL RETRY | P0230 failure recorded; bounded canonical map ancestry and provider-count diagnostics; no invented AreaIDs or hidden minimap fallback. |
| P0232 | 2026-10-17 | INSTALLED / PUSHED (ca639c9); DOCS-ONLY | Verify P0231 0.0.137-dev nearby candidate scan + 2 glyphs; automatic startup remains OPEN |
| P0233 | 2026-10-17 | INSTALLED / PUSHED (27e9e36); DOCS-ONLY / UNASSISTED STARTUP PASS | Record load 307 provider ready before manual retry, two addon-owned glyphs and one user-observed physical quest-giver route; preserve remaining coverage limits. |
| P0234 | 2026-10-17 | PREPARED / DOCS-ONLY / UPSTREAM API AUDIT | Native-first glyph priority, QuestieDB v4 NPC service role masks and bounded possible service implementation plan; no runtime changes. |
| P0235 | 2026-10-17 | PREPARED / RUNTIME UNVERIFIED | Fix quest-only gate for flight master, innkeeper, repair; separate v4 service glyphs, one marker per dual-role NPC; preserve quest v1 and hidden minimap. |
| P0236 | 2026-10-17 | INSTALLED / RUNTIME PASS | Verified pushed `e6179b8`; load 311 nearby services and proximity scaling passed; historical quest relevance and final styling OPEN (see P0237 evidence). |
| P0275 | 2026-10-19 | PUSHED (`75e8024`), VISUAL FAIL | 640x540 quest-art wrapper produced a disjoint empty surround; see P0276 evidence. |
| P0276 | 2026-10-19 | PREPARED / WSL & WoW UNVERIFIED | Disable failed overlay; reuse H native frame audit for secret-safe bounded trainer inventory; preserve stock UI and restoration. |
| P0276 R1 | 2026-10-20 | PREPARED / WoW UNVERIFIED | Correct diagnostic-only R0; H ON/OFF native trainer skin trial, P same-painter preview, H pagination, native audit, guarded reversible root decoration alpha and no transactions. |
| P0276 R2 | 2026-10-20 | PREPARED / WoW UNVERIFIED | R1 refusal on dirty P0275 worktree: support exact prior R0 candidate only, preserve unrelated files; same R1 opt-in trainer skin/panel tests; full WSL and WoW gates pending. |
| P0276 R3 | 2026-10-20 | PREPARED / WSL & WoW UNVERIFIED | R2 prewrite failed checker 109/144 on contradictory stale secret-order assertion; fixed source/checker parity and aggregate failure reports. R1/R2 assistant failures preserved. |
| P0276 R4 | 2026-10-20 | PREPARED / WSL & WoW UNVERIFIED | R3 PREWRITE 1/144 checker failure: CURRENT_HANDOFF.md lacked CURRENT.md; repair generated reference + preflight, no runtime changes, preserve failures. |
