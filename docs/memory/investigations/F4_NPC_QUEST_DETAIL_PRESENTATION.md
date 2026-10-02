# F.4 — Additive NPC Quest Detail Presentation

Status: ACTIVE — RUNTIME PATH PASS; VISUAL + INTEGRATED RETEST PENDING
Opened: 2026-10-02

## Product contract

Temporary additive NPC quest presentation:
- title;
- restrained body excerpt;
- optional objective;
- upper-world placement;
- approximately ten seconds;
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

## Integrated blocker

Run All failed in pre-existing TargetFrame restoration.

P0083 captured the exact error:
Forever rejected the secret-capable IgnoreParentAlpha restoration token passed
to `SetIgnoreParentAlpha`.

P0084 corrects that narrow target path.

## Visual status

Explicit user visual acceptance of F.4 has not yet been recorded.

## Exit

Close F.4 only after:
- P0084 integrated restoration retest passes;
- QuestDialogue remains correct;
- no Lua/taint/secret errors;
- Blizzard quest controls remain unchanged;
- user visually accepts the presentation.
