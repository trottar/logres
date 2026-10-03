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

**Status: ACTIVE — G.2 World/Combat camera zoom capability.**

G.1 captured the current DynamicCam `RPG` profile durably.

G.2 source review corrected the profile interpretation:
- World conditionally targets zoom 5 when farther away;
- World (Combat) conditionally targets zoom 15 when closer;
- ordinary transitions use 2.5 seconds;
- zoom restore is `never`.

The first runtime capability proof uses the primary camera mechanism:
`GetCameraZoom` + `MoveView*Start/Stop`, with read-only `cameraZoomSpeed`.

P0095 proved the reversible primary camera path out of combat, but its combat
classifier used cached Logres state rather than DynamicCam's live
`UnitAffectingCombat("player")` predicate. P0096 corrects only that diagnostic
classification; one live-combat proof remains before automatic ownership.

Canonical phase record:
`memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`

## Phase H — Integration and Polish

**Status: QUEUED.**
