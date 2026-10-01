---
memory_schema: 1
as_of: 2026-09-30
project: logres
---

# Current State

## Active Objective

**Phase A — Core State Engine.** Establish the stable state/lifecycle contract, orthogonal observed context, and user-controlled state required by later Logres modules.

## Current Work Item

**A.3 — User-Controlled State.**

A.2 is complete with one explicit environmental deferral.

The next work separates durable user preference from observed game facts.

Initial A.3 target:

```text
immersionEnabled: boolean
```

This preference should be persisted in `LogresDB` and exposed to consumers without pretending it is an observed Blizzard state.

The design must answer:
- where user-controlled state lives;
- how consumers read it;
- how changes publish;
- whether it belongs in the same snapshot as observed state or in a clearly separated configuration/effective-state layer;
- how defaults/migrations work.

No HUD/settings panel is required for A.3. A slash-command development control is sufficient for proof.

## Verified State

- Phase 0 — Foundation complete.
- A.1 state consumer contract complete and runtime proven.
- P0010 A.2 implementation pushed at `a1f119a`.
- A.2 runtime proof passed for tested sensors.
- resting true in Ironforge and false after leaving the resting area is runtime verified.
- real taxi true/false behavior is runtime verified.
- interaction open/close behavior is runtime verified.
- taxi remains separate from ordinary mounting under the intended state semantics.
- ordinary `mounted=true` is **not runtime verified** because the current beta/character environment cannot provide a practical mount test.
- that mount true-path is deferred by environment, not failed.
- A.2 is complete.

## Next Action

Design A.3 before changing runtime code.

Required questions:
1. Should persisted user preference be exposed through a separate configuration API or included as a clearly named user-controlled field in an effective state snapshot?
2. What is the default for `immersionEnabled`? Current design intent is enabled by default unless a later decision overrides it.
3. What callback semantics apply when the user changes a preference?
4. How should schema/default migration remain safe for existing `LogresDB`?
5. What development command should prove persistence across `/reload` without needing a settings UI?

Prefer the smallest contract that later Immersion/HUD modules can consume without conflating preference with observed game state.

## Success Criteria

A.3 succeeds when:
- user-controlled state is explicitly separated from observed facts;
- `immersionEnabled` has a durable default and persistence path;
- consumers have a supported read API;
- preference changes publish deterministically;
- `/reload` preserves the chosen value;
- existing state contract is not weakened;
- no settings UI is required;
- static checks pass;
- travel-free runtime validation passes;
- failures/limitations are recorded.

## Do Not Reopen Without New Evidence

- **A.1:** complete.
- **A.2:** complete with mounted=true environmental deferral.
- **State authority:** observed mutable state private to `Core/State.lua`.
- **State access:** `GetState()` / `SubscribeState()`.
- **Observed vs user-controlled:** do not conflate them.
- **mounted:** excludes taxi; mounted=true runtime proof deferred.
- **resting:** literal Blizzard state.
- **taxi:** independent orthogonal state.
- **interaction:** event-latched Blizzard interaction type.
- **generic traveling:** rejected.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/A2_CONTEXT_SENSOR_RUNTIME_PROOF_2026-09-30.md`
- `docs/memory/investigations/A2_CONTEXT_SENSORS.md`
- `docs/memory/roadmap/PHASE_A_CORE_STATE_ENGINE.md`
- `docs/memory/decisions/D-009_STATE_CONSUMER_CONTRACT.md`
- `docs/memory/architecture/STATE_ENGINE.md`
- `Logres/Core/Database.lua`
- `Logres/Core/State.lua`
