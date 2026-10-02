# P0080 — TargetFrame Restoration Failure

Status: OPEN — REPRODUCED / RESTORE PATH IDENTIFIED
Opened: 2026-10-02

## Trigger

P0080 Run All failed Restoration Check during the opposite-preference
(Immersion OFF) state.

The P0079-expanded diagnostic reported:

- expected immersion: false;
- controller desired action/player/target: false;
- Action requested/applied: false/false;
- Quiet requested/applied: false/false;
- Player requested/applied: false/false;
- Target requested/applied: false/true;
- Target pending: false;
- Target snapshot: true;
- Target unit watch: true;
- Target interaction mouse ownership: true;
- Target stock presentation suppressed: true;
- Target stock mouse suppressed: true;
- preserved overrides: 4;
- errorsClear: false.

Cleanup later reconverged successfully.

## Narrow code-path conclusion

`TargetFrameReplacement:RequestEnabled(false)` sets `requestedEnabled=false`.

In `DisableReplacement`, if stock restoration succeeds, the implementation
continues to disable interaction and clears:
- `appliedEnabled`;
- snapshot;
- unit watch;
- Logres mouse ownership;
- stock presentation/mouse suppression.

The observed state retains all of those applied fields.

Therefore the failing request did not complete
`TargetFrameReplacement:RestoreStock(snapshot)`.

This is narrower than a general controller settle race.

## Missing evidence

The P0079 mismatch summary printed `errors=false` (errors not clear) but omitted:
- `target.lastReason`;
- `target.lastError`;
- controller `lastTargetResult`;
- controller `lastTargetError`.

Without the actual error string, choosing which native restore call to change
would be speculative.

## P0081

P0081 adds those four fields to the existing restoration mismatch summary.

It does not:
- retry;
- poll;
- reassert;
- hook Blizzard code;
- alter TargetFrame restore/suppress behavior.

## Exit

Reproduce through Run All.

If an error is captured, investigate that exact failing native operation and
prepare the smallest corrective patch.

If repeated runs do not reproduce, preserve the failure as intermittent but do
not erase the two reproduced failures.
