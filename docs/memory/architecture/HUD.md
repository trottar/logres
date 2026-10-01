# HUD Architecture

Status: PHASE B / B.2 ACTIVE

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
- stringify/log them;
- convert them to ordinary values;
- persist them.

Player health vignette uses the D-008 native path:
- `UnitHealthPercent`;
- native `CurveObject`;
- secret-capable `Texture:SetAlpha`.

## B.1 module boundary

P0018 introduces the real:

```text
HUD
```

module through D-011.

The HUD module owns:
- `LogresHUDRoot`;
- vignette curve objects;
- 16 edge textures;
- player health event registration;
- preference subscription;
- cleanup on disable.

It does not own:
- global state detection;
- secure action buttons;
- compass;
- quest presentation;
- camera behavior.

## Initial native layer model

B.1 deliberately uses native/procedural solid textures before art-asset polish.

Four edge bands encode the product danger progression:

| Layer | Health range encoded by native curve | Role |
| --- | --- | --- |
| outerDark | begins below ~70% | faint/dark edge pressure |
| injuryRed | begins below ~50% | red injury pressure |
| criticalPressure | begins below ~30% | wider inward pressure |
| nearDeathTunnel | begins below ~15% | deepest/widest tunnel pressure |

The Lua code does not ask which range applies.

Each curve maps the secret health percentage directly to an alpha value inside the native UI system.

The resulting secret alpha is forwarded directly to each texture's `SetAlpha`.

The widths/insets/colors are provisional visual tuning values. The secret-safe transport and ownership boundary are the durable architecture.

## Immersion preference

The HUD module remains lifecycle-enabled while `immersionEnabled=false`, but hides its presentation root.

This keeps:
- module lifecycle;
- user choice;
- observed game state

as separate concepts.

When immersion becomes enabled again, the HUD root is shown and the vignette refreshes from current health.

## Player health events

B.1 listens only to player:
- `UNIT_HEALTH`;
- `UNIT_MAXHEALTH`.

No health value is persisted.

## Development validation

`/logres hudcheck` verifies only ordinary structural facts:
- module initialized/enabled;
- four bands;
- sixteen textures;
- curves created;
- root visibility matches `immersionEnabled`.

It deliberately does not inspect the secret health-derived alpha.

## Runtime visual proof

The production proof should cover:
- healthy state: vignette effectively absent;
- ordinary injury: edges become visible;
- additional safe injury: stronger/wider pressure is observable;
- immersion off: presentation hides;
- immersion on: current injury presentation returns;
- healing: vignette reduces/disappears;
- no secret-value/Lua errors.

Do not deliberately push the character to near death solely to validate B.1.

## Deferred visual work

Not required to prove B.1 architecture:
- custom vignette artwork/masks;
- near-death pulse;
- accessibility alternate health mode;
- final color/width tuning.

These may iterate after production transport is proven.

## Enemy disclosure

D-003 remains authoritative:
- no numeric target level by default;
- no explicit elite/rare warning by default.

Runtime availability of those fields does not supersede disclosure policy.

## Phase boundary

Phase B may style and reveal awareness information.

It must not implement Phase C secure action clusters.


## P0018 runtime correction

P0018's first visual tuning was not perceptible during ordinary injury.

The curve x scale was correct; normalized percentage input is 0–1.

P0019 strengthens curve outputs/source color and adds a non-secret preview presentation.

The preview is diagnostic only. It does not alter the production secret-health boundary.


## B.1 final result

B.1 production proof passed on P0019.

Verified:
- health-driven progression visible;
- immersion off hides presentation;
- immersion on restores current injury state;
- healing reduces/removes the vignette.

The procedural rectangular bands remain visual-polish debt.

The transport and ownership boundary are now production-proven.

## B.2 entry

Next HUD subdomain:
**player resource percentage**

Use D-008:
`UnitPowerPercent` -> secret-safe formatter -> `FontString:SetText`.

Do not introduce a conventional resource bar by default.
## B.1 final result

B.1 production proof passed on P0019.

