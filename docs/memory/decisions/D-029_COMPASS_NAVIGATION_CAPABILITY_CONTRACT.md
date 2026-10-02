# D-029 — Compass / Navigation Capability Contract

Status: ACCEPTED
Date: 2026-10-01

## Decision

Phase E begins with a heading-only world compass.

The first runtime slice does not depend on player position or waypoint APIs.

## Heading source

Use:
`GetPlayerFacing()`.

Contract:
- treat result as capability data, not guaranteed state;
- usable only when it returns a normal numeric value;
- do not cache the last good heading as fallback when the API becomes
  unavailable;
- suspend presentation when unavailable.

Source convention:
- radians;
- 0 = north;
- counterclockwise-positive.

Presentation convention:
- clockwise compass degrees.

Conversion:
`headingDegrees = (360 - degrees(facing)) % 360`.

Runtime must visually verify N/E/S/W orientation.

## Eligibility

Heading compass presentation requires all of:

```text
Compass module enabled
AND immersionEnabled = true
AND State.context = "world"
AND GetPlayerFacing() available/usable
```

No other global mode is introduced.

Combat and PvP do not disable the heading compass in the first slice.

Instance/restricted unavailability suspends it.

## Update model

Facing is continuous motion state and does not belong in Core State.

Use:
- State subscription for world/instance eligibility;
- preference subscription for Immersion eligibility;
- a module-local throttled `OnUpdate` while eligible for facing refresh.

Stop active heading refresh when presentation is ineligible.

## Player position

Later waypoint work may use:

```text
mapID = C_Map.GetBestMapForUnit("player")
position = C_Map.GetPlayerMapPosition(mapID, "player")
```

The first heading compass does not call these APIs.

## Waypoint boundary

Source availability is not runtime proof.

E.2 excludes:
- user waypoint marker;
- quest waypoint marker;
- distance;
- route/path guidance.

E.3 must separately prove:
- user waypoint retrieval;
- super-tracked quest selection;
- quest waypoint output;
- Forever update events;
- map/world conversion;
- axis/bearing orientation.

`SUPER_TRACKING_CHANGED` is a possible later Forever event.

Do not depend on `USER_WAYPOINT_UPDATED` until Forever support is runtime/source
confirmed.

## Quest ownership boundary

Phase E may own only navigational direction to a selected/super-tracked
destination.

Phase F owns:
- quest text;
- objective presentation;
- NPC quest presentation;
- broader quest-experience policy.

## Minimap

The minimap remains stock.

Do not suppress it in E.2.

Do not suppress it later until Logres has a deliberate safe replacement or
fallback for the required navigation/control surface.

## Failure behavior

Fail open:
- absent heading -> no compass;
- restricted context -> no compass;
- waypoint conversion failure -> no marker;
- unsupported destination -> no marker;
- missing Logres capability -> preserve Blizzard navigation.
