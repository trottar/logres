# Roadmap Status

As of 2026-09-30.

## Active

**Phase A — Core State Engine**

Active work item: **A.1 State contract hardening**

## Phase status

| Phase | State |
| --- | --- |
| 0 — Foundation | COMPLETE |
| A — Core State Engine | ACTIVE — A.1 |
| B — Core HUD | BLOCKED on Phase A |
| C — Action Interface | BLOCKED on Phase A/B |
| D — Immersion Controller | BLOCKED on Phase A |
| E — Compass and Navigation | BLOCKED on Phase A/D |
| F — Quest Experience | BLOCKED on Phase A/D |
| G — Cinematic Camera | BLOCKED on Phase A; requires current DynamicCam profile |
| H — Integration and Polish | BLOCKED on prior phases |

## Foundation result

| Item | State |
| --- | --- |
| 0.1 Repository + durable memory | COMPLETE (`353c5b0`) |
| 0.2 Forever API capability audit | COMPLETE WITH DEFERRALS (`477df5b`) |
| 0.3 Minimal addon skeleton/load proof | COMPLETE (`ce4f1b0` + runtime proof) |

Phase 0.3 runtime proof established:
- clean addon load in tested scope;
- development status command;
- SavedVariables/loadCount persistence;
- correct transition into combined instance + combat state;
- correct restoration after leaving instance.

Separate world-combat retest was intentionally omitted as redundant for this checkpoint.

## Phase A sequence

| Item | State |
| --- | --- |
| A.1 State contract hardening | ACTIVE |
| A.2 Additional context sensors | QUEUED |
| A.3 User-controlled state | QUEUED |
| A.4 Module lifecycle contract | QUEUED |
| A.5 Transition validation | QUEUED |

Canonical Phase A plan:
`PHASE_A_CORE_STATE_ENGINE.md`
