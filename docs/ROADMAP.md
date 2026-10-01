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

Stock Blizzard UI remains visible at this checkpoint by design. Suppression/restoration is capability-gated and assigned explicitly by D-017.

## Phase C — Action Interface

**Status: COMPLETE.**

Implement rectangular/square action clusters:
- primary cluster always legible;
- secondary/tertiary clusters contextually revealed;
- utility clusters normally absent/faded;
- combat and PvP modifiers;
- secure-action/combat-lockdown compliance.

Action-bar replacement is capability-gated: prove Logres secure controls first, then suppress/restore Blizzard action bars.

Canonical phase record:
`memory/roadmap/PHASE_C_ACTION_INTERFACE.md`

## Phase D — Immersion Controller

**Status: ACTIVE — D.4 Player selective shell implementation.**

Implement full immersion orchestration:
- Quiet/social immersion mode;
- contextual HUD fades;
- PvP-aware immersion;
- automatic instance behavior;
- module-level restoration when immersion is suspended;
- suppression/restoration orchestration for Blizzard player/target/party frames;
- stock action-bar suppression/restoration once Phase C replacement is proven.

Canonical phase record:
`memory/roadmap/PHASE_D_IMMERSION_CONTROLLER.md`

## Phase E — Compass and Navigation

Implement a Warcraft-aesthetic horizontal compass:
- world/exploration use;
- selected quest/user waypoint markers where APIs permit;
- automatic suspension in instances;
- graceful degradation whenever position/bearing data is unavailable;
- minimap suppression only after Logres navigation is sufficient for the active context.

## Phase F — Quest Experience

Implement:
- immersive NPC quest presentation;
- restrained objective updates;
- aesthetic quest helper;
- contextual XP presentation;
- stock quest/XP surface suppression only after equivalent Logres presentation is proven.

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
