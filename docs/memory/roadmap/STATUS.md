# Roadmap Status

As of 2026-09-30.

## Active

**Phase 0 — Foundation**

Active work item: **0.1 Memory bootstrap**

Expected next item after checkpoint: **0.2 WoW Forever API capability audit**

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
| 0.1 Repository + durable memory | ACTIVE; bootstrap patch prepared |
| 0.2 Forever API capability audit | QUEUED |
| 0.3 Minimal addon skeleton/load proof | BLOCKED on 0.2 |

## Established design decisions

- D-001 Project identity/world-first philosophy
- D-002 Player health presentation
- D-003 Enemy information disclosure
- D-004 Action cluster geometry
- D-005 Immersion/instance behavior
- D-006 PvP as a state modifier
- D-007 User owns Git checkpoints

See `../../ROADMAP.md` for the full phase roadmap.
