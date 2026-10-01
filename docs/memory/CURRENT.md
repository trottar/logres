---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase B — Core HUD.**

## Current Work Item

**B.5 — Allies and Pets.**

B.4 is complete with an explicit environmental deferral for the current-target caster true path.

Player cast presentation is runtime proven:
- normal cast cue;
- channel cue;
- interruption/failure snap.

The current-target cast cue remains implemented and should be retried when a natural caster is available.

## Verified State

- Phase A complete.
- B.1 health vignette complete.
- B.2 primary resource percentage complete.
- B.3 target presentation complete.
- B.4 cast confirmation complete with target-caster true-path environmental deferral.
- P0025 pushed at `4c27c6c`.
- current runtime version: `0.0.11-dev`.
- player cast/channel/interruption behavior passed runtime testing.
- no conventional cast bar exists.
- no reported secret-value/Lua error in tested B.4 paths.

## Next Action

Design/source-check B.5 before implementing it.

Initial candidate unit scope:
- pet;
- party1;
- party2;
- party3;
- party4.

Resolve:
1. party/pet roster/existence event coverage;
2. per-unit health/name update events;
3. secret-safe name/health forwarding;
4. compact row ownership;
5. layout that preserves future action-cluster space;
6. environmental coverage for party/pet true paths.

Default presentation remains:
- name;
- health percentage;
- compact condition awareness.

Do not build conventional party frames or portrait/bar-heavy unit frames.

When B.5 runtime code is prepared, include the full deploy block before in-game validation.

## Success Criteria

B.5 succeeds when:
- compact ally/pet presentation is implemented;
- available party/pet units show name + health percentage;
- health/name updates behave;
- unit creation/loss/roster changes behave;
- immersion hide/restore works through the shared HUD root;
- no conventional party frame is introduced;
- unavailable true paths are explicitly deferred by environment/class constraints;
- no secret-value/Lua errors occur.

## Do Not Reopen Without New Evidence

- **B.1:** complete.
- **B.2:** complete.
- **B.3:** complete.
- **B.4:** complete with target true-path environmental deferral.
- **Target caster:** retry naturally; no travel required solely for proof.
- **Allies/pets:** sparse name + health percentage default.
- **Accessibility/healer mode:** separate future concern.
- **Deployment:** full deploy block required for runtime-code tests.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/B4_CAST_CONFIRMATION_RUNTIME_PROOF_2026-10-01.md`
- `docs/memory/decisions/D-014_CAST_PRESENTATION_CONTRACT.md`
- `docs/memory/investigations/B5_ALLIES_AND_PETS.md`
- `docs/memory/architecture/HUD.md`
- `docs/memory/roadmap/PHASE_B_CORE_HUD.md`
