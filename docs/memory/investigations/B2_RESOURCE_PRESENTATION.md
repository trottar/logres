# B.2 — Resource Presentation

Status: IMPLEMENTATION PREPARED; RUNTIME PROOF NEXT
Opened: 2026-10-01

## Goal

Add a restrained player-resource percentage near the character/center HUD language without introducing a conventional resource bar.

## Source resolution

Forever 1.60.1 exposes:

```text
UnitPowerPercent(unitToken [, powerType [, unmodified [, curve]]])
```

The returned percentage can be secret when unit-power restrictions apply.

Native curves operate on normalized percentage input `[0, 1]`.

The documented `ScaleTo100` pattern is:

```text
0.0 -> 0
1.0 -> 100
```

`FontString:SetFormattedText` accepts secret arguments and applies the Text secret aspect.

Therefore the production path is:

```text
UnitPowerPercent("player", nil, false, scaleTo100Curve)
    -> FontString:SetFormattedText("%.0f%%", secretPercent)
```

No Lua arithmetic or conversion is required.

## Events

`UNIT_POWER_FREQUENT` is preferred over `UNIT_POWER_UPDATE` because it fires responsively while power regenerates/decays.

Also refresh on:
- `UNIT_MAXPOWER`;
- HUD enable;
- immersion re-enable.

## P0021 implementation

Adds to the existing HUD module:
- native 0–100 resource curve;
- `LogresHUDResourceText`;
- lower-center anchor;
- resource event frame;
- `UpdateResource`;
- structural hudcheck coverage.

No new module is created because resource presentation belongs to the existing HUD lifecycle/visibility boundary.

## Initial position/style

Anchor:

```text
CENTER of HUD root
x = 0
y = -118
```

Text:
- percentage only;
- restrained warm neutral;
- normal large WoW font;
- light shadow.

This is a first-pass layout coordinate and may move when cast confirmation/action constellation geometry becomes concrete.

## Runtime plan

After deploy:
1. confirm `0.0.9-dev`;
2. `/logres hudcheck` passes;
3. resource percentage appears with immersion on;
4. spend/gain primary resource and observe text updates;
5. immersion off hides it;
6. immersion on restores current value;
7. no secret-value/Lua error occurs.

No travel required.

## Coverage limits

The current test proves the current character's primary resource.

Druid/form or other primary-resource switching is not claimed unless exercised.

Secondary resources are out of scope for initial B.2.

## Exit

B.2 completes when the primary percentage is runtime proven and visually acceptable enough to continue.
