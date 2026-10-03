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

**Status: ACTIVE — G.5 camera-distance product/ownership policy after default negative.**

G.1 captured the DynamicCam profile.

G.2 primary camera capability is runtime-proven.

G.3 World/Combat production ownership is PASS.

G.4 City/resting ownership is PASS.

G.5 P0109 proved target 50 is unavailable with current factor 1.2 / ceiling 18
under the no-CVar-mutation boundary.

The follow-up source audit shows the captured DynamicCam Taxi target does not
itself raise max-distance: DynamicCam inherits the client default for its
standard max-distance setting, and that default was not captured by G.1 or
measured by P0109.

P0112 runtime `0.0.45-dev` then measured current factor `1.2` / ceiling `18`
and client default factor `1` / ceiling `15`; both report target-50 support false.
The CVar is account-stored and is not reported locked, secure, or read-only.

The next checkpoint is a product/ownership contract for any temporary
above-default max-distance mutation before any SetCVar probe.

Production Taxi remains fail-open.

Canonical phase record:
`memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`

## Phase H — Integration and Polish

**Status: QUEUED.**

D-032/D-033/D-034 define the accepted world-first / Selective Hybrid E visual
direction.

D-035 establishes NPC quest interaction as a future Logres-owned experience with
Blizzard fail-open fallback until each replacement surface is proven. D-036
freezes the continuous health-tunnel visible-field contract. D-037 defines the
future four-role navigation/minimap endpoint while preserving the current D-030
stock-minimap boundary until all required capabilities are proven. D-038 defines
the accepted compass focus/depth visual contract under the same capability gates.
D-039 preserves the approved twelve-sheet visual baseline and shifts covered Phase-H
visual work toward production asset/runtime translation rather than broad concept
exploration.
