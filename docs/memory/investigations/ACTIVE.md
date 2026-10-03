# Active Investigations

## G.5 — Camera-distance CVar ownership for Taxi target 50

Status:
**SOURCE/CONTRACT REVIEW ACTIVE — NO CVAR MUTATION AUTHORIZED**

Canonical:
`G5_CAMERA_DISTANCE_CVAR_OWNERSHIP.md`

Negative runtime evidence:
`../evidence/G5_P0109_TARGET50_NEGATIVE_2026-10-03.md`

Established by P0109 runtime:
- `cameraDistanceMaxZoomFactor = 1.2`;
- source-derived effective ceiling `18`;
- two independent target-50 attempts both stopped at `18`;
- target not reached;
- movement occurred;
- starting zoom restored;
- CVar remained unchanged;
- no secret-value result;
- DynamicCam was not loaded.

Therefore:
- target 50 is unavailable under the current no-CVar-mutation boundary;
- production Taxi remains fail-open;
- no lower target is accepted by inference.

Next action:
audit camera-distance CVar range, persistence, restoration, protection/combat
boundaries, and DynamicCam/LibCamera source behavior before deciding whether any
targeted mutation capability test is safe.

## G.5 Taxi contract status

`G5_TAXI_CAMERA_OWNERSHIP.md`

Resolved:
- existing `state.onTaxi` is sufficient and already runtime-proven;
- Taxi priority `1000` wins over interaction/combat/City/World;
- conditional-out intended target is absolute zoom `50`;
- Taxi entry uses `5` seconds;
- ordinary Taxi exit fresh-evaluates the destination under restore `never`;
- Taxi rotation remains separately gated;
- Taxi UI hide/fade remains presentation policy.

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
