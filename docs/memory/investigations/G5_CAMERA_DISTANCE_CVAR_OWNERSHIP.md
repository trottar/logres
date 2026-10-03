# G.5 — Camera-Distance CVar Ownership

Status: **SOURCE CONTRACT RESOLVED — READ-ONLY DEFAULT/METADATA PROBE NEXT**
Opened: 2026-10-03
Parent: `G5_TAXI_CAMERA_OWNERSHIP.md`

## Trigger

P0109 runtime evidence proved target 50 is not reachable with the current factor
1.2 / effective ceiling 18.

Canonical negative evidence:
`../evidence/G5_P0109_TARGET50_NEGATIVE_2026-10-03.md`.

## Canonical source audit

`../evidence/G5_CAMERA_DISTANCE_SOURCE_AUDIT_2026-10-03.md`.

Resolved:
- DynamicCam presents non-mainline max distance up to 50;
- displayed distance maps to factor × 15;
- target 50 therefore requires factor >= `50 / 15`;
- DynamicCam standard max-distance comes from `GetCVarDefault`;
- G.1 stores no explicit standard max-distance factor;
- Taxi stores no situation-specific max-distance override;
- Taxi zoom does not automatically raise the max-distance CVar;
- pinned LibCamera does not mutate `cameraDistanceMaxZoomFactor`.

## Narrow unresolved fact

P0109 measured current factor `1.2`, but not the inherited client default.

Before any mutation experiment, record:
- current factor;
- default factor;
- current/default ceilings;
- storage scope;
- locked/secure/read-only flags.

Prefer `C_CVar.GetCVarInfo`, which current Forever API documentation exposes for
1.60.1.

## P0112 diagnostic

Phase G developer-panel action:
`Camera Distance Info`.

Properties:
- read-only;
- no camera motion;
- no controller disable required;
- no Taxi ride required;
- no DynamicCam disable required;
- no SetCVar;
- no timer/event/subscription/polling;
- secret-safe before numeric conversion or formatting.

## Decision after evidence

If default >= `50 / 15`:
open the smallest temporary ownership/restoration capability design.

If default < `50 / 15`:
record that DynamicCam's inherited standard cannot itself satisfy target 50 and
resolve product policy before inventing a higher camera-distance setting.

No target clamp follows automatically from either result.
