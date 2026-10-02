# P0081 — TargetFrame Restore Error Diagnostic

Date: 2026-10-02
Result: INSTALLED / PUSHED — TARGETED PASS / FAILURE NOT REPRODUCED (`ef8fa310`)

## Baseline

P0080 verified pushed:
`cde9b726622642960df27e3862111b9886962cbd`

## Trigger

P0080 reproduced Restoration Check failure.

P0079 detail identified the TargetFrame restore path but did not print the
actual TargetFrame/controller error strings.

## Change

Extended `restorationMismatchSummary` with:
- TargetFrame last reason;
- TargetFrame last error;
- controller last TargetFrame result;
- controller last TargetFrame error.

No restoration behavior changed.

## Runtime result

P0081 targeted validation:
- five Run All PASS;
- one standalone Restoration Check PASS;
- no recurrence.

Because no mismatch occurred, the new error fields were not emitted.

## Classification

The historical P0078/P0080 restoration failures remain recorded.

Current state:
**OPEN — INTERMITTENT / UNREPRODUCED under repeated P0081 targeting.**

No speculative behavior fix is justified.

Production runtime remains:
`0.0.31-dev`.
