# G.5 — Camera-Distance CVar Ownership

Status: **READ-ONLY RUNTIME EVIDENCE RESOLVED — PRODUCT/OWNERSHIP POLICY NEXT**
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

## Next product/ownership question

The previous default gate resolved on the negative branch.

Before any mutation experiment, decide whether Logres may temporarily raise this
account-stored setting above both current `1.2` and default `1`.

If accepted, the contract must define:
- exact target factor `50 / 15`;
- restoration to the captured current value, not the client default;
- concurrent user/other-addon changes;
- reload/logout/disable/error/crash interruption;
- combat/protected behavior;
- fail-open restoration.

If not accepted, target 50 remains intentionally unavailable and a separate
product decision must resolve the Taxi experience.

No target clamp follows automatically from either result.
