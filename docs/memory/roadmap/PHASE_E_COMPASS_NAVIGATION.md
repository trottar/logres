# Phase E — Compass and Navigation

Status: COMPLETE

## Objective

Build a Warcraft-aesthetic navigation layer that shows direction through the
world whenever the tested Forever client provides reliable navigation data.

## E.1

**COMPLETE.**

D-029 established the initial compass/navigation capability contract.

## E.2

**COMPLETE.**

Heading-only world compass runtime proof passed.

## E.3

**COMPLETE.**

Manual user-waypoint retrieval, update behavior, map-space bearing, and north
orientation were runtime-proven.

Accepted bearing:
`(degrees(atan2(dx, -dy)) + 360) % 360`
using the player's current UI map domain.

Raw world X/Y orientation was rejected by runtime evidence.

Quest waypoint output remained unavailable in tested super-tracked quests
`436` and `237`.

## E.4

**COMPLETE.**

Production manual user-waypoint compass marker:
- runtime PASS;
- visual directional/movement PASS;
- no stale clear behavior;
- Immersion OFF/ON suppression/recovery;
- Run All PASS;
- no reported Lua/taint/secret errors;
- minimap unchanged.

Production runtime:
`0.0.30-dev`.

## E.5

**COMPLETE.**

Canonical decision:
`../decisions/D-030_MINIMAP_REMAINS_BLIZZARD_OWNED.md`

The minimap remains stock.

Reason:
Logres does not replace the complete minimap/navigation information and control
surface.

Missing/unreplaced domains include quest navigation, POI/tracking information,
ping/click interaction, zoom controls, zone/territory context, and other stock
minimap utility.

No suppression probe was performed because the prerequisite replacement gate
already failed.

## Final Phase E Contract

Logres owns:
- world-context heading compass;
- manual user-waypoint direction where runtime-capable.

Blizzard retains:
- minimap;
- unsupported quest navigation;
- POI/tracking/map controls and other minimap utility.

Failure behavior remains fail-open.

## Phase E Result

**COMPLETE.**

The phase closes without minimap suppression.

Next:
**Phase F — Quest Experience.**
