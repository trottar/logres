# P0078 Restoration Settle Failure — 2026-10-02

Status: OPEN — REPRODUCED ONCE / SUBDOMAIN NOT YET IDENTIFIED
Date: 2026-10-02

## Observation

During P0078 F.2 validation, `Run All` reached Restoration Check and failed:

```text
cycleError=opposite preference state did not settle
cleanup=none
finalOK=true
```

The final restored state was valid after cleanup.

## Classification

**REAL RUNTIME DIAGNOSTIC FAILURE.**

Not classified as:
- F.2 quest/XP capability failure;
- secret-value failure;
- Lua error;
- known TargetFrame reappearance.

The current saved output does not identify which restoration subdomain caused
the opposite-preference mismatch.

Do not merge this with the open TargetFrame reappearance investigation without
new evidence.

## Existing checker limitation

The D.6 Restoration Check currently tests:
- controller/module readiness;
- desired policy;
- requested/applied replacement state;
- snapshot/ownership coherence;
- errors.

On intermediate mismatch it only persists a stage-level error string, then
prints the final cleanup state.

Therefore this specific failure cannot be diagnosed from the existing saved
line.

## P0079 diagnostic

P0079 preserves behavior and adds failure-only detail for:
- module readiness;
- desired-policy match;
- recovery requested/applied match;
- ownership coherence;
- error cleanliness;
- action snapshot/routing;
- Quiet snapshot;
- Player interaction/presentation ownership;
- Target watch/interaction/presentation ownership and override count.

No retry, timer, polling loop, reassertion, or Blizzard hook is added.

## Exit

Run the panel Restoration Check and Run All after P0079.

If the failure recurs, the persisted diagnostic should identify the failing
subdomain.

If it does not recur, preserve this result as intermittent/unreproduced and do
not invent a fix.
