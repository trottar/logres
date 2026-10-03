# Active Investigations

## G.4 — City camera ownership

Status:
**ACTIVE — CONTRACT REVIEW; NO RUNTIME CODE YET**

Canonical:
`G4_CITY_CAMERA_OWNERSHIP.md`

Starting evidence:
- G.1 captured City as an enabled DynamicCam situation activated by resting;
- City stores an enter transition of `2.5` seconds;
- City uses conditional zoom-in target `5`;
- City also stores DynamicCam UI-hide/fade behavior, which is not automatically a
  Logres camera responsibility;
- G.3 already proves live World (Combat) must take priority over ordinary World
  and resting/City context selection.

Next question:
define exact City camera ownership/precedence/exit semantics and explicitly
separate camera behavior from UI-hide presentation policy before implementation.

## Closed Phase G investigations

G.1 DynamicCam profile capture:
**CLOSED — PASS.**

G.2 World/Combat camera zoom capability:
**CLOSED — RUNTIME + INTEGRATION PASS.**

G.3 production World/Combat camera ownership:
**CLOSED — RUNTIME + INTEGRATION PASS on `0.0.42-dev`.**

Canonical G.3 evidence:
`../evidence/G3_P0102_RUNTIME_PASS_2026-10-03.md`

## Other tracked non-blocking defects / deferred domains

- `D4_TARGETFRAME_REASSERTION_INTERMITTENT.md`
- `FUTURE_AURA_STATUS_PRESENTATION.md`
