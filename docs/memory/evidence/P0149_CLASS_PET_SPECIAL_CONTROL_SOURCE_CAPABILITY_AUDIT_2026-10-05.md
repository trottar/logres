# P0149 — Class / Pet / Special-Control Source-Capability Audit

Date: 2026-10-05
Result: **SOURCE/CAPABILITY LAYER RESOLVED; P0150 READ-ONLY RUNTIME PROBE JUSTIFIED**
Forever client: `1.60.1.70205`
Source pin: `Gethe/wow-ui-source@e3ecc27b64d30fdc735a3f6579b866858f9f9df1`

## Question

Which residual class/pet/special-control domains have supported current-Forever
state/control sources, which are secret/protected or integrated special modes, and
what is the smallest safe runtime proof justified next?

This audit changes no runtime code and authorizes no stock suppression.

## Primary source inspected

Pinned source files include:
- `Interface/AddOns/Blizzard_ActionBar/Shared/PetActionBar.lua`;
- `Interface/AddOns/Blizzard_ActionBar/Mainline/PetActionBar.xml`;
- `Interface/AddOns/Blizzard_ActionBar/Shared/StanceBar.lua`;
- `Interface/AddOns/Blizzard_ActionBar/Mainline/StanceBar.xml`;
- `Interface/AddOns/Blizzard_ActionBar/Shared/PossessActionBar.lua`;
- `Interface/AddOns/Blizzard_ActionBar/Mainline/PossessActionBar.xml`;
- `Interface/AddOns/Blizzard_ActionBarController/ActionBarController.lua`;
- `Interface/AddOns/Blizzard_OverrideActionBar/OverrideActionBar.lua`;
- `Interface/AddOns/Blizzard_OverrideActionBar/OverrideActionBar.xml`;
- `Interface/AddOns/Blizzard_ActionBar/Shared/ExtraActionBar.lua`;
- `Interface/AddOns/Blizzard_ActionBar/Shared/ExtraActionBar.xml`;
- `Interface/AddOns/Blizzard_ActionBar/Shared/VehicleLeaveButton.lua`;
- `Interface/AddOns/Blizzard_FrameXML/SecureTemplates.lua`;
- `Interface/AddOns/Blizzard_UnitFrame/Mainline/TotemFrame.lua`;
- `Interface/AddOns/Blizzard_UnitFrame/Mainline/RuneFrame.lua`;
- `Interface/AddOns/Blizzard_UnitFrame/Mainline/ClassPowerBar.lua`;
- `Interface/AddOns/Blizzard_UnitFrame/Mainline/ClassResourceBarTemplate.lua`;
- class-specific combo/shard/charge/holy-power/essence files;
- `Interface/AddOns/Blizzard_UnitFrame/Mainline/AlternatePowerBar.lua`;
- `Interface/AddOns/Blizzard_UnitFrame/Mainline/PetFrame.lua`;
- generated `ActionBarFrameDocumentation.lua`, `TotemDocumentation.lua`,
  `UnitDocumentation.lua`, `PlayerScriptDocumentation.lua`, and
  `VehicleDocumentation.lua`.

Existing Logres authority consulted:
- D-026 selective unit-frame suppression;
- visual component inventory / implementation status.

## Capability matrix

| Domain | Read/state source | Control/source result | Stock fallback result |
| --- | --- | --- | --- |
| Pet actions | 10 bounded slots; action/cooldown/usable/autocast/range state | Secure `type="pet"` cast path exists; autocast/edit/bindings remain separate | Keep PetActionBar until complete control/restoration proof |
| PetFrame | Secure pet unit-frame surface with health/power/auras | Separate from pet-action ownership | Keep PetFrame |
| Stance/form | Form count/info/cooldown + shapeshift events | Stock calls `CastShapeshiftForm`; no dedicated audited secure stance type | Keep StanceBar |
| Totems | Totem slots/info/time/dismissibility | Read APIs are secret-capable; `DestroyTotem` is separate mutation | Keep TotemFrame |
| Runes | Six rune indices; `GetRuneCooldown`; rune events | Information-only source for Logres at this checkpoint | Keep RuneFrame |
| Class resources | `UnitPower`/`UnitPowerMax`, charged points, class/spec logic | Secret-capable information; discrete mechanics differ per class | Keep direct class-resource children |
| Alternate power | Secondary power selection + unit power events | Specialized secret-capable information | Keep alternate-power presentation |
| Possess/override/vehicle | C_ActionBar mode flags/indexes + controller state | Integrated secure paging/override controls, cancel/exit/pitch responsibilities | Keep stock special modes |
| Extra action | Has-extra-action state + secure action button | Dedicated special action surface | Keep ExtraActionBar |

## 1. Pet actions

`PetActionBar.lua` defines `NUM_PET_ACTION_SLOTS = 10` and uses
`GetPetActionInfo`, pet cooldown/usable state, plus pet/control/vehicle events.

