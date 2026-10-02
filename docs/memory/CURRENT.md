---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase E — Compass and Navigation.**

## Current Work Item

**E.1 — Compass/navigation source review and capability audit.**

Phase D is runtime-proven and complete.

## Verified State

- Phase 0 complete.
- Phase A complete.
- Phase B complete.
- Phase C complete.
- Phase D complete.
- D.1–D.6 complete.
- P0060 pushed at `9608634`.
- P0061 pushed at `01665d1`.
- P0062 pushed at `13c5339`.
- P0063 pushed at `20b1bf55`.
- The user confirmed the requested P0063 runtime validation was completed
  successfully and the panel/runtime behavior was correct.
- P0064 pushed at `770f9f30`; assistant delivery failures are durable project
  knowledge and the standard patch procedure is restored.
- P0063 runtime is `0.0.27-dev`.
- D-028 context policy remains canonical.
- Existing I-001 runtime evidence proves navigation data is available in the
  open world, unavailable in a tested party instance, and restored after
  returning to the world.
- `C_QuestLog.GetNextWaypoint` is known present, but detailed waypoint
  semantics remain unproven.
- Party/CompactPartyFrame suppression remains capability-deferred.
- Primary replacement/routing ownership remains deferred.
- TargetFrame intermittent reappearance remains OPEN / UNREPRODUCED.
- future Aura / Status Presentation remains deferred.
- D-020 live action editing remains deferred.
- cast cue color regression remains open visual debt.

## Next Action

Perform E.1 source review before writing compass runtime code.

Resolve:
1. exact production heading/facing source;
2. exact production map-position source;
3. availability/suspension behavior when navigation data is absent;
4. integration with existing world/instance State;
5. selected quest/user waypoint capability boundaries;
6. the Phase E / Phase F ownership boundary for quest presentation;
7. the minimum capability required before any minimap suppression is allowed;
8. a narrow Compass diagnostic/runtime proof plan.

Do not suppress the minimap during E.1.

Do not fabricate bearings when position/facing data is unavailable.

## Success Criteria

E.1 succeeds when current Forever source/runtime evidence defines:
- the production navigation input APIs;
- a capability-gated world compass contract;
- deterministic instance suspension/restoration;
- waypoint limitations;
- fail-open Blizzard navigation fallback;
- the first safe runtime implementation slice.

## Do Not Reopen Without New Evidence

- **Phase D / D.1–D.6:** complete.
- **Party suppression:** capability-deferred.
- **Primary replacement/routing:** deferred.
- **TargetFrame intermittent reappearance:** open/unreproduced.
- **Aura/status suppression:** deferred design domain.
- **Whole PlayerFrame / TargetFrame suppression:** rejected.
- **P0064 delivery failures:** durable; follow the restored standard patch procedure.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/D6_P0063_RESTORATION_RUNTIME_PROOF_2026-10-01.md`
- `docs/memory/evidence/P0064_ASSISTANT_WORKFLOW_FAILURES_2026-10-01.md`
- `docs/memory/roadmap/PHASE_D_IMMERSION_CONTROLLER.md`
- `docs/memory/roadmap/PHASE_E_COMPASS_NAVIGATION.md`
- `docs/memory/investigations/E1_COMPASS_NAVIGATION_SOURCE_REVIEW.md`
- `docs/memory/architecture/API_BOUNDARIES.md`
- `docs/memory/evidence/I001_RUNTIME_PASS_02_2026-09-30.md`
- `docs/ROADMAP.md`
