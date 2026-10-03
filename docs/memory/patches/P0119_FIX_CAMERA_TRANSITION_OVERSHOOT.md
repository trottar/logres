# P0119 — Fix Camera Transition Overshoot

Date: 2026-10-03
Result: **PREPARED — RUNTIME RETEST PENDING**
Baseline: `6fad23f595a4abc9f5f2bd3fd6f12b825ef204e2`
Runtime: `0.0.48-dev -> 0.0.49-dev`

## Trigger

P0117 automatic Taxi ownership entered correctly, but after landing the shared
camera controller drove an `18 -> 5` City transition to final zoom `0`
(first person).

Canonical evidence:
`../evidence/G5_P0117_TAXI_LANDING_OVERSHOOT_2026-10-03.md`.

The same failure class existed in earlier `0.0.43-dev` City diagnostics.

## Narrow cause

The production controller used one constant MoveView speed for the whole
transition and accepted target crossing as completion.

Pinned LibCamera instead shapes MoveView speed continuously during the
transition.

## Runtime correction

`Camera/WorldCombat.lua` now:

- initializes transitions without one fixed MoveView rate;
- updates MoveView speed each animation frame with bounded ease-in/ease-out;
- uses current camera position for near-end and crossed-target correction;
- reverses toward a non-Taxi requested target after overshoot outside tolerance;
- retains the existing timeout fail-safe;
- preserves Taxi requested target `50`, 5-second duration, and engine-clamp
  success semantics;
- does not call SetCVar;
- adds no timers/polling, Taxi rotation, or Taxi UI fade.

Adds:
`tools/check_camera_transition_driver_contract.py`.

## Parallel P0118 preservation

P0118 is verified pushed at:
`6fad23f595a4abc9f5f2bd3fd6f12b825ef204e2`.

Its action keybind presentation changes and `0.0.48-dev` runtime are preserved.
P0119 changes no action-button/theme implementation.

## Runtime acceptance

After verified push and deploy:

1. use the Developer Panel GUI only;
2. take one normal Taxi flight;
3. during flight confirm context=taxi, owns=true, requested=50, duration=5;
4. after landing allow the destination transition to settle;
5. confirm City/World finishes near its requested target and not at `0`;
6. confirm failures=0, secret=false, error=nil;
7. export panel diagnostics.

## Deployment

Runtime code change. WoW redeploy required after verified push.
