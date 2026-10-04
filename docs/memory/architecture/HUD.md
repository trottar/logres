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
## B.5 implementation boundary

P0027 adds compact ally/pet rows for:
- pet;
- party1–party4.

Each existing unit renders only:

```text
Name                            Health %
```

Identity/health use the same secret-safe text forwarding proven by B.2/B.3.

Structural visibility uses `UnitExists`.

Roster/pet existence refresh uses:
- `GROUP_ROSTER_UPDATE`;
- `UNIT_PET`.

Per-unit content refresh uses:
- `UNIT_HEALTH`;
- `UNIT_MAXHEALTH`;
- `UNIT_NAME_UPDATE`.

No:
- portrait;
- StatusBar;
- role/class/level metadata;
- secure click-casting;
- raid grid.
## B.5 final result

B.5 pet and party presentation is production-proven.

Verified:
- real pet row;
- real party row;
- combat health updates;
- immersion hide/restore.

No pet/party environmental deferral remains.

## B.6 entry

B.6 validates the Phase B HUD as a single integrated system.

No new HUD feature is planned by default.

Validation focuses on:
- coexistence;
- target/cast lifecycle cleanup;
- combat updates;
- immersion hide/restore;
- stale-state prevention;
- usable spacing.

Known visual polish debt remains separate from functional correctness.


## Phase H+ visual direction — D-034

The Phase B text-only percentage displays were capability/proof presentations,
not the final visual endpoint.

Future Logres-owned percentage presentation should normally use the shared
compact percentage-bar primitive with visible `%` text, including:
- primary player resource percentage;
- pet health percentage;
- party-member health percentage;
- fallback/world target health percentage when owned.

Player health remains the health-tunnel/peripheral-pressure system and is not
converted into a conventional player health bar.

This presentation refinement does not change the secret-safe transport
contract. Secret-capable percentages must still flow directly through
native-safe consumers without Lua arithmetic, comparison, stringification,
persistence, or threshold branching.


## Phase H+ player-health visual contract — D-036

The B.1 four-layer native implementation remains valid runtime evidence, but the
procedural rectangular bands are not the final art endpoint.

D-036 freezes the intended health-tunnel presentation: a continuous progression in
which remaining health roughly maps to remaining clear/usable visual field. The
healthy range eases gently; critical ranges collapse much more directly, reaching
an extremely narrow central field near death and effective collapse at 0%.

The visual effect is primarily charcoal/black peripheral pressure, desaturation,
loss of peripheral clarity, and restrained cold burgundy injury color. It is not a
hard circular mask, red fog, blood/vein treatment, numeric warning, or conventional
player-health bar.

This visual refinement must continue to use native secret-safe transport. D-036 is
not permission to branch on, inspect, stringify, or perform Lua arithmetic on the
secret-capable health value.


## Phase H+ shared percentage-bar production primitive — P0120

D-034/D-039 make the compact percentage bar the default final presentation for
Logres-owned percentage values except player health.

P0120 prepares one reusable normal/compact primitive and applies it to:
- player primary resource percentage;
- detached target health percentage;
- pet health percentage;
- party1–party4 health percentage.

The visible `%` text remains part of the primitive. Player health is explicitly
excluded and continues to use the D-036 health tunnel.

Secret-safe transport remains native-only. The existing 0–100 native curve
produces an opaque secret percentage which is forwarded directly to both:
- `StatusBar:SetValue`;
- `FontString:SetFormattedText`.

No Lua arithmetic, comparison, threshold branch, persistence, or value readback
is introduced. Health-to-StatusBar transport is already runtime-proven by D-008.
P0120 intentionally makes player `UnitPowerPercent` -> `StatusBar:SetValue` an
in-client runtime gate; static reasoning alone is not recorded as proof.

The target bar uses a fixed restrained target-health tint in this slice.
Reaction-color semantics and relative-danger styling remain separately
capability-gated rather than branching on an unproven target-reaction source.


## P0120 runtime / visual result

The shared percentage-bar production baseline is runtime + visual PASS at
`6c5f8901` / `0.0.50-dev`. The current production treatment is intentionally
simpler than the approved sheet and is accepted as the baseline for now; richer
ornament remains later polish. Player health remains excluded from this bar
family.

## Phase H+ cast-state cue production translation — P0121

P0121 keeps the B.4 event-driven cast lifecycle unchanged and replaces only the
procedural square cue treatment with Theme-owned production textures derived
from approved sheet 05.

Production states:
- player cast: amber angular glyph;
- player channel: blue flowing glyph;
- target cast: orange/red angular glyph;
- target channel: violet flowing glyph;
- interrupted/failed: brief red shattered glyph.

The cue remains symbolic only. There is still no cast progress bar, timer, spell
text, spell icon, `UnitCastingInfo`, or `UnitChannelInfo` dependency. Target
spellcast payload fields remain ignored.

## Phase H+ organic health-tunnel production translation — P0124

P0124 replaces the procedural four-sided rectangle constructor with Theme-owned
full-screen alpha masks derived from the frozen D-036 / approved sheet-11
health-tunnel direction.

Production layers:

- soft outer charcoal pressure;
- cold-burgundy injury pressure;
- narrower critical pressure;
- severe near-death tunnel;
- death-only effective clear-field collapse.

The live transport boundary is unchanged:

```text
UnitHealthPercent("player", true, nativeCurve)
    -> Texture:SetAlpha(secret)
```

Lua does not compare, stringify, persist, or perform arithmetic on the live
secret-capable health value.

P0124 also adds deterministic developer previews for the D-036 calibration
anchors:

`100 / 80 / 70 / 60 / 50 / 40 / 30 / 20 / 15 / 5 / 0`

Those percentages are ordinary developer-supplied preview inputs and are isolated
from live health. They exist specifically so critical/near-death visual
calibration does not require deliberately endangering the character.

The Phase-B developer panel exposes every D-036 calibration state plus **Health Live**,
so normal visual calibration requires no manual slash-command entry.

The legacy `/logres hudpreview on` remains a compatibility alias for the 30%
preview; `/logres healthpreview off` returns immediately to the live native path.
