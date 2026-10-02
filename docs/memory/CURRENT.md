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

E.1 and E.2 are complete.

P0068 is verified pushed at `740ebe15`.

P0069 prepares a dedicated waypoint capability probe; production Logres remains
at `0.0.28-dev`.

## Verified State

- Phase 0 complete.
- Phase A complete.
- Phase B complete.
- Phase C complete.
- Phase D complete.
- D.1–D.6 complete.
- P0065 pushed at `46271f97`; Phase D closed and Phase E opened.
- P0066 pushed at `586d188d`; D-029 accepted, E.1 closed, E.2 opened.
- P0067 pushed at `931f068e`; heading-only compass runtime proof passed.
- P0068 pushed at `740ebe15`; E.2 closed and E.3 opened.
- D-029 remains the canonical Phase E navigation capability contract.
- E.3 requires runtime proof before production waypoint presentation.
- Current source supports a narrow dedicated diagnostic:
  - user waypoint retrieval source exists;
  - map position -> world position conversion source exists;
  - quest next-waypoint and super-track sources exist;
  - SuperTrack events are candidates for runtime proof.
- `USER_WAYPOINT_UPDATED` remains unproven as a Forever dependency.
- P0069 does not change the production Compass module.
- P0069 does not change the production runtime version.
- P0069 does not set/clear waypoints or mutate supertracking.
- P0069 does not suppress/mutate the minimap.
- Minimap suppression remains forbidden/capability-gated.
- Party/CompactPartyFrame suppression remains capability-deferred.
- Primary replacement/routing ownership remains deferred.
- TargetFrame intermittent reappearance remains OPEN / UNREPRODUCED.
- future Aura / Status Presentation remains deferred.
- D-020 live action editing remains deferred.
- cast cue color regression remains open visual debt.

## Next Action

Deploy the temporary P0069 `LogresWaypointAudit` addon and execute the E.3
runtime matrix:

1. open-world snapshot with no user waypoint;
2. snapshot with an active user waypoint at a visibly known direction;
3. change/clear the waypoint and inspect candidate event counts;
4. super-track a quest with a visible destination and snapshot;
5. change super-tracking if convenient and inspect event counts;
6. compare recorded bearing candidates with visible direction.

Preserve unavailable/unsupported cases as negative evidence.

Do not add production waypoint presentation yet.

Do not suppress the minimap.

## Success Criteria

E.3 succeeds when:
- at least one supported destination source has runtime-proven retrieval;
- player and destination coordinates can be converted into a compatible domain;
- bearing math/orientation is runtime-proven;
- update/invalidation behavior is defined from proven Forever events or another
  narrow evidence-backed mechanism;
- unsupported/restricted cases omit the marker without fabricating direction;
- Blizzard navigation remains available as fail-open fallback.

## Do Not Reopen Without New Evidence

- **Phase D / D.1–D.6:** complete.
- **E.1:** complete.
- **E.2:** complete.
- **D-029 heading source:** `GetPlayerFacing()`.
- **Production waypoint marker:** not authorized before E.3 runtime proof.
- **Minimap suppression:** deferred/capability-gated.
- **Party suppression:** capability-deferred.
- **Primary replacement/routing:** deferred.
- **TargetFrame intermittent reappearance:** open/unreproduced.
- **P0064/P0067 delivery failures:** durable project knowledge.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/decisions/D-029_COMPASS_NAVIGATION_CAPABILITY_CONTRACT.md`
- `docs/memory/evidence/E1_COMPASS_NAVIGATION_SOURCE_REVIEW_2026-10-01.md`
- `docs/memory/evidence/E2_P0067_RUNTIME_PASS_2026-10-01.md`
- `docs/memory/evidence/E3_P0069_WAYPOINT_SOURCE_PROBE_DESIGN_2026-10-01.md`
- `docs/memory/investigations/E3_WAYPOINT_BEARING_CAPABILITY_PROOF.md`
- `docs/memory/roadmap/PHASE_E_COMPASS_NAVIGATION.md`
- `docs/memory/architecture/COMPASS.md`
