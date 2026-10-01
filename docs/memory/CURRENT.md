---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase D — Immersion Controller.**

## Current Work Item

**D.5 — Context / PvP / instance orchestration source/design review.**

D.4 is complete for supported selective unit-frame capabilities.

## Verified State

- Phase 0 complete.
- Phase A complete.
- Phase B complete.
- Phase C complete.
- D.1 complete.
- D.2 complete.
- D.3 complete.
- D.4 complete for supported Player + Target selective replacement.
- Party/CompactPartyFrame suppression remains deferred by capability gate.
- P0057 pushed at `fc848b9`.
- runtime remains `0.0.25-dev`.
- Target Frame Check PASS after P0057.
- Immersion Check PASS after P0057.
- Run All PASS after P0057.
- P0056 secret-boolean diagnostic failure is fixed.
- one stock TargetFrame reappearance was observed once and is OPEN /
  INTERMITTENT / UNREPRODUCED.
- `/reload` restored expected target suppression.
- do not add periodic target suppression forcing without a reproducible trigger.
- target buffs/status remain visible intentionally under D-027.
- player buffs/status remain visible intentionally outside current Player shell
  ownership.
- future Aura / Status Presentation domain is recorded.
- D.3 instance Quiet Mode transition remains environmental deferral.
- Primary replacement/routing ownership remains deferred.
- D-020 live action editing remains deferred.
- cast cue color regression remains open visual debt.

## Next Action

Source/design-resolve D.5.

Use current orthogonal state:
- `context`;
- `inInstance`;
- `instanceType`;
- `combat`;
- `pvpFlagged`;
- mounted/resting/taxi/interacting only where a policy actually needs them.

Resolve a deterministic policy matrix for currently supported immersion
domains:
1. Bar 2–3 replacement;
2. Quiet Mode;
3. Player selective replacement;
4. Target selective replacement;
5. future/unsupported Party remains stock;
6. later Compass/Quest/Camera domains should have explicit hooks but are not
   implemented in Phase D.

Questions:
- should Player/Target selective replacement remain active in instances?
- should action replacement remain active in instances?
- Quiet Mode currently restores in instances; keep or refine by instance type?
- how does PvP flagging modify presentation without becoming immersion OFF?
- which state has precedence when combat/PvP/context overlap?
- which transitions require no mutation because domain policy stays unchanged?
- how should unsupported/deferred surfaces fail open?

## Success Criteria

D.5 source/design review succeeds when there is one explicit policy matrix with:
- world idle;
- world combat;
- PvP flagged idle/combat;
- instance idle/combat;
- precedence rules;
- supported-domain desired state;
- unsupported-domain fallback;
- runtime transition proof plan.

## Do Not Reopen Without New Evidence

- **D.1–D.4 supported scope:** complete.
- **Party suppression:** capability-deferred.
- **TargetFrame intermittent reappearance:** open/unreproduced; capture on
  recurrence.
- **Aura/status suppression:** deferred design domain.
- **Whole PlayerFrame / TargetFrame suppression:** rejected.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/D4_P0057_TARGET_RUNTIME_PROOF_2026-10-01.md`
- `docs/memory/investigations/D4_TARGETFRAME_REASSERTION_INTERMITTENT.md`
- `docs/memory/investigations/FUTURE_AURA_STATUS_PRESENTATION.md`
- `docs/memory/roadmap/PHASE_D_IMMERSION_CONTROLLER.md`
- `docs/memory/decisions/D-024_IMMERSION_ORCHESTRATION_CONTRACT.md`
- `Logres/Core/State.lua`
- `Logres/Immersion/Controller.lua`
