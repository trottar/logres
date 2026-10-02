---
memory_schema: 1
as_of: 2026-10-02
project: logres
---

# Current State

## Active Objective

**Phase E — Compass and Navigation.**

## Current Work Item

**E.4 — User-waypoint compass marker integration.**

P0073 is verified pushed at `4d4ea878`.

E.3 is complete.

Production runtime remains `0.0.29-dev`.

## Verified State

- E.1 complete.
- E.2 complete.
- E.3 complete.
- Forever runtime: client `1.60.1`, build `70170`, interface `16001`.
- User-waypoint present/absent retrieval is runtime-proven.
- User-waypoint clear behavior is runtime-proven with no stale bearing.
- `USER_WAYPOINT_UPDATED` is runtime-proven to register and fire.
- `SUPER_TRACKING_CHANGED` is runtime-proven to register and fire.
- `SUPER_TRACKING_PATH_UPDATED` registered but did not fire in the tested runs.
- Tested super-tracked quest IDs `436` and `237` returned no usable next
  waypoint.
- Raw world X/Y axes are rejected as the compass-north basis on map `1432`.
- The supported user-waypoint bearing path is current UI map space:
  - player position: `C_Map.GetPlayerMapPosition(playerMapID, "player")`;
  - destination: `C_Map.GetUserWaypointPositionForMap(playerMapID)`;
  - clockwise bearing:
    `(degrees(atan2(dx, -dy)) + 360) % 360`.
- Final north-reference proof produced:
  - map delta approximately `-0.00506, -0.37168`;
  - map bearing `359.2` degrees;
  - the same sample's raw-world candidates remained approximately
    `88.8` / `91.2`.
- Therefore map-space orientation is runtime-proven and E.3 closes.
- Quest waypoint presentation remains unsupported unless later runtime evidence
  proves a usable quest destination.
- Minimap remains stock.

## Next Action

E.4 implements only the runtime-proven **manual user waypoint** bearing marker
on the existing compass.

Requirements:
1. use current-player-map coordinates, not raw world X/Y, for bearing;
2. show no marker when the user waypoint is absent or unusable;
3. update on `USER_WAYPOINT_UPDATED` and while player position changes;
4. preserve existing compass world/Immersion eligibility;
5. fail open to Blizzard navigation;
6. do not add quest waypoint presentation from source presence alone;
7. do not suppress the minimap.

## Success Criteria

E.4 succeeds when:
- a manual user waypoint produces a restrained compass marker at the correct
  relative heading;
- moving/clearing the waypoint updates/removes the marker without stale state;
- player movement updates the relative bearing;
- ineligible/restricted contexts omit the marker cleanly;
- no Lua/taint/secret errors occur;
- Blizzard minimap/navigation remains available.

## Do Not Reopen Without New Evidence

- **E.1:** complete.
- **E.2:** complete.
- **E.3:** complete.
- **User-waypoint map-space bearing:** proven.
- **Raw world X/Y bearing:** rejected for compass orientation on tested map.
- **Quest IDs 436/237 next waypoint:** unavailable in tested state.
- **Quest marker:** unsupported until separately runtime-proven.
- **Minimap suppression:** deferred/capability-gated.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/E3_P0073_RUNTIME_PASS_2026-10-02.md`
- `docs/memory/evidence/E3_P0073_MAP_SPACE_BEARING_CORRECTION_2026-10-01.md`
- `docs/memory/investigations/E3_WAYPOINT_BEARING_CAPABILITY_PROOF.md`
- `docs/memory/decisions/D-029_COMPASS_NAVIGATION_CAPABILITY_CONTRACT.md`
