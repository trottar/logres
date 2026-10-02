# P0073 — Map-Space Waypoint Bearing Probe

Date: 2026-10-01
Result: PREPARED — RUNTIME PROOF PENDING

## Baseline

P0072 verified pushed:
`1fc4877767ad035a50c83b3aa0e72f536358f47a`

## Purpose

Correct the final E.3 orientation proof after runtime evidence rejected raw
world X/Y as the compass-north basis.

## Changes

- `vectorRecord` now safely supports both Vector2 mixins and plain x/y tables;
- calls `C_Map.GetUserWaypointPositionForMap(playerMapID)`;
- records waypoint position in the player's current UI map domain;
- computes map-space clockwise bearing with `atan2(dx, -dy)`;
- preserves previous world-coordinate data only as diagnostic/domain evidence;
- updates the probe static contract;
- synchronizes E.3 durable memory.

## Runtime next

Use one waypoint deliberately placed directly north of the player on the map.

Developer panel:
`Waypoint Probe`

Expected map-space bearing:
approximately `0` / `360` degrees.

No repeat of earlier retrieval/event/quest scenarios.
