---
memory_schema: 1
as_of: 2026-09-30
project: logres
---

# Current State

## Active Objective

**Phase A — Core State Engine.** Establish the stable observed-state, user-preference, and module-lifecycle contracts required by later Logres systems.

## Current Work Item

**A.4 — Module Lifecycle Contract.**

P0014 prepares the A.4 implementation.

The lifecycle provides:
- unique ordered module registration;
- one-time initialization;
- default enable after all module initialization;
- idempotent enable/disable;
- LIFO cleanup ownership;
- owned state/preference subscriptions;
- cleanup before surfacing enable/disable errors.

The lifecycle does not add presentation behavior or global combat gating.

## Verified State

- Phase 0 complete.
- A.1 state contract complete.
- A.2 context sensors complete with mounted=true environmental deferral.
- A.3 user preference contract complete.
- P0013 A.3 closure pushed at `73a8494`.
- deployment workflow rule L-007 is active.
- P0014 source/static validation is prepared but not runtime proven.

## Next Action

Install/review/commit/push P0014.

Because P0014 changes runtime addon files, explicitly redeploy:

```bash
WOW_ROOT="/mnt/c/Program Files (x86)/World of Warcraft"
ADDONS="$WOW_ROOT/_classic_beta_/Interface/AddOns"

./tools/deploy_logres.sh "$ADDONS"
```

Then in game:

```text
/reload
/logres status
/logres statecheck
/logres preferencecheck
/logres lifecyclecheck
```

No travel or combat is required.

The lifecycle check temporarily changes and restores `immersionEnabled` to prove module-owned preference subscription cleanup.

## Success Criteria

A.4 succeeds when:
- D-011 is durable;
- duplicate registration is rejected by contract/static enforcement;
- modules initialize once in deterministic order;
- all initialization precedes default enabling;
- enable/disable are idempotent;
- owned cleanup runs and is cleared;
- owned preference subscription receives changes only while enabled;
- lifecycle errors are not silently swallowed;
- existing state/preference checks still pass;
- `/logres lifecyclecheck` passes;
- no Lua errors are reported in the test scope;
- full deploy commands precede runtime validation.

## Do Not Reopen Without New Evidence

- **A.1:** complete.
- **A.2:** complete with mounted=true environmental deferral.
- **A.3:** complete.
- **Module lifecycle:** keep lightweight; see D-011.
- **Combat:** no global lifecycle gating.
- **Cleanup:** module-owned, LIFO, released on disable/failed enable.
- **Deployment:** explicit deploy block required for runtime-code tests.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/decisions/D-011_MODULE_LIFECYCLE_CONTRACT.md`
- `docs/memory/architecture/MODULES.md`
- `docs/memory/roadmap/PHASE_A_CORE_STATE_ENGINE.md`
- `docs/memory/LEARNINGS.md`
- `Logres/Core/Modules.lua`
- `Logres/Core/Lifecycle.lua`
- `Logres/Core/Commands.lua`
- `tools/check_module_contract.py`
