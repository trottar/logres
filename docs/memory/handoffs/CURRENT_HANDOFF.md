# Current Handoff

Authoritative state: `../CURRENT.md`.

P0072 is verified pushed at `1fc48777`.

Phase E / E.3 is active.

The north-reference runtime sample rejected the prior raw-world-axis bearing
assumption.

P0073 is prepared to use current UI map coordinates and
`C_Map.GetUserWaypointPositionForMap(mapID)` for bearing orientation.

Next runtime action after push:
- deploy;
- keep/set one waypoint directly north of player on map;
- developer panel -> `Waypoint Probe`;
- `/reload`;
- export `LOGRES_DIAGNOSTICS_LATEST.lua`.

No repeat of the earlier waypoint/event/quest matrix.

User performs all commits/pushes.
