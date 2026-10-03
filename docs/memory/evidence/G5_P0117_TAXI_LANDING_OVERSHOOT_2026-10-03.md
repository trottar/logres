# G.5 P0117 Taxi Landing Transition Overshoot — 2026-10-03

Status: **RUNTIME FAIL — SHARED CAMERA TRANSITION DRIVER**
Runtime observed: `0.0.47-dev`
Client: Forever `1.60.1`
Build: `70205`

## Observation

P0117 successfully entered automatic Taxi ownership:

- context `taxi`;
- owns=true;
- requested target `50`;
- diagnostic effective target `18`;
- transition duration `5`;
- max factor `1.2`;
- max ceiling `18`;
- failures=0;
- secret=false;
- error=nil.

After landing in a resting/City destination, the controller selected City and
started the expected `18 -> 5` transition, but the camera overshot to first
person:

- context `city`;
- owns=true;
- current/start `18`;
- requested/effective target `5`;
- duration `2.5`;
- final `0`;
- elapsed about `0.061`;
- targetReached=false;
- failures=0;
- error=nil.

The user also observed the first-person result visually.

## Historical corroboration

The same failure class appears in earlier `0.0.43-dev` diagnostics:

- City current/start `18`;
- target `5`;
- final `0`;
- targetReached=false.

Taxi ownership therefore exposed a latent shared World/Combat/City transition
defect rather than creating a Taxi-specific destination-selection defect.

## Source cause

The P0117 production controller starts one constant-speed
`MoveViewInStart()` / `MoveViewOutStart()` rate from the full
`delta / transitionDuration`, then uses `OnUpdate` primarily to detect target
crossing or timeout.

Pinned LibCamera instead updates MoveView speed frame-by-frame along an easing
curve and performs destination correction.

The existing Logres crossing test also treats any crossing as completion. If a
sampled frame has already moved from target `5` to `0`, the controller stops
there rather than correcting back toward `5`.

## Corrective contract

P0119 changes only the shared zoom-transition driver:

- keep existing context selection, targets, priority, and restore-never behavior;
- keep existing MoveView APIs;
- no SetCVar;
- shape MoveView velocity every animation frame using bounded ease-in/ease-out;
- when a non-Taxi transition crosses beyond target outside tolerance, drive back
  toward the requested target instead of accepting the overshoot;
- retain the existing non-Taxi timeout window as a fail-safe;
- Taxi still requests `50` for `5` seconds and may finish at the engine clamp;
- no polling, Taxi rotation, or UI fade.

## Classification

P0117:
**TAXI ENTRY PASS / LANDING TRANSITION FAIL.**

G.5 remains open pending P0119 runtime retest.
