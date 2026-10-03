# Roadmap Status

As of 2026-10-02.

## Active

**Phase G — Cinematic Camera**

Active work item:
**G.2 World/Combat camera zoom capability**

State:
**Phase F COMPLETE; Phase G ACTIVE — G.2**

## Phase status

| Phase | State |
| --- | --- |
| 0 — Foundation | COMPLETE |
| A — Core State Engine | COMPLETE |
| B — Core HUD | COMPLETE |
| C — Action Interface | COMPLETE |
| D — Immersion Controller | COMPLETE |
| E — Compass and Navigation | COMPLETE |
| F — Quest Experience | COMPLETE |
| G — Cinematic Camera | ACTIVE — G.2 |
| H — Integration and Polish | QUEUED |

## Phase G

| Item | State |
| --- | --- |
| G.1 Current DynamicCam profile capture | COMPLETE — exact RPG evidence preserved |
| G.2 World/Combat camera zoom capability | ACTIVE — source review / runtime proof pending |
| G.3+ Camera implementation/context slices | QUEUED — evidence-driven |

## G.1 captured profile

Enabled RPG contexts:
- City;
- World;
- World (Combat);
- Taxi;
- Hearth/Teleport;
- NPC Interaction;
- Fishing;
- AFK;
- Gathering.

No explicit enabled instance situation is present.

Canonical evidence:
`../evidence/G1_DYNAMICCAM_PROFILE_CAPTURE_2026-10-02.md`.

## G.2 target

World:
- zoom in by 5;
- enter 2.5;
- exit 0.

World (Combat):
- zoom out by 15;
- enter 2.5;
- exit 0.

No WoW redeploy is required for P0094.

## Deferred navigation

Quest IDs `436`, `237`, and `1338` remain negative waypoint samples.

Quest compass marker remains unsupported.
