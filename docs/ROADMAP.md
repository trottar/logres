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

Completed:
- F.1 passive quest/XP versus Blizzard control contract;
- F.2 runtime capability proof;
- F.3 contextual XP pulse;
- F.4 additive NPC quest detail presentation;
- F.5 objective/progress capability proof;
- F.6 contextual objective progress pulse.

Final F.6 evidence:
P0092 (`5f8e9e96`) produced one production pulse for one natural same-quest
objective change, with a matching live Quest Probe update and user visual
acceptance.

Deferred boundaries remain deliberate:
- stock Objective Tracker remains Blizzard-owned;
- quest interaction controls remain Blizzard-owned;
- quest compass marker remains unsupported without a runtime-proven
  destination.

Canonical phase record:
`memory/roadmap/PHASE_F_QUEST_EXPERIENCE.md`

## Phase G — Cinematic Camera

**Status: ACTIVE — G.1 current DynamicCam profile capture.**

Before camera implementation:
- obtain a fresh current DynamicCam export/profile;
- preserve exact settings durably;
- map configured context behavior;
- do not reconstruct exact values from old uploads or conversation.

Canonical phase record:
`memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`

## Phase H — Integration and Polish

**Status: QUEUED.**

Unified settings, profiles, visual consistency, performance, accessibility/configurability, packaging, release documentation, and compatibility testing.
