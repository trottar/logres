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

Established heading compass, manual user-waypoint compass marker, fail-open navigation, and Blizzard-owned stock minimap.

## Phase F — Quest Experience

**Status: COMPLETE.**

Contextual XP, additive NPC quest detail, objective capability proof, and
contextual objective progress are runtime-proven.

Deferred boundaries remain deliberate:
- stock Objective Tracker remains Blizzard-owned;
- quest interaction controls remain Blizzard-owned;
- quest compass marker remains unsupported without a runtime-proven
  destination.

Canonical phase record:
`memory/roadmap/PHASE_F_QUEST_EXPERIENCE.md`

## Phase G — Cinematic Camera

**Status: ACTIVE — G.2 World/Combat camera zoom capability.**

G.1:
complete. The user's current DynamicCam `RPG` profile is preserved as durable
evidence.

Captured enabled contexts:
- City;
- World;
- World (Combat);
- Taxi;
- Hearth/Teleport;
- NPC Interaction;
- Fishing;
- AFK;
- Gathering.

There is no explicit enabled instance camera situation in the captured profile.

G.2:
source-audit and runtime-prove the narrow World/Combat zoom path before
production implementation.

Target behavior:
- World: zoom in by 5;
- World (Combat): zoom out by 15;
- 2.5-second enter transitions;
- no UI-hide or rotation behavior in this first slice.

Canonical phase record:
`memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`

## Phase H — Integration and Polish

**Status: QUEUED.**

Unified settings, profiles, visual consistency, performance, accessibility/configurability, packaging, release documentation, and compatibility testing.
