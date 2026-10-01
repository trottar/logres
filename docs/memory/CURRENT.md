---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase D — Immersion Controller.**

## Current Work Item

**D.2 — Immersion Controller runtime foundation.**

D.1 source/design review is complete.

## Verified State

- Phase 0 complete.
- Phase A complete.
- Phase B complete.
- Phase C complete.
- P0046 pushed at `8ad0f01`.
- runtime remains `0.0.20-dev`.
- D-024 immersion orchestration contract accepted.
- Phase C Bar 2–3 replacement is safe for automatic Phase D orchestration.
- Quiet Mode first pass can use runtime-only chat/tab suppression without
  changing saved chat settings.
- full PlayerFrame suppression is BLOCKED by un-replaced child resources.
- full TargetFrame suppression is BLOCKED by secure interaction + aura policy.
- full PartyFrame/CompactPartyFrame suppression is BLOCKED by secure
  interaction and additional group context.
- Primary action routing remains manual while Primary stock replacement is
  unsupported.
- live action editing remains deferred under D-020.
- cast cue color regression remains open visual debt.

## Next Action

Implement D.2.

Runtime target:
1. add `ImmersionController` module;
2. consume preference snapshot/subscription;
3. consume State snapshot/subscription;
4. compute desired orchestration policy;
5. when immersion ON, automatically request Phase C Bar 2–3 replacement;
6. when immersion OFF, restore that replacement;
7. expose desired Quiet Mode state diagnostically;
8. add `Immersion Check`;
9. do not suppress Player/Target/Party yet.

Expected policy:
- action replacement follows `immersionEnabled`;
- Quiet Mode desired in world while immersion ON;
- Quiet Mode desired OFF in instances for first conservative pass;
- PvP does not turn immersion off.

## Success Criteria

D.2 succeeds when:
- reload with persisted immersion ON automatically applies supported Bar 2–3
  replacement;
- immersion OFF restores Bars 2–3;
- immersion ON reapplies them;
- combat-time preference changes safely defer through the existing replacement
  module;
- Primary keys are not seized automatically;
- unit frames remain untouched;
- controller diagnostics explain desired/applied state;
- no protected/taint/Lua/secret regression occurs.

## Do Not Reopen Without New Evidence

- **Phase C:** complete.
- **D.1:** complete.
- **Full PlayerFrame suppression:** blocked pending child-resource-safe design.
- **Full TargetFrame suppression:** blocked pending secure interaction/aura
  design.
- **Party suppression:** blocked pending secure interaction + normal/compact
  coverage.
- **Primary replacement/routing:** deferred.
- **D-020 live action editing:** deferred.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/D1_IMMERSION_ORCHESTRATION_SOURCE_REVIEW_2026-10-01.md`
- `docs/memory/decisions/D-024_IMMERSION_ORCHESTRATION_CONTRACT.md`
- `docs/memory/roadmap/PHASE_D_IMMERSION_CONTROLLER.md`
- `docs/memory/investigations/D1_IMMERSION_ORCHESTRATION_SOURCE_REVIEW.md`
- `docs/memory/decisions/D-017_BLIZZARD_UI_SUPPRESSION_AND_RESTORATION.md`
