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

Implement the identity-defining awareness layer:
- no conventional player health bar;
- screen-edge health vignette;
- compact resource percentage;
- minimal target information;
- minimal ally/pet information;
- cast confirmation without a cast bar.

Canonical phase record:
`memory/roadmap/PHASE_B_CORE_HUD.md`

Phase B runtime-proven:
- health vignette;
- resource percentage;
- sparse target;
- cast/channel cues;
- pet/party rows;
- in-game diagnostic/control panel.

## Phase C — Action Interface

**Status: COMPLETE.**

Secure action clusters and proven selective stock replacement.

Canonical phase record:
`memory/roadmap/PHASE_C_ACTION_INTERFACE.md`

## Phase D — Immersion Controller

**Status: COMPLETE.**

Immersion orchestration, Quiet Mode, context policy, selective unit-frame
suppression/restoration, and proven action replacement orchestration.

Canonical phase record:
`memory/roadmap/PHASE_D_IMMERSION_CONTROLLER.md`

## Phase E — Compass and Navigation

**Status: COMPLETE.**

Established:
- heading compass;
- runtime-proven map-space manual user-waypoint bearing;
- production manual user-waypoint compass marker;
- fail-open navigation behavior;
- explicit minimap ownership decision.

Canonical phase record:
`memory/roadmap/PHASE_E_COMPASS_NAVIGATION.md`

Canonical minimap decision:
`memory/decisions/D-030_MINIMAP_REMAINS_BLIZZARD_OWNED.md`

The Blizzard minimap remains stock.

## Phase F — Quest Experience

**Status: ACTIVE — F.1 source / capability review.**

Implement:
- immersive NPC quest presentation;
- restrained objective updates;
- aesthetic quest helper;
- contextual XP presentation;
- stock quest/XP surface suppression only after equivalent Logres presentation is proven.

Canonical phase record:
`memory/roadmap/PHASE_F_QUEST_EXPERIENCE.md`

Current work:
F.1 inventories tested Forever quest, interaction, objective, helper, XP, and
stock-ownership capabilities before selecting the first implementation slice.

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
