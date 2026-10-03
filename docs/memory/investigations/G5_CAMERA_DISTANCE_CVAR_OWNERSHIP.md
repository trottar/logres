# G.5 — Camera-Distance CVar Ownership

Status: **DEFERRED — VALID EVIDENCE, NO LONGER BLOCKS TAXI ZOOM PARITY**
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

## P0112 runtime result

Canonical evidence:
`../evidence/G5_P0112_CAMERA_DISTANCE_INFO_2026-10-03.md`.

Runtime `0.0.45-dev` measured:
- current factor `1.2`;
- default factor `1`;
- current/default ceilings `18` / `15`;
- required target-50 factor `3.3333333333333`;
- current/default support false / false;
- account-stored=true;
- character-stored=false;
- locked=false;
- secure=false;
- readOnly=false;
- secret=false;
- error=nil.

The inherited client default cannot satisfy target 50.

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

## Superseding parity result

Canonical:
`../evidence/G5_DYNAMICCAM_TAXI_PARITY_CORRECTION_2026-10-03.md`.

Pinned DynamicCam/LibCamera proves that physical reachability of requested target
50 is not required for the Taxi situation action. The engine may clamp to the
current max-distance ceiling.

Therefore above-default CVar ownership is **not a G.5 Taxi zoom prerequisite**.

This investigation remains useful later if Logres migrates DynamicCam's broader
standard CVar policy. P0112's account-storage/default/current evidence remains
authoritative for that future work.

No SetCVar is authorized by this deferral.
