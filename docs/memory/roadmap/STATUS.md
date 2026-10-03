# Roadmap Status

As of 2026-10-03.

## Active

**Phase G — Cinematic Camera**

Active work item:
**G.5 Taxi target-50 capability proof**

State:
**Phase F COMPLETE; Phase G ACTIVE — G.5**

## Phase status

| Phase | State |
| --- | --- |
| 0 — Foundation | COMPLETE |
| A — Core State Engine | COMPLETE |
| B — Core HUD | COMPLETE |
| C — Action Interface | COMPLETE |
| D — Immersion Controller | COMPLETE |
| E — Compass and Navigation | COMPLETE |
| F — Quest Experience | COMPLETE |
| G — Cinematic Camera | ACTIVE — G.5 |
| H — Integration and Polish | QUEUED |

## G.2

**CLOSED — RUNTIME + INTEGRATION PASS.**

## G.3

**CLOSED — RUNTIME + INTEGRATION PASS.**

## G.4

**CLOSED — RUNTIME + INTEGRATION PASS on `0.0.43-dev`.**

Canonical evidence:
`../evidence/G4_P0105_RUNTIME_PASS_2026-10-03.md`.

## G.5

**SOURCE/PROFILE CONTRACT RESOLVED — TARGET-50 CAPABILITY PROBE NEXT.**

Canonical source/profile evidence:
`../evidence/G5_TAXI_CAMERA_SOURCE_AUDIT_2026-10-03.md`.

Resolved:
- Taxi uses existing `state.onTaxi`;
- priority `1000` outranks interaction/combat/City/World;
- conditional-out target is `50`;
- entry is `5` seconds;
- ordinary exit uses destination timing under restore `never`;
- rotation and UI fade remain separately gated.

Production ownership is blocked on one narrow capability question:
whether current Forever can reach zoom `50` through the proven MoveView path
without changing `cameraDistanceMaxZoomFactor`.

Next checkpoint:
developer-panel target-50 capability probe.

## Phase H queued direction

D-032/D-033/D-034 define the accepted world-first / Selective Hybrid E visual
direction. D-035 defines NPC quest interaction as a future Logres-owned
experience with Blizzard fallback until each replacement surface is proven.
