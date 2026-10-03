# Roadmap Status

As of 2026-10-03.

## Active

**Phase G — Cinematic Camera**

Active work item:
**G.5 camera-distance ownership review for Taxi target 50**

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

Target-50 under no-CVar-mutation boundary:
**CLOSED — CLEAN NEGATIVE on `0.0.44-dev`.**

P0109 runtime evidence repeated the same result twice:
- factor `1.2`;
- effective ceiling `18`;
- target `50`;
- turn zoom `18`;
- `targetReached=false`;
- movement/restoration PASS;
- CVar unchanged;
- secret=false.

Production Taxi therefore remains fail-open.

Active next step:
**source/contract review of camera-distance CVar ownership.**

No CVar mutation or clamped Taxi target is authorized yet.

## Phase H queued direction

D-032/D-033/D-034 define the accepted world-first / Selective Hybrid E visual
direction. D-035 defines NPC quest interaction as a future Logres-owned
experience with Blizzard fallback until each replacement surface is proven.
D-036 freezes the approved health-tunnel visible-field progression. D-037 defines
the future four-role navigation/minimap endpoint while preserving D-030 until
local POI/tracking/quest and remaining minimap capabilities are runtime-proven.
