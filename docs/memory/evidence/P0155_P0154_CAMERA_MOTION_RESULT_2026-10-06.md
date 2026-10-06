# P0155 — P0154 Camera Motion Result — 2026-10-06

Status: **P0154 DIAGNOSTIC PASS / CAMERA RUNTIME FAIL; DIRECTION-SWITCH DEFECT IDENTIFIED**
Runtime: `0.0.75-dev`
Client: Forever `1.60.1.70235`
Durable P0154 commit: `40dec1874a587156c88319a9caed940088e25db7`
LoadCount: `184`

## Requested validation

After P0154 deployment:
1. normal `/reload`;
2. Phase G -> **Camera World/Combat Check**;
3. Phase 0 -> **Run All** separately.

## Runtime result

The direct Phase G check failed:
- context `world`, owns=true;
- reason `PLAYER_ENTERING_WORLD`;
- start `23.147617340088`;
- requested/effective target `5`;
- current/final `50`;
- elapsed about `3.252s`;
- target not reached;
- one timeout failure;
- no secret-value error.

Motion diagnostic:
- samples `145`;
- toward `1`;
- away `1`;
- flat `143`;
- minimum zoom `0`;
- maximum zoom `50`;
- expected final easing position `5`;
- current/max absolute position error `45`;
- last command `in`;
- inward commands `142`;
- outward commands `1`.

Separate Run All repeated the same camera failure while its other listed checks passed.

## Interpretation

The original P0154 conditional hypothesis expected inward commands only. That exact condition was not met.

Instead, the stronger evidence is the one outward command together with observed `min=0` and `max=50`: the world-entry displacement crossed the target and forced P0119's crossed-target correction to reverse command direction.

Source inspection then identified a concrete local defect. `ApplyTransitionMotion()` starts the new MoveView direction when correction reverses, but does not stop the previously active direction until full transition cleanup. Therefore the single outward correction could remain active during the subsequent 142 inward commands.

This defect is independent of the still-unproven source of the discrete world-entry `0/50` displacement.

## Corrective gate

P0155 may correct only stop-before-reverse behavior:
- stop/reset the previous MoveView direction before starting the opposite one;
- retain P0154 diagnostics and record switch count;
- fail open on stop failure.

Do not add positional rebasing, timers, arbitrary delays, polling, broad hooks, CVar mutation, target/timing changes, or Taxi-policy expansion in this checkpoint.
