---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase B — Core HUD.**

## Current Work Item

**B.6 — HUD Integration Validation.**

B.5 is complete.

Pet and party presentation are both runtime proven:
- real pet row;
- real party row;
- health updates during combat;
- immersion hide/restore.

B.6 now validates the completed Phase B HUD pieces together before Phase B closes.

## Verified State

- Phase A complete.
- B.1 health vignette complete.
- B.2 primary resource percentage complete.
- B.3 target presentation complete.
- B.4 cast confirmation complete with current-target caster true-path environmental deferral.
- B.5 allies and pets complete.
- P0027 pushed at `42aa8d6`.
- current runtime version: `0.0.12-dev`.
- pet true path: PASS.
- party true path: PASS.
- ally/pet health updates during combat: PASS.
- ally/pet immersion hide/restore: PASS.

## Next Action

Run B.6 integrated HUD validation on the existing `0.0.12-dev` runtime.

The validation should combine ordinary scenarios rather than test each component only in isolation.

Minimum integrated pass:
1. healthy world idle baseline;
2. acquire a target;
3. ordinary combat with target damage;
4. player casts/channels during combat;
5. take safe damage so the health vignette participates;
6. observe resource changes;
7. keep pet and/or party row visible if currently available;
8. clear/switch target and confirm no stale target/cast presentation;
9. immersion off/on while multiple HUD components have active state;
10. combat end cleanup.

Classify:
- functional/runtime defects;
- secret-value errors;
- stale-state regressions;
- visual/layout debt.

Do not require a target caster solely for B.6. Its true path remains environmentally deferred until naturally available.

When giving the runtime validation handoff, include the full deploy block before in-game commands.

## Success Criteria

B.6 succeeds when:
- Phase B HUD components coexist without functional regressions;
- player health/resource/target/cast/ally presentations update together;
- target/cast lifecycle cleanup leaves no stale cues;
- immersion off/on cleanly hides/restores integrated HUD state;
- no Lua/secret-value errors occur;
- layout is usable enough to proceed;
- polish debt is recorded separately;
- existing environmental deferrals remain accurately classified.

## Do Not Reopen Without New Evidence

- **B.1:** complete.
- **B.2:** complete.
- **B.3:** complete.
- **B.4:** complete with target-caster true-path environmental deferral.
- **B.5:** complete; pet and party true paths both proven.
- **Target caster:** retry naturally; do not force travel solely for proof.
- **Visual debt:** does not equal architecture failure unless unusable.
- **Deployment:** full deploy block required for runtime validation handoffs.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/B5_ALLIES_PETS_RUNTIME_PROOF_2026-10-01.md`
- `docs/memory/investigations/B6_HUD_INTEGRATION_VALIDATION.md`
- `docs/memory/architecture/HUD.md`
- `docs/memory/roadmap/PHASE_B_CORE_HUD.md`
- `Logres/HUD/HUD.lua`
