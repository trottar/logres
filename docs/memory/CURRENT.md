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

P0074 is verified pushed at `04d79317`.

P0075 prepares the production manual user-waypoint compass marker.

Production runtime target:
`0.0.30-dev`.

## Verified State

- E.1 complete.
- E.2 complete.
- E.3 complete.
- Manual user-waypoint retrieval is runtime-proven.
- User-waypoint clear behavior is runtime-proven with no stale bearing.
- `USER_WAYPOINT_UPDATED` is runtime-proven to register and fire.
- The supported bearing domain is the player's current UI map:
  - player position from `C_Map.GetPlayerMapPosition`;
  - destination from `C_Map.GetUserWaypointPositionForMap`;
  - clockwise bearing from `(degrees(atan2(dx, -dy)) + 360) % 360`.
- Deliberate north-reference proof resolved to `359.2` degrees.
- Raw world X/Y remains rejected for compass orientation.
- Tested super-tracked quest IDs `436` and `237` returned no usable next waypoint.
- Quest marker presentation remains unsupported without new runtime evidence.
- Minimap remains stock.

## P0075 Design

P0075 integrates only the proven manual user-waypoint path into the existing
Compass module.

The marker:
- uses current UI map coordinates only;
- updates from `USER_WAYPOINT_UPDATED`;
- resamples player/destination position on a throttled interval while the
  compass is eligible so player movement changes the relative bearing;
- shares existing world/Immersion eligibility;
- is shown only while its relative bearing lies inside the visible compass tape;
- disappears immediately when the waypoint/input becomes absent or unusable;
- never caches a stale destination as fallback.

`Compass Check` remains the canonical developer-panel diagnostic and is extended
to validate the waypoint-marker state. No new user workflow is introduced.

## Next Action

Apply/push P0075, deploy, then validate through the existing developer panel.

Required runtime matrix:
1. no manual waypoint -> Compass Check;
2. set a manual waypoint -> Compass Check;
3. rotate so marker crosses the tape and visually follows the correct direction;
4. move enough for bearing to update -> Compass Check;
5. move/clear the waypoint -> Compass Check;
6. Immersion OFF -> marker/compass hidden -> Compass Check;
7. Immersion ON -> recovery -> Compass Check;
8. Run All;
9. no Lua/taint/secret errors;
10. minimap unchanged.

After the final check:
- `/reload`;
- `python3 tools/export_panel_diagnostics.py`;
- attach `LOGRES_DIAGNOSTICS_LATEST.lua`.

## Success Criteria

E.4 succeeds when:
- manual waypoint marker direction is visually correct;
- moving/clearing the waypoint updates/removes without stale state;
- player movement updates relative bearing;
- policy-ineligible contexts omit marker cleanly;
- Compass Check and Run All pass;
- no Lua/taint/secret errors occur;
- minimap/navigation fallback remains available.

## Do Not Reopen Without New Evidence

- **E.1:** complete.
- **E.2:** complete.
- **E.3:** complete.
- **User-waypoint map-space bearing:** proven.
- **Raw world X/Y bearing:** rejected.
- **Quest marker:** unsupported until separately runtime-proven.
- **Minimap suppression:** deferred/capability-gated.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/E3_P0073_RUNTIME_PASS_2026-10-02.md`
- `docs/memory/evidence/E4_P0075_USER_WAYPOINT_MARKER_DESIGN_2026-10-02.md`
- `docs/memory/decisions/D-029_COMPASS_NAVIGATION_CAPABILITY_CONTRACT.md`
