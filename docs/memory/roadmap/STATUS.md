# Roadmap Status

As of 2026-09-30.

## Active

**Phase A — Core State Engine**

Active work item: **A.5 Transition Validation**

State: **ACTIVE — TARGETED GAP VALIDATION**

## Phase status

| Phase | State |
| --- | --- |
| 0 — Foundation | COMPLETE |
| A — Core State Engine | ACTIVE — A.5 |
| B — Core HUD | BLOCKED on Phase A |
| C — Action Interface | BLOCKED on Phase A/B |
| D — Immersion Controller | BLOCKED on Phase A |
| E — Compass and Navigation | BLOCKED on Phase A/D |
| F — Quest Experience | BLOCKED on Phase A/D |
| G — Cinematic Camera | BLOCKED on Phase A; requires current DynamicCam profile |
| H — Integration and Polish | BLOCKED on prior phases |

## Phase A sequence

| Item | State |
| --- | --- |
| A.1 State contract hardening | COMPLETE |
| A.2 Additional context sensors | COMPLETE WITH ENVIRONMENTAL DEFERRAL |
| A.3 User-controlled state | COMPLETE |
| A.4 Module lifecycle contract | COMPLETE (`f5a12d4` corrected runtime proof) |
| A.5 Transition validation | ACTIVE |

## A.5 evidence policy

Already covered:
- load/reload;
- persistence;
- world/instance/combat;
- state contract;
- resting/taxi/interaction;
- preference contract/persistence;
- module lifecycle.

Open gap:
- real PvP flagged transition.

Environmental deferral:
- ordinary mounted=true.

Do not repeat already-proven travel-heavy scenarios without new evidence.
