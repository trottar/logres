# Project Logres Roadmap

Project Logres is an immersive, world-first interface addon for World of Warcraft Forever.

The roadmap is capability-gated. A phase advances only when its success criteria are satisfied and repository memory is synchronized.

## Phase 0 — Foundation

**Status: COMPLETE.**

Established:
- repository and durable memory;
- WSL/Windows development workflow;
- user-owned Git checkpoint boundary;
- Forever API capability audit;
- minimal real addon skeleton;
- load/reload and SavedVariables proof.

## Phase A — Core State Engine

**Status: COMPLETE.**

Established:
- private observed-state authority;
- snapshot/subscription consumer contract;
- world/instance/combat/PvP/resting/taxi/interaction facts;
- separate persisted user preference contract;
- lightweight module lifecycle;
- integrated transition evidence matrix.

Known environmental deferral:
- ordinary `mounted=true` runtime path.

Canonical phase record:
`memory/roadmap/PHASE_A_CORE_STATE_ENGINE.md`

## Phase B — Core HUD

**Status: COMPLETE.**

Identity-defining awareness layer is runtime-proven.

Canonical phase record:
`memory/roadmap/PHASE_B_CORE_HUD.md`

## Phase C — Action Interface

**Status: COMPLETE.**

Secure action clusters and proven selective stock replacement.

Canonical phase record:
`memory/roadmap/PHASE_C_ACTION_INTERFACE.md`

## Phase D — Immersion Controller

**Status: COMPLETE.**

Immersion orchestration and proven selective restoration/suppression.

Canonical phase record:
`memory/roadmap/PHASE_D_IMMERSION_CONTROLLER.md`

## Phase E — Compass and Navigation

**Status: COMPLETE.**

Established:
- heading compass;
- manual user-waypoint compass marker;
- fail-open navigation;
- Blizzard-owned stock minimap.

Canonical phase record:
`memory/roadmap/PHASE_E_COMPASS_NAVIGATION.md`

## Phase F — Quest Experience

**Status: ACTIVE — F.6 contextual objective progress pulse.**

F.1:
complete under D-031.

F.2:
complete with runtime-proven XP/event and quest-detail inputs.

F.3:
contextual XP complete with runtime, integration, and visual proof.

F.4:
additive NPC quest detail presentation complete with runtime, integration, and
visual proof.

F.5:
objective/progress capability proof complete, including populated incomplete and
completed rows plus a same-quest `0/10 -> 1/10` refresh.

Current work:
F.6 implements a temporary contextual objective-progress pulse using the proven
passive objective source and proven refresh events.

F.6 constraints:
- baseline first;
- no permanent objective tracker;
- no stock Objective Tracker suppression;
- no watch/super-track mutation;
- fail open on secret/invalid/uncached data.

Deferred:
- stock Objective Tracker replacement/suppression;
- quest destination / quest compass marker.

Canonical phase record:
`memory/roadmap/PHASE_F_QUEST_EXPERIENCE.md`

## Phase G — Cinematic Camera

Translate the user's established DynamicCam behavior into Logres:
- world;
- combat;
- NPC interaction;
- gathering;
- fishing;
- taxi;
- hearth/teleport;
- instance behavior.

Exact behavior must be reconstructed from a current exported profile, not from memory alone.

## Phase H — Integration and Polish

- unified settings;
- profiles;
- visual language consistency;
- performance;
- accessibility/configurability;
- packaging;
- release documentation;
- compatibility testing.
