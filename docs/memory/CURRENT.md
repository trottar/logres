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

P0067 is verified pushed at `931f068e`.

The user reported that all requested P0067 runtime validation checks passed.

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
- P0065 pushed at `46271f97`; Phase D closed and Phase E opened.
- P0066 pushed at `586d188d`; D-029 accepted, E.1 closed, E.2 opened.
- P0067 pushed at `931f068e`; runtime `0.0.28-dev`.
- P0067 requested runtime validation passed:
  - open-world Compass Check PASS;
  - heading tape followed player rotation;
  - N/E/S/W orientation was correct;
  - Immersion OFF hid/suspended the compass and Compass Check passed;
  - Immersion ON restored the compass and Compass Check passed;
  - Run All passed;
  - no Lua/taint/secret regression was reported;
  - minimap remained unchanged.
- Direct P0067 module suspension/restoration across a natural instance transition
  was not separately exercised in the final requested validation sequence.
- Existing I-001 runtime evidence remains authoritative for the underlying
  restricted-context capability boundary: facing/position were unavailable in
  the tested party instance and restored after returning to the world.
- E.2 therefore closes with direct world/preference/orientation proof plus the
  explicitly permitted instance environmental deferral.
- D-029 remains the canonical Phase E navigation capability contract.
- E.2 uses `GetPlayerFacing()` only and has no position/waypoint dependency.
- User/quest waypoint behavior remains unproven and is now the active E.3 scope.
- Minimap suppression remains forbidden/capability-gated.
- Party/CompactPartyFrame suppression remains capability-deferred.
- Primary replacement/routing ownership remains deferred.
- TargetFrame intermittent reappearance remains OPEN / UNREPRODUCED.
- future Aura / Status Presentation remains deferred.
- D-020 live action editing remains deferred.
- cast cue color regression remains open visual debt.

## Next Action

Execute E.3 waypoint-bearing capability/proof before adding any waypoint marker.

Prove:
1. user waypoint retrieval on Forever;
2. active/super-tracked quest selection behavior;
3. quest waypoint result semantics;
4. reliable Forever update events;
5. player + destination map/world conversion;
6. axis/bearing orientation in game;
7. same-domain requirements for valid bearing math;
8. fail-open behavior when any required input is unavailable.

Do not add waypoint presentation from source presence alone.

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
- **E.2:** complete with user-reported requested runtime PASS and explicit
  natural-instance environmental deferral.
- **D-029 heading source:** `GetPlayerFacing()`.
- **Waypoint markers:** E.3 capability/proof first; presentation remains unproven.
- **Minimap suppression:** deferred/capability-gated.
- **Party suppression:** capability-deferred.
- **Primary replacement/routing:** deferred.
- **TargetFrame intermittent reappearance:** open/unreproduced.
- **P0064/P0067 delivery failures:** durable project knowledge.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/decisions/D-029_COMPASS_NAVIGATION_CAPABILITY_CONTRACT.md`
- `docs/memory/evidence/E1_COMPASS_NAVIGATION_SOURCE_REVIEW_2026-10-01.md`
- `docs/memory/evidence/E2_P0067_HEADING_COMPASS_IMPLEMENTATION_2026-10-01.md`
- `docs/memory/evidence/E2_P0067_RUNTIME_PASS_2026-10-01.md`
- `docs/memory/evidence/E2_P0067_STATIC_CHECKER_FAILURE_2026-10-01.md`
- `docs/memory/investigations/E2_HEADING_COMPASS_RUNTIME_VALIDATION.md`
- `docs/memory/investigations/E3_WAYPOINT_BEARING_CAPABILITY_PROOF.md`
- `docs/memory/roadmap/PHASE_E_COMPASS_NAVIGATION.md`
- `docs/memory/architecture/COMPASS.md`
- `docs/memory/evidence/I001_RUNTIME_PASS_01_2026-09-30.md`
- `docs/memory/evidence/I001_RUNTIME_PASS_02_2026-09-30.md`
