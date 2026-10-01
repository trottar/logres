---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase D — Immersion Controller.**

## Current Work Item

**D.4 — Unit-frame interaction + selective suppression source/design review.**

D.3 is complete with instance-transition proof deferred by environment.

## Verified State

- Phase 0 complete.
- Phase A complete.
- Phase B complete.
- Phase C complete.
- D.1 complete.
- D.2 complete.
- D.3 complete.
- P0050 pushed at `57c682c`.
- P0050 Quiet Mode runtime PASS in the tested world workflow.
- passive chat/social presentation is suppressed under world immersion.
- intentional chat input remains available by design.
- instance Quiet Mode transition proof is DEFERRED BY ENVIRONMENT.
- do not require travel solely to manufacture the instance proof.
- runtime remains `0.0.22-dev`.
- full Player/Target/Party suppression remains capability-gated.
- Primary replacement/routing ownership remains deferred.
- D-020 live action editing remains deferred.
- cast cue color regression remains open visual debt.

## Next Action

Source/design-resolve D.4 before unit-frame suppression code.

Review exact Blizzard source and current Logres capability for:

1. PlayerFrame conventional shell vs required child resources;
2. PlayerFrame secure interaction requirements;
3. TargetFrame shell vs auras/dependent children;
4. secure target click/menu behavior;
5. normal PartyFrame secure interaction;
6. CompactPartyFrame raid-style path;
7. party aura/debuff/role information;
8. combat-lockdown constraints;
9. exact restoration ownership;
10. smallest capability-safe suppression subset for each domain.

Prefer selective shell suppression or explicit deferral over blanket frame hide.

## Success Criteria

D.4 source review succeeds when Player, Target, and Party each have an explicit
decision:
- supported selective suppression;
- required replacement capability first;
- or deferred stock ownership;

with combat/restoration/runtime-proof rules.

## Do Not Reopen Without New Evidence

- **Phase C:** complete.
- **D.1–D.3:** complete.
- **D.3 instance transition:** environmental deferral; retry naturally.
- **Direct ChatFrame Hide/Show for Quiet Mode:** rejected.
- **Blanket Player/Target/Party suppression:** rejected pending D.4 selective
  capability resolution.
- **Primary replacement/routing ownership:** deferred.
- **Auto replies:** not promised.
- **D-020 live action editing:** deferred.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/D3_P0050_QUIET_MODE_RUNTIME_PROOF_2026-10-01.md`
- `docs/memory/decisions/D-025_QUIET_MODE_RUNTIME_SUPPRESSION.md`
- `docs/memory/investigations/D4_UNIT_FRAME_INTERACTION_SUPPRESSION_REVIEW.md`
- `docs/memory/roadmap/PHASE_D_IMMERSION_CONTROLLER.md`
- `docs/memory/evidence/D1_IMMERSION_ORCHESTRATION_SOURCE_REVIEW_2026-10-01.md`
