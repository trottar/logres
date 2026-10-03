# G.5 — Taxi Camera Ownership

Status: **TARGET-50 CAPABILITY PROBE IMPLEMENTED — RUNTIME PROOF PENDING**
Opened: 2026-10-03
Contract review resolved: 2026-10-03

## Objective

Replace the current Taxi fail-open exclusion only after Logres proves the
captured Taxi target can be reached safely without silently taking camera-distance
CVar, rotation, or UI-presentation ownership.

## Canonical source/profile audit

`../evidence/G5_TAXI_CAMERA_SOURCE_AUDIT_2026-10-03.md`

Resolved facts:
- activation is existing `state.onTaxi`, sourced from `UnitOnTaxi("player")`;
- DynamicCam Taxi priority `1000` outranks interaction `110`, live combat `50`,
  City `1`, and World `0`;
- Taxi conditional-out target is absolute zoom `50`;
- ordinary Taxi entry uses `5` seconds;
- ordinary Taxi exit to World/City/Combat uses the destination situation's
  entering transition under restore `never`;
- no remembered pre-Taxi zoom restore is allowed;
- Taxi rotation is a separate continuous-yaw capability and is not part of the
  first zoom slice;
- Taxi UI hide/fade remains presentation policy;
- current instance fail-open remains outside the Taxi slice;
- existing DynamicCam/probe coexistence and fail-open rules remain unchanged.

## P0109 target-50 capability probe

P0109 prepares runtime `0.0.44-dev`.

It extends the existing manual `CameraCapabilityProbe` rather than creating a
second camera mover, preserving the production controller's existing
`CameraCapabilityProbe.running` mutual-exclusion gate.

Developer-panel action:
`Taxi Target 50 Probe` in Phase G.

The probe:
- requires the production camera controller to be OFF;
- refuses while DynamicCam is loaded or load status is unknown;
- reads `cameraDistanceMaxZoomFactor` through `GetCVar`;
- checks secret status before numeric conversion;
- records the source-derived effective ceiling as `factor * 15`;
- attempts absolute target 50 over a 5-second MoveView leg;
- stops on target/crossing or timeout;
- returns to the captured starting zoom over the same MoveView path;
- re-reads the distance factor and requires it to remain unchanged;
- records targetReached, moved, restored, CVar state, secret state, and error;
- never calls `SetCVar`, `CameraZoomIn`, or `CameraZoomOut`;
- adds no event hook, state subscription, timer, or polling loop.

If the camera begins already within target tolerance, the probe blocks and asks
for a closer starting camera position rather than manufacturing movement.

## Current production behavior

Taxi remains fail-open/out-of-slice in the production controller.

P0109 does not alter:
- Taxi production ownership;
- context precedence in production;
- rotation;
- UI fade;
- camera-distance CVar ownership.

## Runtime acceptance

After verified push/deployment:
1. disable DynamicCam for the isolated proof;
2. Phase G -> `Camera World/Combat OFF`;
3. manually place camera clearly below target 50;
4. Phase G -> `Taxi Target 50 Probe`;
5. wait for outbound and restore legs to finish;
6. Phase G -> `Taxi Target 50 Probe` again to persist the result;
7. Phase G -> `Camera World/Combat ON`;
8. flush/export diagnostics.

A PASS authorizes a later zoom-only Taxi production implementation.

A target-reach FAIL is a valid capability finding. If restoration/CVar/secret/error
state is otherwise clean, record target 50 as unavailable under the accepted
no-CVar-mutation boundary and investigate camera-distance ownership separately.

Do not silently substitute another Taxi target.
