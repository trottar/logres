# Camera World-Entry Transition Timeout — 2026-10-06

Status: **REPRODUCED — P0155 RUNTIME FAIL EXPOSES FIRST-UPDATE TIMEBASE DEFECT; P0156 PREPARED**

## Initial trigger

The integrated P0152 validation first recorded a `PLAYER_ENTERING_WORLD` camera transition timeout on `0.0.74-dev`.

A targeted retest reproduced the failure, and P0154 then instrumented command-versus-observed motion.

## P0154 diagnostic result

P0154 is durable at `40dec1874a587156c88319a9caed940088e25db7` / `0.0.75-dev`.

LoadCount `184` captured:
- start about `23.148`;
- target `5`;
- final `50`;
- range `0 -> 50`;
- `145` samples;
- final/max easing error `45`;
- `142` inward commands and `1` outward command.

This exposed a real stop-before-reverse defect in P0119.

## P0155 R1

P0155 R1 is durable at `e9be312d24c89d6b2d4d9935ea6eb6f9424ca698` / `0.0.76-dev`.

It corrects direction-switch hygiene by stopping the previous MoveView direction before starting the opposite direction.

The initial P0155 delivery refusal remains preserved separately; R1 corrected that artifact baseline.

## P0155 runtime result

LoadCount `185` produced a different and more fundamental failure:
- user-visible camera remained extremely zoomed out;
- start/current/final `50`;
- requested/effective target `5`;
- elapsed about `23.523s`;
- samples `1`;
- toward `0`, away `0`, flat `1`;
- `inCommands=0`;
- `outCommands=0`;
- `switches=0`;
- one timeout failure;
- no secret-value failure.

Separate Run All repeated the same state.

## Narrow cause

This sample proves P0155's reversal correction was not exercised.

`BeginTransition()` starts `transitionStartTime` inside the `PLAYER_ENTERING_WORLD` reconcile. In this runtime sample, no camera OnUpdate executed for about `23.5s`.

When the first OnUpdate finally ran, the code computed elapsed from the old event time, found the transition already beyond its timeout budget, and called `FinishTransition()` before `ApplyTransitionMotion()`.

That directly explains:
- one sample;
- zero commands;
- zero switches;
- unchanged zoom `50`;
- immediate timeout on first drivable frame.

## P0156 corrective contract

P0156 may:
- record the event-time arm zoom/time for diagnostics;
- leave `transitionStartTime` unset at event-time arm;
- on the first actual OnUpdate, set `transitionStartTime` to that frame time;
- set transition start/min/max/previous/expected zoom to the first actual drivable zoom sample;
- retain direction-switch hygiene;
- expose first-update delay in addon-owned diagnostics.

P0156 must not:
- schedule a delayed timer/reconcile;
- poll;
- add events or broad hooks;
- periodically reassert;
- mutate camera CVars;
- change World/City/Combat/Taxi targets;
- change transition duration or timeout allowance;
- expand Taxi ownership.

## Runtime gate

After P0156:
1. normal `/reload`;
2. Phase G -> **Camera World/Combat Check**;
3. Phase 0 -> **Run All** separately;
4. preserve diagnostics.

A large `firstDelay` is acceptable; it must no longer consume the transition's motion budget before the first drivable frame.

PASS requires target convergence, `failures=0`, `secret=false`, and no Lua/taint/protected-action failure.


## P0156 runtime acceptance

P0156 is verified durable at:
`e1be731bd64db2acb62480f62fafaea58515989f`
on `0.0.77-dev`.

LoadCount `187` / Forever `1.60.1.70245`:
- Phase G Camera World/Combat Check PASS;
- context `world`, owns=true;
- start/current/final `5.0794949531555`;
- requested/effective target `5`;
- elapsed `0`;
- targetReached=true;
- failures=0;
- secret=false;
- error=nil;
- samples=1;
- inCommands=0;
- outCommands=0;
- switches=0;
- armZoom `5.0794949531555`;
- firstDelay=0.

Separate Run All repeated the same camera PASS and completed cleanly.

## Final classification

**RESOLVED FOR OBSERVED NORMAL WORLD ENTRY — P0156 RUNTIME PASS.**

The earlier failures remain authoritative historical evidence:
- P0154 reproduced competing world-entry motion;
- P0155 exposed the stale event-time timeout with one sample and zero commands.

The accepted P0156 run did not naturally reproduce a large first-update delay, so that branch remains unexercised in runtime evidence. It also did not exercise P0155's direction-switch stop (`switches=0`).

Those branch-level deferrals do not justify more speculative code. Reopen this investigation only if normal world entry fails again.

The next Phase G gate is the independently pending normal-Taxi landing retest from P0119.
