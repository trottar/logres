# HUD Architecture

Status: PHASE B ACTIVE

## Intent

The HUD exposes the minimum information necessary for awareness while preserving uncertainty and world focus.

Planned subdomains:
- player health vignette;
- resource percentage;
- cast confirmation;
- target presentation;
- party/allies;
- pets.

## Hard design constraints

- no conventional player health bar by default;
- no numeric enemy level by default;
- no explicit elite warning by default;
- no cast progress bar by default;
- percentage-oriented health/power presentation where shown;
- state-aware visibility;
- consume Phase A state/preferences/lifecycle rather than duplicating context detection.

## Secret-safe boundary

Player and target health/power percentages are secret-capable.

The HUD must not:
- perform ordinary Lua arithmetic on them;
- compare them in `if` threshold logic;
- convert them to ordinary numbers;
- persist them.

Player health vignette uses the D-008 native path:
- `UnitHealthPercent`;
- native curve transformation;
- secret-capable status/texture properties.

Resource uses:
- `UnitPowerPercent`;
- secret-safe formatting;
- `FontString:SetText`.

## Module boundary

Phase B will introduce a real `HUD` module through the D-011 lifecycle.

The HUD module owns:
- its frames/textures/font strings;
- state/preference subscriptions;
- cleanup on disable.

It does not own:
- global context detection;
- secure action buttons;
- compass;
- quest presentation;
- camera behavior.

## B.1 first implementation

Start with:
**HUD root + player health vignette**

Architecture before polish:
1. real HUD module;
2. screen-edge layer ownership;
3. secret-safe health transport;
4. immersion preference integration;
5. runtime proof;
6. visual tuning after the transport is proven in production code.

## Enemy disclosure

D-003 remains authoritative:
- no numeric target level by default;
- no explicit elite/rare warning by default.

Runtime availability of those fields does not supersede disclosure policy.

## Phase boundary

Phase B may style and reveal awareness information.

It must not implement Phase C secure action clusters.
