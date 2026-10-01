---
memory_schema: 1
as_of: 2026-09-30
project: logres
---

# Current State

## Active Objective

**Phase A — Core State Engine.** Establish the stable state/lifecycle contract that later Logres modules consume.

## Current Work Item

**A.1 — State contract hardening.**

P0007 prepares the A.1 implementation:
- authoritative mutable state becomes private to `Core/State.lua`;
- consumers read fresh snapshots through `Logres:GetState()`;
- consumers subscribe through `Logres:SubscribeState(handler)`;
- state revisions advance only for actual canonical transitions;
- callback payload semantics are explicit;
- `/logres statecheck` provides travel-free contract validation;
- a static state-contract checker prevents direct `Logres.State` access.

No new game-state sensor and no HUD behavior is added.

## Verified State

- Phase 0 — Foundation is complete.
- P0006 Foundation closure is pushed at `25bc9da`.
- Existing P0005 state wiring passed load/reload and combined instance+combat transition testing.
- I-001 established combat/restriction timing can settle across multiple events.
- A.1 contract is captured by D-009.
- P0007 source/static validation is prepared but not yet runtime proven.

## Next Action

Install/review/commit/push P0007.

Then deploy the updated Logres addon and run, from any stable in-game location:

```text
/reload
/logres status
/logres statecheck
```

Expected statecheck result:

```text
Logres statecheck: PASS (...)
```

No travel or combat is required for this A.1 contract proof.

If a natural state transition is convenient, `/logres status` before/after may be observed, but it is not required to repeat Phase 0/I-001 travel-heavy testing.

## Success Criteria

A.1 succeeds when:
- D-009 is durable;
- authoritative mutable state is not publicly exposed;
- `GetState()` snapshot mutation cannot affect authority;
- subscribers receive transition copies and can unsubscribe;
- revision changes only for real canonical transitions;
- no-op refresh emits no callback;
- `/logres status` still works;
- `/logres statecheck` passes;
- memory/addon/state-contract static checks pass;
- no Lua errors are reported in the test scope.

## Do Not Reopen Without New Evidence

- **Foundation:** Phase 0 complete.
- **State authority:** mutable state belongs to `Core/State.lua`.
- **State access:** consumers use `GetState()` and `SubscribeState()`.
- **Revision:** actual canonical transitions only.
- **State philosophy:** orthogonal facts/modifiers; avoid combinatorial mega-states.
- **Combat timing:** event occurrence is not assumed to equal settled restriction state.
- **Health/resource:** secret-safe native display path only.
- **Enemy disclosure:** level/elite metadata hidden by default.
- **Compass:** suspend when world navigation data is unavailable in instances.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/decisions/D-009_STATE_CONSUMER_CONTRACT.md`
- `docs/memory/architecture/STATE_ENGINE.md`
- `docs/memory/roadmap/PHASE_A_CORE_STATE_ENGINE.md`
- `docs/memory/evidence/PHASE_0_3_RUNTIME_PROOF_2026-09-30.md`
- `Logres/Core/State.lua`
- `Logres/Core/Commands.lua`
- `tools/check_state_contract.py`
