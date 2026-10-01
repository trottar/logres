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

A.3 is complete.

The next work defines the smallest lifecycle boundary future modules need before HUD/Immersion implementation begins.

Required capabilities:
- module registration;
- deterministic initialization;
- enable/disable;
- state/preference subscription ownership;
- cleanup/unsubscribe on disable;
- no duplicate initialization;
- clear ordering relative to database/state startup.

Do not build a general-purpose addon framework.

No HUD behavior belongs in A.4.

## Verified State

- Phase 0 complete.
- A.1 state consumer contract complete and runtime proven.
- A.2 context sensors complete with ordinary mounted=true deferred by environment.
- P0012 preference contract pushed at `6a01f85`.
- A.3 runtime validation passed after correct redeploy.
- preference contract check passed with no issue reported.
- `immersionEnabled` persisted through off/reload and on/reload testing.
- database schema 2 loaded/migrated without reported issue in the tested path.
- observed state remained separate from user preference.
- the initial command-list result was caused by failing to redeploy P0012, not by a product defect.
- L-007 now requires explicit deployment commands for every runtime-code validation handoff.
- A.3 is complete.

## Next Action

Design A.4 before adding a module implementation.

Specify:
1. what constitutes a Logres module;
2. registration semantics;
3. initialization order;
4. enable/disable semantics;
5. how a module owns and releases state/preference subscriptions;
6. whether modules may be disabled while in combat;
7. how lifecycle errors surface during development;
8. what minimum development diagnostic proves lifecycle correctness.

Prefer a small explicit contract over an AceAddon-like framework.

For any later runtime-code patch, always include the complete deployment block before in-game test commands.

## Success Criteria

A.4 succeeds when:
- module lifecycle semantics are documented;
- initialization order is deterministic;
- duplicate registration/initialization is rejected;
- enable/disable are idempotent or explicitly defined;
- subscriptions/resources can be released reliably;
- lifecycle does not silently swallow development errors;
- static validation exists for the agreed contract;
- travel-free runtime proof passes;
- no unnecessary framework features are added;
- deployment instructions explicitly precede runtime validation.

## Do Not Reopen Without New Evidence

- **A.1:** complete.
- **A.2:** complete with mounted=true environmental deferral.
- **A.3:** complete.
- **Observed state:** `GetState()` / `SubscribeState()`.
- **User preferences:** separate D-010 contract.
- **immersionEnabled:** boolean, default true, persistence runtime proven.
- **Database schema:** 2.
- **Deployment:** every runtime-code test handoff repeats deploy commands; see L-007.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/A3_USER_PREFERENCE_RUNTIME_PROOF_2026-09-30.md`
- `docs/memory/decisions/D-010_USER_PREFERENCE_CONTRACT.md`
- `docs/memory/architecture/PREFERENCES.md`
- `docs/memory/roadmap/PHASE_A_CORE_STATE_ENGINE.md`
- `docs/memory/LEARNINGS.md`
- `docs/memory/MAINTENANCE.md`
- `Logres/Core/Bootstrap.lua`
- `Logres/Core/State.lua`
- `Logres/Core/Preferences.lua`
