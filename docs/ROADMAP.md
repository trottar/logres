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

**Status: ACTIVE — G.3 Production World/Combat camera ownership.**

G.1 captured the current DynamicCam `RPG` profile durably.

G.2 established and runtime-proved the first camera capability contract:
- World conditionally targets zoom 5 when farther away;
- World (Combat) conditionally targets zoom 15 when closer;
- ordinary transitions use 2.5 seconds;
- zoom restore is `never`;
- the primary `GetCameraZoom` + `MoveView*Start/Stop` path works out of combat
  and in live DynamicCam-equivalent combat on `0.0.40-dev`.

P0096's two live-combat probes also recorded `cachedCombat=false` while live
`UnitAffectingCombat("player")` and lockdown were true. That mismatch is retained
as evidence that production camera context must use the actual live DynamicCam
predicate rather than cached Logres combat state.

G.3 now implements production World/Combat ownership from the proven contract,
without adopting the unproven temporary-CVar fallback and without allowing
DynamicCam and Logres to drive camera movement simultaneously.

Canonical phase record:
`memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`

## Phase H — Integration and Polish

**Status: QUEUED.**

D-032 records the accepted world-first integration direction: authored semantic
regions, optional Active Quest, shared transient Context, fixed Primary plus
Secondary/Utility source-role assignment, separate class/pet controls,
world-attached target presentation as the intended default, and status placement
by owner/urgency.

Logres owns its aesthetic rather than becoming a general UI/action-bar profile
editor. Limited safe layout presets may be considered; unrestricted layout can
use stock/specialist addons with the Logres action presentation disabled.

Parallel art-direction / mockup work may proceed before Lua integration. Current
preferred working hypothesis: World Ghost — simple, immersive, Warcraft-native,
with a subtle Logres / Camelot inflection.

Canonical phase record:
`memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
