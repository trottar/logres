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

G.2 runtime-proved the first camera capability contract: conditional World 5,
conditional World (Combat) 15, ordinary 2.5-second transitions, zoom restore
`never`, and the primary `GetCameraZoom` + `MoveView*Start/Stop` path in live
combat.

P0096 also proved why production combat selection must use live
`UnitAffectingCombat("player")` rather than cached Logres combat state.

P0100 is pushed at `31a2a7f` and implements the first production controller at runtime `0.0.41-dev`:
- event/state-driven World/Combat ownership;
- targeted live-combat reevaluation;
- primary MoveView transitions only;
- explicit interruption/fail-open behavior;
- DynamicCam coexistence gating;
- no temporary-CVar fallback.

G.3 remains open pending current-runtime production evidence.

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
