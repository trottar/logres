# P0147 — Correct Manual-Waypoint Depth Calibration and Acceptance

Date: 2026-10-05
Baseline: `9606379c1c8f600d26a5fe9659e448c14df76e7b`
Candidate runtime: `0.0.71-dev`
Result: **PREPARED — RUNTIME + VISUAL REVALIDATION REQUIRED**

## Purpose

Correct the P0145/P0146 acceptance overclaim and replace arbitrary absolute-yard
depth thresholds with a source-grounded local-awareness model.

## Correction

P0145 remains valid for:
- same-map manual-waypoint yard arithmetic;
- the old near endpoint;
- clear-state reset;
- preserved P0123 bearing/off-tape semantics.

It did not prove scale variation because all accepted populated samples were within
the old `120` yard near threshold. P0146's stronger depth-acceptance wording is
therefore superseded by P0147 evidence.

## Runtime change

`C_Minimap.GetViewRadius()` supplies live local-awareness radius `R`.

Depth bands:
- close: `<=0.5R` -> `1.05`;
- near: interpolate from `1.05` to `1.00` through `1.0R`;
- medium: interpolate from `1.00` to `0.95` through `4.0R`;
- far: interpolate from `0.95` to `0.90` through `8.0R`;
- beyond `8.0R`: `0.90`.

The existing angular focus scale and `0.90–1.12` final cap remain.

New addon-owned diagnostics expose:
- view-radius API/source availability;
- current view radius in yards;
- waypoint distance divided by view radius;
- semantic depth band;
- separate depth reason/error.

Depth-source failure is non-owning and fails open to depth `1.0`; it cannot remove
the proven bearing marker.

## Memory correction

This checkpoint updates authoritative memory to:
- mark P0145 distance arithmetic PASS but cross-band visual depth UNPROVEN;
- mark P0146's depth acceptance as overstated/superseded;
- preserve the user's negative observation that the marker appeared the same size
  during the inadequate original test;
- require explicit near/medium/far diagnostics plus user visual confirmation;
- postpone the class/pet/special-control source audit from P0147 to P0148.

## Runtime gate

After deployment and `/reload`, use ordinary map waypoints to deliberately sample:
- close `<=0.5R`;
- near `0.5R–1R`;
- medium `>1R` (preferably `2–4R`);
- far `>=8R` if conveniently placeable on the current map;
- clear state.

Each Compass Check must report coherent `radius`, `ratio`, `band`, `depth`, and
render scale. The user must also visually confirm that marker size changes across
the sampled bands. Diagnostics alone are insufficient for acceptance.

No quest/POI/tracking marker, exact distance text, label, minimap mutation, or stock
minimap suppression is added.
## Final runtime / visual result

P0147 is durable at `c274a9d13c677082cf4ce90b9fbbd0152e9989ec` on `0.0.71-dev`.

Runtime mechanics passed across real close/near/medium/far samples and integrated `Run All` passed. The user nevertheless reported the marker looked effectively the same size, with any shrink barely noticeable.

Classification: **RUNTIME / MECHANICAL PASS; VISUAL FAIL.**

The `1.05 -> 0.90` scale range is therefore rejected as final calibration. P0148 retains the proven live-radius band mechanics and increases only visual amplitude.
