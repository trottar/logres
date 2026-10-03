# Active Investigations

## G.5 — Taxi zoom parity

Status:
**DYNAMICCAM PARITY CORRECTED — P0117 PRODUCTION RUNTIME PROOF NEXT**

Canonical Taxi investigation:
`G5_TAXI_CAMERA_OWNERSHIP.md`

Parity correction:
`../evidence/G5_DYNAMICCAM_TAXI_PARITY_CORRECTION_2026-10-03.md`

Established:
- requested Taxi target remains `50`;
- current factor `1.2` physically caps at `18`;
- client default factor `1` caps at `15`;
- pinned DynamicCam/LibCamera does not require requested target 50 to be
  physically reachable;
- engine-clamped endpoint is normal source behavior rather than a situation
  failure;
- no max-distance mutation is needed for the narrow Taxi zoom slice.

P0117 runtime `0.0.47-dev` extends the existing production controller with Taxi
requested/effective diagnostic target semantics.

No Taxi rotation or UI fade is included.

## G.5 Taxi contract status

`G5_TAXI_CAMERA_OWNERSHIP.md`

P0117 production Taxi zoom is prepared; runtime proof is pending.

Taxi requested target remains 50. The engine's live physical clamp is valid
DynamicCam-parity behavior and is not rewritten as a hard-coded substitute.

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
