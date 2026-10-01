# P0023 — B.3 target presentation

Date: 2026-10-01
Result: PREPARED — runtime proof pending

## Intent

Add Logres' minimal current-target awareness without recreating a conventional target frame.

## Presentation

```text
Target Name
Health %
```

## Identity path

```text
UnitName("target")
    -> FontString:SetText
```

Target names may be secret under identity restrictions.

No Lua inspection/concatenation/readback.

## Health path

```text
UnitHealthPercent("target", true, percentScaleCurve)
    -> FontString:SetFormattedText("%.0f%%", result)
```

No target-health arithmetic/comparison/stringification.

## Events

- PLAYER_TARGET_CHANGED
- target UNIT_HEALTH
- target UNIT_MAXHEALTH
- target UNIT_NAME_UPDATE

## Disclosure enforcement

No:
- UnitLevel;
- UnitClassification;
- portrait;
- target health bar.

Static HUD checks enforce these obvious regressions.

## Scope

Target resource percentage is deliberately deferred.

## Version

`0.0.9-dev -> 0.0.10-dev`

## Runtime proof

After deploy:
- hudcheck PASS;
- no target -> absent;
- acquire -> name + health %;
- damage -> health updates;
- switch/clear -> updates/hides;
- immersion off/on -> hide/restore;
- ordinary combat -> no secret/Lua errors;
- elite target, if naturally available -> no level/classification shown.
