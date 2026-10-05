# P0126 Active Quest Source Audit — 2026-10-04

Status: **SOURCE CONTRACT RESOLVED — NO NEW CAPABILITY PROBE REQUIRED**

## Question

Can the approved D-032/D-039 Active Quest one-focus presentation be built from
already-proven passive quest data without taking new Blizzard quest-control,
tracker, navigation, or protected ownership?

## Existing proven inputs

The current `QuestObjectiveProgress` producer already implements the focus identity
policy:

1. `C_SuperTrack.GetSuperTrackedQuestID`;
2. fallback to `C_QuestLog.GetSelectedQuest`.

It also owns guarded `C_QuestLog.GetQuestObjectives` reads and rejects secret,
invalid, missing, or uncached objective shapes before presentation logic.

Prior Phase-F runtime evidence proves:
- selected/super-tracked active quest identity;
- `C_QuestLog.GetTitleForQuestID`;
- `C_QuestLog.IsComplete`;
- `C_QuestLog.ReadyForTurnIn`;
- populated objective `text`, `finished`, `numFulfilled`, and `numRequired`;
- ordinary numeric objective counts on the tested Forever client;
- completed objective rows and completed/turn-in-ready quest state.

## Implementation consequence

P0126 does not need a new source-capability probe.

The Active Quest renderer may:
- reuse `QuestObjectiveProgress:ReadActiveQuestID()`;
- reuse `QuestObjectiveProgress:ReadObjectives(questID)`;
- read the already-proven title/completion flags with the same secret-first rule;
- derive percentage bars only from ordinary objective counts that survived the
  guarded producer;
- derive restrained qualitative wording only from safe progress/completion state;
- reveal source objective wording and exact counts only on deliberate hover.

## Ownership boundary

P0126 must not:
- mutate selected/super-tracked/watch state;
- suppress the Blizzard Objective Tracker or quest log;
- add quest waypoint/Compass behavior;
- accept/decline/continue/complete quests;
- select rewards or navigate gossip;
- poll with OnUpdate/timers when established quest events already exist.

The full Blizzard quest log remains available.

## Result

**RESOLVED.**

Proceed with one event-driven optional Active Quest presentation plus an
independent persisted `activeQuestEnabled` preference.
