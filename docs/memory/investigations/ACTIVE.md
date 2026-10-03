# Active Investigations

## G.4 — City camera ownership

Status:
**IMPLEMENTATION PUSHED — RUNTIME PROOF PENDING**

Canonical:
`G4_CITY_CAMERA_OWNERSHIP.md`

Source/profile audit:
`../evidence/G4_CITY_CAMERA_SOURCE_AUDIT_2026-10-03.md`

Resolved contract:
- existing resting sensor selects City after higher proven exclusions;
- live combat precedes City;
- City conditional-in target is 5;
- ordinary City entry is 2.5 seconds;
- destination context is freshly evaluated on exit; restore remains `never`;
- proven G.3 movement/coexistence/fail-open behavior is reused.

Deferred deliberately:
- City UI hide/fade presentation;
- City `cameraDistanceMaxZoomFactor` override / broader CVar ownership;
- reactive-zoom implementation;
- startup first-situation instant transition parity;
- later DynamicCam situations.

P0105 is verified pushed at `69560080`, runtime `0.0.43-dev`.

Next action:
deploy P0105 and collect targeted City runtime proof.

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
