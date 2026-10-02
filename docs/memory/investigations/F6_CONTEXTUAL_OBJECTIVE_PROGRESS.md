# F.6 — Contextual Objective Progress Pulse

Status: ACTIVE — IMPLEMENTED; RUNTIME + VISUAL PROOF PENDING
Opened: 2026-10-02

Canonical capability contract:
`../decisions/D-031_QUEST_EXPERIENCE_CAPABILITY_CONTRACT.md`

F.5 evidence:
`../evidence/F5_SAME_QUEST_TRANSITION_PASS_2026-10-02.md`

## Product intent

Present objective progress only when it meaningfully changes.

This is a contextual pulse, not a permanent quest/objective tracker.

## P0088 implementation

Module:
`QuestObjectiveProgress`.

Source:
`Logres/Quest/Progress.lua`.

Runtime:
`0.0.34-dev`.

### Passive identity

Prefer:
`C_SuperTrack.GetSuperTrackedQuestID`.

Safe fallback:
`C_QuestLog.GetSelectedQuest`.

A secret/invalid/failing identity read fails open.

### Objective source

Use:
`C_QuestLog.GetQuestObjectives(questID)`.

Before inspection:
- secret-check objective container;
- secret-check each row;
- secret-check each scalar field.

Session baseline may contain safe objective text/counts for comparison.

Real quest/objective content is not persisted to Logres SavedVariables or
developer-panel diagnostics.

### Baseline policy

First usable sample:
baseline only.

Quest identity change:
rebaseline and hide any old pulse.

World/super-track rebaseline:
no progress pulse merely because identity/context changed.

Same quest:
compare safe current rows to the immediately prior safe baseline.

### Change policy

A row is eligible only when the objective text remains the same at the same
source position.

Meaningful change:
- fulfilled/required count changed; and/or
- finished boolean changed.

A presentable completion shows:
`<objective>  ·  Complete`.

A presentable count change shows:
`<objective>  ·  current/required`.

Added/removed/reidentified rows rebaseline without fabricating a progress
claim.

### Refresh events

Production listens to:
- `QUEST_LOG_UPDATE`;
- `QUEST_WATCH_UPDATE`;
- `SUPER_TRACKING_CHANGED`;
- `PLAYER_ENTERING_WORLD`.

The last two force rebaseline and do not themselves imply progress.

Production does not require:
- `QUEST_PROGRESS`;
- `QUEST_COMPLETE`;
- `QUEST_TURNED_IN`.

### Presentation

- temporary;
- 3 seconds;
- text-only;
- non-interactive;
- maximum two changed rows;
- no permanent background/list.

Immersion OFF:
- hide/suppress Logres presentation;
- continue safe objective baseline updates so re-enable does not replay stale
  progress.

### Blizzard ownership

P0088 does not:
- suppress Objective Tracker;
- mutate watch state;
- mutate super-track state;
- mutate quest-log selection;
- alter quest interaction controls.

## Diagnostics

Developer panel:
- **Objective Progress Check**
- **Objective Progress Preview**

Run All includes Objective Progress Check.

Addon-owned status includes:
- event registration/counts;
- baseline capture count;
- meaningful change count;
- pulse/suppressed/preview counts;
- safe quest ID;
- baseline row count;
- last secret flag;
- last sample/presentation reason;
- last fixed error.

Real objective text is not emitted by the diagnostic.

## Runtime acceptance

Required:
1. Check PASS;
2. Preview visible while Immersion ON;
3. Preview suppressed while Immersion OFF;
4. initial baseline does not false-pulse;
5. real same-quest objective update produces one short pulse;
6. unchanged subsequent refresh does not duplicate;
7. identity change does not replay old progress;
8. Objective Tracker remains usable;
9. no Lua/taint/protected/secret-value errors.

Visual:
- concise/readable;
- temporary;
- no permanent-tracker feel;
- no conflict with NPC quest dialogue.
