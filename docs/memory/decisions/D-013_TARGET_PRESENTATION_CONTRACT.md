# D-013 — Target presentation contract

Status: ACCEPTED
Date: 2026-10-01

## Decision

Logres' default current-target presentation is:

```text
Target Name
Health %
```

It is a sparse center-HUD awareness element, not a conventional unit frame.

## Default disclosure

Show:
- current target name;
- current target health percentage.

Do not show by default:
- numeric level;
- elite/rare classification;
- portrait;
- health bar;
- explicit difficulty label.

D-003 remains authoritative.

Technical availability of level/classification does not change the disclosure policy.

## Target resource

Target resource percentage is not included in the first B.3 implementation.

It remains optional and may be added later only if it materially improves awareness without clutter.

## Name transport

`UnitName("target")` may become secret under unit-identity restrictions.

Production code forwards the returned value directly:

```text
UnitName("target")
    -> FontString:SetText
```

Lua must not:
- concatenate the target name;
- inspect/compare it;
- read the target-name FontString back for logic.

Target existence is determined separately with `UnitExists("target")`.

## Health transport

Use the existing native 0–100 curve:

```text
UnitHealthPercent("target", true, percentScaleCurve)
    -> FontString:SetFormattedText("%.0f%%", result)
```

No target-health arithmetic/comparison/stringification in Lua.

## Events

Refresh target presentation on:
- `PLAYER_TARGET_CHANGED`;
- target `UNIT_HEALTH`;
- target `UNIT_MAXHEALTH`;
- target `UNIT_NAME_UPDATE`.

## Visibility

No target:
- target block hidden.

Valid target:
- target block shown.

`immersionEnabled=false` hides the entire HUD root including target presentation.

Re-enabling immersion refreshes the current target.

## Rejected

- conventional target frame;
- portrait;
- target health bar;
- level text;
- elite/rare badge/text;
- classification-driven default styling;
- placing target state into the central observed-state contract.
