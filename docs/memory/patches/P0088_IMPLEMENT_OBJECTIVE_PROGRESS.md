# P0088 — Implement Contextual Objective Progress

Date: 2026-10-02
Result: INSTALLED / PUSHED — RUNTIME/INTEGRATION PASS; VISUAL FAIL (`228b467`)

## Baseline

P0087 verified pushed:
`4aecb22418d8980f2a121acce4d9eeafdf4a604b`

## Runtime

`0.0.33-dev -> 0.0.34-dev`.

## Implementation

Adds `QuestObjectiveProgress`:
- passive super-tracked/selected quest identity;
- secret-safe objective reads;
- baseline-first;
- same-quest count/finished comparison;
- temporary 3-second objective pulse;
- maximum two changed rows;
- no permanent tracker;
- Immersion OFF suppression while safe baseline updates continue.

Events:
- QUEST_LOG_UPDATE;
- QUEST_WATCH_UPDATE;
- SUPER_TRACKING_CHANGED rebaseline;
- PLAYER_ENTERING_WORLD rebaseline.

## Runtime result

PASS within the tested integration scope on `0.0.34-dev`.

Observed:
- Objective Progress Check PASS;
- Preview Immersion ON/OFF/ON behavior PASS;
- two consecutive Run All PASS;
- no F.6 secret/fixed-error diagnostic.

A real production pulse was not captured:
`changes=0`, `pulses=0`.

## Visual result

FAIL.

Objective-progress Preview overlapped the lower-center action cluster.

Evidence:
`../evidence/F6_P0088_RUNTIME_VISUAL_FAIL_2026-10-02.md`.

Presentation placement is superseded by P0089.

## Blizzard ownership

Unchanged:
- Objective Tracker remains stock;
- watch/super-track mutation remains Blizzard-owned;
- quest interaction controls remain Blizzard-owned.

## Delivery history

The first P0088 apply failed because the Compass checker froze runtime at the
historical E.4 version `0.0.30-dev`.

The repaired P0088 removed only that stale version freeze and preserved the
feature contract/version-sync check.

Evidence:
`../evidence/P0088_DELIVERY_FAILURE_2026-10-02.md`.
