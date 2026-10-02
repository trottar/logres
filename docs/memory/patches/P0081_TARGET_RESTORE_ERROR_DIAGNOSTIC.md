# P0081 — TargetFrame Restore Error Diagnostic

Date: 2026-10-02
Result: PREPARED — TARGETED ERROR CAPTURE PENDING

## Baseline

P0080 verified pushed:
`cde9b726622642960df27e3862111b9886962cbd`

## Trigger

P0080 reproduced Restoration Check failure.

P0079 detail identified the TargetFrame restore path but did not print the
actual TargetFrame/controller error strings.

## Change

Extend `restorationMismatchSummary` with:
- TargetFrame last reason;
- TargetFrame last error;
- controller last TargetFrame result;
- controller last TargetFrame error.

## Non-change

No:
- TargetFrame mutation change;
- retry;
- polling;
- periodic reassertion;
- Blizzard hook;
- XP behavior change.

## Runtime

Production runtime remains:
`0.0.31-dev`.

This changes runtime diagnostics, so WoW redeploy is required.

## Validation

Developer panel:
- Run All once;
- if PASS, Run All a second time;
- then Restoration Check once if needed;
- reload/export diagnostics.

A reproduced failure should now provide the error required for a narrow
corrective patch.
