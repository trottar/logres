# P0094 — Capture Current DynamicCam Profile

Date: 2026-10-02
Result: INSTALLED / PUSHED — G.1 PASS (`9db11d2b`)

## Baseline

P0093 verified pushed:
`de30c6f3dfd9855a9c96c25d1d48e3c628fe9748`.

## Result

G.1 captured the user's current DynamicCam SavedVariables and preserved the
exact stored `RPG` profile as canonical JSON.

P0094 was pushed at:
`9db11d2b61f49be48a4b488af1285b2e4439aca0`.

## Interpretation correction

P0094's human-readable evidence initially described `zoomType = in/out` as
zooming **by** the stored value.

G.2 source review proves that wording was wrong:
`in/out` are conditional absolute target modes.

The canonical JSON was correct and unchanged.

Correction evidence:
`../evidence/G2_DYNAMICCAM_ZOOM_SOURCE_AUDIT_2026-10-02.md`.

## Deployment

Docs/evidence only.

No WoW redeploy was required for P0094.
