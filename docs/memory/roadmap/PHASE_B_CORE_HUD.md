# Phase B — Core HUD

Status: ACTIVE
Opened: 2026-09-30

## Purpose

Implement Logres' identity-defining moment-to-moment awareness layer while preserving the product rule:

> Show information through the world whenever possible; show abstractions only when the player actually needs them.

Phase B consumes the completed Phase A contracts. It must not invent competing state detection.

## Hard constraints

1. No conventional player health bar by default.
2. Player health is felt through a screen-edge vignette.
3. Health/power percentages are secret-capable at all times.
4. No ordinary Lua arithmetic/comparison on secret health/power values.
5. Resource presentation is restrained and percentage-oriented.
6. Player casting uses confirmation glyph/rune behavior, not a cast progress bar.
7. Enemy default presentation does not expose numeric level or elite/rare classification.
8. Availability of enemy metadata does not imply disclosure.
9. HUD visibility consumes central state/preferences rather than directly rebuilding context detection.
10. Phase B does not implement secure action clusters; that remains Phase C.

Canonical decisions:
- D-002 Player Health Presentation;
- D-003 Enemy Information Disclosure;
- D-008 Secret-Safe Health and Resource Path.

## B.1 — HUD root + player health vignette

**Status: COMPLETE.**

Goal:
establish the first real presentation module and prove the production secret-safe health transport in Logres itself.

Work:
- create a `HUD` module through D-011 lifecycle;
- create a HUD root/frame ownership boundary;
- implement screen-edge health-vignette layers;
- use `UnitHealthPercent` through native secret-safe transformation;
- drive secret-capable visual properties without Lua threshold branching;
- preserve full absence at healthy state where the native curve allows;
- define frame strata/level/anchors without blocking later HUD elements;
- subscribe through state/preferences only where needed;
- hide/suspend cleanly when `immersionEnabled=false`.

### P0018 implementation

- real `HUD` lifecycle module;
- full-screen HUD root;
- four curve-driven edge bands;
- 16 native procedural textures;
- `UNIT_HEALTH` / `UNIT_MAXHEALTH` player refresh;
- `immersionEnabled` presentation gating;
- `/logres hudcheck`;
- static checker preventing obvious secret-health boundary regressions.

Initial visual target:
- healthy: effectively absent;
- moderate injury: subtle dark edge pressure;
- serious injury: stronger red/black pressure;
- critical: inward/tunnel pressure;
- near-death: strongest readable pressure without obscuring gameplay.

Exact art tuning may iterate; the architecture must be correct first.

P0019 runtime result:
- health-driven progression visible;
- immersion off/on hides/restores correctly;
- healing recedes/removes the effect;
- procedural rectangles remain polish debt.

Success:
- no conventional player health bar/numbers;
- health-vignette transport runs in the real Logres HUD module;
- no secret arithmetic/comparison in Lua;
- state/preference/lifecycle contracts are used correctly;
- immersion off disables the HUD module presentation cleanly;
- static checks pass;
- runtime proof covers healthy/injured path as practical without intentionally risking character death.

## B.2 — Resource presentation

**Status: COMPLETE.**

Goal:
add compact player resource percentage near the character/center HUD language.

Use:
- `UnitPowerPercent`;
- secret-safe formatting;
- `FontString:SetText`.

Do not add a conventional resource bar unless later accessibility work explicitly requires one.

### P0021 implementation

- primary resource percentage only;
- native 0–100 scale curve;
- secret value passed directly to `FontString:SetFormattedText`;
- `UNIT_POWER_FREQUENT` + `UNIT_MAXPOWER`;
- owned by existing HUD root;
- immersion preference inherited from HUD visibility;
- no secondary-resource modeling yet.

## B.3 — Target presentation

**Status: COMPLETE.**

Default target information:
- name;
- restrained health percentage;
- optional resource percentage where useful.

Do not show:
- numeric level;
- explicit elite/rare status;
- portrait-heavy conventional target frame.

Any relative-difficulty styling requires a separate design decision if used.

### P0023 implementation

Initial production target block:
- target name;
- target health percentage;
- no target resource yet;
- no level/classification;
- no portrait/bar;
- target identity forwarded directly to secret-safe FontString text;
- target health forwarded through native percent curve to `SetFormattedText`.

## B.4 — Cast confirmation

**Status: ACTIVE.**

Implement minimal cast/channel cues for both:
- the player;
- the current target.

Player self-cast/channel:
- small glyph/rune near resource;
- active while casting/channeling;
- resolves/disappears on completion;
- interruption/failure snap/fade where practical;
- no cast progress bar.

Current-target cast/channel:
- similarly restrained cue associated with target presentation;
- visible while the current target casts/channels;
- no conventional enemy cast bar.

Current-target true-path runtime proof may be deferred by environment if no caster is conveniently available. That defers testing, not the feature.

Canonical decision:
`../decisions/D-014_CAST_PRESENTATION_CONTRACT.md`

## B.5 — Allies and pets

Implement restrained ally/pet presentation:
- name;
- health percentage;
- compact party condition awareness.

Accessibility/healer alternatives may be added later without changing the default philosophy.

## B.6 — HUD integration validation

Validate:
- world;
- combat;
- instance;
- PvP modifier behavior;
- immersion preference off/on;
- module enable/disable cleanup;
- no regression in state/preference contracts;
- no secret-value violations.

Avoid forcing scenarios already proven unless HUD behavior itself depends on them.

## Phase B exit criteria

Phase B completes when:
- player health vignette is production-viable;
- resource display is secret-safe and restrained;
- target presentation follows disclosure policy;
- self-cast confirmation exists without a progress bar;
- ally/pet presentation is sufficient for default awareness;
- HUD uses Phase A contracts rather than duplicate state detection;
- runtime limitations/failures are durable;
- no action-cluster implementation has leaked into Phase B.
