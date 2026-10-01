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

P0014 runtime testing exposed a diagnostic assertion defect, not a lifecycle behavior failure.

Observed lifecyclecheck result:

```text
beforeInit=true
beforeEnabled=false
initializedAgain=false
enabled=true/false
disabled=true/false
init=1->1
enable=0->1
disable=0->1
cleanup=0->1
prefEnabled=2
prefDisabled=0
afterEnabled=false
afterCleanup=0
```

These values match the intended lifecycle semantics.

The only failing predicate was the test's incorrect expectation that the explicit cleanup counter should increase by two.

P0015 corrects that expectation from `+2` to `+1`.

A.4 remains open until the corrected diagnostic passes in-client.

## Verified State

- Phase 0 complete.
- A.1 state contract complete.
- A.2 context sensors complete with mounted=true environmental deferral.
- A.3 user preference contract complete.
- P0014 module lifecycle implementation pushed at `2b40d0c`.
- P0014 runtime evidence shows:
  - one-time initialization behavior correct;
  - enable idempotence correct;
  - disable idempotence correct;
  - explicit cleanup executed;
  - preference subscription active only while enabled;
  - cleanup stack empty after disable.
- P0014 `/logres lifecyclecheck` itself reported FAIL because its cleanup counter assertion was wrong.
- P0015 fixes only that diagnostic assertion and bumps version to `0.0.6-dev`.

## Next Action

Install/review/commit/push P0015.

Then explicitly redeploy:

```bash
WOW_ROOT="/mnt/c/Program Files (x86)/World of Warcraft"
ADDONS="$WOW_ROOT/_classic_beta_/Interface/AddOns"

./tools/deploy_logres.sh "$ADDONS"
```

In game:

```text
/reload
/logres status
/logres lifecyclecheck
```

First confirm `/logres status` begins with:

```text
Logres 0.0.6-dev
```

Then `lifecyclecheck` should report PASS.

No travel or combat is required.

## Success Criteria

A.4 succeeds when:
- the corrected P0015 diagnostic is deployed;
- version `0.0.6-dev` confirms the new build is active;
- `/logres lifecyclecheck` reports PASS;
- no new lifecycle discrepancy is exposed;
- the P0014 false-negative remains durable evidence;
- static checks pass.

## Do Not Reopen Without New Evidence

- **A.1:** complete.
- **A.2:** complete with mounted=true environmental deferral.
- **A.3:** complete.
- **P0014 lifecycle behavior:** observed values matched intended semantics.
- **P0014 FAIL classification:** diagnostic assertion defect.
- **Cleanup counter:** counts only the explicit instrumented cleanup, not every owned cleanup.
- **Deployment:** explicit deploy block required for runtime-code tests.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/A4_LIFECYCLECHECK_FAILURE_2026-09-30.md`
- `docs/memory/decisions/D-011_MODULE_LIFECYCLE_CONTRACT.md`
- `docs/memory/architecture/MODULES.md`
- `docs/memory/LEARNINGS.md`
- `Logres/Core/Commands.lua`
- `Logres/Core/Modules.lua`
