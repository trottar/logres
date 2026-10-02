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

Tested quest limitation:
- super-tracked quest IDs `436` and `237` produced no usable next waypoint.

Quest marker support remains unavailable until separately proven.

## E.4 — User-waypoint compass marker integration

**ACTIVE — P0075 PREPARED.**

P0075 integrates only the proven manual user-waypoint path into the existing
Compass module.

Contract:
- current-player-map coordinates only;
- no raw-world bearing;
- no quest marker;
- marker shares existing world/Immersion eligibility;
- `USER_WAYPOINT_UPDATED` triggers immediate destination refresh;
- player/destination positions are resampled on a throttled interval while
  eligible;
- no stale destination is retained when an input becomes unavailable;
- marker is shown only inside the existing visible compass tape;
- Compass Check remains the canonical developer-panel diagnostic;
- minimap remains stock.

Runtime proof is required before E.4 closes.

## E.5+ — Navigation sufficiency / minimap capability

**QUEUED.**

Do not suppress the minimap merely because heading and user-waypoint bearing
exist.

Any later suppression requires a separate capability review proving that Logres
replaces the required navigation/control surface safely and reversibly.

## Navigation ownership

Phase E may own restrained navigational direction.

Phase F owns quest text/objective presentation.

## Exit

Phase E completes only when:
- supported navigation presentation is runtime-proven;
- unsupported destination cases fail open;
- Blizzard fallback remains available where Logres lacks capability;
- any minimap suppression is separately capability-gated and reversible.
