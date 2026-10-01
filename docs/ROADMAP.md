# Project Logres Roadmap

Project Logres is an immersive, world-first interface addon for World of Warcraft Forever.

The roadmap is intentionally capability-gated. A phase does not advance because code exists; it advances when its success criteria are satisfied and the repository memory is synchronized.

## Phase 0 — Foundation

Purpose: establish the repository, memory discipline, development environment, design invariants, and verified WoW Forever API boundaries before addon implementation depends on assumptions.

### 0.1 Repository and durable memory
- [x] Git repository created.
- [x] Repository-native memory architecture defined.
- [x] WSL on Windows 11 recorded as canonical development environment.
- [x] User-controlled commit/push boundary recorded.
- [x] Negative-result retention required.
- [ ] Memory bootstrap committed and pushed.
- [ ] Memory health checker run successfully on the committed bootstrap.

### 0.2 WoW Forever capability audit
Verify, with primary/current sources and later in-client probes where needed:
- project/interface identification and TOC requirements;
- event surface relevant to Logres;
- player health and resource display mechanisms;
- unit health/power percentages and secret-value restrictions;
- target level/classification information;
- cast/channel information and combat restrictions;
- secure action buttons and combat lockdown;
- chat/social APIs and addon restrictions;
- map/player position APIs and instance restrictions;
- quest/objective APIs;
- camera CVars/functions and protected/restricted behavior;
- PvP flag state;
- instance state and transitions.

Deliverables:
- `docs/memory/investigations/FOREVER_API_CAPABILITY_AUDIT.md`
- evidence/source notes under `docs/memory/evidence/`
- decisions for any implementation boundary that becomes settled.

### 0.3 Addon skeleton
After the API audit establishes a safe baseline:
- create `Logres/Logres.toc`;
- establish addon namespace and saved-variable policy;
- create Core event/state infrastructure;
- add a minimal load confirmation with no permanent UI;
- prove load/reload behavior in WoW Forever.

## Phase A — Core State Engine

Implement the central context model rather than independent modules making conflicting visibility decisions.

Primary state inputs:
- immersion enabled/disabled;
- world vs instance;
- combat;
- PvP flag;
- NPC interaction;
- mounted/travel state;
- resting;
- other later contextual modifiers.

Success requires deterministic transitions and no subsystem independently inventing a competing global mode.

## Phase B — Core HUD

Implement the identity-defining presentation:
- no conventional player health bar;
- screen-edge health vignette;
- compact resource percentage;
- minimal target information;
- minimal ally/pet information;
- cast confirmation without a cast bar.

## Phase C — Action Interface

Implement rectangular/square action clusters:
- primary cluster always legible;
- secondary/tertiary clusters contextually revealed;
- utility clusters normally absent/faded;
- combat and PvP modifiers;
- secure-action/combat-lockdown compliance.

## Phase D — Immersion Controller

Implement full immersion orchestration:
- Quiet/social immersion mode;
- contextual HUD fades;
- PvP-aware immersion;
- automatic instance behavior;
- module-level restoration when immersion is suspended.

## Phase E — Compass and Navigation

Implement a Warcraft-aesthetic horizontal compass:
- world/exploration use;
- selected quest/user waypoint markers where APIs permit;
- automatic suspension in instances;
- graceful degradation whenever position/bearing data is unavailable.

## Phase F — Quest Experience

Implement:
- immersive NPC quest presentation;
- restrained objective updates;
- aesthetic quest helper;
- contextual XP presentation.

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
