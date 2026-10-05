# P0148 — Increase Manual-Waypoint Depth Visual Amplitude

Date: 2026-10-05
Baseline: `c274a9d13c677082cf4ce90b9fbbd0152e9989ec`
Candidate runtime: `0.0.72-dev`
Result: **PREPARED — VISUAL REVALIDATION REQUIRED**

## Purpose

Correct P0147's visually ineffective scale range without reopening the already-proven live-radius band/reference mechanics.

## Retained semantics

The live reference remains `R = C_Minimap.GetViewRadius()`.

Bands remain:
- close `<=0.5R`;
- near `0.5R–1R`;
- medium `1R–4R`;
- far `4R–8R`, minimum beyond `8R`.

## Visual amplitude correction

P0147 used `1.05 / 1.00 / 0.95 / 0.90`, which was mechanically correct but visually failed.

P0148 changes only the scale anchors:
- close `1.20`;
- near endpoint `1.05`;
- medium endpoint `0.85`;
- far endpoint `0.70`;
- final render clamp `0.70–1.28`.

On the 12x20 base marker this yields roughly `14.4x24` px close versus `8.4x14` px far before the small center-focus multiplier.

No alpha modulation, numeric distance text, identity label, bounce, glow, quest/POI/tracking marker, minimap mutation, or stock suppression is added.

## Runtime gate

Re-use ordinary manual waypoints and compare similar-bearing samples across close/near, medium, and far bands. Compass Check must remain coherent and integrated Run All must pass.

Acceptance additionally requires explicit user confirmation that the size difference is clearly visible and still aesthetically acceptable.

The class/pet/special-control source audit moves to P0149 until this visual checkpoint closes.
