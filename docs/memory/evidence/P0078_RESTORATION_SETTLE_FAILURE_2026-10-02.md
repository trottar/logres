# P0078 Restoration Settle Failure — 2026-10-02

Status: OPEN — INTERMITTENT / UNREPRODUCED UNDER P0079 TARGETED VALIDATION
Date: 2026-10-02

## Original observation

During P0078 F.2 validation, `Run All` reached Restoration Check and failed:

```text
cycleError=opposite preference state did not settle
cleanup=none
finalOK=true
```

The final restored state was valid after cleanup.

## Classification

**REAL RUNTIME DIAGNOSTIC FAILURE.**

It is not erased by later success.

It is not classified as:
- F.2 quest/XP capability failure;
- secret-value failure;
- Lua error;
- known TargetFrame reappearance.

The original saved output did not identify which restoration subdomain caused
the intermediate opposite-preference mismatch.

## P0079 targeted follow-up

P0079 added failure-only detail without changing restoration behavior.

Targeted runtime validation then produced:
- standalone Restoration Check PASS;
- subsequent Run All PASS, including Restoration Check.

The failure did not recur, so the expanded mismatch detail was not exercised.

Current classification:
**INTERMITTENT / UNREPRODUCED under targeted validation.**

## Standing rule

Do not:
- add retry loops;
- add polling;
- periodically reassert suppression;
- add broad Blizzard hooks;
- merge this with the TargetFrame reappearance issue without evidence.

## Reopening / escalation

If the failure recurs, P0079 diagnostic output should identify:
- readiness;
- desired policy;
- recovery match;
- ownership coherence;
- error cleanliness;
- action/Quiet/Player/Target subdomain state.

Investigate the identified narrow subdomain before changing behavior.
