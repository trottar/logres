# Phase E — Compass and Navigation

Status: ACTIVE — E.4

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

**COMPLETE.**

Runtime-proven manual user-waypoint path:
- player map:
  `C_Map.GetBestMapForUnit("player")`;
- player position:
  `C_Map.GetPlayerMapPosition(mapID, "player")`;
- user waypoint projection:
  `C_Map.GetUserWaypointPositionForMap(mapID)`;
- clockwise bearing:
  `(degrees(atan2(dx, -dy)) + 360) % 360`.

Final north-reference runtime proof:
- map delta approximately `-0.00506, -0.37168`;
- bearing `359.2` degrees.

Raw world X/Y axes are rejected for compass orientation on the tested map.

Runtime-proven events:
- `USER_WAYPOINT_UPDATED`;
- `SUPER_TRACKING_CHANGED`.

Not observed firing:
- `SUPER_TRACKING_PATH_UPDATED`.

Tested quest limitation:
- super-tracked quest IDs `436` and `237` produced no usable next waypoint.

Therefore quest marker support remains unavailable until separately proven.

## E.4 — User-waypoint compass marker integration

**ACTIVE.**

Implement only the proven manual user-waypoint path on the existing compass.

Required behavior:
- restrained marker integrated into the horizontal compass;
- bearing calculated in the current player UI map domain;
- marker omitted when waypoint/map/position data is absent or unusable;
- marker updates when the waypoint changes and as the player moves;
- existing world/Immersion eligibility remains authoritative;
- restricted/unavailable contexts fail open;
- no quest marker from API/source presence alone;
- minimap remains stock.

## E.5+ — Navigation sufficiency / minimap capability

**QUEUED.**

Do not suppress the minimap merely because heading and user-waypoint bearing
exist.

Any later suppression requires a separate deliberate capability review proving
that Logres replaces the required navigation/control surface safely and
reversibly.

## Navigation ownership

Phase E may own restrained navigational direction.

Phase F owns quest text/objective presentation.

## Exit

Phase E completes only when:
- supported navigation presentation is runtime-proven;
- unsupported destination cases fail open;
- Blizzard fallback remains available where Logres lacks capability;
- any minimap suppression is separately capability-gated and reversible.
