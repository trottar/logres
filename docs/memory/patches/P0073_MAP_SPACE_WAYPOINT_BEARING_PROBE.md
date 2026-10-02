# P0073 — Map-Space Waypoint Bearing Probe

Date: 2026-10-01
Result: INSTALLED / PUSHED — RUNTIME PASS (`4d4ea878`)

## Baseline

P0072 verified pushed:
`1fc4877767ad035a50c83b3aa0e72f536358f47a`

## Purpose

Correct the final E.3 orientation proof after runtime evidence rejected raw
world X/Y as the compass-north basis.

## Changes

- `vectorRecord` supports both Vector2 mixins and plain x/y tables;
- calls `C_Map.GetUserWaypointPositionForMap(playerMapID)`;
- records waypoint position in the player's current UI map domain;
- computes map-space clockwise bearing with `atan2(dx, -dy)`;
- preserves world-coordinate data as diagnostic/domain evidence;
- updates the probe static contract.

## Runtime result

The user deliberately placed a waypoint directly north of the player.

P0073 captured:
- map delta approximately `-0.00506, -0.37168`;
- map-space bearing `359.2` degrees.

PASS.

The same sample's raw-world candidates remained near east, confirming that the
map-space correction is required.

E.3 closes in P0074.
