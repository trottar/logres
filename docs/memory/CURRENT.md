---
memory_schema: 1
as_of: 2026-09-30
project: logres
---

# Current State

## Active Objective

**Phase A — Core State Engine.** Establish the stable state/lifecycle contract and minimal orthogonal context sensors required by later Logres modules.

## Current Work Item

**A.2 — Additional Context Sensors.**

P0010 prepares the implementation for:
- mounted;
- resting;
- onTaxi;
- interacting;
- interactionType.

The implementation preserves D-009 and adds `/logres sensorcheck`.

No HUD behavior is included.

## Verified State

- Phase 0 complete.
- A.1 complete and runtime proven.
- P0009 source review pushed at `dd6c4d7`.
- A.2 sensor semantics are source/documentation backed.
- P0010 implementation/static checks are prepared but not yet runtime proven.
- user is currently near the Ironforge flight path, allowing an efficient taxi true-path test without a dedicated trip.

## Next Action

Install/review/commit/push P0010 and redeploy Logres.

In game:

```text
/reload
/logres statecheck
/logres sensorcheck
/logres status
```

Then use the current Ironforge location for efficient validation:
1. mount/dismount locally where mounting is permitted;
2. open/close a nearby normal interaction frame;
3. take any convenient short taxi flight;
4. during flight verify `taxi=true` and `mounted=false`;
5. after landing verify `taxi=false`;
6. note the resting value in the current/resting areas encountered.

No separate world/instance travel is required.

## Success Criteria

A.2 succeeds when:
- `/logres statecheck` still passes;
- `/logres sensorcheck` passes;
- mounted transition is observed;
- taxi transition is observed if the currently convenient flight path is used;
- mounted remains false on taxi;
- one interaction transition is observed if a suitable nearby interaction uses Interaction Manager events;
- resting state agrees with the direct API diagnostic;
- no Lua errors occur in tested scope;
- any unobserved true-path is explicitly deferred;
- failures/quirks are preserved.

## Do Not Reopen Without New Evidence

- **A.1:** complete.
- **State authority:** private.
- **State access:** `GetState()` / `SubscribeState()`.
- **mounted:** excludes taxi.
- **resting:** literal Blizzard state.
- **taxi:** authority is `UnitOnTaxi`, not control-loss event alone.
- **interaction:** event-latched Blizzard interaction type.
- **generic traveling:** rejected.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/investigations/A2_CONTEXT_SENSORS.md`
- `docs/memory/evidence/A2_CONTEXT_SENSOR_SOURCE_AUDIT_2026-09-30.md`
- `docs/memory/architecture/STATE_ENGINE.md`
- `docs/memory/decisions/D-009_STATE_CONSUMER_CONTRACT.md`
- `Logres/Core/State.lua`
- `Logres/Core/Commands.lua`
