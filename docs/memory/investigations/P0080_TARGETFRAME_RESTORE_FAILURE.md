# P0080 — TargetFrame Restoration Failure

Status: ROOT CAUSE IDENTIFIED — P0084 CORRECTION PREPARED
Opened: 2026-10-02

## History

P0078 and P0080 showed the same TargetFrame restoration state shape.

P0081 added TargetFrame/controller reason/error fields.

## P0083 exact recurrence

Run All captured:

`TargetFrameReplacement.lua:306: bad argument #1 to 'SetIgnoreParentAlpha'`

Forever reported that secret values are only allowed during untainted execution
for that setter argument.

The replacement remained applied until cleanup reconverged.

## Root cause

P0057 stopped inspecting `IsIgnoringParentAlpha()` and kept its result as an
opaque restoration token.

P0083 proves that is still insufficient: the native setter rejects the secret
token itself from addon execution.

## P0084 correction

Do not guess the secret boolean and do not retry the setter.

Instead:
- leave Auras/RaidTargetIcon/QuestIcon/PingIconFrame untouched;
- stop alpha-zeroing the contextual parent;
- alpha-suppress only the nine unwanted contextual children;
- capture/restore their alpha values opaquely;
- restore stock before removing Logres secure interaction.

## Historical attribution

P0083 establishes the concrete root cause for this failure path.

P0078/P0080 had compatible state shape but did not capture the native error at
the time.

## Exit

P0084 must pass repeated Restoration Check and Run All with no secret-value
error.
