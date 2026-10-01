# D-008 — Secret-safe health and resource presentation path

Status: ACCEPTED  
Date: 2026-09-30

## Decision

Logres will treat player and target health/power percentages as secret-capable values at all times.

The default implementation must not depend on ordinary Lua arithmetic, comparison, or branching over those percentages.

### Player health vignette

Use native secret-safe transformations and visual properties:
- `UnitHealthPercent`;
- a native curve suitable for Logres' desired intensity response;
- secret-capable bar/alpha/color presentation.

Runtime evidence proved that a custom Logres inverse/threshold curve can remain secret and directly drive status-bar value and texture alpha, including during combat lockdown and instance combat.

### Resource percentage

Use:
- `UnitPowerPercent`;
- secret-safe formatting;
- `FontString:SetText`.

## Rejected

- `UnitHealth()/UnitHealthMax()` arithmetic as the default path;
- `if healthPercent < threshold then ... end`;
- converting secret health/power into ordinary numbers;
- persisting health/power values in SavedVariables.

## Rationale

Forever 1.60.1 returned player health and power percentages as secret even outside combat.

The native UI system already supports safe transformation/display of secret data, and runtime testing proved the relevant transport path.

## Evidence

- `../evidence/I001_RUNTIME_PASS_01_2026-09-30.md`
- `../evidence/I001_RUNTIME_PASS_02_2026-09-30.md`
