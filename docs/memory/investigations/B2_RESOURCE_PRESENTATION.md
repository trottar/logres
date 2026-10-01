# B.2 — Resource Presentation

Status: ACTIVE
Opened: 2026-10-01

## Goal

Add a restrained player-resource display near the character/center HUD language without introducing a conventional resource bar.

## Product intent

Default presentation:
- simple percentage;
- low/center near character;
- visually quieter than primary action information;
- optional subtle class/resource color/ornament later.

Do not create a persistent horizontal mana/energy/rage bar by default.

## Secret-safe boundary

D-008 remains authoritative.

Use:

```text
UnitPowerPercent("player")
    -> secret-safe formatting
    -> FontString:SetText
```

Do not:
- perform Lua arithmetic on the returned percentage;
- compare it against thresholds;
- stringify it with ordinary Lua conversion;
- persist it.

## Initial B.2 scope

First implementation should prove:
- real HUD-owned resource `FontString`;
- secret-safe percentage text;
- updates on relevant player power events;
- clean hide/show under `immersionEnabled`;
- no duplicate global state detection;
- no conventional bar.

## Open implementation questions

Before coding, settle:
- exact secret-safe formatter available on Forever for percentage text;
- whether `UnitPowerPercent("player")` default power type is sufficient across classes/forms;
- which power update events are necessary/minimal;
- whether zero/empty/alternate resources require contextual suppression;
- initial anchor relative to future cast glyph/action constellation.

## Runtime proof target

Travel-free where possible:
- resource text visible when immersion is on;
- immersion off/on hides/restores it;
- spending/gaining resource updates text;
- no secret-value/Lua errors;
- no persistent bar introduced.

Class/form-specific edge cases may be deferred if the current character cannot produce them.

## Exit

B.2 completes when the default player resource percentage is production-viable and secret-safe.
