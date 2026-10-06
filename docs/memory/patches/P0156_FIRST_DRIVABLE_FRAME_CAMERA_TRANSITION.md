# P0156 — First-Drivable-Frame Camera Transition

Date: 2026-10-06
Baseline: `e9be312d24c89d6b2d4d9935ea6eb6f9424ca698`
Candidate runtime: `0.0.77-dev`
Result: **PREPARED — RUNTIME RETEST REQUIRED**

## Trigger

P0155 R1 is durable but its runtime retest timed out before issuing any MoveView command.

Canonical evidence:
`../evidence/P0156_P0155_FIRST_UPDATE_TIMEOUT_2026-10-06.md`.

## Narrow cause

`BeginTransition()` starts its elapsed clock during `PLAYER_ENTERING_WORLD`.

The observed first OnUpdate arrived about `23.523s` later. Since timeout is evaluated before motion application, the transition expired on sample 1 with zero commands and left the camera at zoom `50`.

## Runtime correction

P0156:
- records event-time arm zoom/time;
- leaves the transition motion clock unstarted at event-time arm;
- on the first actual OnUpdate, records first-update delay;
- sets transition start time to that frame;
- rebases transition start/min/max/previous/expected zoom to that frame's ordinary current zoom;
- retains P0154 motion diagnostics;
- retains P0155 stop-before-reverse behavior;
- exposes `armZoom` and `firstDelay` in the existing Phase G motion line;
- bumps runtime to `0.0.77-dev`.

It does not change targets, durations, timeout allowance, context selection, events, DynamicCam coexistence, CVar policy, Taxi policy, or suppression.

It adds no timer, ticker, delayed reconcile, polling, broad hook, periodic reassertion, or recurring positional rebase.

## Runtime acceptance

After deployment:
1. normal `/reload`;
2. Phase G -> **Camera World/Combat Check**;
3. Phase 0 -> **Run All** separately;
4. upload diagnostics.

A large `firstDelay` is not itself failure; the transition must still receive its full motion budget after that first drivable frame.

PASS requires target convergence, `failures=0`, `secret=false`, and no Lua/taint/protected-action failure.
