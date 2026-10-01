# Roadmap Status

As of 2026-09-30.

## Active

**Phase A — Core State Engine**

Active work item: **A.1 State contract hardening**

State: **IMPLEMENTATION PREPARED; RUNTIME PROOF PENDING**

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

## Phase A sequence

| Item | State |
| --- | --- |
| A.1 State contract hardening | ACTIVE — implementation prepared |
| A.2 Additional context sensors | QUEUED |
| A.3 User-controlled state | QUEUED |
| A.4 Module lifecycle contract | QUEUED |
| A.5 Transition validation | QUEUED |

## A.1 contract

- mutable authoritative state is private;
- `GetState()` returns snapshots;
- `SubscribeState()` provides transition notifications/unsubscribe;
- revisions advance only for actual canonical changes;
- no-op observations do not publish;
- `/logres statecheck` provides travel-free runtime validation;
- static checker rejects direct `Logres.State` consumer access.

Canonical decision:
`../decisions/D-009_STATE_CONSUMER_CONTRACT.md`
