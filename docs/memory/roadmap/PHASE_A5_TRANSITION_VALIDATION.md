# Phase A.5 — Transition Validation

Status: ACTIVE  
Opened: 2026-09-30

## Purpose

Close Phase A by validating the **integrated state/preference/lifecycle system** without needlessly repeating scenarios already proven by earlier runtime evidence.

A.5 is evidence consolidation plus targeted gap testing.

It is not a reason to repeat travel-heavy tests for their own sake.

## Existing evidence matrix

| Capability | Runtime evidence | A.5 status |
| --- | --- | --- |
| addon load / reload | Phase 0.3, later phases | COVERED |
| SavedVariables persistence | Phase 0.3, A.3 | COVERED |
| world state | Phase 0.3 / I-001 | COVERED |
| instance entry | Phase 0.3 / I-001 | COVERED |
| instance exit / restoration | Phase 0.3 / I-001 | COVERED |
| combat observation | Phase 0.3 / I-001 | COVERED |
| combat/lockdown transitional ordering | I-001 | COVERED |
| state snapshot isolation | A.1 | COVERED |
| no-op state revision/callback behavior | A.1 | COVERED |
| resting true/false | A.2 | COVERED |
| taxi true/false | A.2 | COVERED |
| interaction open/close | A.2 | COVERED |
| ordinary mounted=true | blocked by beta environment | DEFERRED BY ENVIRONMENT |
| preference snapshot/change contract | A.3 | COVERED |
| preference persistence across reload | A.3 | COVERED |
| module initialize/enable/disable/cleanup | A.4 | COVERED |
| PvP flagged transition | no true transition captured yet | OPEN GAP |

## Primary open gap — PvP flag transition

`pvpFlagged` already exists in the canonical observed state and is important to later presentation policy.

Runtime history has shown the API callable with a false result, but no true/false transition has yet been captured.

A.5 should attempt the **smallest practical PvP flag test** before Phase A closes.

Do not force battleground/arena travel merely to prove the boolean.

Preferred order:
1. determine whether the current Forever beta permits a local `/pvp` flag transition;
2. if yes, observe `/logres status` before and after;
3. if de-flagging is delayed by game rules, record that rule/observation rather than waiting unnecessarily;
4. if the current environment cannot practically produce a flag transition, mark it as an explicit environmental deferral with retry condition.

## Mounted=true

Do not reopen A.2 solely to obtain `mounted=true`.

Current beta environment prevents a practical ordinary mount test.

Retry condition remains:
- later build/character can actually mount;
- or a later owning phase naturally exercises a mount-capable environment.

## A.5 implementation choice

Before adding any new diagnostic code, first determine whether existing commands are sufficient.

Existing useful commands:

```text
/logres status
/logres statecheck
/logres sensorcheck
/logres preferencecheck
/logres lifecyclecheck
```

If the remaining PvP transition can be observed with `/logres status`, do not add a redundant `phaseacheck` command.

## Phase A exit criteria

Phase A may close when:
- A.1 through A.4 remain runtime proven;
- the evidence matrix is durable;
- PvP flagged transition is either runtime proven or explicitly deferred by environment with a clear retry condition;
- ordinary mounted=true remains an accepted environmental deferral unless the environment changes;
- no unresolved integration regression exists;
- all static checks pass.

## What Phase A completion means

Later modules can rely on:
- observed-state snapshots/subscriptions;
- user preference snapshots/subscriptions;
- deterministic module lifecycle;
- known transition semantics and explicit evidence limits.

It does **not** mean every later HUD/camera/action behavior has been implemented.
