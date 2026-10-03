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

**Status: ACTIVE — G.4 City camera ownership contract review.**

G.1 captured the current DynamicCam `RPG` profile durably.

G.2 runtime-proved the primary camera capability and correct conditional zoom
semantics in real combat.

G.3 production World/Combat ownership is closed with runtime + integration PASS.
P0100 supplies the controller; final acceptance on P0102 runtime `0.0.42-dev`
proved World transition/no-op, live-combat transition/no-op, combat-exit World
evaluation, disable interruption, Run All integration, and DynamicCam
coexistence blocking.

G.4 now reviews the City/resting camera contract from the already-captured
profile. Runtime code waits until City precedence, transition/zoom behavior, and
the separation between camera ownership and DynamicCam UI hide/fade behavior are
explicit.

Canonical phase record:
`memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`

## Phase H — Integration and Polish

**Status: QUEUED.**

D-032 records the accepted world-first integration direction. D-033 permits
parallel art-direction/mockup work. D-034 refines the current visual anchor to
Selective Hybrid E: World Ghost restraint, authored ornament on meaning-heavy
surfaces, simple high-density interaction controls, and a shared percentage-bar
primitive for percentage-based Logres-owned values except player health.

Canonical phase record:
`memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
