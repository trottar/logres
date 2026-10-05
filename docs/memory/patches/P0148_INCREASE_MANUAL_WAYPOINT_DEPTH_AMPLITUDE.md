# P0148 — Increase Manual-Waypoint Depth Visual Amplitude

Date: 2026-10-05
Baseline: `c274a9d13c677082cf4ce90b9fbbd0152e9989ec`
Durable commit: `6f381a77f857cb9305cf6870fc2621e6aff826dc`
Runtime: `0.0.72-dev`
Result: **INSTALLED / PUSHED — RUNTIME + VISUAL PASS; PRODUCTION BASELINE ACCEPTED**

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

## Runtime + visual result

`0.0.72-dev` samples include:
- far `1129.5` yd / ratio `8.47` / depth+render `0.700`;
- medium `482.6` yd / ratio `3.62` / depth+render `0.875`;
- close `35.7` yd / ratio `0.27` / depth `1.200` / render `1.238`;
- centered close `14.1` yd / ratio `0.11` / depth `1.200` / render `1.280`.

Integrated `Run All` passed.

The user confirmed that the stronger depth cue works. Further amplitude refinement
is deferred to later whole-interface polish and does not block sequencing.

The class/pet/special-control source audit advances as P0149.
