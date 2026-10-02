# E.3 P0073 Map-Space Bearing Correction — 2026-10-01

Status: PREPARED — RUNTIME ORIENTATION PROOF NEXT
Date: 2026-10-01
Baseline: `1fc4877767ad035a50c83b3aa0e72f536358f47a`

## Triggering evidence

The user placed the requested manual waypoint directly north of the player on
the world map.

The persisted diagnostic sample recorded:

- player map ID: `1432`;
- player world position:
  `-5384.4209, -2963.9761`;
- waypoint world position:
  `-4690.3291, -2929.2881`;
- raw world delta:
  `+694.09, +34.69`;
- previous candidate world bearings:
  `87.1` and `92.9` degrees.

That is incompatible with the known visual north reference.

## Conclusion

The prior probe assumption that raw world X/Y axes could directly define
compass north is rejected for this map.

Do not choose either previous world-axis candidate.

## Corrected proof path

Use the player's current UI map domain:

- `C_Map.GetPlayerMapPosition(mapID, "player")`;
- `C_Map.GetUserWaypointPositionForMap(mapID)`.

For UI map coordinates:
- X increases left -> right;
- Y increases top -> bottom.

Clockwise compass bearing from map north is therefore:

`bearing = degrees(atan2(dx, -dy)) mod 360`

P0073 records that map-space bearing directly.

The existing world-coordinate conversion remains useful for domain/capability
evidence but is no longer treated as the north-axis source.

## Runtime exit

With the same deliberately north-placed waypoint, one `Waypoint Probe` result
should produce a map-space bearing near `0`/`360` degrees.

If it does, E.3 orientation proof can close.

If `GetUserWaypointPositionForMap` is unavailable or returns unusable data on
Forever, record that negative result and do not fabricate a bearing.
