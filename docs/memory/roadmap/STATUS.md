# Roadmap Status

As of 2026-10-01.

## Active

**Phase B — Core HUD**

Active work item:
**B.4 Cast Confirmation**

## Phase status

| Phase | State |
| --- | --- |
| 0 — Foundation | COMPLETE |
| A — Core State Engine | COMPLETE |
| B — Core HUD | ACTIVE — B.4 |
| C — Action Interface | BLOCKED on Phase B |
| D — Immersion Controller | BLOCKED on core HUD/state consumers |
| E — Compass and Navigation | QUEUED |
| F — Quest Experience | QUEUED |
| G — Cinematic Camera | QUEUED; requires current DynamicCam profile |
| H — Integration and Polish | BLOCKED on prior phases |

## Phase B sequence

| Item | State |
| --- | --- |
| B.1 HUD root + player health vignette | COMPLETE |
| B.2 Resource presentation | COMPLETE |
| B.3 Target presentation | COMPLETE |
| B.4 Cast confirmation | ACTIVE |
| B.5 Allies and pets | QUEUED |
| B.6 HUD integration validation | QUEUED |

## B.4 scope

Required:
- player cast/channel cue;
- current-target cast/channel cue.

No conventional cast bars.

Target-caster true-path runtime proof may defer by environment if no caster is available.
