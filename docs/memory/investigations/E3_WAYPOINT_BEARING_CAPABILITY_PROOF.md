# E.3 — Waypoint-Bearing Capability / Proof

Status: ACTIVE — MAP-SPACE ORIENTATION PROOF REMAINS
Opened: 2026-10-01

Canonical decision:
`../decisions/D-029_COMPASS_NAVIGATION_CAPABILITY_CONTRACT.md`

Latest evidence:
- `../evidence/E3_P0071_RUNTIME_EVIDENCE_2026-10-01.md`
- `../evidence/E3_P0073_MAP_SPACE_BEARING_CORRECTION_2026-10-01.md`

## Proven

- open-world player map/world position;
- user waypoint present/absent semantics;
- user waypoint world conversion;
- clean clear/no-stale-bearing behavior;
- `USER_WAYPOINT_UPDATED` firing;
- `SUPER_TRACKING_CHANGED` firing.

## Negative / incomplete evidence

- `SUPER_TRACKING_PATH_UPDATED` registered but did not fire;
- tested super-tracked quest IDs 436 and 237 returned no usable next waypoint;
- this does not generalize to all quests.

## Rejected orientation assumption

A waypoint deliberately placed directly north on the UI map produced raw world
delta `+694.09, +34.69` and previous candidate bearings `87.1` / `92.9`.

Therefore raw world X/Y axes are rejected as the compass-north basis for this
map.

## Corrected orientation path

P0073 uses:
- player position in current UI map coordinates;
- `C_Map.GetUserWaypointPositionForMap(playerMapID)`;
- map-space `dx`, `dy`;
- clockwise bearing:
  `(degrees(atan2(dx, -dy)) + 360) % 360`.

## Remaining proof

One north-reference panel run.

Expected result:
map-space bearing approximately `0`/`360`.

Do not repeat already-proven retrieval/event/quest scenarios.

## Exit

E.3 closes if the corrected map-space path returns a usable waypoint position
and the deliberate north reference resolves correctly.

Production may then implement the proven user-waypoint bearing path. Quest
waypoint support remains capability-gated/fail-open until separately proven.
