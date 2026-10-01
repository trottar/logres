# Roadmap Status

As of 2026-09-30.

## Active

**Phase A — Core State Engine**

Active work item: **A.3 User-Controlled State**

State: **IMPLEMENTATION PREPARED; RUNTIME PROOF NEXT**

## Phase status

| Phase | State |
| --- | --- |
| 0 — Foundation | COMPLETE |
| A — Core State Engine | ACTIVE — A.3 |
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
| A.3 User-controlled state | ACTIVE — implementation prepared |
| A.4 Module lifecycle contract | QUEUED |
| A.5 Transition validation | QUEUED |

## A.3 implementation

P0012 adds:
- separate preference API;
- `immersionEnabled=true` default;
- database schema 2;
- additive schema 1 -> 2 migration;
- preference transition subscriptions;
- `/logres preferencecheck`;
- `/logres immersion ...`.

Runtime validation is entirely travel-free.
