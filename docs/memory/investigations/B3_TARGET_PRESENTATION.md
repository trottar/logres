# B.3 — Target Presentation

Status: ACTIVE
Opened: 2026-10-01

## Goal

Add the minimum target information necessary for combat/world awareness without restoring a conventional target frame.

## Product contract

Default target presentation:
- target name;
- target health percentage;
- optional target resource percentage where useful.

Do not show by default:
- numeric level;
- elite/rare classification;
- portrait;
- large health bar;
- explicit difficulty label.

D-003 remains authoritative even though level/classification are technically readable.

## Secret-safe boundary

Target health and power percentages are secret-capable.

Expected production paths:

```text
UnitHealthPercent("target", ...)
    -> native scale/formatting
    -> FontString:SetFormattedText
```

and, if target resource is included:

```text
UnitPowerPercent("target", ...)
    -> native scale/formatting
    -> FontString:SetFormattedText
```

Do not perform Lua arithmetic/comparison/stringification over target percentage values.

## Ordinary target facts

Target name may be read through the ordinary unit-name API if current source verification confirms the expected Forever behavior.

Name display should disappear cleanly when no valid target exists.

Do not use target classification or level to alter default disclosure during B.3.

## Initial layout direction

Keep the target block sparse and close to the center-HUD language rather than recreating Blizzard's upper-left frame.

Candidate first-pass structure:

```text
Target Name
72%
```

Optional target resource percentage should not be included unless it materially improves the first implementation and remains visually restrained.

## Source questions before implementation

Resolve:
1. exact target-name API/event path;
2. target health secret-safe formatting path;
3. minimal target health/update events;
4. whether target resource should ship in initial B.3 or remain optional;
5. how target disappearance is handled without reading secret presentation text;
6. anchor relation to the existing player resource text and future cast glyph.

## Runtime proof target

Using ordinary open-world targets where possible:
- no target -> target block absent;
- acquire target -> name + health % appear;
- damage target -> percentage updates;
- clear/change target -> block updates correctly;
- immersion off/on hides/restores it;
- normal and elite targets do not expose level/classification;
- no secret-value/Lua errors.

An instance is not required solely to prove elite-disclosure policy because D-003 and prior runtime evidence already establish classification availability/withholding.

## Exit

B.3 completes when sparse target presentation is production-viable and preserves the disclosure contract.
