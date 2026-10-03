# Roadmap Status

As of 2026-10-03.

## Active

**Phase G — Cinematic Camera**

Active work item:
**G.5 read-only camera-distance default/metadata proof**

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

Target 50 under current no-CVar-mutation boundary:
**CLOSED — CLEAN NEGATIVE on `0.0.44-dev`.**

Camera-distance source contract:
**RESOLVED.**

Key finding:
DynamicCam's captured Taxi target 50 does not itself raise max-distance; the
standard max-distance setting inherits the client default, which G.1 did not
persist and P0109 did not measure.

P0112 prepares runtime `0.0.45-dev` with a read-only Phase G
`Camera Distance Info` action.

Production Taxi remains fail-open.

No CVar mutation or clamped target is authorized.

## Phase H queued direction

D-032/D-033/D-034 define the accepted world-first / Selective Hybrid E visual
direction. D-035 defines NPC quest interaction as a future Logres-owned
experience with Blizzard fallback until each replacement surface is proven.
D-036 freezes the approved health-tunnel visible-field progression. D-037 defines
the future four-role navigation/minimap endpoint while preserving D-030 until
local POI/tracking/quest and remaining minimap capabilities are runtime-proven.
