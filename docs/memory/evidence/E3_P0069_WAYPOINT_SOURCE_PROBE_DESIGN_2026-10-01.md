# E.3 P0069 Waypoint Source / Probe Design — 2026-10-01

Status: SOURCE-RESOLVED; RUNTIME PROOF NEXT
Date: 2026-10-01
Baseline: `740ebe15ae933dc50cbcd9482528a9ae6eb7f846`
Production runtime: `0.0.28-dev`

## Current source findings

Current Warcraft Wiki references reviewed on 2026-10-01:

- `C_Map.GetUserWaypoint`
  - Forever 1.60.1 listed;
  - may return nothing;
  - returns a `UiMapPoint` with `uiMapID`, `position`, optional `z`.

- `C_Map.GetWorldPosFromMapPos`
  - available on Forever;
  - accepts UI map ID + vector2 map position;
  - returns continent ID + vector2 world position.

- `C_QuestLog.GetNextWaypoint`
  - listed on Forever;
  - returns `mapID, x, y`;
  - runtime semantics remain unproven for this project.

- `C_SuperTrack.GetSuperTrackedQuestID`
  - source-present;
  - runtime behavior remains unproven.

- SuperTrackManager exposes:
  - `SUPER_TRACKING_CHANGED`;
  - `SUPER_TRACKING_PATH_UPDATED`.

Prior E.1 evidence remains authoritative that current
`USER_WAYPOINT_UPDATED` documentation does not establish Forever support.

## Narrow hypothesis

E.3 can prove navigation capability without touching production Compass code.

A dedicated temporary probe can:
1. retrieve player map/world position;
2. retrieve a user waypoint when present;
3. retrieve the super-tracked quest ID;
4. call `C_QuestLog.GetNextWaypoint` for that quest;
5. normalize supported destination map positions into world coordinates;
6. record navigation-event registration/firing;
7. record two world-axis bearing candidates for visual selection in game.

## Bearing discipline

The probe does not choose a world-axis convention from static reasoning.

For a same-continent player/destination pair it records:
- raw world `dx`, `dy`;
- candidate assuming `+Y = north`;
- candidate assuming `-Y = north`.

In-game visual comparison to a waypoint of known direction determines the valid
convention.

## Secret discipline

Every scalar/vector returned from navigation APIs is checked for secrecy before:
- comparison;
- stringification;
- arithmetic;
- persistence.

A secret/unavailable/incompatible value stops that branch.

No stale destination or bearing is synthesized.

## Event discipline

The probe attempts registration independently for:
- `SUPER_TRACKING_CHANGED`;
- `SUPER_TRACKING_PATH_UPDATED`;
- `USER_WAYPOINT_UPDATED`.

Registration success and actual event counts are persisted separately.

This distinguishes source presence, registerability, and observed event firing.

## Non-scope

P0069 does not:
- add waypoint presentation to Logres;
- modify the production Compass module;
- set/clear user waypoints;
- change super-tracking;
- suppress/mutate the minimap;
- add broad polling.

## Runtime exit evidence

P0069 runtime should establish:
- no-user-waypoint behavior;
- active-user-waypoint return shape and world conversion when available;
- super-tracked quest behavior;
- quest waypoint return shape/world conversion when available;
- which candidate navigation events register and fire;
- which bearing candidate matches visible in-game direction.

Negative/unavailable cases are evidence, not failures to be hidden.
