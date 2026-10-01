# D-015 — Ally and pet presentation contract

Status: ACCEPTED
Date: 2026-10-01

## Decision

Logres' default ally/pet presentation is a compact text row:

```text
Name                            Health %
```

Initial unit scope:
- player `pet`;
- `party1`;
- `party2`;
- `party3`;
- `party4`.

## Default disclosure

Show:
- unit name;
- health percentage.

Do not show by default:
- portrait;
- conventional health bar;
- level;
- role icon;
- class icon;
- detailed combat metadata;
- raid-frame-style status grid.

## Secret-safe transport

Identity:

```text
UnitName(unit)
    -> FontString:SetText
```

Health:

```text
UnitHealthPercent(unit, true, percentScaleCurve)
    -> FontString:SetFormattedText("%.0f%%", result)
```

Lua must not:
- inspect/concatenate a secret unit name;
- compare or perform arithmetic on health percentage;
- read the text back for control flow;
- persist ally/pet name or health.

## Structural visibility

`UnitExists(unit)` controls whether an individual row is shown.

This is separate from secret presentation content.

## Update model

Per-unit text/health refresh:
- `UNIT_HEALTH`;
- `UNIT_MAXHEALTH`;
- `UNIT_NAME_UPDATE`.

Structural refresh:
- `GROUP_ROSTER_UPDATE`;
- `UNIT_PET` for the player's pet.

Initial enable and immersion re-enable also refresh all rows.

## Layout

P0027 uses a small vertical stack left of the center HUD:

```text
x = -330
y = -44
```

Five possible rows are reserved, but only existing units are shown.

The placement is provisional and must remain subordinate to future Phase C action-cluster geometry.

## Scope exclusions

Initial B.5 does not implement:
- raid units;
- party pets;
- healer-specific conventional frames;
- click-casting;
- secure unit buttons.

Those require separate product/secure-action decisions if later needed.
