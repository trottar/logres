# Roadmap Status

As of 2026-09-30.

## Active

**Phase A — Core State Engine**

Active work item: **A.3 User-Controlled State**

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
| A.3 User-controlled state | ACTIVE |
| A.4 Module lifecycle contract | QUEUED |
| A.5 Transition validation | QUEUED |

## A.2 result

Runtime verified:
- resting true/false;
- taxi true/false;
- interaction open/close;
- taxi separated from ordinary mount state.

Deferred by environment:
- ordinary mounted=true path.

The current beta/character test environment cannot practically produce a mount test, so A.2 is not held open for that path.

## A.3 target

First user-controlled value:

```text
immersionEnabled
```

Persist it separately from observed game facts and prove change + reload behavior without requiring a settings UI.
