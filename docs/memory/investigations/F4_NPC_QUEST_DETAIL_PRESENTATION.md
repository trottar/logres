# F.4 — Additive NPC Quest Detail Presentation

Status: ACTIVE — P0083 IMPLEMENTATION PREPARED
Opened: 2026-10-02

Canonical capability contract:
`../decisions/D-031_QUEST_EXPERIENCE_CAPABILITY_CONTRACT.md`

F.2 source/runtime evidence already proved:
- `QUEST_DETAIL`;
- `GetQuestID`;
- `GetTitleText`;
- `GetQuestText`;
- `GetObjectiveText`;
- quest ID/title/body/objective values for tested quest `436`;
- `QUEST_ACCEPTED`.

## Product contract

Present quest-giver narrative as a restrained, temporary world-oriented text
surface while leaving Blizzard's quest frame fully available for control.

P0083 presentation:
- centered near the upper world view;
- quest title;
- restrained quest body excerpt;
- optional objective line;
- approximately ten-second lifetime;
- no mouse interaction;
- no replacement of accept/decline/reward controls.

## Input contract

Production presentation starts only from:
`QUEST_DETAIL`.

Read:
- `GetQuestID`;
- `GetTitleText`;
- `GetQuestText`;
- `GetObjectiveText`.

Every returned value is secret-checked before type inspection/string handling.

## Cleanup contract

Hide on:
- `QUEST_ACCEPTED`;
- `QUEST_FINISHED`;
- `PLAYER_ENTERING_WORLD`;
- timeout;
- Immersion OFF;
- module disable.

Timeout is the stale-state fallback if a cleanup event is unavailable or does
not fire.

## Stock ownership

P0083 does not:
- hide/mutate QuestFrame or GossipFrame;
- accept/decline/complete quests;
- choose rewards;
- change quest selection/watch/super-tracking;
- suppress objective tracker/minimap/XP UI.

This slice is additive only.

## Diagnostics

Developer panel:
- **Quest Dialogue Check**;
- **Quest Dialogue Preview**.

Run All includes Quest Dialogue Check.

## Runtime proof

Required:
1. Quest Dialogue Check PASS after reload;
2. Quest Dialogue Preview visual acceptance;
3. open a normal quest detail page;
4. real presentation shows the same quest context;
5. accept/close path removes the Logres presentation;
6. Immersion OFF suppresses Preview;
7. Immersion ON restores Preview;
8. Run All PASS;
9. no Lua/taint/secret errors;
10. Blizzard quest controls remain usable and visually unchanged.

## Exit

Close F.4 only after runtime + visual proof.

Do not expand into quest progress/reward replacement or objective tracking from
this slice.
