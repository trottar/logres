# F.3 P0080 XP Runtime + Target Restore Failure — 2026-10-02

Status: XP RUNTIME PASS / INTEGRATED RESTORATION FAIL
Date: 2026-10-02
P0080 commit: `cde9b726622642960df27e3862111b9886962cbd`

## Runtime

Forever:
- client `1.60.1`;
- build `70170`;
- interface `16001`.

Logres:
- runtime `0.0.31-dev`;
- loadCount `59`.

## XP baseline

XP Check PASS:
- initialized/enabled;
- API available;
- timer available;
- all XP support events registered;
- baseline available;
- current `11370`;
- max `12900`;
- secret flag false.

## Preview

Multiple XP Preview actions reported:
`PASS (state=shown)`.

After Immersion OFF:
`PASS (state=suppressed-immersion-off)`.

After Immersion ON:
`PASS (state=shown)`.

## Real XP event

Post-gain XP Check PASS:
- current `11494`;
- max `12900`;
- `xpEvents=1`;
- `pulses=1`;
- `delta=124`;
- `progress=89.1`;
- `shown=false`;
- secret flag false;
- reason `PLAYER_XP_UPDATE`;
- no error.

This proves the production event path emitted a pulse and later auto-hid it.

Visual appearance remains user-confirmation evidence, not inferable from the
SavedVariables output.

## Integrated Run All

Run All:
- XP Check PASS;
- Action/stock/Immersion/Quiet/Player/Target checks PASS;
- Restoration Check FAIL;
- Context Policy Check PASS;
- Compass Check PASS.

## Restoration mismatch

Expected opposite state:
Immersion OFF.

Action/Quiet/Player were restored.

Target state remained:
- requested false;
- applied true;
- pending false;
- snapshot true;
- unit watch true;
- interaction mouse ownership true;
- stock presentation suppressed true;
- stock mouse suppressed true;
- preserved overrides 4.

`errorsClear=false`.

Final cleanup reconverged.

## Result

F.3 XP runtime behavior is proven but F.3 cannot close while integrated
Restoration Check fails.

P0081 captures the missing TargetFrame/controller error text before any
behavioral fix.
