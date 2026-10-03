# G.5 — Taxi Camera Ownership

Status: **TARGET-50 NO-CVAR CAPABILITY CLOSED NEGATIVE — CAMERA-DISTANCE OWNERSHIP REVIEW ACTIVE**
Opened: 2026-10-03
Contract review resolved: 2026-10-03
Target-50 no-CVar runtime result: 2026-10-03

## Objective

Replace the current Taxi fail-open exclusion only after Logres can reproduce the
captured Taxi target safely without silently taking unproven camera-distance CVar,
rotation, or UI-presentation ownership.

## Canonical source/profile audit

`../evidence/G5_TAXI_CAMERA_SOURCE_AUDIT_2026-10-03.md`

Resolved facts:
- activation is existing `state.onTaxi`, sourced from `UnitOnTaxi("player")`;
- DynamicCam Taxi priority `1000` outranks interaction `110`, live combat `50`,
  City `1`, and World `0`;
- Taxi conditional-out intended target is absolute zoom `50`;
- ordinary Taxi entry uses `5` seconds;
- ordinary Taxi exit to World/City/Combat uses the destination situation's
  entering transition under restore `never`;
- no remembered pre-Taxi zoom restore is allowed;
- Taxi rotation is a separate continuous-yaw capability;
- Taxi UI hide/fade remains presentation policy;
- current instance fail-open remains outside the Taxi slice.

## P0109 target-50 capability result

Canonical runtime evidence:
`../evidence/G5_P0109_TARGET50_NEGATIVE_2026-10-03.md`

Runtime:
`0.0.44-dev`.

Two independent developer-panel probe runs recorded:
- `cameraDistanceMaxZoomFactor = 1.2`;
- effective ceiling `18`;
- intended target `50`;
- outbound movement reached exactly `18`;
- `targetReached=false`;
- `moved=true`;
- restoration to starting zoom succeeded;
- `cvarUnchanged=true`;
- `secret=false`;
- DynamicCam not loaded.

This is a **clean negative capability result** for target 50 under the accepted
no-CVar-mutation boundary.

The aggregate error text says `movement/target/restoration tolerance failed`, but
the explicit telemetry shows movement and restoration passed; only target reach
failed.

No additional target-50 no-CVar retries are required without new evidence.

## Current production behavior

Taxi remains fail-open/out-of-slice in the production controller.

Do not:
- replace target 50 with 18;
- infer another acceptable target;
- mutate `cameraDistanceMaxZoomFactor`;
- add Taxi rotation;
- add Taxi UI fade.

## Active sub-investigation

`G5_CAMERA_DISTANCE_CVAR_OWNERSHIP.md`

The next question is whether Logres can ever own a temporary camera-distance CVar
change safely enough to reproduce target 50.

That question must be source-resolved before another runtime patch.
