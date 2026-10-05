# P0130 Quest Dialogue Immersion-Restore Failure — 2026-10-05

Status: **REAL RUNTIME FAILURE — NARROW LIFECYCLE DEFECT**
Runtime: `0.0.60-dev`
Baseline Git HEAD: `e50676b993b9f5bc544eab610f99c7532dc98148`

## Observed result

P0130 otherwise validated successfully:
- deterministic multi-page Quest Dialogue Preview rendered;
- Previous / Next controls worked;
- Quest Dialogue Check passed;
- a real `QUEST_DETAIL` offer rendered with body/objective data;
- Blizzard Accept / Decline remained usable;
- integrated `checkall` passed.

One real lifecycle defect remained:

1. open a real quest offer while Immersion is ON;
2. turn Immersion OFF;
3. Logres correctly hides its narrative while Blizzard remains usable;
4. turn Immersion ON without leaving the quest conversation;
5. Logres narrative remains hidden;
6. leaving the conversation and reopening it causes a fresh `QUEST_DETAIL`, after
   which the Logres narrative appears again.

## Classification

**FAIL — P0130 cannot be accepted yet.**

This is not a source-data, secret-value, paging, control-ownership, or Blizzard
fallback failure.

It is a narrow presentation lifecycle defect.

## Cause

`QuestDialogue:ApplyPreferences()` hides the Logres narrative when Immersion turns
OFF but has no restore path when Immersion turns back ON.

The source detail is only rendered from `QUEST_DETAIL`.

No new `QUEST_DETAIL` event is emitted merely because the preference toggles back
ON, so the panel remains hidden until the conversation is exited/re-entered.

## Corrective design

P0130 R1 should:
- cache only the successfully read ordinary `QUEST_DETAIL` snapshot currently
  owned by the open quest interaction;
- preserve that cache while Immersion is OFF;
- on OFF -> ON, re-present the cached source title/body/objective without
  re-reading or mutating quest state;
- clear the cache on `QUEST_ACCEPTED`, `QUEST_FINISHED`, world transition, module
  disable, and failed/secret new detail reads;
- expose restore count/cache state through addon-owned diagnostics;
- keep Blizzard controls untouched.

## Retest gate

With a real quest offer open:
1. confirm Logres narrative visible;
2. Immersion OFF -> Logres narrative hidden, Blizzard controls usable;
3. Immersion ON -> the same Logres narrative restores immediately without
   leaving/reopening the conversation;
4. Quest Dialogue Check -> PASS;
5. Run All -> PASS.

Any Lua, secret-value, taint, protected-action, stale/wrong quest restoration, or
Blizzard interaction regression remains a real failure.
