# P0117 — G.5 DynamicCam Taxi Parity + Production Zoom

Date: 2026-10-03
Result: **INSTALLED / PUSHED — RUNTIME PROOF PENDING** (`82bdb4f3`)
Baseline: `c64fcc97698e0dbe98a8d52469444f2ef15a76ec`
Commit: `82bdb4f33b8199c6794f486eff0067f99e22b4d0`
Runtime: `0.0.46-dev -> 0.0.47-dev`

## Purpose

Use pinned DynamicCam + LibCamera as the reference implementation and stop
treating Taxi target `50` as a guarantee of physical reachability.

Implement the smallest production Taxi zoom slice on top of the durable P0116
action-visual checkpoint.

## Source correction

Canonical:
`../evidence/G5_DYNAMICCAM_TAXI_PARITY_CORRECTION_2026-10-03.md`.

DynamicCam requests target `50` and lets the engine enforce the currently
available physical camera-distance ceiling. It does not first raise max-distance
and does not make literal target reachability a situation-success requirement.

P0109/P0112 measurements remain valid. Only their former blocking architectural
interpretation is superseded.

## Runtime change

Extends existing `CameraWorldCombat` production controller:

- Taxi selected from existing `state.onTaxi`;
- instance remains outer fail-open boundary;
- Taxi outranks interaction, combat, City, World;
- requested target `50`;
- live diagnostic effective target =
  `min(50, cameraDistanceMaxZoomFactor * 15)`;
- Taxi transition duration `5` seconds;
- motion is driven toward requested target 50 for the source transition;
- an engine/geometry-limited Taxi endpoint is not counted as controller failure;
- ordinary Taxi exit reevaluates destination context through the existing
  restore-never controller behavior;
- DynamicCam-loaded coexistence block remains;
- no SetCVar;
- no Taxi rotation;
- no Taxi UI fade;
- no polling.

Diagnostics expose requested/effective target, transition duration, live
max-distance factor, and live physical ceiling.

## Static contracts

Adds:
`tools/check_camera_taxi_production_contract.py`.

Updates:
- historical Taxi target-probe checker to accept production Taxi ownership while
  retaining probe coexistence;
- historical City checker to forbid CVar mutation rather than forbidding the
  read-only max-distance CVar name.

## Parallel visual checkpoint

P0116 is verified pushed at:
`c64fcc97698e0dbe98a8d52469444f2ef15a76ec`.

Its action visual runtime remains in-client visual-proof pending. P0117 does not
change the approved visual assets or D-040 contract.

## Delivery correction

The provisional camera-P0115 R1 duplicate-anchor failure and the two subsequent
parallel patch-number collisions are recorded in the canonical source evidence.

P0117 adds the reusable scoped-anchor rule to AGENTS/LEARNINGS and keeps
transform construction before tracked writes.

## Runtime acceptance

After verified push and deploy:

1. use the Developer Panel GUI;
2. take one normal Taxi flight when convenient;
3. during the flight click Phase G -> `Camera World/Combat Check`;
4. expect context `taxi`, owns=true, requested=50, duration=5, failures=0,
   secret=false, error=nil;
5. `effective` should reflect the current live physical ceiling when readable;
6. after landing click the same check and confirm destination context reconciles
   normally;
7. export panel diagnostics.

A normal Taxi flight is the essential environmental proof for automatic
`state.onTaxi` ownership. No extra contrived travel is required.

## Deployment

Runtime code changes.

WoW redeploy required after verified push.
