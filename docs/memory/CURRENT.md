---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase E — Compass and Navigation.**

## Current Work Item

**E.2 — Heading-only world compass runtime implementation.**

E.1 source review is complete.

## Verified State

- Phase 0 complete.
- Phase A complete.
- Phase B complete.
- Phase C complete.
- Phase D complete.
- D.1–D.6 complete.
- P0063 pushed at `20b1bf55`; user-reported runtime validation PASS.
- P0064 pushed at `770f9f30`; assistant workflow failures are durable project
  knowledge and the standard patch procedure is restored.
- P0065 pushed at `46271f97`; Phase D closed and Phase E / E.1 opened.
- Runtime remains `0.0.27-dev`.
- D-029 is the canonical Phase E navigation capability contract.
- Forever source + I-001 runtime evidence agree that `GetPlayerFacing()` is
  usable outdoors and unavailable in restricted instance contexts.
- `C_Map.GetBestMapForUnit("player")` +
  `C_Map.GetPlayerMapPosition(mapID, "player")` is the later player-position
  path; I-001 already proved it in open world and proved its absence in the
  tested party instance.
- User-waypoint APIs are source-present on Forever, but project runtime semantics
  are not yet proven.
- `C_QuestLog.GetNextWaypoint` is source-present and project presence-proven,
  but detailed waypoint semantics are not yet runtime-proven.
- `SUPER_TRACKING_CHANGED` is source-listed for Forever.
- `USER_WAYPOINT_UPDATED` is not relied on because current source reference does
  not list Forever support.
- Minimap suppression remains forbidden until Logres navigation deliberately
  replaces the required information/control surface.

## Next Action

Implement E.2 as the smallest proven compass slice:

1. add a `Compass` module;
2. top-center horizontal Warcraft-style heading tape;
3. consume `immersionEnabled` + existing State context;
4. use `GetPlayerFacing()` only for the first slice;
5. convert API facing to conventional compass heading for presentation:
   `headingDegrees = (360 - degrees(facing)) % 360`;
6. update on a throttled `OnUpdate` only while eligible;
7. suspend when Immersion is OFF, context is not world, or facing is unavailable;
8. add addon-owned diagnostic state + `Compass Check`;
9. do not add waypoint markers, distance, map-position logic, or minimap
   suppression in E.2.

Runtime target:
`0.0.28-dev`.

## Success Criteria

E.2 succeeds when:
- the heading tape tracks player facing outdoors;
- N/E/S/W orientation is visually correct;
- Immersion OFF hides it;
- Immersion ON restores it;
- instance/restricted unavailability suspends it without fabricated heading;
- returning to world restores it;
- no Lua/taint/secret regression occurs;
- minimap remains untouched.

## Do Not Reopen Without New Evidence

- **Phase D / D.1–D.6:** complete.
- **D-029 heading source:** `GetPlayerFacing()` for E.2.
- **E.2 position dependency:** none.
- **Waypoint markers:** deferred until their runtime data/event contract is
  proven.
- **Minimap suppression:** deferred/capability-gated.
- **Party suppression:** capability-deferred.
- **Primary replacement/routing:** deferred.
- **TargetFrame intermittent reappearance:** open/unreproduced.
- **P0064 delivery failures:** durable; follow the restored standard patch procedure.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/decisions/D-029_COMPASS_NAVIGATION_CAPABILITY_CONTRACT.md`
- `docs/memory/evidence/E1_COMPASS_NAVIGATION_SOURCE_REVIEW_2026-10-01.md`
- `docs/memory/roadmap/PHASE_E_COMPASS_NAVIGATION.md`
- `docs/memory/investigations/E1_COMPASS_NAVIGATION_SOURCE_REVIEW.md`
- `docs/memory/architecture/COMPASS.md`
- `docs/memory/architecture/API_BOUNDARIES.md`
- `docs/memory/evidence/I001_RUNTIME_PASS_01_2026-09-30.md`
- `docs/memory/evidence/I001_RUNTIME_PASS_02_2026-09-30.md`
