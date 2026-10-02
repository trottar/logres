# P0080 — TargetFrame Restoration Failure

Status: OPEN — INTERMITTENT / UNREPRODUCED UNDER P0081 TARGETED RUNS
Opened: 2026-10-02

## Reproduced evidence

The restoration failure was observed in:
- P0078 Run All;
- P0080 Run All.

P0080 / P0079-expanded state narrowed the mismatch to TargetFrame restoration:

- expected Immersion OFF;
- Target requested false;
- Target applied true;
- Target pending false;
- snapshot retained;
- unit watch retained;
- Logres interaction mouse ownership retained;
- stock presentation/mouse suppression retained;
- Action, Quiet, and Player had restored.

Final cleanup reconverged.

## Narrow code-path conclusion

The observed state is consistent with
`TargetFrameReplacement:DisableReplacement()` entering the stock restoration
path but not completing it on the failing runs.

P0081 was created to expose:
- `target.lastReason`;
- `target.lastError`;
- controller `lastTargetResult`;
- controller `lastTargetError`.

No behavior changed.

## P0081 targeted result

The failure did not reproduce.

Observed after P0081 deployment:
- Run All PASS;
- standalone Restoration Check PASS;
- Run All PASS;
- after reload, three additional Run All PASS executions.

Total:
- five Run All PASS;
- one standalone Restoration Check PASS.

Because no mismatch occurred, the new TargetFrame error fields were not
emitted.

## Classification

**REAL HISTORICAL FAILURE — CURRENTLY INTERMITTENT / UNREPRODUCED.**

Do not erase the P0078/P0080 failures.

Do not infer the exact native failing restore operation without an emitted error.

Do not add:
- retry loops;
- polling;
- periodic reassertion;
- broad Blizzard hooks;
- speculative TargetFrame mutation changes.

## Reopening / escalation

If the failure recurs, use the P0081 error fields to identify the exact failing
native call and investigate that operation narrowly.

Until recurrence, this issue remains tracked but does not block unrelated
runtime-proven Phase F work.
