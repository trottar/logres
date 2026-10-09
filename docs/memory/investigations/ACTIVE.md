## H.1 reopened — remaining redundant Blizzard UI (P0168)

P0168 R0 failed in the shadow checker before tracked writes: the new contract demanded a non-existent `visualSnapshot =` assignment while generated source correctly used `local visualSnapshot, visualError =`. R1 corrects the self-mismatch and removes the unneeded `QUEST_ITEM_UPDATE` restore trigger, because Blizzard processes that event without leaving an ordinary quest offer. The prior failed delivery is preserved as negative evidence.

The user correctly identified that the previous closure counted D/C suppression as if Phase H itself had finished hiding the UI. P0165 suppressed only Accept/Decline. P0168 now targets the remainder of *supported ordinary quest-offer* presentation, not an unsupported quest state. This is candidate work; no runtime PASS until manually observed. Main/override/special actions, pet, party, minimap, persistent XP, full tracker, nameplates, class-resource, unsupported auras, and reward/continue/complete/gossip remain source/capability gated per D-023/D-031/D-044. No blanket frame hider is authorized. The existing P0164 matrix remains a blocker inventory, not a completed-removal claim.

# Active Investigations

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
