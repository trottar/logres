# P0156 — P0155 First-Update Timeout — 2026-10-06

Status: **P0155 RUNTIME FAIL; FIRST-DRIVABLE-FRAME TIMEBASE DEFECT PROVEN**
Runtime: `0.0.76-dev`
Client: Forever `1.60.1.70245`
Durable P0155 commit: `e9be312d24c89d6b2d4d9935ea6eb6f9424ca698`
LoadCount: `185`

## User-visible result

The user reported the camera was extremely zoomed out after the P0155 R1 deployment/reload.

## Runtime result

Phase G **Camera World/Combat Check**:
- context `world`, ownership retained;
- reason `PLAYER_ENTERING_WORLD`;
- start `50`;
- current/final `50`;
- requested/effective target `5`;
- elapsed about `23.523s`;
- samples `1`;
- toward `0`, away `0`, flat `1`;
- minimum/maximum `50`;
- inward commands `0`;
- outward commands `0`;
- direction switches `0`;
- `targetReached=false`;
- one timeout failure;
- `secret=false`.

Separate Run All repeated the same camera failure.

## Interpretation

P0155's stop-before-reverse behavior was not exercised. There was no MoveView command at all.

The existing driver stores `transitionStartTime = GetTime()` when the transition is armed during `PLAYER_ENTERING_WORLD`. On this sample, the first camera OnUpdate did not run until roughly `23.5s` later.

OnUpdate checks timeout before `ApplyTransitionMotion()`. Therefore the first sample immediately satisfied the timeout condition and finished the transition without ever driving toward target.

The max-zoomed-out result is thus directly explained by stale event-time elapsed state in this sample.

## P0156 gate

P0156 may:
- retain event-time arm zoom/time as diagnostics;
- begin motion/timeout timing on the first actual OnUpdate frame;
- use that frame's current zoom as the transition start/min/max/previous baseline;
- preserve P0155 direction-switch hygiene.

P0156 may not add a timer, delayed reconcile, polling loop, broad event hook, periodic reassertion, CVar mutation, target change, transition-duration change, or Taxi expansion.
