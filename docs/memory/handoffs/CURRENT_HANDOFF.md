# Current Handoff

Authoritative state:
`../CURRENT.md`.

Latest verified durable checkpoint:
P0146 `9606379c1c8f600d26a5fe9659e448c14df76e7b`.

Current pushed/tested runtime:
`0.0.70-dev`.

## Active work stream

**P0147 — correct P0145/P0146 manual-waypoint depth calibration and acceptance before advancing to the class/pet/special-control audit.**

P0145 remains runtime-proven for ordinary same-map yard distance and clean waypoint removal. It is **not** runtime/visual-proven for distance-dependent marker-size variation because every accepted populated sample was inside the old 120-yard near threshold and therefore reported the same `depth=1.050` endpoint. The user also reported no visible size change during that inadequate test.

P0147 moves depth calibration to live local-awareness radius `R = C_Minimap.GetViewRadius()`:
- close `<=0.5R`;
- near `0.5R–1R`;
- medium `1R–4R`;
- far `4R–8R`, minimum beyond `8R`.

Scale anchors are `1.05 / 1.00 / 0.95 / 0.90`, with the existing final render clamp `0.90–1.12`.

Runtime validation must deliberately sample multiple bands and must include explicit user visual confirmation that the marker actually changes size. Diagnostics alone cannot close the checkpoint.

Quest/current-navigation, AreaPOI/service, tracking-result, and minimap-ownership boundaries remain unchanged. P0123 remains off-tape runtime authority.

The class/pet/special-control source audit moves from P0147 to P0148 and remains source-only when resumed.

Camera remains frozen; P0119 Taxi landing proof is still pending.

## Key references

- `../CURRENT.md`
- `../evidence/P0147_P0145_DEPTH_VALIDATION_CORRECTION_2026-10-05.md`
- `../patches/P0147_CORRECT_MANUAL_WAYPOINT_DEPTH_CALIBRATION.md`
- `../patches/P0146_RECORD_P0145_RUNTIME_RESULT.md`
- `../patches/P0145_MANUAL_WAYPOINT_DISTANCE_DEPTH.md`
- `../decisions/D-038_COMPASS_VISUAL_FOCUS_AND_DEPTH_CONTRACT.md`
- `../investigations/FUTURE_NAVIGATION_POI_TRACKING_CAPABILITY.md`
- `../investigations/FUTURE_CLASS_PET_SPECIAL_CONTROL_CAPABILITY.md`
- `../architecture/VISUAL_IMPLEMENTATION_STATUS.md`
- `../roadmap/PHASE_H_INTEGRATION_POLISH.md`
