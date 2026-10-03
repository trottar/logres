# Active Investigations

## G.5 — Taxi camera ownership

Status:
**SOURCE/PROFILE CONTRACT RESOLVED — TARGET-50 CAPABILITY PROBE NEXT**

Canonical:
`G5_TAXI_CAMERA_OWNERSHIP.md`

Source/profile audit:
`../evidence/G5_TAXI_CAMERA_SOURCE_AUDIT_2026-10-03.md`

Resolved:
- existing `state.onTaxi` is sufficient and already runtime-proven;
- Taxi priority `1000` wins over interaction/combat/City/World;
- conditional-out target is absolute zoom `50`;
- Taxi entry uses `5` seconds;
- ordinary Taxi exit fresh-evaluates the destination under restore `never`;
- Taxi rotation is source-separable and remains capability-gated;
- Taxi UI hide/fade remains presentation policy;
- current instance and DynamicCam fail-open boundaries remain intact.

Blocking question:
can the current Forever camera physically reach target `50` without mutating
`cameraDistanceMaxZoomFactor`?

Next action:
add a targeted Phase G developer-panel capability probe using the proven
MoveView path and read-only CVar observation.

Production Taxi ownership remains unauthorized until that capability result is
known.

## Closed Phase G investigations

G.1 DynamicCam profile capture:
**CLOSED — PASS.**

G.2 World/Combat camera zoom capability:
**CLOSED — RUNTIME + INTEGRATION PASS.**

G.3 production World/Combat camera ownership:
**CLOSED — RUNTIME + INTEGRATION PASS.**

G.4 City camera ownership:
**CLOSED — RUNTIME + INTEGRATION PASS on `0.0.43-dev`.**

## Other tracked non-blocking defects / deferred domains

- `D4_TARGETFRAME_REASSERTION_INTERMITTENT.md`
- `FUTURE_AURA_STATUS_PRESENTATION.md`
