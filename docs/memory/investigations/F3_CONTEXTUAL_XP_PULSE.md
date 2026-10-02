# F.3 — Contextual XP Pulse

Status: ACTIVE — XP RUNTIME PROVEN; INTEGRATED RESTORATION BLOCKER
Opened: 2026-10-02

Canonical capability contract:
`../decisions/D-031_QUEST_EXPERIENCE_CAPABILITY_CONTRACT.md`

## Production implementation

P0080 runtime:
`0.0.31-dev`.

Presentation:
- `+N XP · progress%`;
- approximately two seconds;
- no permanent bar;
- no stock XP suppression.

## Runtime evidence

Proven:
- safe XP baseline;
- real `PLAYER_XP_UPDATE`;
- positive delta `124`;
- progress `89.1%`;
- pulse count `1`;
- automatic hide;
- Immersion OFF preview suppression;
- Immersion ON preview restoration;
- XP Check PASS.

Visual appearance still requires user acceptance.

## Integrated blocker

P0080 Run All reproduced the restoration failure.

P0079 diagnostic detail now identifies TargetFrame restoration as the failing
domain.

See:
`P0080_TARGETFRAME_RESTORE_FAILURE.md`.

F.3 cannot close until integrated restoration passes after the narrow defect is
understood/resolved.

## P0081

Diagnostic-only checkpoint.

Adds the TargetFrame/controller reason/error strings to the restoration mismatch
record.

No XP or restoration behavior changes.

## Exit

Close F.3 only after:
- XP visual acceptance;
- real XP pulse remains correct;
- Immersion policy remains correct;
- Run All passes;
- no Lua/taint/secret errors;
- stock XP/quest UI remains unchanged.
