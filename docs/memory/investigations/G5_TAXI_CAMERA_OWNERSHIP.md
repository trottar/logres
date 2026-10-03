# G.5 — Taxi Camera Ownership

Status: **SOURCE/PROFILE CONTRACT RESOLVED — TARGET-50 CAPABILITY PROBE NEXT; NO PRODUCTION TAXI OWNERSHIP YET**
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
- ordinary Taxi exit to World/City/Combat uses the **destination** situation's
  entering transition under restore `never`;
- no remembered pre-Taxi zoom restore is allowed;
- Taxi rotation is a separate continuous-yaw capability and is not part of the
  first zoom slice;
- Taxi UI hide/fade remains presentation policy;
- current instance fail-open remains outside the Taxi slice;
- existing DynamicCam/probe coexistence and fail-open rules remain unchanged.

## Target-50 gate

DynamicCam permits target `50` on non-mainline clients, but current source also
ties effective camera distance to `cameraDistanceMaxZoomFactor`.

The captured profile does not preserve an explicit effective runtime value for
that standard CVar, and Logres has not accepted CVar mutation.

Production Taxi ownership therefore remains blocked until a targeted developer-
panel probe proves target `50` through the existing `MoveView*` path while only
**reading** the camera-distance CVar.

The probe must:
- refuse while DynamicCam is loaded;
- report `cameraDistanceMaxZoomFactor` and its source-derived `*15` ceiling;
- attempt target `50`;
- restore starting zoom;
- record target reached / secret / error state;
- never mutate a CVar.

If target `50` cannot be reached, record the negative result and open a separate
camera-distance ownership decision. Do not clamp or substitute another target.

## Current production behavior

Taxi remains fail-open/out-of-slice in the production controller until the
capability gate passes and a later production patch deliberately changes that
branch.

## Next action

Prepare the narrow target-50 developer-panel capability probe.

No real Taxi ride is needed for that capability check.

No production Taxi zoom, rotation, UI fade, or CVar mutation is authorized by
this source-review checkpoint.
