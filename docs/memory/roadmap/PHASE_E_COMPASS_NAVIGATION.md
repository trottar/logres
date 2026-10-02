# Phase E — Compass and Navigation

Status: ACTIVE

## Objective

Build a Warcraft-aesthetic navigation layer that shows direction through the
world whenever the tested Forever client provides reliable navigation data.

Blizzard navigation remains fail-open fallback until Logres deliberately
replaces the required information/control surface.

## E.1

**COMPLETE.**

D-029 is canonical.

## E.2

**COMPLETE.**

Heading-only world compass runtime proof passed.

## E.3 — Waypoint-bearing capability/proof

**ACTIVE.**

Runtime-proven:
- user waypoint present/absent retrieval;
- user waypoint world conversion;
- clean clear/no-stale-bearing behavior;
- `USER_WAYPOINT_UPDATED`;
- `SUPER_TRACKING_CHANGED`.

Observed but not proven useful:
- `SUPER_TRACKING_PATH_UPDATED` registered but did not fire.

Tested quest limitation:
- super-tracked quest IDs 436 and 237 produced no usable next waypoint.

### Orientation correction

The first probe tested raw world-coordinate bearing candidates.

A deliberate north-reference waypoint disproved that assumption on map 1432:
the raw-world candidates resolved near east.

P0073 therefore proves bearing in the current UI map domain instead:
- player position from `C_Map.GetPlayerMapPosition`;
- user waypoint from `C_Map.GetUserWaypointPositionForMap`;
- clockwise bearing from map north via `atan2(dx, -dy)`.

One north-reference runtime sample remains.

## Navigation ownership

Do not add quest text/objective presentation here.

Do not suppress the minimap.

Production waypoint presentation remains blocked until E.3 orientation proof
closes.

## Exit

E.3 exits when the current-map waypoint position is runtime-usable and a known
north reference resolves near `0`/`360` degrees without stale/fabricated output.
