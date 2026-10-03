# Active Investigations

## G.5 — Taxi camera ownership

Status:
**TARGET-50 CAPABILITY PROBE IMPLEMENTED — RUNTIME PROOF PENDING**

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

P0109 implements the narrow capability gate on runtime `0.0.44-dev`:
- Phase G `Taxi Target 50 Probe`;
- reads but never mutates `cameraDistanceMaxZoomFactor`;
- records `factor * 15` effective ceiling;
- attempts target 50 with the proven MoveView path;
- restores captured starting zoom;
- checks CVar unchanged;
- records target/movement/restoration/secret/error state;
- production Taxi remains fail-open.

Next action:
collect the developer-panel runtime result.

PASS -> prepare zoom-only production Taxi ownership.

FAIL because target 50 cannot be reached -> preserve the negative finding and
open a separate camera-distance ownership decision. Do not clamp the target.

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
