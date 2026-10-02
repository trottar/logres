# F.6 — Contextual Objective Progress Pulse

Status: ACTIVE — LIVE SOURCE PASS; PREVIEW REGRESSION; PRODUCTION PULSE UNPROVEN
Opened: 2026-10-02

Canonical capability contract:
`../decisions/D-031_QUEST_EXPERIENCE_CAPABILITY_CONTRACT.md`

F.5 evidence:
`../evidence/F5_SAME_QUEST_TRANSITION_PASS_2026-10-02.md`

P0088 runtime/visual evidence:
`../evidence/F6_P0088_RUNTIME_VISUAL_FAIL_2026-10-02.md`

P0089 runtime evidence:
`../evidence/F6_P0089_LIVE_SOURCE_PASS_PREVIEW_REGRESSION_2026-10-02.md`

## Product intent

Present objective progress only when it meaningfully changes.

This is a contextual pulse, not a permanent quest/objective tracker.

## Passive / baseline contract

Unchanged:
- safe super-tracked/selected quest identity;
- passive `C_QuestLog.GetQuestObjectives`;
- secret checks before inspection;
- first usable sample baselines without a pulse;
- identity changes rebaseline;
- same-quest count/finished changes may pulse;
- missing/empty/unusable data does not fabricate progress.

## Refresh contract

Unchanged:
- `QUEST_LOG_UPDATE`;
- `QUEST_WATCH_UPDATE`;
- `SUPER_TRACKING_CHANGED` rebaseline;
- `PLAYER_ENTERING_WORLD` rebaseline.

Do not require:
- `QUEST_PROGRESS`;
- `QUEST_COMPLETE`;
- `QUEST_TURNED_IN`.

## P0089 durable runtime

P0089 implementation is pushed at:
`1781c038`.

Runtime:
`0.0.35-dev`.

Placement:
- width `520`;
- height `32`;
- 6px above addon-owned `LogresHUDTarget`;
- fallback UI-center `y=-5`.

## Live source result

**PASS.**

Quest 237 was captured with:
- Skullthumper `3/10`;
- Seer `3/10`.

A later natural update captured:
- Skullthumper `4/10`;
- Seer `3/10`.

Relevant event counters advanced:
- QUEST_LOG_UPDATE `85 -> 86`;
- QUEST_WATCH_UPDATE `6 -> 7`.

This closes the stale-source concern.

## Production pulse result

**UNPROVEN for the captured `3/10 -> 4/10` update.**

The diagnostic sequence did not include Objective Progress Check after that
natural change and before reload, so the existing `meaningfulChangeCount` /
`pulseCount` evidence was not preserved in the exported panel run.

Do not change production event logic from this result alone.

## Preview regression

**CONFIRMED.**

P0089 changed Objective Progress Preview from a quest-looking synthetic example
to the explicit generic:

`PREVIEW · Objective progress · 3/10`.

That successfully stopped Preview from masquerading as live quest evidence, but
it made the developer-panel action less useful for a real multi-objective quest.

The correct behavior is:
- when a safe active quest/objective set exists, Preview shows the current live
  objective rows;
- maximum two rows;
- Preview does not establish or mutate the production baseline;
- when current data is unavailable, Preview uses the explicit synthetic sample.

The previous hardcoded Seer sample is not restored.

## P0090

Runtime target:
`0.0.36-dev`.

P0090 changes Preview semantics only.

Production source, event, baseline, comparison, timer, Immersion policy, and
Blizzard ownership remain unchanged.

## Runtime acceptance

Required:
1. Objective Progress Check PASS;
2. with active quest 237, Preview shows current live objective rows;
3. with no usable active quest, Preview may show explicit synthetic fallback;
4. Preview does not alter production baseline/change counters;
5. one natural same-quest objective update produces one automatic pulse;
6. immediately after that update, Objective Progress Check records the change
   and pulse before reload;
7. Quest Probe records the matching updated live count;
8. unchanged later refresh produces no duplicate pulse;
9. stock Objective Tracker remains usable;
10. no Lua/taint/protected/secret-value errors.
