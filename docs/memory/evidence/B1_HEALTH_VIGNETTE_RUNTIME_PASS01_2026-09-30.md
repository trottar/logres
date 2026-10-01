# B.1 Health Vignette Runtime Pass 01 — 2026-09-30

Status: VISUAL FAILURE / TRANSPORT NOT YET INVALIDATED
Baseline: `fa342adaf21230d1ad56a83e627084b386a60527`

## User observation

The user reported:

> There was no vignette until I got to low enough life that the red pulsed.

## Classification

B.1 does **not** pass on P0018.

The intended design requires a faint dark vignette beginning around 70–50% health and increasing progressively.

The user did not perceive that progression during ordinary injury.

## Important ambiguity

The low-health red pulse may be Blizzard's own low-health presentation rather than Logres.

Therefore this observation does not prove that the P0018 Logres texture alpha path became visible at low health.

Do not claim production health-vignette transport is visually proven yet.

## API / curve-range check

Current curve documentation confirms percentage curve input is normalized to `[0, 1]`.

Examples:
- `ZeroToOne`: 0 -> 0, 1 -> 1;
- `Reverse`: 0 -> 1, 1 -> 0;
- `ScaleTo100`: 0 -> 0, 1 -> 100.

Therefore P0018's x coordinates such as `0.70`, `0.50`, and `0.30` were on the correct input scale.

The failure is **not** attributed to 0–1 versus 0–100 curve scaling.

## Likely cause

P0018's first-pass visual values were too conservative.

Examples:
- outer dark alpha at 50%: only `0.08`;
- injury red alpha at 50%: `0.00`;
- injury red alpha at 30%: only `0.08`;
- source colors were themselves very dark.

This can make the intended signal effectively invisible against normal gameplay.

## Next test strategy

P0019:
- raises the native curve output strength while preserving the same thresholds;
- strengthens the red source color;
- adds `/logres hudpreview on|off`.

Preview uses ordinary fixed alpha values and does not inspect health.

It allows the user to verify Logres geometry at full health and distinguish it from Blizzard's low-health effect.

## Reopen conditions

If preview is visible but health-driven presentation remains absent after P0019:
- investigate event/curve/secret application rather than continuing visual tuning.

If preview itself is invisible:
- investigate frame strata/draw layer/root visibility.

If health-driven presentation becomes visible:
- classify P0018 as a tuning failure and continue B.1 visual refinement.
