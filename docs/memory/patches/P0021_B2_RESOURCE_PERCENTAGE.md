# P0021 — B.2 resource percentage

Date: 2026-10-01
Result: PREPARED — runtime proof pending

## Intent

Add Logres' default player primary-resource percentage without a conventional bar.

## Source-resolved path

```text
UnitPowerPercent("player", nil, false, nativeScaleTo100Curve)
    -> FontString:SetFormattedText("%.0f%%", secretPercent)
```

## Runtime code

Updates:
`Logres/HUD/HUD.lua`

Adds:
- `createScaleTo100Curve`;
- `LogresHUDResourceText`;
- `UpdateResource`;
- UNIT_POWER_FREQUENT;
- UNIT_MAXPOWER;
- immersion refresh;
- hudcheck structural fields.

## Secret boundary

Forbidden:
- UnitPower/UnitPowerMax arithmetic;
- percent arithmetic;
- percent comparisons;
- tostring/string.format over percent;
- reading secret fontstring text for logic;
- persistence.

## Version

`0.0.8-dev -> 0.0.9-dev`

## Runtime proof

After deploy:
- version 0.0.9-dev;
- hudcheck PASS;
- percentage visible;
- percentage changes as primary resource changes;
- immersion off/on hides/restores;
- no Lua/secret errors.

Current character primary-resource behavior is the required proof.

Class/form switching is not claimed unless exercised.
