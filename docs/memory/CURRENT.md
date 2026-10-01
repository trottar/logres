---
memory_schema: 1
as_of: 2026-09-30
project: logres
---

# Current State

## Active Objective

**Phase A — Core State Engine.** Establish the stable state/lifecycle contract and the minimal orthogonal context sensors required by later Logres modules.

## Current Work Item

**A.2 — Additional Context Sensors.**

A.1 is complete.

The next work must add only context facts that have a concrete downstream owner and a justified API/event source.

Primary candidates:
- mounted;
- resting;
- NPC interaction;
- taxi/travel state if technically justified.

Do not add all imaginable player states. Each sensor needs:
1. an owning future subsystem;
2. a clear semantic definition;
3. an API/event source;
4. a narrow validation plan.

No HUD behavior belongs in A.2.

## Verified State

- Phase 0 — Foundation is complete.
- P0006 Foundation closure pushed at `25bc9da`.
- P0007 A.1 state contract pushed at `e2f3d17`.
- D-009 defines the state consumer contract.
- `/logres statecheck` passed in-client with no issues reported.
- snapshot isolation is runtime verified by the A.1 development check.
- no-op refresh revision stability is runtime verified by the A.1 development check.
- no-op refresh callback suppression is runtime verified by the A.1 development check.
- prior world/instance/combat state transitions remain established by Phase 0.3/I-001.
- A.1 is complete.

## Next Action

Start A.2 with a narrow capability/source review for the candidate sensors before modifying `State.lua`.

For each candidate sensor:
- identify why Logres needs it;
- verify the current Forever API/event surface;
- prefer a boolean/orthogonal fact over a derived mega-state;
- determine whether it can be validated without expensive travel;
- explicitly defer any sensor whose semantics or API are not yet justified.

The first A.2 implementation patch should stay small enough that each new field's behavior can be understood independently.

## Success Criteria

A.2 succeeds when:
- the minimal required additional sensors are selected explicitly;
- each selected sensor has a documented semantic definition;
- API/event sources are current and justified;
- sensors publish through the existing D-009 state contract;
- no combinatorial mega-states are introduced;
- static checks pass;
- narrow runtime validation passes;
- deferred/rejected sensors are recorded rather than silently omitted.

## Do Not Reopen Without New Evidence

- **Foundation:** Phase 0 complete.
- **A.1:** state consumer contract complete and runtime proven.
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

- `docs/memory/evidence/A1_STATE_CONTRACT_RUNTIME_PROOF_2026-09-30.md`
- `docs/memory/decisions/D-009_STATE_CONSUMER_CONTRACT.md`
- `docs/memory/architecture/STATE_ENGINE.md`
- `docs/memory/roadmap/PHASE_A_CORE_STATE_ENGINE.md`
- `docs/memory/evidence/PHASE_0_3_RUNTIME_PROOF_2026-09-30.md`
- `Logres/Core/State.lua`
