# E.1 Compass / Navigation Source Review — 2026-10-01

Status: SOURCE-RESOLVED

## Repository evidence

I-001 already runtime-proved on the tested Forever client:
- `C_Map.GetBestMapForUnit("player")` succeeds outdoors;
- `C_Map.GetPlayerMapPosition(...)` returns non-secret coordinates outdoors;
- `GetPlayerFacing()` returns a non-secret value outdoors;
- tested party-instance position is unavailable;
- tested party-instance facing is unavailable;
- both recover after returning to the world.

The production State engine already owns:
- `context`;
- `inInstance`;
- `instanceType`;
- combat/PvP and other orthogonal facts.

The module system already provides:
- module lifecycle;
- State subscription;
- preference subscription;
- cleanup ownership.

## Current external API references

Warcraft Wiki current references consulted on 2026-10-01:

- `GetPlayerFacing`
  https://warcraft.wiki.gg/wiki/API:GetPlayerFacing
  - Forever 1.60.1 listed;
  - radians;
  - 0 north;
  - counterclockwise-positive;
  - `#noinstance`.

- `C_Map.GetBestMapForUnit`
  https://warcraft.wiki.gg/wiki/API:C_Map.GetBestMapForUnit
  - Forever 1.60.1 listed;
  - returns current UI map for player/group units.

- `C_Map.GetPlayerMapPosition`
  https://warcraft.wiki.gg/wiki/API:C_Map.GetPlayerMapPosition
  - Forever 1.60.1 listed;
  - `#noinstance`;
  - returns Vector2 map position.

- `C_Map.GetWorldPosFromMapPos`
  https://warcraft.wiki.gg/wiki/API:C_Map.GetWorldPosFromMapPos
  - Forever 1.60.1 listed;
  - available for later map->world conversion.

- `C_Map.GetUserWaypoint`
  https://warcraft.wiki.gg/wiki/API:C_Map.GetUserWaypoint
  - Forever 1.60.1 listed;
  - may return nothing.

- `C_Map.GetUserWaypointPositionForMap`
  https://warcraft.wiki.gg/wiki/API:C_Map.GetUserWaypointPositionForMap
  - Forever 1.60.1 listed;
  - may return nothing.

- `C_QuestLog.GetNextWaypoint`
  https://warcraft.wiki.gg/wiki/API:C_QuestLog.GetNextWaypoint
  - Forever 1.60.1 listed;
  - may return nothing;
  - returns mapID/x/y for a quest ID.

- `C_SuperTrack.GetSuperTrackedQuestID`
  https://warcraft.wiki.gg/wiki/API:C_SuperTrack.GetSuperTrackedQuestID
  - current Forever reference lists support.

- `SUPER_TRACKING_CHANGED`
  https://warcraft.wiki.gg/wiki/SUPER_TRACKING_CHANGED
  - current reference lists Forever.

- `USER_WAYPOINT_UPDATED`
  https://warcraft.wiki.gg/wiki/USER_WAYPOINT_UPDATED
  - current reference does not list Forever.
  - therefore it is not adopted as a required Forever event.

## Source conclusion

### Safe now

Heading-only compass:
- `GetPlayerFacing`;
- State world/instance gate;
- Immersion preference gate;
- module-local throttled refresh.

### Known but deferred

Player position:
- source-known;
- runtime-proven outdoors;
- not required for heading tape.

### Requires dedicated runtime proof

Waypoint navigation:
- user waypoint retrieval;
- super-tracked quest selection;
- quest next-waypoint semantics;
- relevant update events;
- cross-map/world conversion;
- axis/bearing orientation.

### Not authorized

Minimap suppression.

## First runtime slice

E.2:
**heading-only world compass**.

Runtime target:
`0.0.28-dev`.
