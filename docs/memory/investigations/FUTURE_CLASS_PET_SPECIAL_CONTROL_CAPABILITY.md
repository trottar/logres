# Future Class / Pet / Special-Control Capability Audit

Status: **P0150 READ-ONLY RUNTIME PROBE PREPARED — RUNTIME EVIDENCE PENDING**
Opened: 2026-10-05
Source pin: `Gethe/wow-ui-source@e3ecc27b64d30fdc735a3f6579b866858f9f9df1`
Forever client: `1.60.1.70205`

## Why this exists

The approved visual system covers the shared action-button language and reserves
space for class/pet/special controls, but ownership is intentionally separate from
ordinary Primary/Secondary/Utility action roles.

Canonical visual inventory separates:
- pet action cluster;
- stance/form cluster;
- totem/class-special cluster;
- rune/class-resource presentation;
- combo-point / discrete-pip presentation;
- possess/override/vehicle/special controls.

D-026 preserves direct player class-resource children, RuneFrame, TotemFrame,
PetFrame, alternate-power, and unknown/unproven children until replacement
completeness is proven.

Canonical P0149 evidence:
`../evidence/P0149_CLASS_PET_SPECIAL_CONTROL_SOURCE_CAPABILITY_AUDIT_2026-10-05.md`.

Accepted policy:
`../decisions/D-044_CLASS_PET_SPECIAL_CONTROL_SOURCE_AND_FALLBACK_POLICY.md`.

## P0149 source result

### Pet actions

Source exposes ten pet-action slots and the stock path reads:
- `GetPetActionInfo`;
- `GetPetActionCooldown`;
- `GetPetActionSlotUsable`;
- `PetHasActionBar`.

Blizzard invalidates from pet-bar/pet-unit/control events.

Most importantly, `Blizzard_FrameXML/SecureTemplates.lua` defines
`SECURE_ACTIONS.pet`, which reads the secure button `action` attribute and calls
`CastPetAction`. An addon-owned `SecureActionButtonTemplate` with `type="pet"` is
therefore a source-plausible secure cast path.

That is not complete PetActionBar ownership. Stock pet controls additionally own
right-click autocast toggling, drag/reorder, quick-keybind/binding presentation,
cooldown/range/usable feedback, and restoration.

Classification:
**SECURE CAST SOURCE AVAILABLE / FULL CONTROL REPLACEMENT RUNTIME-UNPROVEN.**

`PetFrame` is separate: it inherits `SecureUnitButtonTemplate` and owns pet unit
interaction plus health/power/aura information. Pet-action proof does not authorize
PetFrame suppression.

### Stance / form

Source exposes state through:
- `GetNumShapeshiftForms`;
- `GetShapeshiftFormInfo`;
- `GetShapeshiftFormCooldown`.

Stock mutation uses `CastShapeshiftForm`, with invalidation from shapeshift update
events. Stance visibility also depends on possess/override action-bar mode.

The audited secure template has action types for `action`, `pet`, `spell`, `macro`
and related paths, but no dedicated stance/shapeshift secure action type. P0149
does not infer generic spell execution as an equivalent replacement contract.

Classification:
**READ SOURCE AVAILABLE / CONTROL OWNERSHIP RUNTIME+SECURITY GATED.**

### Totems

Generated Totem API exposes:
- `GetNumTotemSlots`;
- `GetTotemInfo`;
- `GetTotemTimeLeft`;
- `GetTotemCannotDismiss`;
- `DestroyTotem`.

`GetTotemInfo` and `GetTotemTimeLeft` are secret-capable by totem slot. The stock
TotemFrame is invalidated by `PLAYER_TOTEM_UPDATE` and related world/spec/form
events, and right-click dismissal is a separate mutation.

Classification:
**SECRET-CAPABLE READ SOURCE AVAILABLE / DISMISS MUTATION SEPARATELY GATED.**

### Runes and class resources

DK RuneFrame uses six explicit rune indices and `GetRuneCooldown`, invalidated by
`RUNE_POWER_UPDATE`.

The generic/class-specific resource framework uses `UnitPower`,
`UnitPowerMax`, `UNIT_POWER_FREQUENT`, `UNIT_MAXPOWER`,
`UNIT_POWER_POINT_CHARGE`, and class/spec-specific logic. Examples include:
- combo points;
- charged combo points;
- soul shards, including fractional Destruction semantics;
- arcane charges;
- holy power;
- essence.