Verified:
- health-driven progression visible;
- immersion off hides presentation;
- immersion on restores current injury state;
- healing reduces/removes the vignette.

The procedural rectangular bands remain visual-polish debt.

The transport and ownership boundary are now production-proven.

## B.2 entry

Next HUD subdomain:
**player resource percentage**

Use D-008:
`UnitPowerPercent` -> secret-safe formatter -> `FontString:SetText`.

Do not introduce a conventional resource bar by default.
## B.2 implementation boundary

P0021 adds the default primary-resource percentage to the existing HUD module.

Secret-safe flow:

```text
UnitPowerPercent("player", nil, false, scaleTo100Curve)
    -> FontString:SetFormattedText("%.0f%%", secretPercent)
```

The fontstring text becomes a secret Text aspect and is never read back for logic.

Resource events:
- `UNIT_POWER_FREQUENT`;
- `UNIT_MAXPOWER`.

The initial readout is lower-center text only.

No resource bar and no percentage-based Lua threshold styling are introduced.
## B.2 final result

B.2 primary-resource percentage is production-proven on P0021.

Verified:
- secret-safe percentage rendering;
- responsive resource updates;
- immersion hide/restore;
- no conventional resource bar.

Current-character primary-resource behavior is proven. Broader class/form coverage remains conditional on future natural test opportunities.

## B.3 entry

Next HUD subdomain:
**target presentation**

D-003 remains authoritative:
- target name;
- health percentage;
- optional resource percentage;
- no default numeric level;
- no explicit elite/rare disclosure;
- no portrait-heavy conventional target frame.

Target health/power remain secret-capable and must use native safe display paths.
## B.3 implementation boundary

P0023 adds sparse target presentation to the existing HUD module:

```text
Target Name
Health %
```

Target identity path:

```text
UnitName("target")
    -> FontString:SetText
```

The name may be secret; Logres does not inspect/read it back.

Target health path:

```text
UnitHealthPercent("target", true, percentScaleCurve)
    -> FontString:SetFormattedText("%.0f%%", secretPercent)
```

The target block is shown/hidden from `UnitExists("target")`, not from secret text/health values.

D-003 is statically reinforced:
- no UnitLevel;
- no UnitClassification;
- no portrait;
- no conventional target bar.

Target resource remains deferred from initial B.3.
## B.3 final result

B.3 sparse target presentation is production-proven:
- target name;
- target health percentage;
- target loss/change handling;
- immersion hide/restore;
- no extra level/classification/portrait/bar disclosure.

## B.4 entry

Cast presentation includes both:
- player self cast/channel cue;
- current-target cast/channel cue.

Neither uses a conventional cast bar.

The prior statement that enemy casting should remain deferred unless later justified is superseded by D-014.

Only target-caster **runtime proof** may defer by environment when no caster is available.
## B.4 implementation boundary

P0025 implements player and current-target cast cues through spellcast lifecycle events only.

It intentionally does not query:
- `UnitCastingInfo`;
- `UnitChannelInfo`.

Reason:
target cast information may be secret-restricted.

The target event frame is registered directly for `"target"` and ignores all spellcast payload fields.

Visual state:
- player cast: amber;
- player channel: blue;
- target cast: orange;
- target channel: violet;
- interrupt/failure: brief red snap.

There is no:
- cast timing;
- progress bar;
- spell text;
- target cast metadata inspection.
## B.4 final result

B.4 player cast presentation is production-proven:
- cast;
- channel;
- interruption/failure snap.

The current-target cast cue remains implemented but its true-path runtime proof is deferred by environment because no convenient caster was available.

This does not reopen or remove the target-cast feature.

## B.5 entry

Next HUD subdomain:
**allies and pets**

Default direction:
- name;
- health percentage;
- compact condition awareness.

Expected secret-safe paths:

```text
UnitName(unit)
    -> FontString:SetText
```

and:

```text
UnitHealthPercent(unit, true, percentScaleCurve)
    -> FontString:SetFormattedText("%.0f%%", secretPercent)
```

Initial candidate units:
- pet;
- party1–party4.

No portraits, dense raid grid, or conventional large party bars by default.
