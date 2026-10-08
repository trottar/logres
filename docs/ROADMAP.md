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

**Status: ACTIVE — P0165 QUEST-OFFER STOCK SUPPRESSION RUNTIME GATE; AUTHORED LAYOUT THEN FINAL POLISH.**

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

P0165 is prepared on candidate `0.0.82-dev` as the first new suppression slice. Exact Forever `1.60.1.70245` source backs alpha+mouse suppression/restoration of the **stock quest-offer Accept/Decline controls only** for ordinary non-PvP/non-auto-accept offers. PvP-confirmation, auto-accept, hidden/gamepad, missing/secret/unreadable, and unsafe protected/combat states fail open. This does not authorize hiding the QuestFrame root or any progress/complete/reward/gossip surface. Runtime evidence is required before H.1 closes.


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
