---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase D — Immersion Controller.**

## Current Work Item

**D.6 — Restoration / integration validation.**

D.5 is runtime-proven and complete.

## Verified State

- Phase 0 complete.
- Phase A complete.
- Phase B complete.
- Phase C complete.
- D.1 complete.
- D.2 complete.
- D.3 complete.
- D.4 complete for supported Player + Target selective replacement.
- D.5 complete.
- P0060 pushed at `9608634`.
- P0060 runtime `0.0.26-dev`.
- Context Policy Check PASS.
- Run All PASS.
- Immersion OFF context policy PASS.
- Immersion ON context policy PASS.
- D-028 orchestration matrix remains canonical and runtime-proven for tested
  scope.
- Party/CompactPartyFrame suppression remains capability-deferred.
- Primary replacement/routing ownership remains deferred.
- TargetFrame intermittent reappearance remains OPEN / UNREPRODUCED.
- future Aura / Status Presentation domain remains deferred.
- D-020 live action editing remains deferred.
- cast cue color regression remains open visual debt.

## Next Action

Design and implement D.6 integrated restoration / recovery validation.

The validation should cover:
1. Immersion ON;
2. Immersion OFF;
3. OFF -> ON and ON -> OFF restoration;
4. persisted preference through `/reload`;
5. combat-deferred protected transitions and convergence after combat;
6. world/PvP/context integration;
7. natural instance transition when available;
8. module disable/restore recovery where supported;
9. stock fallback surfaces remain available;
10. no invisible protected interaction regions;
11. no Lua/taint/secret regression.

Prefer addon-owned diagnostic state.

Do not inspect protected Blizzard presentation values solely to prove a
mutation.

## Success Criteria

D.6 succeeds when Phase D behaves as one reversible system:
- preference-driven suppression/restoration is reliable;
- protected deferrals converge;
- context policy remains coherent;
- fallback stock surfaces remain available where Logres lacks replacement;
- developer recovery remains fail-open;
- no required control/information is lost.

## Do Not Reopen Without New Evidence

- **D.1–D.5:** complete.
- **Party suppression:** capability-deferred.
- **Primary replacement/routing:** deferred.
- **TargetFrame intermittent reappearance:** open/unreproduced.
- **Aura/status suppression:** deferred design domain.
- **Whole PlayerFrame / TargetFrame suppression:** rejected.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/D5_P0060_CONTEXT_POLICY_RUNTIME_PROOF_2026-10-01.md`
- `docs/memory/investigations/D6_RESTORATION_INTEGRATION_VALIDATION.md`
- `docs/memory/decisions/D-028_CONTEXT_ORCHESTRATION_MATRIX.md`
- `docs/memory/roadmap/PHASE_D_IMMERSION_CONTROLLER.md`
