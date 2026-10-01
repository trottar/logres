# P0019 — B.1 vignette visibility correction

Date: 2026-09-30
Result: PREPARED — runtime proof pending

## Trigger

P0018 runtime observation:
the intended vignette was not perceptible during ordinary injury.

A red pulse was only noticed at very low health and may be Blizzard's own effect.

## Diagnosis

The 0–1 curve x range was correct.

P0018's alpha/color tuning was too conservative to count as usable presentation.

Examples:
- outer alpha at 50% = 0.08;
- red alpha at 50% = 0;
- red alpha at 30% = 0.08.

## Changes

- strengthen native curve alpha outputs;
- strengthen the injury-red source color;
- retain 70/50/30/15-ish threshold structure;
- add `/logres hudpreview on|off`;
- bump version to `0.0.8-dev`.

## Preview

Preview:
- uses fixed ordinary alpha values;
- does not inspect health;
- proves geometry/root visibility at full health;
- lets the user distinguish Logres from Blizzard low-health effects.

## Production boundary

Unchanged:

```text
UnitHealthPercent("player", true, curve)
-> Texture:SetAlpha(secret)
```

## Runtime proof

After deployment:
1. full health preview on — Logres edges clearly visible;
2. preview off — edges disappear at full health;
3. ordinary safe damage — health-driven edge pressure becomes visible;
4. immersion off/on — hide/restore;
5. heal — effect recedes.

No near-death test required.
