# F.2 P0078 Quest / XP Runtime Evidence — 2026-10-02

Status: CAPABILITY EVIDENCE CAPTURED — INTEGRATED RUN BLOCKED BY RESTORATION FAILURE
Date: 2026-10-02
P0078 commit: `8b38fe64d381bb4ab87b245073cc288ae4f092b7`

## Runtime

Forever:
- client `1.60.1`;
- build `70170`;
- interface `16001`.

Logres:
- production runtime `0.0.30-dev`.

## XP

Baseline Quest Probe:
- current XP `11246`;
- max XP `12900`;
- rested XP `8910`;
- Forever experience preset `1`.

Later:
- current XP `11370`;
- max XP `12900`;
- rested XP `8788`.

Events:
- `PLAYER_XP_UPDATE`: registered, observed count `1`;
- `UPDATE_EXHAUSTION`: registered, observed count `2`.

The probe would print `<secret>` for secret values. These XP values were normal
numeric scalars.

### XP conclusion

The passive XP source/event path required for the D-031 contextual XP candidate
is runtime-proven.

This does not authorize stock XP suppression.

## Quest identity and interaction

A super-tracked quest was observed:
- quest ID `436`;
- title `Ironband's Excavation`;
- complete `true`;
- failed `false`;
- ready for turn-in `true`.

A `QUEST_DETAIL` interaction was observed for quest `436` with usable:
- quest ID;
- title;
- quest text;
- objective text;
- reward XP (`340`).

`QUEST_ACCEPTED` subsequently fired once.

### NPC-read conclusion

Quest-giver passive reads are runtime-proven for the tested detail/accept flow.

Blizzard remains owner of accept/decline/reward controls.

## Objectives

For the tested completed/ready quest `436`,
`C_QuestLog.GetQuestObjectives` produced a present, non-secret empty objective
table.

This is a valid tested state, but it does not prove populated active-objective
rows.

Objective-row presentation remains runtime-unproven.

## Quest destination

For super-tracked quest `436`:
- `C_QuestLog.GetNextWaypoint` returned no usable map/x/y;
- `C_QuestLog.GetNextWaypointForMap` returned no usable x/y;
- map-space quest bearing was unavailable.

This repeats the earlier negative quest-436 destination evidence.

Quest compass marker support remains deferred.

## Event observations

Registered and observed:
- `QUEST_LOG_UPDATE`;
- `QUEST_WATCH_LIST_CHANGED`;
- `SUPER_TRACKING_CHANGED`;
- `QUEST_DETAIL`;
- `QUEST_ACCEPTED`;
- `PLAYER_XP_UPDATE`;
- `UPDATE_EXHAUSTION`.

Registered but not observed in this run:
- `QUEST_PROGRESS`;
- `QUEST_COMPLETE`;
- `QUEST_TURNED_IN`;
- `QUEST_WATCH_UPDATE`.

Those are environmental deferrals, not failures.

## Integrated validation failure

`Run All` produced one failure:

`restorationcheck: FAIL (cycleError=opposite preference state did not settle ...)`

Cleanup succeeded and final state reconverged:
- `cleanup=none`;
- `finalOK=true`;
- final immersion/controller replacement state returned to expected enabled
  values.

All later checks in the same Run All continued, including:
- Context Policy Check PASS;
- Compass Check PASS.

This failure blocks advancing to production work until it is narrowed.

See:
`P0078_RESTORATION_SETTLE_FAILURE_2026-10-02.md`.
