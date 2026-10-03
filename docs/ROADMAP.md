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

**Status: ACTIVE — G.4 City camera ownership implementation.**

G.1 captured the current DynamicCam `RPG` profile durably.

G.2 runtime-proved the primary camera capability and correct conditional zoom
semantics in real combat.

G.3 production World/Combat ownership is closed with runtime + integration PASS
on `0.0.42-dev`.

G.4 source/profile review resolves the City camera contract. P0105 prepares
runtime `0.0.43-dev` by selecting City from resting after live-combat precedence
and reusing the proven conditional target-5 / 2.5-second MoveView path. Runtime
acceptance is the next narrow checkpoint.

City UI hide/fade, City/global CVar ownership, reactive zoom, startup instant
transition parity, and later DynamicCam situations remain separately gated.

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
