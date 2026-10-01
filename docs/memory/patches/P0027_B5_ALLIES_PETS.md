# P0027 — B.5 allies and pets

Date: 2026-10-01
Result: PREPARED — runtime proof pending

## Intent

Add sparse pet/party condition awareness without conventional party frames.

## Units

- pet
- party1
- party2
- party3
- party4

## Presentation

Each existing unit:

```text
Name                            Health %
```

No portrait or bar.

## Secret-safe paths

Name:
`UnitName(unit) -> FontString:SetText`

Health:
`UnitHealthPercent(unit, true, percentScaleCurve) -> SetFormattedText`

## Events

Per-unit:
- UNIT_HEALTH
- UNIT_MAXHEALTH
- UNIT_NAME_UPDATE

Structural:
- GROUP_ROSTER_UPDATE
- UNIT_PET for player

## Layout

Compact five-slot stack left of center:
- x=-330
- y=-44

Only existing units are shown.

## Version

`0.0.11-dev -> 0.0.12-dev`

## Runtime proof

Pet and party true paths should be tested only if naturally available.

Unavailable paths may be explicitly deferred by environment/class constraints.
