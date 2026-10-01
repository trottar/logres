# Roadmap Status

As of 2026-09-30.

## Active

**Phase 0 — Foundation**

Active work item: **0.2 WoW Forever API capability audit**

State: **RUNTIME PASS 01 COMPLETE; TARGETED PASS 02 NEXT**

## Phase status

| Phase | State |
| --- | --- |
| 0 — Foundation | ACTIVE |
| A — Core State Engine | BLOCKED on Phase 0 |
| B — Core HUD | BLOCKED on Phase 0/A |
| C — Action Interface | BLOCKED on Phase 0/A |
| D — Immersion Controller | BLOCKED on Phase A |
| E — Compass and Navigation | BLOCKED on Phase 0/A/D |
| F — Quest Experience | BLOCKED on Phase 0/A/D |
| G — Cinematic Camera | BLOCKED on Phase 0/A; requires current DynamicCam profile |
| H — Integration and Polish | BLOCKED on prior phases |

## Foundation sequence

| Item | State |
| --- | --- |
| 0.1 Repository + durable memory | COMPLETE (`353c5b0`) |
| 0.2 Forever API capability audit | ACTIVE; runtime pass 01 complete |
| 0.3 Minimal addon skeleton/load proof | BLOCKED on 0.2 |

## Runtime pass 01 established

- client: Forever 1.60.1 build 70124 / interface 16001;
- project ID collision with MAINLINE confirmed;
- secret health/power behavior confirmed;
- secret-safe health bar/alpha/text transport confirmed;
- ordinary target level/classification readable in tested context;
- open-world map/facing path confirmed;
- combat transition timing nuance discovered;
- SavedVariables persistence across `/reload` confirmed;
- camera/chat read APIs confirmed;
- probe compatibility failure (`table.pack`) recorded and fixed.

## Runtime pass 02 priorities

- custom health curve;
- target retained in active combat lockdown;
- real player cast/channel;
- elite target;
- instance map/facing;
- quest waypoint;
- PvP transition if convenient.

Phase 0.3 remains blocked until these architecture-critical questions are closed or explicitly deferred.
