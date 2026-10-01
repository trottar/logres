# A.5 / Phase A Transition Validation — 2026-09-30

Status: VERIFIED  
Final runtime baseline: `f5a12d4fc4b644dd5eac8aac02ef195d0b0e9104`

## Purpose

Close Phase A by consolidating existing runtime evidence and testing only the remaining genuine transition gap.

The A.5 policy explicitly avoided repeating travel-heavy scenarios already proven in earlier checkpoints.

## Evidence matrix

| Capability | Result | Evidence |
| --- | --- | --- |
| addon load / reload | PASS | Phase 0.3 and later phase tests |
| SavedVariables persistence | PASS | Phase 0.3, A.3 |
| world state | PASS | Phase 0.3 / I-001 |
| instance entry | PASS | Phase 0.3 / I-001 |
| instance exit / restoration | PASS | Phase 0.3 / I-001 |
| combat observation | PASS | Phase 0.3 / I-001 |
| combat/lockdown transitional ordering | PASS / characterized | I-001 |
| state snapshot isolation | PASS | A.1 |
| no-op state revision/callback behavior | PASS | A.1 |
| resting true/false | PASS | A.2 |
| taxi true/false | PASS | A.2 |
| interaction open/close | PASS | A.2 |
| ordinary mounted=true | DEFERRED BY ENVIRONMENT | A.2 |
| preference snapshot/change contract | PASS | A.3 |
| preference persistence across reload | PASS | A.3 |
| module initialize/enable/disable/cleanup | PASS | A.4 |
| PvP flagged transition | PASS | A.5 |

## PvP flag transition — runtime verified

Before A.5, `UnitIsPVP("player")` had only been observed in the false/unflagged state.

The user performed the minimal local PvP flag test with the already-deployed Logres build and reported that it worked.

Test flow:

```text
/logres status
/pvp
/logres status
```

The Logres state transitioned to the flagged condition as intended.

Result:

**PASS**

This verifies the Phase A `pvpFlagged` state path under a real player flag transition.

A long de-flag wait was not required for A.5 because the missing evidence was the true transition.

## Mounted=true deferral

Ordinary player-controlled `mounted=true` remains untested because the current beta/character environment does not permit a practical mount test.

Classification:

**DEFERRED BY ENVIRONMENT**

This does not block Phase A because:
- source/API support is established;
- `mounted=false` behavior is exercised;
- taxi exclusion semantics are runtime verified;
- a clear retry condition exists.

Retry when:
- a future test character/build can actually mount;
- or a later owning phase naturally reaches a mount-capable environment.

## Known negative results retained

Phase A does not erase its failures/false starts:

- `table.pack` unavailable in Forever addon Lua;
- combat/restriction state can settle across multiple events;
- P0012 first command test used an older undeployed addon build;
- P0014 lifecycle diagnostic had a cleanup-counter false negative;
- mounted=true cannot currently be tested.

Each has a durable lesson/retry condition.

## Phase A conclusion

The following contracts are now runtime established:

### Observed state
- private authority;
- isolated snapshots;
- deterministic actual-change revision semantics;
- transition subscription;
- world/instance/combat/PvP/resting/taxi/interaction state.

### User preferences
- separate from observed game facts;
- typed persisted `immersionEnabled`;
- deterministic preference notifications;
- reload persistence.

### Module lifecycle
- deterministic registration-order initialization;
- idempotent enable/disable;
- owned cleanup;
- owned state/preference subscription cleanup;
- development errors surface.

No unresolved integration regression remains within the tested Phase A scope.

**Phase A — Core State Engine: COMPLETE.**
