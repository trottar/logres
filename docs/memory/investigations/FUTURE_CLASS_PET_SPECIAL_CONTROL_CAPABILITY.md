# Future Class / Pet / Special-Control Capability Audit

Status: **P0152 R12 PET-ACTION RUNTIME + CONTROL + STATE-PRESENTATION PASS — FULL PET/CLASS/SPECIAL OWNERSHIP STILL GATED**
Opened: 2026-10-05
Original P0149 source pin: `Gethe/wow-ui-source@e3ecc27b64d30fdc735a3f6579b866858f9f9df1` (`1.60.1.70205`)
Current matching source: `Gethe/wow-ui-source@a84e2b1b41d3d4137127c07e4da448aa3251d6f1` (`1.60.1.70235`)

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

## P0150 initial runtime failure / R3 correction

Initial `0.0.73-dev` runtime reached all 22/22 event registrations and the full required API set, but the probe failed with six `pet.isToken:unexpected-number` errors. This proves the diagnostic's boolean-only assumption was wrong for the observed Forever pet-action rows.

The same run safely secret-skipped one Warlock primary-power value with zero resource failures. Stance/forms and active totems were absent. Special-mode detail flags were ordinary false, while the summary incorrectly collapsed false to nil through Lua `and/or`. Separate integrated `Run All` passed.

P0150 R3 keeps `0.0.73-dev`, treats `isToken` as opaque secret-first value data, preserves false special-mode summary values, and does not change mutation, ownership, polling, or suppression scope. Runtime retest remains required.

## P0151 P0150 runtime acceptance / P0152 next

P0150 R3 is durable at `46e06295695587af07f6f3e1b4a6ac4ace4e4c15` and
runtime PASS for the observed read-only scope on `0.0.73-dev` / client
`1.60.1.70235`.

Observed proof:
- 22/22 expected event registrations;
- required API set present;
- PetActionBar present, 10 slots scanned / 7 occupied;
- pet-domain failures `0`;
- one Warlock primary-power value secret-skipped safely;
- resource-domain failures `0`;
- all special-mode flags ordinary `false`;
- total failures `0`;
- separate integrated Run All PASS.

Environmental deferrals remain for stance/forms, active totems, DK runes, active
special modes, and meaningful nonzero class-resource presentation.

Source continuity is resolved for the current client: Forever 70235 commit
`a84e2b1b41d3d4137127c07e4da448aa3251d6f1` is the direct child of the P0149
70205 pin and changes only `version.txt`. The audited `SecureTemplates.lua` and
`PetActionBar.lua` blobs are unchanged.

The strongest next capability candidate is therefore pet secure execution.

P0152 may prove only user-triggered secure pet-action execution through addon-owned
`SecureActionButtonTemplate` controls using `type="pet"` and ordinary slot
attributes. Protected setup must be out of combat and fail open.

P0152 must retain the stock PetActionBar and must not toggle autocast, reorder/edit
pet actions, replace bindings, suppress PetActionBar, or touch PetFrame. Those
remain separate completeness/restoration gates.

## P0152 implementation checkpoint

P0152 targets candidate runtime `0.0.74-dev` and proves only the secure left-click
pet-action execution path.

The diagnostic strip contains ten addon-owned `SecureActionButtonTemplate` buttons
with fixed ordinary pet-slot numbers. It registers only `LeftButtonUp`, sets
`type="pet"` plus the ordinary `action` slot out of combat, and never calls
`CastPetAction` directly.

The strip is armed/hidden only out of combat. `PreClick` captures ordinary
`isActive` baseline state, `PostClick` records the hardware click, and source-owned
pet events re-read the clicked slot. Mechanical PASS requires PostClick, at least
one follow-up pet event, an ordinary active-state transition, and zero failures.
Final project acceptance also requires the user to confirm the pet visibly entered
the selected inactive Follow/Stay-type state.

P0152 does not register right-click, toggle autocast, pick up/edit/reorder actions,
replace bindings, suppress PetActionBar, mutate PetFrame, poll, or use timers.
Stock PetActionBar remains the completeness fallback throughout.

## P0152 R5 protected-control result / R6 delegation boundary

R5 supplies negative runtime evidence that the direct addon secure `type1="pet"` / `action1=slot` implementation is not accepted on Forever 70235: a hardware left click produced Blizzard's protected-action block. Source plausibility alone is not sufficient to reopen that direct path.

R6 therefore narrows the capability proof to secure click delegation from a Logres shared-action button to the matching Blizzard `PetActionBar.actionButtons[slot]`. This keeps Blizzard in control of protected left-click execution and right-click autocast while Logres owns presentation. Because this retains a Blizzard control dependency, it does **not** authorize PetActionBar suppression or claim complete replacement ownership.

## P0152 final runtime acceptance

P0152 is durable at `00aef4a90e5999140dc9082e68e934cfc854cb05` on `0.0.74-dev`. After the preserved R1–R11 delivery/runtime correction history, R12 resolves persistent presentation from the effective click-specific secure pet bindings used by the working controls.

Accepted observed state:
- ten pet bindings recognized;
- seven naturally readable/occupied slots;
- two ordinary active-state indicators;
- one ordinary autocast-enabled indicator;
- default-on pet cluster without manual diagnostic ARM;
- user-confirmed visible state treatment and working pet button presses.

This proves the bounded Logres pet-action control/state-presentation slice, not full PetActionBar replacement completeness. Stock PetActionBar remains available. Edit/reorder, binding replacement, PetActionBar suppression/restoration, PetFrame ownership, and every other class/special domain remain separately gated.

Exact pet-button ornament/contrast tuning is deferred to later whole-interface polish.
