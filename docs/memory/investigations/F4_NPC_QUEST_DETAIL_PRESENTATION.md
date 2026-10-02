# F.4 — Additive NPC Quest Detail Presentation

Status: CLOSED — RUNTIME + INTEGRATION + VISUAL PASS
Opened: 2026-10-02
Closed: 2026-10-02

Canonical capability contract:
`../decisions/D-031_QUEST_EXPERIENCE_CAPABILITY_CONTRACT.md`

Runtime/closure evidence:
`../evidence/F4_P0084_RUNTIME_AND_VISUAL_PASS_2026-10-02.md`

## Product result

Temporary additive NPC quest presentation:
- quest title;
- restrained body excerpt;
- optional objective line;
- upper-world placement;
- approximately ten-second lifetime;
- no mouse interaction.

Blizzard retains all quest interaction controls.

## P0083 runtime result

PASS:
- Quest Dialogue Preview;
- Quest Dialogue Check;
- real `QUEST_DETAIL`;
- quest ID `436`;
- body/objective present;
- production presentation;
- `QUEST_ACCEPTED` cleanup;
- Immersion OFF suppression;
- Immersion ON recovery.

## Integrated restoration correction

P0083 Run All exposed a pre-existing TargetFrame restoration failure.

P0084 replaced the failing IgnoreParentAlpha mechanism with selective contextual
alpha suppression/restoration.

P0084 runtime:
- Target Frame Check PASS;
- two standalone Restoration Checks PASS;
- three consecutive Run All executions PASS;
- no recurrence of the secret-value setter failure.

## Visual result

User reported:
**visual passed**.

The acceptance request included:
- readable placement;
- appropriate temporary duration;
- non-interactive presentation;
- unchanged Blizzard quest controls;
- no observed Lua/taint/secret-value errors.

## Exit

All F.4 exit criteria are satisfied.

Next:
F.5 objective/progress capability proof using the existing Quest Probe.
