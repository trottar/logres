# P0011 — Close A.2 and open A.3

Date: 2026-09-30  
Result: PREPARED — not durable until user commits/pushes

## Intent

Record A.2 runtime evidence, preserve the mount-test environmental limitation, and advance Phase A to user-controlled state.

## Runtime evidence

Verified:
- resting true in Ironforge;
- resting false after leaving the resting area during taxi travel;
- real taxi transition;
- interaction open/close behavior;
- taxi remains semantically separate from ordinary mounting.

No issues were reported in tested behavior.

## Environmental deferral

Ordinary `mounted=true` could not be tested.

The user reported:
- current character level: 14;
- current beta test environment does not allow reaching a practical mount test.

This is recorded as:

**DEFERRED BY ENVIRONMENT**

It is not an addon failure.

Retry only when a future build/test character naturally permits mounting.

## Phase transition

A.2:
**COMPLETE WITH ENVIRONMENTAL DEFERRAL**

A.3:
**ACTIVE**

## A.3 initial target

Persisted user preference:

```text
immersionEnabled
```

The next patch must keep user choice conceptually separate from observed Blizzard state.

## Code changes

None.

This is an evidence/phase-transition checkpoint only.

## Validation

Before commit:

```text
python3 tools/check_memory_health.py
python3 tools/check_addon_structure.py
python3 tools/check_state_contract.py
git diff --check
```
