# C.4 Context Visibility / Secure Paging Source Review — 2026-10-01

Status: SOURCE-RESOLVED
Date: 2026-10-01

## Goal

Resolve:
- combat-safe contextual visibility/emphasis;
- Primary combat-time action-page behavior;
- safe capability gates before stock action-bar suppression.

## 1. Protected frame mutation

Forever uses combat lockdown.

Ordinary insecure code cannot safely:
- Show/Hide protected frames;
- SetAttribute on protected frames;
- re-anchor/move protected frames;
- change protected bindings;

during lockdown.

`InCombatLockdown()` remains the authoritative guard.

## 2. Alpha is presentation, not hiding

`Region:SetAlpha` / `Frame:SetAlpha` is available as a presentation operation
and is not the same as protected Show/Hide.

Important behavior:
an alpha-zero frame remains present and interactable.

Therefore C.4 must not use alpha `0` as a fake secure hide for action buttons.

### C.4 policy

Use alpha only for emphasis:
- Primary remains fully legible;
- Secondary can become subdued;
- Utility can become strongly subdued but still visibly present.

Keep all proof-stage action controls clickable.

If true contextual disappearance is later required:
use a verified secure visibility driver instead.

## 3. Secure visibility/state drivers

SecureStateDriver / AttributeDriver can securely:
- drive visibility;
- drive arbitrary attributes;

from macro-condition state.

The driver is evaluated securely across relevant state changes including:
- action-bar page;
- bonus action bar;
- shapeshift;
- combat transitions;
- world entry.

`RegisterStateDriver` is a compatibility bridge over attribute drivers.

Preferred architecture terminology:
**AttributeDriver / SecureStateDriver**.

## 4. Secure command conditionals

Current secure macro conditions include:
- `bar:n`;
- `bonusbar:n`;
- `vehicleui`;
- `overridebar`;
- `possessbar`;
- `shapeshift`;
- `combat`.

These conditionals can be consumed through SecureStateDriver.

`SecureCmdOptionParse` is documented for Forever 1.60.1.

## 5. Built-in secure action paging

`SecureActionButtonTemplate` action execution supports action paging.

If a secure action button has:
- `type = "action"`;
- a positive button ID;
- an `actionpage` modified attribute;

the secure action calculation resolves:

```text
button ID + ((actionpage - 1) * 12)
```

rather than requiring insecure Lua to rewrite the concrete `action` attribute
for every page transition.

This is the preferred C.4 direction for Primary.

## 6. Primary normal-page driver

Normal primary pages can be expressed securely through the action-page
conditionals:

```text
[bar:2] 2;
[bar:3] 3;
[bar:4] 4;
[bar:5] 5;
[bar:6] 6;
1
```

Bonus-bar conditionals are also expressible.

Current Blizzard source continues to distinguish additional special states:
- vehicle action bar;
- override action bar;
- temporary shapeshift action bar;
- bonus action bar;
- normal action-bar page.

The relevant C_ActionBar index APIs exist in the current API family.

## 7. Special-page capability gate

Do not assume one generic page driver is complete until runtime proof covers:
- ordinary page switching;
- class bonus/form states;
- temporary shapeshift;
- vehicle;
- override/quest action states;
- possess state where relevant.

A source-level conditional can be built for these states, but the exact Forever
runtime semantics must still be proven.

Until then:
- stock Blizzard primary/special bars remain visible;
- Logres must not claim full replacement coverage.

## 8. Presentation registration

Current C_ActionBar API includes:

```text
C_ActionBar.RegisterActionUIButton
C_ActionBar.UnregisterActionUIButton
```

and they are available on Forever 1.60.1.

When Primary switches to secure `actionpage` execution, Logres presentation
still needs to track the active concrete action slots for:
- icons;
- native checked-state registration;
- cooldown/count/range/usability refresh.

The first implementation should keep secure execution and ordinary
presentation synchronization as separate concerns.

Runtime proof is required before deleting the old post-combat refresh fallback.

## 9. Context policy inputs

Use the existing observed-state contract.

Relevant orthogonal inputs:
- `combat`;
- `pvpFlagged`;
- `context`.

Do not introduce a monolithic combined action mode.

Initial policy precedence:

```text
combat > pvpFlagged > context/default
```

This is presentation precedence only.

Observed state remains independent flags.

## 10. Initial visual weighting

First-pass C.4 target:

### Primary

Always:
- alpha 1.00.

### Secondary

- ordinary world idle: approximately 0.45;
- PvP flagged idle: approximately 0.75;
- instance idle: approximately 0.70;
- combat: 1.00.

### Utility

- ordinary world idle: approximately 0.20;
- PvP flagged idle: approximately 0.40;
- instance idle: approximately 0.45;
- combat: approximately 0.75.

These are tuning constants, not product invariants.

Important:
no state uses alpha 0.

## 11. Interaction

C.4 emphasis does not disable interaction.

A subdued button remains:
- visible;
- clickable;
- key-usable.

This preserves fail-open access while contextual policy is being proven.

Any future policy that disables mouse interaction or fully hides a protected
cluster requires a separate secure-interaction/visibility decision.

## 12. D-020 compatibility

C.4 policy should be expressed as cluster-role policy rather than hardcoded
frame-name logic wherever practical.

Future profile-driven clusters need to consume the same roles:
- Primary;
- Secondary;
- Utility;
- later Micro Utility / custom roles.

The full layout editor remains deferred.

## Sources

Warcraft Wiki:
- `https://warcraft.wiki.gg/wiki/InCombatLockdown`
- `https://warcraft.wiki.gg/wiki/API:Region_SetAlpha`
- `https://warcraft.wiki.gg/wiki/SecureStateDriver`
- `https://warcraft.wiki.gg/wiki/SecureHandlerStateTemplate`
- `https://warcraft.wiki.gg/wiki/Macro_conditionals`
- `https://warcraft.wiki.gg/wiki/API:SecureCmdOptionParse`
- `https://warcraft.wiki.gg/wiki/Secure_action_button`
- `https://warcraft.wiki.gg/wiki/API:C_ActionBar.RegisterActionUIButton`

Blizzard source mirrors:
- `https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_ActionBarController/ActionBarController.lua`
- `https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_FrameXML/SecureTemplates.lua`
