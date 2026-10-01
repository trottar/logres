# Roadmap Status

As of 2026-09-30.

## Active

**Phase B — Core HUD**

Active work item:
**B.1 HUD root + player health vignette**

## Phase status

| Phase | State |
| --- | --- |
| 0 — Foundation | COMPLETE |
| A — Core State Engine | COMPLETE |
| B — Core HUD | ACTIVE — B.1 |
| C — Action Interface | BLOCKED on Phase B |
| D — Immersion Controller | BLOCKED on core HUD/state consumers |
| E — Compass and Navigation | QUEUED after core integration dependencies |
| F — Quest Experience | QUEUED |
| G — Cinematic Camera | QUEUED; requires current DynamicCam profile |
| H — Integration and Polish | BLOCKED on prior phases |

## Phase A final result

Covered:
- load/reload/persistence;
- world/instance/combat;
- real PvP flag transition;
- resting/taxi/interaction;
- state contract;
- preference contract/persistence;
- module lifecycle.

Environmental deferral retained:
- ordinary mounted=true.

## Phase B entry

B.1 begins with:
- real HUD module;
- HUD root;
- production secret-safe player health vignette;
- immersion preference integration.

No action-cluster implementation belongs in B.1.
