---
memory_schema: 1
as_of: 2026-09-30
project: logres
---

# Current State

## Active Objective

**Phase A — Core State Engine.** Establish the stable observed-state, user-preference, and lifecycle contracts required by later Logres modules.

## Current Work Item

**A.3 — User-Controlled State.**

P0012 prepares the A.3 preference contract.

Observed game state remains separate.

User preference API:

```text
GetPreferences
GetPreference
SetPreference
SubscribePreferences
```

Initial persisted preference:

```text
immersionEnabled = true
```

Database schema advances from 1 to 2 with an additive migration.

## Verified State

- Phase 0 complete.
- A.1 complete and runtime proven.
- A.2 complete with ordinary mounted=true deferred by environment.
- P0011 A.2 closure pushed at `7ff61b0`.
- P0012 preference implementation/static validation is prepared but not yet runtime proven.
- observed state does not include `immersionEnabled`.
- A.3 design is captured by D-010.

## Next Action

Install/review/commit/push P0012 and redeploy.

Then run:

```text
/reload
/logres statecheck
/logres preferencecheck
/logres immersion
```

The first `/logres immersion` should show:
- schema 2;
- `immersionEnabled=true` unless the existing database already contains an explicit value.

Persistence proof:

```text
/logres immersion off
/reload
/logres immersion
```

Confirm false.

Then restore the intended default/current choice:

```text
/logres immersion on
/reload
/logres immersion
```

Confirm true.

No travel is required.

## Success Criteria

A.3 succeeds when:
- schema 1 database migrates safely to schema 2;
- default `immersionEnabled=true` is established when absent;
- observed State remains separate;
- preference snapshots are isolated;
- no-op writes do not publish or advance revision;
- actual preference changes publish deterministically;
- off persists across reload;
- on persists across reload;
- static checks pass;
- no Lua errors occur in tested scope;
- runtime evidence is recorded.

## Do Not Reopen Without New Evidence

- **A.1:** complete.
- **A.2:** complete with mount true-path environmental deferral.
- **Observed state:** `GetState()` / `SubscribeState()`.
- **User preferences:** separate contract; see D-010.
- **immersionEnabled:** boolean, default true.
- **Preference revision:** session-local; value persists.
- **Database schema:** A.3 target schema 2.
- **Generic traveling:** rejected.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/decisions/D-010_USER_PREFERENCE_CONTRACT.md`
- `docs/memory/architecture/PREFERENCES.md`
- `docs/memory/decisions/D-009_STATE_CONSUMER_CONTRACT.md`
- `docs/memory/roadmap/PHASE_A_CORE_STATE_ENGINE.md`
- `Logres/Core/Database.lua`
- `Logres/Core/Preferences.lua`
- `Logres/Core/Commands.lua`
- `tools/check_preference_contract.py`
