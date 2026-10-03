# G.5 — Taxi Camera Ownership

Status: **P0117 TAXI ENTRY PASS / LANDING TRANSITION FAIL — P0119 RETEST NEXT**
Opened: 2026-10-03
Contract review resolved: 2026-10-03
Target-50 no-CVar runtime result: 2026-10-03

## Objective

Replace the current Taxi fail-open exclusion only after Logres can reproduce the
captured Taxi behavior without silently taking unproven camera-distance CVar,
rotation, or UI-presentation ownership.

## Resolved Taxi contract

- activation is existing `state.onTaxi`, sourced from `UnitOnTaxi("player")`;
- Taxi priority `1000` outranks interaction `110`, live combat `50`, City `1`,
  and World `0`;
- intended Taxi conditional-out target is absolute zoom `50`;
- ordinary Taxi entry uses `5` seconds;
- ordinary Taxi exit uses destination entering transition under restore `never`;
- Taxi rotation is separately gated;
- Taxi UI hide/fade remains presentation policy;
- instance and DynamicCam fail-open boundaries remain intact.

## P0109 capability result

Target 50 with current factor 1.2:
**CLEAN NEGATIVE**.

Canonical evidence:
`../evidence/G5_P0109_TARGET50_NEGATIVE_2026-10-03.md`.

## DynamicCam parity correction

Canonical:
`../evidence/G5_DYNAMICCAM_TAXI_PARITY_CORRECTION_2026-10-03.md`.

The previous blocking interpretation was too strict.

Pinned DynamicCam passes Taxi target `50` to LibCamera without proving that
`cameraDistanceMaxZoomFactor` can physically reach 50. LibCamera drives toward
the requested value and the engine may clamp visible distance.

Therefore P0109/P0112 remain valid measurements, but physical reachability of 50
is not a prerequisite for reproducing the user's DynamicCam Taxi action.

P0117 production contract:
- requested target `50`;
- live diagnostic effective endpoint =
  `min(50, cameraDistanceMaxZoomFactor * 15)`;
- entry `5` seconds;
- no SetCVar;
- rotation/UI fade still separate.

## Current production behavior

P0117 moves Taxi zoom into the existing production camera controller while
preserving instance/DynamicCam fail-open boundaries.

Do not:
- rewrite requested target `50` to a hard-coded `18` or `15`;
- mutate max-distance;
- add Taxi rotation;
- add Taxi UI fade.

## Next

P0117 automatic Taxi ownership passed, but landing destination convergence
failed: City `18 -> 5` ended at zoom `0`. P0119 corrects the shared transition
driver; repeat one normal Taxi flight on `0.0.49-dev`.

## P0117 runtime failure

Canonical:
`../evidence/G5_P0117_TAXI_LANDING_OVERSHOOT_2026-10-03.md`.

Taxi entry passed, but the post-Taxi City transition `18 -> 5` finished at zoom
`0` / first person. Earlier `0.0.43-dev` diagnostics contain the same failure.

P0119 corrects the shared transition driver with frame-shaped velocity and
crossed-target correction. Taxi target/priority/no-SetCVar boundaries remain
unchanged.
