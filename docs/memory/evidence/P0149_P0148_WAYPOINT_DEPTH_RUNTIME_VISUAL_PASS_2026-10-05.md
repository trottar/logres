# P0149 Evidence — P0148 Manual-Waypoint Depth Runtime + Visual Pass

Date: 2026-10-05
Durable P0148 commit: `6f381a77f857cb9305cf6870fc2621e6aff826dc`
Runtime: `0.0.72-dev`
Classification: **RUNTIME + VISUAL PASS; PRODUCTION BASELINE ACCEPTED; FURTHER CALIBRATION DEFERRED TO LATER POLISH**

## Runtime evidence

P0148 retained the P0147 live minimap-radius bands and widened only the visual
scale amplitude.

Observed samples used live radius approximately `133.3` yards:
- far: `1129.5` yd, ratio `8.47`, depth/render scale `0.700`;
- medium: `482.6` yd, ratio `3.62`, depth/render scale `0.875`;
- medium: `198.2` yd, ratio `1.49`, depth `1.018`, render scale `1.028`;
- close: `35.7` yd, ratio `0.27`, depth `1.200`, render scale `1.238`;
- close/centered: `14.1` yd, ratio `0.11`, depth `1.200`, render scale `1.280`.

Integrated `Run All` on `0.0.72-dev` completed cleanly.

No navigation source/ownership expansion occurred.

## Visual result

The user confirmed that the stronger size cue works.

The accepted production baseline is therefore:
- close anchor `1.20`;
- near endpoint `1.05`;
- medium endpoint `0.85`;
- far endpoint `0.70`;
- final render clamp `0.70–1.28`;
- unchanged live-radius semantic boundaries `0.5R / 1R / 4R / 8R`.

The user also noted that the treatment could still be refined. That is accepted
as later whole-interface polish, not an open capability or blocking visual defect.

## Consequence

P0147 remains preserved as the mechanically-correct but visually-insufficient
calibration attempt.

P0148 is the current manual-waypoint depth production baseline.

Quest/current-navigation destination, AreaPOI/service, tracking-result positions,
and stock-minimap ownership remain unchanged.
