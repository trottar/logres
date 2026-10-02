# F.5 Objective Data Shapes — 2026-10-02

Status: PARTIAL PASS — DATA SHAPES PROVEN; SAME-QUEST TRANSITION PENDING
Date: 2026-10-02
Baseline checkpoint: P0085 `f6a30d8`
Runtime: `0.0.33-dev`

## Runtime identity

Forever:
- client `1.60.1`;
- build `70170`;
- interface `16001`.

Logres:
- loadCount 69 during the objective samples;
- final persisted loadCount 70.

## No active quest

Quest Probe:
- active quest nil;
- objectives nil.

This preserves the unavailable/no-active state.

## Populated active objectives

Quest ID:
`237`

Title:
`In Defense of the King's Lands`

State:
- complete=false;
- failed=false;
- ready=false.

Objectives:
1. Stonesplinter Skullthumper slain — `0/10`, done=false;
2. Stonesplinter Seer slain — `0/10`, done=false.

This is the first runtime proof of populated incomplete objective rows on
Forever.

## Populated completed objective

Quest ID:
`1338`

Title:
`Stormpike's Order`

State:
- complete=true;
- failed=false;
- ready=true.

Objective:
1. Bring Stormpike's Request to Furen Longbeard in Stormwind —
   `1/1`, done=true.

This proves that a populated completed objective row and completed/turn-in-ready
quest state are readable through the passive query path.

## Event counters

Across the new samples:
- `QUEST_LOG_UPDATE`: 32 -> 33 -> 34;
- `SUPER_TRACKING_CHANGED`: 9 -> 10 -> 11;
- `QUEST_PROGRESS`: remained 0;
- `QUEST_COMPLETE`: remained 0;
- `QUEST_TURNED_IN`: remained 0;
- `QUEST_WATCH_UPDATE`: remained 0.

Do not infer unobserved events from the final completed state.

## Update semantics

The probe switched from:
- no active quest;
- to quest `237`;
- to quest `1338`.

Each sample returned the current active quest's own objective state, so
cross-quest stale retention was not observed.

A same-quest objective count/finished transition remains unproven.

## Waypoint evidence

Quest `237`:
no usable next waypoint.

Quest `1338`:
no usable next waypoint.

Together with prior quest `436`, the tested negative destination samples are now:
- `436`;
- `237`;
- `1338`.

## Result

Objective data shape:
**PASS**.

Same-quest update behavior:
**PENDING**.

F.5 remains open.

No production objective presentation and no stock Objective Tracker suppression
are authorized yet.
