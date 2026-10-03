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

**Status: ACTIVE — G.5 camera-distance ownership review.**

G.1 captured the current DynamicCam `RPG` profile durably.

G.2 runtime-proved the primary camera capability and conditional zoom semantics.

G.3 World/Combat production ownership is runtime + integration PASS.

G.4 City/resting ownership is runtime + integration PASS on `0.0.43-dev`.

G.5 source/profile review is resolved. P0109 runtime `0.0.44-dev` then proved a
clean negative for target 50 under the accepted no-CVar-mutation boundary:
current factor `1.2`, effective ceiling `18`, outbound turn zoom `18`, target not
reached, restoration successful, CVar unchanged, no secret-value result.

Production Taxi ownership therefore remains fail-open.

The next checkpoint is a source/contract review of camera-distance CVar ownership,
not a production Taxi implementation and not a clamped target.

Canonical phase record:
`memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`

## Phase H — Integration and Polish

**Status: QUEUED.**

D-032 records the accepted world-first integration direction. D-033 permits
parallel art-direction/mockup work. D-034 refines the visual anchor to Selective
Hybrid E and the shared percentage-bar direction.

D-035 establishes NPC quest interaction as a future Logres-owned experience with
Blizzard fail-open fallback until each replacement capability is proven.

Canonical phase record:
`memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
