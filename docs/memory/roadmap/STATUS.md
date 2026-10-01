# Roadmap Status

As of 2026-09-30.

## Active

**Phase 0 — Foundation**

Active work item: **0.3 Minimal addon skeleton/load proof**

State: **SKELETON PREPARED; RUNTIME PROOF PENDING**

## Phase status

| Phase | State |
| --- | --- |
| 0 — Foundation | ACTIVE — 0.3 |
| A — Core State Engine | BLOCKED on 0.3 runtime proof |
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
| 0.2 Forever API capability audit | COMPLETE WITH DEFERRALS (`477df5b`) |
| 0.3 Minimal addon skeleton/load proof | ACTIVE — source prepared |

## 0.3 source prepared

P0005 adds:
- real `Logres/Logres.toc`;
- core namespace/event bus;
- SavedVariables initialization;
- central state observation;
- development status/debug commands;
- WSL deployment helper;
- static addon-structure checker.

## Gate to Phase A

Do not begin Phase A until runtime proves:
- clean addon load;
- clean `/reload`;
- SavedVariables persistence;
- basic state transitions;
- repeatable WSL deployment.

No HUD presentation is part of this gate.
