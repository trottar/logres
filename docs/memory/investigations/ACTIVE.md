# Active Investigations

## G.5 — Camera-distance CVar ownership for Taxi target 50

Status:
**SOURCE CONTRACT RESOLVED — READ-ONLY DEFAULT/METADATA RUNTIME EVIDENCE NEXT**

Canonical:
`G5_CAMERA_DISTANCE_CVAR_OWNERSHIP.md`

Source audit:
`../evidence/G5_CAMERA_DISTANCE_SOURCE_AUDIT_2026-10-03.md`

P0109 negative evidence:
`../evidence/G5_P0109_TARGET50_NEGATIVE_2026-10-03.md`

Established:
- current factor `1.2` physically capped zoom at `18`;
- target 50 requires factor at least `50 / 15`;
- DynamicCam's captured Taxi situation does not itself override max distance;
- DynamicCam's standard max-distance setting inherits the client default;
- the G.1 profile does not persist an explicit standard max-distance value;
- LibCamera does not own this CVar.

Missing fact:
the actual current Forever **default** and CVar metadata.

P0112 prepares read-only runtime `0.0.45-dev` with Phase G action:
`Camera Distance Info`.

No `SetCVar`, camera movement, polling, or production Taxi ownership is
authorized.

## G.5 Taxi contract status

`G5_TAXI_CAMERA_OWNERSHIP.md`

Production Taxi remains fail-open.

Taxi target remains 50 by captured intent; no clamped substitute is accepted.

Taxi rotation and UI hide/fade remain separately gated.

## Closed Phase G investigations

G.1 DynamicCam profile capture:
**CLOSED — PASS.**

G.2 World/Combat camera zoom capability:
**CLOSED — RUNTIME + INTEGRATION PASS.**

G.3 production World/Combat camera ownership:
**CLOSED — RUNTIME + INTEGRATION PASS.**

G.4 City camera ownership:
**CLOSED — RUNTIME + INTEGRATION PASS on `0.0.43-dev`.**

G.5 target-50 without CVar mutation:
**CLOSED — CLEAN NEGATIVE on `0.0.44-dev`.**

## Other tracked non-blocking defects / deferred domains

- `D4_TARGETFRAME_REASSERTION_INTERMITTENT.md`
- `FUTURE_AURA_STATUS_PRESENTATION.md`
- `FUTURE_NAVIGATION_POI_TRACKING_CAPABILITY.md` — future Phase H+ source/runtime
  audit for local radius POIs, tracking results, quest destination, and minimap
  replacement completeness.
