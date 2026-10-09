# Project Logres Roadmap

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

**Status: ACTIVE — H.1 REOPENED FOR REDUNDANT STOCK PRESENTATION; H.2 LAYOUT AFTER SUPPRESSION.**

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
