# D-012 — Player resource presentation contract

Status: ACCEPTED
Date: 2026-10-01

## Decision

Logres displays the player's current **primary resource as a percentage** near the lower center of the HUD.

Default presentation:
- text percentage only;
- no conventional resource bar;
- current primary power type;
- visually subordinate to action information.

## Secret-safe transport

Use:

```text
UnitPowerPercent("player", nil, false, scaleTo100Curve)
    -> secret 0..100 result
    -> FontString:SetFormattedText("%.0f%%", result)
```

The scale curve is native:

```text
0.0 -> 0
1.0 -> 100
```

Lua must not:
- multiply by 100;
- compare the percentage;
- call `tostring` on it;
- call ordinary `string.format` on it in Logres production code;
- persist it;
- read the resource fontstring text back for logic.

`FontString:SetFormattedText` is the consumer boundary.

## Primary resource semantics

Omit `powerType` so `UnitPowerPercent` follows the player's current primary displayed power.

This matches the intended single restrained resource readout.

Secondary class resources are outside the first B.2 contract and may later receive separate presentation if product needs justify them.

## Events

Refresh on:
- `UNIT_POWER_FREQUENT` for responsive current-power changes;
- `UNIT_MAXPOWER` for maximum-power changes.

Initial enable and immersion re-enable also refresh the text.

Class/form transitions not naturally exercised by the current character are a runtime coverage limitation, not a reason to broaden the initial event/model contract preemptively.

## Preference behavior

The resource text is owned by `LogresHUDRoot`.

Therefore:
- `immersionEnabled=false` hides it with the HUD;
- re-enabling immersion refreshes the current percentage.

## Rejected

- conventional horizontal resource bar;
- `UnitPower / UnitPowerMax` arithmetic;
- secret percentage arithmetic in Lua;
- threshold color branching based on percentage;
- duplicating current primary resource into observed State.
