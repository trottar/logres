---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase E — Compass and Navigation.**

## Current Work Item

**E.2 — Heading-only world compass runtime validation.**

E.1 is complete.

P0067 implementation is prepared for runtime proof.

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
- P0067 targets runtime `0.0.28-dev`.
- D-029 remains the canonical Phase E navigation capability contract.
- E.2 uses `GetPlayerFacing()` only.
- E.2 has no player-position, waypoint, distance, route, or minimap dependency.
- Compass presentation is gated by Immersion preference + existing State world
  context.
- The compass samples facing only in eligible world context.
- Facing values are secret-checked before inspection/arithmetic.
- Unavailable facing clears/hides presentation; no stale heading fallback is
  retained.
- In eligible world context, the throttled sampler remains active through a
  temporarily unavailable sample so capability can recover.
- In instance/non-world context the facing sampler is disabled.
- User/quest waypoint work remains queued for E.3.
- Minimap suppression remains forbidden/capability-gated.
- Party/CompactPartyFrame suppression remains capability-deferred.
- Primary replacement/routing ownership remains deferred.
- TargetFrame intermittent reappearance remains OPEN / UNREPRODUCED.
- future Aura / Status Presentation remains deferred.
- D-020 live action editing remains deferred.
- cast cue color regression remains open visual debt.

## Next Action

Deploy and runtime-validate P0067 on `0.0.28-dev`.

Validate:
1. Immersion ON in open world: Compass Check PASS;
2. heading tape visible and follows player rotation;
3. N/E/S/W orientation correct;
4. Immersion OFF: compass hidden and Compass Check PASS suspended;
5. Immersion ON: compass restores and Compass Check PASS;
6. `/reload`: preference-driven compass state restores;
7. natural instance transition when available: compass suspends, sampler stops,
   Compass Check PASS; returning to world restores;
8. Run All PASS for checks actually performed;
9. no Lua/taint/secret regression;
10. minimap remains untouched.

Do not require contrived travel solely to manufacture instance proof. If no
natural instance is available, record environmental deferral rather than PASS.

## Success Criteria

E.2 succeeds when:
- the heading tape tracks player facing outdoors;
- N/E/S/W orientation is visually correct;
- Immersion OFF hides it;
- Immersion ON restores it;
- restricted-context suspension/restoration is proven or explicitly
  environmentally deferred with prior I-001 capability evidence preserved;
- no Lua/taint/secret regression occurs;
- minimap remains untouched.

## Do Not Reopen Without New Evidence

- **Phase D / D.1–D.6:** complete.
- **D-029 heading source:** `GetPlayerFacing()` for E.2.
- **E.2 position dependency:** none.
- **Waypoint markers:** deferred to E.3.
- **Minimap suppression:** deferred/capability-gated.
- **Party suppression:** capability-deferred.
- **Primary replacement/routing:** deferred.
- **TargetFrame intermittent reappearance:** open/unreproduced.
- **P0064 delivery failures:** durable; follow the restored standard patch procedure.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/decisions/D-029_COMPASS_NAVIGATION_CAPABILITY_CONTRACT.md`
- `docs/memory/evidence/E1_COMPASS_NAVIGATION_SOURCE_REVIEW_2026-10-01.md`
- `docs/memory/evidence/E2_P0067_HEADING_COMPASS_IMPLEMENTATION_2026-10-01.md`
- `docs/memory/evidence/E2_P0067_STATIC_CHECKER_FAILURE_2026-10-01.md`
- `docs/memory/investigations/E2_HEADING_COMPASS_RUNTIME_VALIDATION.md`
- `docs/memory/roadmap/PHASE_E_COMPASS_NAVIGATION.md`
- `docs/memory/architecture/COMPASS.md`
- `docs/memory/evidence/I001_RUNTIME_PASS_01_2026-09-30.md`
- `docs/memory/evidence/I001_RUNTIME_PASS_02_2026-09-30.md`
