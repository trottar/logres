# E.4 P0075 User-Waypoint Marker Design — 2026-10-02

Status: PREPARED — RUNTIME PROOF PENDING
Date: 2026-10-02
Baseline: `04d7931764e2b35d68709c4513722637d85f3064`

## Scope

P0075 implements the first production waypoint presentation.

Supported source:
**manual Blizzard user waypoint only**.

Unsupported:
- quest waypoint marker;
- route/path guidance;
- minimap suppression.

## Bearing source

Use the E.3 runtime-proven current UI map path:

```text
mapID = C_Map.GetBestMapForUnit("player")
player = C_Map.GetPlayerMapPosition(mapID, "player")
destination = C_Map.GetUserWaypointPositionForMap(mapID)

dx = destination.x - player.x
dy = destination.y - player.y

bearing = (degrees(atan2(dx, -dy)) + 360) % 360
```

Never derive compass orientation from raw world X/Y.

## Presentation

The existing Compass tape remains authoritative.

The user waypoint is represented by a restrained accent tick/cap.

Relative angle:

```text
relative = normalize(bearing - heading)
```

The marker is visible only when `relative` lies inside the existing
`+/-100 degree` tape.

When the destination is outside that tape, the marker is omitted rather than
clamped to a misleading position.

## Update model

Heading:
- existing `0.05s` facing refresh.

Waypoint/player position:
- `USER_WAYPOINT_UPDATED` triggers immediate refresh;
- `0.15s` throttled resampling while the compass is eligible keeps player
  movement reflected without broad polling elsewhere.

## Failure behavior

Any absent, secret, invalid, or failed required input:
- clears waypoint bearing;
- hides waypoint marker;
- retains Blizzard navigation unchanged.

No last-known waypoint bearing is used as fallback.

## Diagnostics

The existing developer-panel `Compass Check` is extended.

It consumes addon-owned Compass status only.

It does not directly query protected/secret-capable navigation APIs.

## Runtime proof

Required:
- no-waypoint omission;
- set/move/clear behavior;
- visual directional correctness while rotating;
- player-movement bearing update;
- Immersion OFF/ON suppression/recovery;
- Compass Check;
- Run All;
- no Lua/taint/secret errors;
- minimap unchanged.
