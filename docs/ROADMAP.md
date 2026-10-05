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

P0132 is next: production Logres offer Accept / Decline controls with Blizzard
controls retained as visible fallback during proof. Only after that replacement
surface is proven may a later checkpoint consider suppression.

Continue / Complete, reward selection, progress/completion presentation, and
gossip mutation remain separately gated.

D-037 unproven navigation/minimap roles, aura ownership, world-target anchoring,
and other capability expansions remain separately gated.
