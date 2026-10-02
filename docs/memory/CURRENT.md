---
memory_schema: 1
as_of: 2026-10-02
project: logres
---

# Current State

## Active Objective

**Phase E — Compass and Navigation.**

## Current Work Item

**E.5 — Navigation sufficiency / minimap capability review.**

P0075 is verified pushed at `51763025`.

E.4 is complete.

Production runtime remains:
`0.0.30-dev`.

## Verified State

- E.1 complete.
- E.2 complete.
- E.3 complete.
- E.4 complete.
- Manual user-waypoint retrieval, update, clearing, map-space bearing, and
  production compass presentation are runtime-proven.
- P0075 persisted diagnostics prove:
  - no waypoint -> no marker;
  - out-of-tape waypoint -> marker omitted;
  - in-tape waypoint -> marker shown;
  - clearing waypoint -> no stale marker;
  - Immersion OFF -> compass/marker suppressed;
  - Immersion ON -> compass recovery;
  - Compass Check PASS;
  - Run All PASS.
- User visual confirmation proves:
  - marker direction tracked correctly while rotating/moving;
  - no Lua/taint/secret-value errors were observed;
  - Blizzard minimap remained unchanged.
- The supported bearing domain remains current UI map space:
  - player position from `C_Map.GetPlayerMapPosition`;
  - destination from `C_Map.GetUserWaypointPositionForMap`;
  - clockwise bearing:
    `(degrees(atan2(dx, -dy)) + 360) % 360`.
- Raw world X/Y remains rejected for compass orientation.
- Tested super-tracked quest IDs `436` and `237` returned no usable next waypoint.
- Quest marker presentation remains unsupported without new runtime evidence.
- Minimap remains stock.

## Next Action

E.5 reviews whether Logres navigation is sufficient to replace any Blizzard
minimap/navigation surface safely.

The review must identify:
1. information/control surfaces currently supplied by the Blizzard minimap;
2. which of those Logres already replaces deliberately;
3. which remain missing or intentionally Blizzard-owned;
4. interaction/control requirements, including tracking and click behavior;
5. context-specific fallback requirements;
6. whether any minimap suppression is justified at all.

Do not suppress or mutate the minimap during the review.

## Success Criteria

E.5 succeeds when the project has an explicit capability contract stating:
- which minimap/navigation surfaces remain required;
- whether reversible minimap suppression is allowed in any context;
- exact capability gates for any allowed suppression;
- required restoration/fail-open behavior;
- explicit non-scope for surfaces Logres does not replace.

## Do Not Reopen Without New Evidence

- **E.1:** complete.
- **E.2:** complete.
- **E.3:** complete.
- **E.4:** complete.
- **Manual user-waypoint compass marker:** runtime + visual PASS.
- **User-waypoint map-space bearing:** proven.
- **Raw world X/Y bearing:** rejected.
- **Quest marker:** unsupported until separately runtime-proven.
- **Minimap:** stock until E.5 capability contract explicitly says otherwise.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/E4_P0075_RUNTIME_PASS_2026-10-02.md`
- `docs/memory/evidence/E3_P0073_RUNTIME_PASS_2026-10-02.md`
- `docs/memory/investigations/E5_NAVIGATION_SUFFICIENCY_MINIMAP_CAPABILITY.md`
- `docs/memory/decisions/D-029_COMPASS_NAVIGATION_CAPABILITY_CONTRACT.md`