`UnitPower`, `UnitPowerMax`, and charged-power-point reads are documented
secret-capable under their restriction predicates.

These are discrete mechanics, not a generic percentage value.

Classification:
**SOURCE AVAILABLE / SECRET-FIRST RUNTIME PROOF REQUIRED / DISCRETE PRESENTATION.**

### Alternate power

Blizzard alternate-power paths use class/power-type selection plus `UnitPower` /
`UnitPowerMax`, with unit-power, display-power, spec/world, and lifecycle events.
The same power reads are secret-capable.

Classification:
**SOURCE AVAILABLE / SPECIALIZED + SECRET-FIRST / STOCK RETAINED.**

### Possess / override / vehicle / extra action

`C_ActionBar` exposes mode flags and bar indices including:
- `IsPossessBarVisible`;
- `HasVehicleActionBar`;
- `HasOverrideActionBar`;
- `HasTempShapeshiftActionBar`;
- `HasExtraActionBar`;
- vehicle/override/temp-shapeshift bar indices.

Blizzard `ActionBarController` switches secure action pages or dedicated
OverrideActionBar presentation according to those modes. Possess/override/vehicle
surfaces also carry cancel/exit, taxi early landing, vehicle pitch, and other
special responsibilities. ExtraActionBar uses the secure action-button path.

Classification:
**SOURCE AVAILABLE / INTEGRATED SPECIAL MODE / NOT ORDINARY BAR 1–3 ROUTING.**

## P0150 runtime probe

The smallest justified next step is one bounded read-only diagnostic module.

It may read:
- pet action-bar presence and at most ten pet slots;
- current stance/form count and state;
- bounded totem slot state secret-first;
- current class/resource state secret-first;
- DK rune cooldown state only when naturally applicable;
- special-mode flags and ordinary bar indices.

It must invalidate from source-owned events and re-query current state. Event
payloads are not proof.

It must not:
- cast pet actions;
- toggle pet autocast;
- pick up/reorder pet actions;
- cast shapeshift forms;
- destroy/dismiss totems;
- mutate action pages or state drivers;
- exit/cancel vehicles/possess state;
- manipulate override/extra-action controls;
- suppress or mutate PetActionBar, StanceBar, TotemFrame, RuneFrame, PetFrame,
  alternate power, OverrideActionBar, PossessActionBar, ExtraActionBar, or vehicle
  controls.

Environmental absence is **DEFERRED**, not FAIL.

## Standing constraints

Until later runtime/capability checkpoints prove replacement completeness:
- do not suppress RuneFrame;
- do not suppress TotemFrame;
- do not suppress PetFrame;
- do not suppress alternate-power presentation;
- do not suppress unknown/direct player class-resource children;
- do not suppress pet, stance/form, possess/override/vehicle/extra-action controls;
- do not route unsupported special actions through ordinary Bar 2–3 replacement;
- do not force discrete class mechanics into the shared percentage-bar primitive.

Protected setup/mutation must remain combat-safe and fail open to stock UI.

## P0150 implementation checkpoint

P0150 targets candidate runtime `0.0.73-dev` and adds one addon-owned diagnostic module, `ClassPetSpecialProbe`.

The probe is bounded and read-only. It observes naturally available pet actions, stance/forms, totems, current class/resource state, Death Knight runes only when the ordinary player class is Death Knight, and special action-bar mode flags/indexes.

Secret-capable values are checked before nil/type/value inspection. Charged-point tables are bounded by fixed index rather than counted or generically iterated. Secret observations are counted/deferred; they are not formatted or used for branching.

Source-owned invalidation refreshes only the affected domain where practical. Event payloads are discarded.

P0150 does not cast, toggle autocast, reorder, shapeshift, dismiss totems, mutate action pages/state drivers, exit/cancel special modes, invoke extra/override actions, or alter Blizzard presentation.

Runtime proof must use the Phase-H **Class / Pet / Special Probe** action, followed by a separate **Run All** regression pass. Environmental absence remains DEFERRED and must not be manufactured solely for proof.
