# Roadmap Status

As of 2026-10-01.

## Active

**Phase C — Action Interface**

Active work item:
**C.5 Stock Action-Bar Replacement**

State:
**FIRST-PASS SOURCE-RESOLVED; IMPLEMENTATION NEXT**

## Phase status

| Phase | State |
| --- | --- |
| 0 — Foundation | COMPLETE |
| A — Core State Engine | COMPLETE |
| B — Core HUD | COMPLETE |
| C — Action Interface | ACTIVE — C.5 |
| D — Immersion Controller | QUEUED |
| E — Compass and Navigation | QUEUED |
| F — Quest Experience | QUEUED |
| G — Cinematic Camera | QUEUED |
| H — Integration and Polish | QUEUED |

## Phase C sequence

| Item | State |
| --- | --- |
| C.1 Secure action capability/source review | COMPLETE |
| C.2 Primary action cluster | COMPLETE |
| C.3 Secondary / utility clusters | COMPLETE |
| C.4 Contextual visibility / secure paging | COMPLETE |
| C.5 Stock action-bar replacement | ACTIVE — first-pass contract resolved |
| C.6 Action interface integration validation | QUEUED |

## C.5 first runtime scope

Replace only:
- stock Bar 2 / `MultiBarBottomLeft`;
- stock Bar 3 / `MultiBarBottomRight`.

Keep visible:
- MainActionBar;
- special action bars;
- Bars 4–5;
- unsupported extra bars.

Replacement is session-only and fail-open during first proof.
