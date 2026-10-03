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

## G.5

**TARGET-50 CAPABILITY PROBE IMPLEMENTED — RUNTIME PROOF PENDING.**

P0108 at `19efaad6` resolves the Taxi source/profile contract.

P0109 prepares runtime `0.0.44-dev` and adds only the diagnostic capability gate:
- Phase G `Taxi Target 50 Probe`;
- read-only `cameraDistanceMaxZoomFactor`;
- recorded `factor * 15` effective ceiling;
- 5-second MoveView target-50 attempt;
- MoveView restoration to start;
- unchanged-CVar / target / secret / error diagnostics;
- dedicated static contract enforcement.

Production Taxi remains fail-open/out-of-slice.

A PASS permits a later zoom-only Taxi production patch.

A clean target-reach FAIL opens a separate camera-distance ownership decision;
the target must not be silently lowered.

## Phase H queued direction

D-032/D-033/D-034 define the accepted world-first / Selective Hybrid E visual
direction. D-035 defines NPC quest interaction as a future Logres-owned
experience with Blizzard fallback until each replacement surface is proven.
