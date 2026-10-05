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

**Status: ACTIVE — G.5 OPEN / PAUSED FOR APPROVED VISUAL TRANSLATION.**

G.1 through G.4 are runtime-proven.

G.5 established that Taxi target `50` is a requested DynamicCam/LibCamera target
that may be engine-clamped without requiring max-distance CVar mutation.

P0117 proved Taxi entry but exposed a shared post-Taxi destination overshoot:
City `18 -> 5` reached zoom `0`.

P0119 is durable at `c342bc176a9d5de80ec116d0c6b31fa595cd75b3`
on `0.0.49-dev` and replaces the constant-rate driver with frame-shaped MoveView
motion plus bounded target correction.

The normal-Taxi landing retest has not been durably recorded as PASS. Camera work
is explicitly frozen until the current approved visual translation sequence is
finished. No SetCVar, Taxi rotation, or Taxi UI fade is authorized.

Canonical phase record:
`memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`

## Phase H — Integration and Polish

**Status: QUEUED — approved visual translation underway in parallel.**

D-039 preserves the approved twelve-sheet World Ghost / Selective Hybrid E visual
baseline. D-040 defines `Logres/Media/` plus `Theme.lua` as the runtime asset/token
boundary.

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

P0144 is durable at `47534363`. P0145 is prepared on candidate `0.0.70-dev`:
manual-waypoint comparable-distance / bounded-depth integration only. It preserves
the proven bearing, requires ordinary same-map geometry for yard distance, fails
open to the fixed marker when distance is unavailable, and adds no distance label
or new navigation role. Runtime + visual proof is pending. Stock minimap
presentation remains available until the replacement gate is actually proven.
