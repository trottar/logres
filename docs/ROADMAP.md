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

P0129 prepares that read-only NPC quest interaction runtime capability probe on
`0.0.59-dev`. The next gate is in-client evidence from natural NPC quest/gossip
states before any Logres-owned quest controls or Blizzard quest/gossip suppression.

D-037 unproven navigation/minimap roles, aura ownership, world-target anchoring,
and other capability expansions remain separately gated.
