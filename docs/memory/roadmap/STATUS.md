# Roadmap Status

As of 2026-09-30.

## Active

**Phase 0 — Foundation**

Active work item: **0.3 Minimal addon skeleton/load proof**

## Phase status

| Phase | State |
| --- | --- |
| 0 — Foundation | ACTIVE — 0.3 |
| A — Core State Engine | BLOCKED on 0.3 |
| B — Core HUD | BLOCKED on Phase A |
| C — Action Interface | BLOCKED on Phase A/B |
| D — Immersion Controller | BLOCKED on Phase A |
| E — Compass and Navigation | BLOCKED on Phase A/D |
| F — Quest Experience | BLOCKED on Phase A/D |
| G — Cinematic Camera | BLOCKED on Phase A; requires current DynamicCam profile |
| H — Integration and Polish | BLOCKED on prior phases |

## Foundation sequence

| Item | State |
| --- | --- |
| 0.1 Repository + durable memory | COMPLETE (`353c5b0`) |
| 0.2 Forever API capability audit | COMPLETE WITH DEFERRALS |
| 0.3 Minimal addon skeleton/load proof | ACTIVE |

## Phase 0.2 closure

Runtime established:
- Forever identity/project-ID behavior;
- secret-safe health/resource architecture;
- custom vignette curve viability;
- player cast/channel feasibility;
- normal and elite metadata in combat;
- instance navigation restriction/restoration;
- combat-lockdown timing;
- SavedVariables persistence.

Deferred to owning phases:
- enemy cast presentation;
- PvP flagged transition;
- quest waypoint semantics;
- secure action mutation;
- outbound chat automation;
- camera mutation/restore.

## Next

Create and runtime-prove the minimal Logres addon skeleton without implementing product HUD features.
