# B.5 Allies and Pets Runtime Proof — 2026-10-01

Status: VERIFIED
Final tested baseline: `42aa8d616ad95c85105d6289d857b7eebb61af5c`

## Runtime result

P0027 implemented compact rows for:
- player pet;
- party1–party4.

The user exercised both pet and party true paths.

Verified:
- player pet row appeared correctly;
- party-member row appeared correctly;
- health percentage updated as the pet/party member took damage during combat;
- immersion off hid the presentation;
- immersion on restored it.

No Lua/secret-value error was reported.

## Presentation result

The tested presentation remained compact:

```text
Name                            Health %
```

No conventional health bar, portrait, role icon, level, or dense party-frame chrome was introduced.

## Structural result

The implementation uses:
- `UnitExists` for row visibility;
- per-unit name/health refresh;
- group/pet structural refresh events.

The tested pet and party rows appeared for real units and behaved as expected.

No pet or party environmental deferral is required.

## Secret-safe result

Name path:

```text
UnitName(unit)
    -> FontString:SetText
```

Health path:

```text
UnitHealthPercent(unit, true, percentScaleCurve)
    -> FontString:SetFormattedText("%.0f%%", result)
```

Observed health depletion confirms the production ally/pet percentage path is functioning.

## Conclusion

B.5 success criteria are satisfied.

**B.5 — Allies and Pets: COMPLETE.**
