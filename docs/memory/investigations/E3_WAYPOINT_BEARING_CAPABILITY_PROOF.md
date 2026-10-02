# E.3 — Waypoint-Bearing Capability / Proof

Status: CLOSED — RUNTIME PASS
Opened: 2026-10-01
Closed: 2026-10-02

Canonical decision:
`../decisions/D-029_COMPASS_NAVIGATION_CAPABILITY_CONTRACT.md`

Final runtime evidence:
`../evidence/E3_P0073_RUNTIME_PASS_2026-10-02.md`

## Proven

- open-world player map/world position;
- user waypoint present/absent semantics;
- clean clear/no-stale-bearing behavior;
- `USER_WAYPOINT_UPDATED` firing;
- `SUPER_TRACKING_CHANGED` firing;
- current-map user waypoint projection through
  `C_Map.GetUserWaypointPositionForMap(playerMapID)`;
- clockwise map-space bearing orientation.

## Final orientation proof

The user deliberately placed a manual waypoint directly north of the player on
the UI map.

P0073 captured:
- player map position:
  `0.3511172533, 0.4888285398`;
- waypoint position in the same map:
  `0.3460545540, 0.1171445549`;
- map delta:
  `-0.00506, -0.37168`;
- corrected map-space bearing:
  `359.2` degrees.

This is consistent with the known north reference.

The same sample's raw-world candidates were approximately `88.8` / `91.2`,
confirming that raw world X/Y is not the compass-north orientation source for
this map.

## Accepted bearing path

For a manual user waypoint:

```text
mapID = C_Map.GetBestMapForUnit("player")
player = C_Map.GetPlayerMapPosition(mapID, "player")
destination = C_Map.GetUserWaypointPositionForMap(mapID)

dx = destination.x - player.x
dy = destination.y - player.y

bearingDegrees = (degrees(atan2(dx, -dy)) + 360) % 360
```

All values remain capability-gated and secret-safe.

If any required input is absent/unusable, no waypoint marker is shown.

## Negative / deferred evidence

- `SUPER_TRACKING_PATH_UPDATED` registered but did not fire in tested runs.
- tested super-tracked quest IDs `436` and `237` returned no usable next
  waypoint.
- this does not generalize to all quests, but it does prohibit assuming quest
  marker support.

## Result

E.3 exit criteria are satisfied for the manual user-waypoint path.

Next:
E.4 may implement only the proven manual user-waypoint compass marker.

Quest waypoint support remains separately capability-gated.

The minimap remains stock.
