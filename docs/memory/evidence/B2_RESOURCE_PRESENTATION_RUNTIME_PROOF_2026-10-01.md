# B.2 Resource Presentation Runtime Proof — 2026-10-01

Status: VERIFIED
Final tested baseline: `66b27a38c4c593622e24cc2e78df6f53f57092e8`

## Runtime result

P0021 implemented the player's primary resource as a lower-center percentage using the production secret-safe path.

The user reported that it works correctly.

The requested runtime scope covered:
- version `0.0.9-dev`;
- existing state/preference/lifecycle checks;
- `/logres hudcheck`;
- visible lower-center percentage;
- spending/gaining primary resource;
- immersion off/on behavior.

No Lua or secret-value error was reported.

## Secret-safe transport

Production path:

```text
UnitPowerPercent("player", nil, false, scaleTo100Curve)
    -> secret 0..100 result
    -> FontString:SetFormattedText("%.0f%%", result)
```

This keeps percentage scaling and formatting outside ordinary Lua arithmetic/string conversion.

The HUD does not:
- divide UnitPower by UnitPowerMax;
- multiply the secret percentage by 100 in Lua;
- compare the percentage;
- persist it;
- read the FontString text back for logic.

## Runtime behavior

Verified on the current character:
- resource percentage is visible while immersion is enabled;
- the percentage updates as the primary resource changes;
- immersion off hides the HUD/resource presentation;
- immersion on restores the resource presentation with current state.

## Coverage limit

This proves the current character's primary-resource path.

It does not independently prove:
- every class resource;
- form-driven primary-resource switching;
- secondary class resources.

Those are not required for the initial B.2 contract.

## Presentation result

The initial text size/placement was reported as working well enough to proceed.

Further final-position styling remains subordinate to later cast/action geometry.

## Conclusion

B.2 success criteria are satisfied.

**B.2 — Resource Presentation: COMPLETE.**
