# Active Investigations

## G.5 — Camera-distance CVar ownership for Taxi target 50

Status:
**READ-ONLY DEFAULT/METADATA RUNTIME PASS — PRODUCT/OWNERSHIP POLICY NEXT**

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

P0112 runtime evidence:
- runtime `0.0.45-dev`;
- source `C_CVar.GetCVarInfo`;
- current factor `1.2`, ceiling `18`;
- default factor `1`, ceiling `15`;
- required factor `3.3333333333333`;
- current/default support false/false;
- account-stored=true; character-stored=false;
- locked=false; secure=false; readOnly=false;
- DynamicCam not loaded;
- secret=false; error=nil.

Therefore DynamicCam's inherited/client default cannot satisfy target 50.

Next:
resolve whether Logres should ever temporarily own an above-default,
account-stored max-distance value and, if so, define exact restoration and
interruption semantics before any SetCVar probe.

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