Stock button behavior includes:
- left-click `CastPetAction`;
- right-click `TogglePetAutocast`;
- drag/reorder through `PickupPetAction`;
- binding/quick-keybind presentation.

The strongest source result is in `SecureTemplates.lua`:
`SECURE_ACTIONS.pet` reads a secure button `action` attribute and calls
`CastPetAction`.

Result:
**SECURE CAST PATH SOURCE-PROVEN; FULL PET CONTROL OWNERSHIP NOT PROVEN.**

A later Logres pet action implementation may investigate `SecureActionButtonTemplate`
with `type="pet"` rather than routing pet actions through ordinary Bar 1–3.

## 2. PetFrame separation

`PetFrame.xml` inherits `SecureUnitButtonTemplate`.

`PetFrame.lua` initializes secure unit interaction for `"pet"` and also carries
pet health/power/aura behavior.

Result:
**PET ACTION OWNERSHIP DOES NOT INCLUDE PETFRAME.**

## 3. Stance / form

Stock StanceBar reads shapeshift form count/info/cooldown and invokes
`CastShapeshiftForm`.

Its visibility is coupled to possess/override state.

The pinned secure template defines action types including action, pet, spell,
macro, etc., but no dedicated stance/shapeshift type was found.

Result:
**READ SOURCE AVAILABLE; CONTROL REPLACEMENT REMAINS RUNTIME/SECURITY-GATED.**

Do not assume generic secure spell casting is behaviorally equivalent to stock
stance/form control without evidence.

## 4. Totems

Generated Totem API exposes slot count/info/time/dismissibility and `DestroyTotem`.

`GetTotemInfo` and `GetTotemTimeLeft` are marked secret-capable by totem-slot
secrecy. Blizzard updates TotemFrame from totem/world/form/spec events; stock
right-click dismissal calls `DestroyTotem` only when allowed.

Result:
**SECRET-CAPABLE READ SOURCE AVAILABLE; DISMISS MUTATION SEPARATELY GATED.**

## 5. Runes and discrete class resources

DK RuneFrame has six explicit rune indices and reads `GetRuneCooldown` under
`RUNE_POWER_UPDATE`.

Class resource infrastructure uses `UNIT_POWER_FREQUENT`, `UNIT_MAXPOWER`,
`UNIT_POWER_POINT_CHARGE`, and class/spec setup. Current source includes discrete
families such as combo points, charged combo points, soul shards, arcane charges,
holy power, and essence.

Generated Unit API marks `UnitPower`, `UnitPowerMax`, and charged-power-point reads
secret-capable under their restriction predicates.

Warlock source demonstrates why one generic percentage model is incorrect:
Destruction may display fractional shards while other specs floor shard power.

Result:
**SOURCE AVAILABLE; SECRET-FIRST RUNTIME PROOF REQUIRED; KEEP MECHANICS DISCRETE.**

## 6. Alternate power

Blizzard alternate power uses class/power-type selection plus secret-capable unit
power reads and its own event/lifecycle handling.

Result:
**SPECIALIZED SOURCE AVAILABLE; STOCK RETAINED.**

## 7. Possess / override / vehicle / extra action

ActionBarController reacts to vehicle/override/possess/extra/shapeshift events and
switches secure action pages or dedicated OverrideActionBar presentation.

Possess cancel may request taxi early landing, exit a vehicle, or cancel possession.
OverrideActionBar also carries vehicle exit and pitch controls. ExtraActionBar uses
the secure action-button path as a separate special surface.

Result:
**INTEGRATED SPECIAL-MODE SOURCES; NOT ORDINARY PRIMARY/SECONDARY/UTILITY.**

Source evidence does not justify suppressing or rerouting these controls.

## 8. Exact P0150 probe justified

P0150 may implement one bounded read-only diagnostic-only module that:
- reads pet action-bar presence and at most ten pet slots;
- reads current stance/form count/state;
- reads bounded totem slot state secret-first;
- reads current class/resource state secret-first;
- reads rune cooldown state only when naturally class-applicable;
- reads special-mode flags and ordinary bar indexes;
- invalidates from source-owned pet/form/totem/power/rune/special-bar/world events;
- discards event payloads and re-queries current state;
- stores sanitized addon-owned diagnostics only.

P0150 must not:
- cast or rearrange pet actions;
- toggle autocast;
- cast forms;
- dismiss totems;
- mutate action pages/state drivers;
- exit/cancel vehicles or possess state;
- invoke extra/override controls;
- suppress or mutate any Blizzard class/pet/special surface.

Environmental absence is **DEFERRED**, not FAIL.

## Result

P0149 resolves the source layer and accepts D-044.

The only especially strong control candidate is pet-action secure casting, but even
that is incomplete replacement ownership.

Production remains unchanged. P0150 read-only runtime proof is next.
