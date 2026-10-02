# Phase E — Compass and Navigation

Status: ACTIVE — E.5

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

## E.4 — User-waypoint compass marker integration

**COMPLETE — P0075 RUNTIME + VISUAL PASS.**

Production runtime:
`0.0.30-dev`.

Runtime-proven:
- no waypoint -> no marker;
- waypoint outside visible tape -> marker omitted;
- waypoint inside tape -> marker shown;
- moving/clearing waypoint updates/removes marker without stale state;
- player movement updates relative bearing;
- Immersion OFF suppresses the compass/marker;
- Immersion ON restores the compass;
- Compass Check PASS;
- Run All PASS.

User visual confirmation:
- marker tracked the correct destination direction while rotating/moving;
- no Lua/taint/secret errors observed;
- minimap unchanged.

Quest waypoint support remains unavailable until separately proven.

## E.5 — Navigation sufficiency / minimap capability review

**ACTIVE.**

E.4 does not authorize minimap suppression.

E.5 must inventory the stock minimap/navigation information and control surfaces
and decide whether Logres replaces enough of them to suppress anything safely.

Review at minimum:
- local spatial/orientation information;
- manual waypoint navigation;
- quest/objective navigation;
- POI/tracking information;
- minimap click interactions;
- zoom and related controls;
- context-specific fallback;
- deterministic restoration.

Do not mutate or suppress the minimap during the review.

E.5 closes only with an explicit capability contract.

## Navigation ownership

Phase E may own restrained navigational direction.

Phase F owns quest text/objective presentation.

Quest navigation remains unsupported until separately runtime-proven.

## Exit

Phase E completes only when:
- supported navigation presentation is runtime-proven;
- unsupported destination cases fail open;
- Blizzard fallback remains available where Logres lacks capability;
- minimap ownership/suppression has an explicit accepted capability decision.
