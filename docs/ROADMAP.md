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

**Status: ACTIVE — F.2 runtime capability probe.**

F.1 is complete under:
`memory/decisions/D-031_QUEST_EXPERIENCE_CAPABILITY_CONTRACT.md`

Current work:
F.2 passively runtime-proves quest interaction reads, objective state, quest
destination output, XP/rested XP, and relevant events through the developer
panel.

First production candidate after proof:
**contextual XP pulse**.

Quest compass integration remains conditional on a usable runtime-proven quest
destination.

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
