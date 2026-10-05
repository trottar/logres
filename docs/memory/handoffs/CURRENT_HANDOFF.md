# Current Handoff

Authoritative state:
`../CURRENT.md`.

Latest verified durable checkpoint:
P0147 `c274a9d13c677082cf4ce90b9fbbd0152e9989ec`.

Current pushed/tested runtime:
`0.0.71-dev`.

## Active work stream

**P0148 — correct the P0147 manual-waypoint depth visual-amplitude failure before advancing to class/pet/special-control work.**

P0147 mechanically proves live `C_Minimap.GetViewRadius()` depth reference and close/near/medium/far band classification. Runtime samples reached `depth=1.050` close and `depth=0.900` far, with integrated checks passing.

Visual review failed: the user reported the marker looked effectively the same size, with any shrink barely noticeable. On the 12x20 base glyph, the prior `1.05 -> 0.90` range changed nominal geometry by only about 1.8 px width / 3 px height.

P0148 retains the same semantic bands but increases scale anchors to `1.20 / 1.05 / 0.85 / 0.70`, with final render clamp `0.70–1.28`. Runtime candidate is `0.0.72-dev`.

P0148 requires explicit close/medium/far visual confirmation. Diagnostics alone cannot close it.

Quest/current-navigation, AreaPOI/service, tracking-result, and minimap-ownership boundaries remain unchanged. P0123 remains off-tape runtime authority.

The class/pet/special-control source audit moves to P0149 and remains source-only when resumed.

Camera remains frozen; P0119 Taxi landing proof is still pending.

## Key references

- `../CURRENT.md`
- `../evidence/P0148_P0147_WAYPOINT_DEPTH_VISUAL_FAIL_2026-10-05.md`
- `../patches/P0148_INCREASE_MANUAL_WAYPOINT_DEPTH_AMPLITUDE.md`
- `../patches/P0147_CORRECT_MANUAL_WAYPOINT_DEPTH_CALIBRATION.md`
- `../decisions/D-038_COMPASS_VISUAL_FOCUS_AND_DEPTH_CONTRACT.md`
- `../investigations/FUTURE_NAVIGATION_POI_TRACKING_CAPABILITY.md`
- `../investigations/FUTURE_CLASS_PET_SPECIAL_CONTROL_CAPABILITY.md`
- `../architecture/VISUAL_IMPLEMENTATION_STATUS.md`
- `../roadmap/PHASE_H_INTEGRATION_POLISH.md`
