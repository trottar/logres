# P0131 Accept Event-Order Failure — 2026-10-05

Status: **REAL RUNTIME DIAGNOSTIC FAILURE — NARROW EVENT-ORDER DEFECT**
Runtime: `0.0.62-dev`
Baseline Git HEAD: `ab6473b25944f6d8e17318235b370a6cb5a74cc5`

## Observed runtime result

P0131 loaded on `0.0.62-dev`, loadCount `144`.

### Accept attempt

The player explicitly triggered `TEST Accept Current Quest` for:
- quest ID `436`;
- title `Ironband's Excavation`.

The mutation call itself returned successfully:
- `callOK=true`;
- `mutationCalls=1`.

However, the probe observed `QUEST_FINISHED` first and immediately terminalized the
Accept attempt as:

```text
state=finished-without-accepted
```

The second diagnostic click therefore reported FAIL.

Later integrated diagnostics from the same runtime session recorded the quest
dialogue module with:

```text
accepted=1
```

This demonstrates that a `QUEST_ACCEPTED` event did occur in the tested session
after the probe had already discarded its pending Accept correlation.

The Accept action therefore cannot yet be classified from the probe as PASS even
though the client subsequently emitted acceptance evidence. The defect is in
probe event-order handling, not in source availability.

### Decline attempt

The player then explicitly triggered `TEST Decline Current Quest` for the same
quest offer.

The probe recorded:
- `callOK=true`;
- `event=QUEST_FINISHED`;
- `state=event-confirmed`;
- `success=1`;
- `secret=false`;
- `error=nil`.

Decline is therefore **runtime PASS** for the tested offer flow.

### Integrated regression result

`Run All` completed cleanly on `0.0.62-dev` after the mutation probes.

No Lua, secret-value, taint, protected-action, or unrelated subsystem failure was
reported in the tested scope.

## Cause

P0131 initially assumed that `QUEST_FINISHED` arriving before `QUEST_ACCEPTED` on
a pending Accept meant acceptance had failed.

Forever's tested offer flow instead emitted `QUEST_FINISHED` before the later
`QUEST_ACCEPTED` event.

The probe therefore produced a false negative by treating an intermediate
interaction-lifecycle event as a terminal Accept failure.

## Corrective design

P0131 R2 must:
- keep Decline semantics unchanged: `QUEST_FINISHED` remains its terminal success
  event;
- for pending Accept, treat `QUEST_FINISHED` only as an intermediate observation;
- preserve the exact preflight quest identity and pending Accept correlation;
- continue waiting for `QUEST_ACCEPTED` without polling, timers, broad hooks, or
  periodic reassertion;
- preserve `awaiting-accepted-after-finished` if `QUEST_FINISHED` occurs
  synchronously inside `AcceptQuest()`;
- allow a later `QUEST_ACCEPTED` to resolve the same action as PASS;
- fail on identity mismatch/secret state as before;
- fail if a replacement offer or world transition occurs before acceptance.

Blizzard controls remain visible throughout.

## Retest gate

Only Accept needs corrective retest.

1. open a real quest offer the player is willing to accept;
2. click `TEST Accept Current Quest`;
3. confirm normal acceptance;
4. click the same diagnostic again after the events resolve;
5. require `event=QUEST_ACCEPTED`, `state=event-confirmed`, and PASS;
6. `finishedObserved=true` is expected/allowed and confirms the event ordering;
7. run `Run All`.

Decline does not need to be repeated solely for this correction; its `0.0.62-dev`
PASS remains valid.
