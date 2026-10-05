# P0147 Evidence — P0145/P0146 Depth Validation Correction

Date: 2026-10-05
Baseline runtime: `0.0.70-dev`
Classification: **P0145 DISTANCE PATH PASS; DISTANCE-DEPENDENT VISUAL DEPTH UNPROVEN / P0146 ACCEPTANCE OVERSTATED**

## Why this correction exists

P0145 was intended to make the manual-waypoint marker somewhat larger when near and
smaller when far. The runtime evidence recorded four populated samples at `45.5`,
`51.7`, `115.8`, and `116.0` yards. Every sample was at or below the original
hard-coded `120` yard near threshold, so every sample correctly reported the same
`depth=1.050` endpoint.

Those samples proved ordinary same-map distance arithmetic and the near endpoint.
They did **not** prove that depth scale changes as distance crosses the curve.

The user also reported that the waypoint appeared the same size throughout the
observed test. Because the validation never deliberately crossed the original near
threshold, that report is negative evidence against the adequacy of the validation
procedure, not yet proof that the scale code itself was defective.

## Validation-process failure

The prior acceptance procedure incorrectly treated "depth stayed within the allowed
bounds" as proof that the distance-dependent visual behavior worked. It also did
not ask the user to compare clearly separated near/mid/far waypoint states and did
not require explicit user visual confirmation of the changed feature.

Therefore P0146 overstated P0145 by recording the bounded depth treatment as fully
runtime accepted.

Correct classification of the `0.0.70-dev` evidence:
- same-map manual-waypoint yard distance: **PASS**;
- original near endpoint (`depth=1.050`): **PASS**;
- clear-state reset/no stale distance-marker state: **PASS**;
- distance-dependent change across multiple depth bands: **UNPROVEN**;
- user-visible distance-dependent size change: **UNPROVEN**.

P0123 remains the actual runtime authority for off-tape suppression.

## Calibration defect

The original `120` / `1200` yard thresholds were only an implementation calibration.
They were not grounded in a semantic local-awareness boundary. D-038 deliberately
left exact distance thresholds and curves for later calibration.

P0143 had already proven `C_Minimap.GetViewRadius()` as an ordinary yard-valued
runtime source (approximately `133.33` yards in the recorded state). That live
radius is a better product anchor for the meaning of local/near spatial awareness.

## Corrected depth policy

P0147 uses the live minimap view radius `R` as the depth reference:
- **close:** `distance <= 0.5R`;
- **near:** `0.5R < distance <= 1.0R`;
- **medium:** `1.0R < distance <= 4.0R`;
- **far:** `4.0R < distance <= 8.0R`;
- distances beyond `8.0R` remain at the far minimum.

Scale anchors remain restrained:
- close: `1.05`;
- near endpoint: `1.00`;
- medium endpoint: `0.95`;
- far endpoint: `0.90`;
- existing angular focus remains additive through multiplication and final render
  scale remains capped at `0.90–1.12`.

If live view radius is unavailable, secret, invalid, or fails, depth fails open to
`1.0` while the already-proven manual waypoint bearing remains usable.

## Required runtime proof

P0147 is not accepted from diagnostics alone. In-client validation must deliberately
sample multiple semantic bands and record both addon diagnostics and user visual
observation:
1. close (`<=0.5R`);
2. near (`0.5R–1R`);
3. medium (`>1R`, preferably around `2–4R`);
4. far (preferably `>=8R` to exercise the minimum endpoint);
5. cleared waypoint fallback.

Acceptance requires the reported radius/ratio/band/depth values to change
coherently **and** the user to confirm the marker visibly changes size across the
sampled bands without becoming distracting.

P0147 does not reopen quest/AreaPOI/tracking production roles or minimap ownership.
