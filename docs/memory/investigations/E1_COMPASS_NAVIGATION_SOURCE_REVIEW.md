# E.1 — Compass / Navigation Source Review

Status: COMPLETE
Opened: 2026-10-01
Closed: 2026-10-01

Canonical decision:
`../decisions/D-029_COMPASS_NAVIGATION_CAPABILITY_CONTRACT.md`

Canonical evidence:
`../evidence/E1_COMPASS_NAVIGATION_SOURCE_REVIEW_2026-10-01.md`

## Question

What is the smallest capability-safe production compass/navigation contract for
the tested Forever client?

## Resolution

The smallest safe first slice is a heading-only world compass.

It does not need player position.

### Heading

Use:
`GetPlayerFacing()`

Source/reference semantics:
- Forever 1.60.1 support;
- radians;
- 0 = north;
- values increase counterclockwise;
- restricted/no-instance API;
- returns no usable value in restricted instances.

I-001 independently runtime-proved:
- non-secret facing outdoors;
- no facing in tested party instance;
- facing restored after returning to the world.

Presentation conversion:
`headingDegrees = (360 - degrees(facing)) % 360`

This yields conventional clockwise compass degrees for UI labeling:
- N = 0;
- E = 90;
- S = 180;
- W = 270.

Runtime E.2 must visually verify this orientation rather than treating source
documentation as visual proof.

### Position

Later waypoint work may use:
1. `C_Map.GetBestMapForUnit("player")`;
2. `C_Map.GetPlayerMapPosition(mapID, "player")`.

I-001 already proved this outdoors and proved the position path unavailable in
the tested party instance.

Position is not required for E.2.

### Waypoints

User waypoint APIs are source-present on Forever:
- `C_Map.GetUserWaypoint`;
- `C_Map.GetUserWaypointPositionForMap`;
- related user-waypoint helpers.

Quest waypoint source is present:
- `C_QuestLog.GetNextWaypoint(questID)`.

Active quest selection can potentially use:
- `C_SuperTrack.GetSuperTrackedQuestID()`.

But project runtime evidence does not yet establish:
- actual user-waypoint return behavior;
- exact active quest/super-track behavior;
- quest waypoint result behavior;
- reliable Forever event behavior for user-waypoint changes;
- waypoint bearing axis/orientation.

Therefore waypoint markers are not part of E.2.

### Events / update cadence

Facing changes continuously during player rotation.

Do not force global State to own heading.

E.2 should use a module-local throttled `OnUpdate` only while the compass is
eligible.

Preference/context changes remain event/subscription driven through existing:
- `SubscribePreferences`;
- `SubscribeState`.

For later waypoint work:
- `SUPER_TRACKING_CHANGED` is source-listed for Forever;
- current `USER_WAYPOINT_UPDATED` reference does not list Forever, so E.1 does
  not adopt it as a required Forever event.

### Context / immersion

The compass belongs to Immersion Mode.

E.2 presentation eligibility:
- Immersion ON;
- State context `world`;
- facing available.

Instance entry does not disable Logres globally.

The compass simply suspends.

### Blizzard fallback

The minimap remains stock.

The heading strip is not equivalent to:
- map interaction;
- zoom;
- map pins;
- tracking controls;
- arbitrary point selection;
- instance navigation.

Therefore E.2 does not authorize minimap suppression.

## E.1 exit result

E.1 is complete.

First runtime slice:
**E.2 heading-only world compass.**

Waypoint bearing is separately capability-gated as E.3.
