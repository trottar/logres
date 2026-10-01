---
memory_schema: 1
as_of: 2026-09-30
project: logres
---

# Current State

## Active Objective

**Phase A — Core State Engine.** Turn the proven minimal Logres runtime into the stable state/lifecycle contract that later HUD, Immersion, Actions, Compass, Questing, Social, and Camera modules will consume.

## Current Work Item

**A.1 — State contract hardening.**

Phase 0 — Foundation is complete.

The next implementation work must harden the existing state engine before adding more sensors or any product HUD:
- define canonical state schema;
- define consumer-facing state access;
- define `STATE_CHANGED` payload/revision semantics;
- separate internal mutable state from consumer usage where practical;
- preserve the runtime-proven world/instance/combat behavior;
- retain the combat-transition timing lesson from I-001.

## Verified State

- P0001 memory bootstrap pushed at `353c5b0`.
- P0002 source audit/probe pushed at `48a7d28`.
- P0003 first runtime evidence pushed at `ad3a660`.
- P0004 I-001 closure pushed at `477df5b`.
- P0005 minimal real addon runtime pushed at `ce4f1b0`.
- Phase 0.3 runtime proof passed.
- Logres loads without reported Lua errors in the tested scenario.
- `/logres status` works.
- `LogresDB.meta.loadCount` persists and increases across `/reload`.
- outside-instance state returned expected false values.
- combined in-instance combat correctly reported instance context plus true combat/instance flags.
- leaving the instance restored non-instance/non-combat state.
- separate out-of-instance combat was intentionally not re-tested in Phase 0.3 because I-001 already established the underlying combat behavior and duplicate travel was not justified.
- Phase 0 — Foundation is complete.

## Next Action

Prepare the A.1 implementation patch.

Before changing source:
1. treat the existing P0005 state engine as the baseline;
2. specify the consumer contract in architecture memory;
3. implement the smallest code change that prevents future modules from depending directly on mutable internal state;
4. preserve `/logres status` as a development diagnostic;
5. add static checks where they can enforce the contract;
6. runtime-test with an efficient transition scenario rather than requiring redundant travel.

Do not begin HUD work yet.

## Success Criteria

A.1 succeeds when:
- the canonical state schema is explicit;
- consumers have a documented supported way to read state;
- `STATE_CHANGED` callback semantics are explicit and deterministic;
- revision behavior is defined;
- external consumers do not need to mutate authoritative state;
- world/instance/combat/PvP baseline behavior remains intact;
- static checks pass;
- a minimal runtime proof passes;
- failures/limitations are recorded.

## Do Not Reopen Without New Evidence

- **Project name:** Logres.
- **Development environment:** Windows 11 + WSL.
- **Git authority:** user performs commits/pushes.
- **Negative-result policy:** failures are durable learning.
- **Foundation:** Phase 0 is complete.
- **Forever identity:** interface 16001 currently collides with MAINLINE project ID.
- **Health/resource architecture:** secret-safe native transforms/display only; see D-008.
- **No conventional player health bar.**
- **Enemy disclosure:** level/elite metadata remains intentionally hidden by default.
- **Action layout:** rectangular/square clusters.
- **Compass context:** world-only where data exists; suspend in instances.
- **PvP:** state modifier, not immersion-off.
- **State philosophy:** orthogonal facts/modifiers; avoid combinatorial mega-states.

## Relevant References

- `docs/memory/roadmap/PHASE_A_CORE_STATE_ENGINE.md`
- `docs/memory/architecture/STATE_ENGINE.md`
- `docs/memory/architecture/SYSTEM.md`
- `docs/memory/evidence/PHASE_0_3_RUNTIME_PROOF_2026-09-30.md`
- `docs/memory/evidence/I001_RUNTIME_PASS_02_2026-09-30.md`
- `docs/memory/roadmap/STATUS.md`
- `Logres/Core/State.lua`
- `Logres/Core/Bootstrap.lua`
