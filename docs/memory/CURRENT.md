---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase E — Compass and Navigation.**

## Current Work Item

**E.3 — Waypoint-bearing capability/proof.**

P0072 is verified pushed at `1fc48777`.

## Verified State

- E.1 complete.
- E.2 complete.
- User-waypoint retrieval is runtime-proven.
- User-waypoint absence/clear behavior is runtime-proven.
- User-waypoint world conversion is runtime-proven.
- `USER_WAYPOINT_UPDATED` is runtime-proven to register and fire.
- `SUPER_TRACKING_CHANGED` is runtime-proven to register and fire.
- `SUPER_TRACKING_PATH_UPDATED` registered but did not fire in the tested run.
- Tested super-tracked quest IDs `436` and `237` returned no usable next
  waypoint.
- P0072 corrected the P0071 TOC/Bootstrap version mismatch.
- Runtime is `0.0.29-dev`.
- A deliberate north-reference waypoint produced previous raw-world bearing
  candidates near east (`87.1`/`92.9`), proving the raw world axes are not a
  valid north-axis source for this map.
- P0073 switches orientation proof to player-map coordinates via
  `C_Map.GetUserWaypointPositionForMap(mapID)`.
- Production waypoint presentation remains unimplemented.
- Minimap remains stock.

## Next Action

Apply/push P0073.

Then perform exactly one north-reference `Waypoint Probe`.

Expected proof:
- user waypoint present;
- current-player-map waypoint position usable;
- map-space bearing approximately `0`/`360` degrees.

Do not repeat retrieval/event/quest tests already proven.

## Success Criteria

E.3 closes when:
- map-space waypoint retrieval works on Forever;
- the deliberate north-reference waypoint resolves near `0`/`360`;
- absent/unavailable waypoint inputs still produce no bearing;
- Blizzard navigation remains fail-open fallback.

## Do Not Reopen Without New Evidence

- **E.1:** complete.
- **E.2:** complete.
- **User waypoint retrieval/world conversion:** proven.
- **USER_WAYPOINT_UPDATED:** proven.
- **SUPER_TRACKING_CHANGED:** proven.
- **Raw world axes as compass-north basis:** rejected by runtime north-reference
  evidence.
- **Quest IDs 436/237 next waypoint:** unavailable in tested state.
- **Minimap suppression:** deferred/capability-gated.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/E3_P0071_RUNTIME_EVIDENCE_2026-10-01.md`
- `docs/memory/evidence/E3_P0073_MAP_SPACE_BEARING_CORRECTION_2026-10-01.md`
- `docs/memory/investigations/E3_WAYPOINT_BEARING_CAPABILITY_PROOF.md`
- `docs/memory/decisions/D-029_COMPASS_NAVIGATION_CAPABILITY_CONTRACT.md`
