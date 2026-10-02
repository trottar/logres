# F.3 — Contextual XP Pulse

Status: ACTIVE — RUNTIME + INTEGRATION PASS; VISUAL ACCEPTANCE PENDING
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

P0080 proven:
- safe XP baseline;
- real `PLAYER_XP_UPDATE`;
- positive delta `124`;
- progress `89.1%`;
- pulse count `1`;
- automatic hide;
- Immersion OFF preview suppression;
- Immersion ON preview restoration;
- XP Check PASS.

## Integrated validation

P0080 Run All reproduced the historical TargetFrame restoration failure.

P0081 added TargetFrame/controller failure text only.

P0081 targeted result:
- five Run All PASS;
- one standalone Restoration Check PASS;
- no mismatch recurred.

Therefore:
- the historical restoration failures remain preserved;
- the defect is classified intermittent/unreproduced under repeated P0081
  targeting;
- no behavioral fix is justified;
- integrated validation no longer blocks F.3.

## Remaining item

Visual appearance still requires explicit user acceptance.

## Exit

Close F.3 when the user confirms:
- preview/real pulse appears in the intended centered location;
- text is readable and appropriately brief;
- pulse disappears instead of remaining as a permanent bar;
- stock XP/quest UI remains unchanged;
- no Lua/taint/secret errors were observed.

All persisted runtime/integration criteria are currently satisfied.
