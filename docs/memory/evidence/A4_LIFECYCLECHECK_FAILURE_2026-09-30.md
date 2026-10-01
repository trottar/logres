# A.4 Lifecycle Diagnostic Failure — 2026-09-30

Status: DIAGNOSTIC DEFECT CONFIRMED  
Affected baseline: `2b40d0c15ceb331b53afdc7bae56fc4c921ffd7d`

## Observed result

The user ran:

```text
/logres lifecyclecheck
```

and received:

```text
Logres lifecyclecheck: FAIL (beforeInit=true beforeEnabled=false initializedAgain=false enabled=true/false disabled=true/false init=1->1 enable=0->1 disable=0->1 cleanup=0->1 prefEnabled=2 prefDisabled=0 afterEnabled=false afterCleanup=0)
```

## Interpretation

Every lifecycle behavior exercised by the diagnostic produced the intended result:

- probe was initialized before the command:
  - `beforeInit=true`;
- probe began disabled:
  - `beforeEnabled=false`;
- repeat initialization was a no-op:
  - `initializedAgain=false`;
  - `init=1->1`;
- first enable succeeded and second enable was a no-op:
  - `enabled=true/false`;
  - `enable=0->1`;
- first disable succeeded and second disable was a no-op:
  - `disabled=true/false`;
  - `disable=0->1`;
- preference subscription received exactly two changes while enabled:
  - `prefEnabled=2`;
- preference subscription received no changes after disable:
  - `prefDisabled=0`;
- all owned cleanup entries were removed after disable:
  - `afterCleanup=0`;
- the explicit counted cleanup ran once:
  - `cleanup=0->1`.

## Root cause

The P0014 diagnostic incorrectly required:

```lua
lifecycleProbe.cleanupCount == cleanupBefore + 2
```

The probe owns two cleanup functions:

1. an explicit test cleanup that increments `lifecycleProbe.cleanupCount`;
2. the unsubscribe function returned by `SubscribePreferences`, which removes the subscription but does not increment that counter.

Therefore the correct explicit-cleanup expectation is:

```lua
lifecycleProbe.cleanupCount == cleanupBefore + 1
```

The separate assertion:

```text
afterCleanup=0
```

already proves that both owned cleanup entries were removed from the module cleanup stack.

The `prefDisabled=0` assertion additionally proves that the unsubscribe cleanup executed functionally.

## Classification

**TEST / DIAGNOSTIC ASSERTION DEFECT**

Not:
- module lifecycle failure;
- cleanup ownership failure;
- preference unsubscribe failure.

## Fix

P0015 changes only the incorrect expected count and bumps the development version to make redeployment verification explicit.

A.4 remains open until the corrected diagnostic reports PASS in-client.
