# P0088 — Implement Contextual Objective Progress

Date: 2026-10-02
Result: PREPARED — RUNTIME + VISUAL PROOF PENDING

## Baseline

P0087 verified pushed:
`4aecb22418d8980f2a121acce4d9eeafdf4a604b`

## Runtime

`0.0.33-dev -> 0.0.34-dev`.

## Implementation

Adds:
`Logres/Quest/Progress.lua`.

Module:
`QuestObjectiveProgress`.

Behavior:
- passive super-tracked/selected quest identity;
- secret-safe objective reads;
- baseline-first;
- same-quest count/finished comparison;
- temporary 3-second objective pulse;
- maximum two changed rows;
- no permanent tracker;
- Immersion OFF suppresses presentation while safe baseline updates continue.

Events:
- QUEST_LOG_UPDATE;
- QUEST_WATCH_UPDATE;
- SUPER_TRACKING_CHANGED rebaseline;
- PLAYER_ENTERING_WORLD rebaseline.

Does not rely on:
- QUEST_PROGRESS;
- QUEST_COMPLETE;
- QUEST_TURNED_IN.

## Diagnostics

Adds:
- Objective Progress Check;
- Objective Progress Preview;
- Run All integration.

Real objective text/content is not emitted into developer-panel diagnostics.

## Blizzard ownership

Unchanged:
- Objective Tracker remains stock;
- watch/super-track mutation remains Blizzard-owned;
- quest interaction controls remain Blizzard-owned.

## Static contract

Adds:
`tools/check_objective_progress_contract.py`.

No polling, ticker, broad hook, or stock Objective Tracker mutation.

## Runtime

Pending after push/deploy.

WoW redeploy required.

## Delivery repair

The first P0088 apply failed during temporary-tree validation because
`tools/check_compass_contract.py` still froze the current runtime at the
historical E.4 version `0.0.30-dev`.

No tracked P0088 target file had been written.

The repair removes only that historical version freeze, preserves the Compass
feature contract and Bootstrap/TOC synchronization check, and adds a
repository-wide static-checker scan for the same obsolete pattern before the
normal checker suite runs.

Evidence:
`../evidence/P0088_DELIVERY_FAILURE_2026-10-02.md`.

