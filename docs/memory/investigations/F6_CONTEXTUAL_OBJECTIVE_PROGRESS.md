# F.6 — Contextual Objective Progress Pulse

Status: ACTIVE — CONTRACT ACCEPTED; IMPLEMENTATION NEXT
Opened: 2026-10-02

Canonical capability contract:
`../decisions/D-031_QUEST_EXPERIENCE_CAPABILITY_CONTRACT.md`

F.5 evidence:
`../evidence/F5_SAME_QUEST_TRANSITION_PASS_2026-10-02.md`

## Product intent

Present objective progress only when it meaningfully changes.

This is a contextual pulse, not a permanent quest/objective tracker.

The world-first rule remains:
show an abstraction only when the player actually needs the update.

## Passive source

Use the runtime-proven quest-log path:
- current super-tracked quest ID when usable;
- selected quest ID as fallback when usable;
- `C_QuestLog.GetQuestObjectives(questID)`.

Objective fields may be used only after secret-safe validation:
- text;
- finished;
- numFulfilled;
- numRequired.

Do not persist objective text/content.

## Refresh events

Production may listen to:
- `QUEST_LOG_UPDATE` — primary runtime-proven refresh;
- `QUEST_WATCH_UPDATE` — runtime-observed refresh;
- `SUPER_TRACKING_CHANGED` — identity/baseline update only.

Do not require:
- `QUEST_PROGRESS`;
- `QUEST_COMPLETE`;
- `QUEST_TURNED_IN`.

Those remain environmental deferrals.

## Baseline and stale-state policy

First usable sample for a quest:
- establish baseline;
- show nothing.

Quest identity changes:
- discard the previous quest baseline;
- capture the new quest baseline;
- show nothing merely because identity changed.

Same quest:
- recapture current objective rows after a proven refresh event;
- compare only secret-safe normal scalar values;
- pulse only when a row's count or finished state meaningfully changes.

Unusable read:
- clear/withhold presentation;
- do not fabricate an empty/completed state;
- do not reuse stale data as current data.

## Presentation

Initial production presentation:
- temporary;
- text-only;
- non-interactive;
- no permanent objective list;
- no background tracker panel;
- no exact replacement of Blizzard Objective Tracker.

For a count change, a compact example shape is:
`Stonesplinter Seer slain  ·  1/10`

For completion:
`Stonesplinter Seer slain  ·  Complete`

The implementation may truncate long objective text conservatively.

Multiple changed rows in one refresh should remain bounded and restrained.

## Context policy

Immersion ON:
- normal contextual pulse behavior.

Immersion OFF:
- suppress Logres objective presentation;
- continue safe observation/baselining so re-enabling does not replay stale
  progress as a new pulse.

## Fail-open

On:
- missing active quest;
- nil objectives;
- secret objective container/row/field;
- invalid scalar type;
- API call failure;
- uncached/empty data where completion cannot be inferred;

show nothing and leave Blizzard UI untouched.

## Blizzard ownership

F.6 does not:
- suppress the stock Objective Tracker;
- mutate quest watch state;
- mutate super-track state;
- alter quest log interaction;
- alter accept/decline/continue/complete/reward controls;
- add a quest compass marker.

## Diagnostics

Implementation should add developer-panel:
- **Objective Progress Check**
- **Objective Progress Preview**

Run All should include Objective Progress Check.

Useful addon-owned counters/state:
- refresh event counts;
- baseline captures;
- meaningful changes;
- pulses shown;
- suppressed pulses;
- previews;
- current quest ID if safely usable;
- current baseline row count;
- last presentation reason;
- last safe error/reason.

No protected/secret Blizzard presentation state is inspected for proof.

## Runtime acceptance

Required:
1. Check PASS after initialization;
2. Preview PASS / visible while Immersion ON;
3. Preview suppressed while Immersion OFF;
4. first real baseline produces no false pulse;
5. one real same-quest objective change produces a short pulse;
6. repeat refresh without a new change produces no duplicate pulse;
7. quest identity change does not replay prior objective progress;
8. stock Objective Tracker remains unchanged/usable;
9. no Lua/taint/protected/secret-value errors.

Visual acceptance:
- concise/readable;
- temporary;
- does not resemble a permanent tracker;
- does not compete with the NPC quest-dialogue presentation.
