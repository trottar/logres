# P0148 Evidence — P0147 Manual-Waypoint Depth Visual Failure

Date: 2026-10-05
Durable P0147 commit: `c274a9d13c677082cf4ce90b9fbbd0152e9989ec`
Runtime: `0.0.71-dev`
Classification: **RUNTIME / MECHANICAL PASS; VISUAL FAIL**

## Observed runtime

The live-radius depth implementation functioned across real manual-waypoint samples.
Observed `C_Minimap.GetViewRadius()` was approximately `133.3` yards.

Representative samples:
- close: `6.2` yd / ratio `0.05` / depth `1.050`;
- near: `96.6` yd / ratio `0.72` / depth `1.028`;
- medium: `185.1` yd / ratio `1.39` / depth `0.994`;
- medium: `364.2` yd / ratio `2.73` / depth `0.971`;
- far: `686.3` yd / ratio `5.15` / depth `0.936`;
- far: `1055.0` yd / ratio `7.91` / depth `0.901`;
- far minimum: `1606.0` yd / ratio `12.04` / depth `0.900`.

The same runtime also exercised a map-mismatch fail-open sample and integrated `Run All` completed cleanly.

## Visual result

The user reported that the waypoint looked the same size throughout; if it became smaller, the change was barely noticeable.

This is a real visual failure, not an evidence deferral.

The existing base marker is only `12x20` px. The P0147 endpoints therefore produced roughly:
- close `1.05`: `12.6x21` px;
- far `0.90`: `10.8x18` px.

A difference of about `1.8` px width and `3` px height is too subtle at normal play scale to reliably communicate distance.

## Consequence

P0147 is retained as proof of:
- live minimap-radius source use;
- semantic band classification;
- normalized distance/radius diagnostics;
- depth interpolation mechanics;
- fail-open behavior.

P0147 is rejected as final visual calibration.

P0148 retains the same semantic bands and increases only the visual amplitude. No navigation source/ownership expansion is authorized.
