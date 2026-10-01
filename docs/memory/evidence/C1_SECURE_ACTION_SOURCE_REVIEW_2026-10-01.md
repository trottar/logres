# C.1 Secure Action Source Review — 2026-10-01

Status: SOURCE-RESOLVED
Date: 2026-10-01

## Scope

Resolve enough of World of Warcraft Forever's secure-action surface to design Logres' first action cluster without guessing.

Forever target:
- interface/game API family 1.60.1;
- secret-value restrictions enabled;
- protected-action/combat-lockdown model active.

## 1. Protected action execution

`UseAction(slot)` is protected.

The API documentation explicitly directs addons to the `"action"` type of `SecureActionButtonTemplate`.

Supported secure-button shape:

```lua
local button = CreateFrame(
    "Button",
    "LogresActionButton1",
    UIParent,
    "SecureActionButtonTemplate"
)

button:SetAttribute("type", "action")
button:SetAttribute("action", 1)
button:RegisterForClicks("AnyUp", "AnyDown")
```

Protected execution therefore belongs to the secure button.

Logres must not call `UseAction` from ordinary insecure Lua.

## 2. Combat lockdown

`InCombatLockdown()` is available on Forever 1.60.1.

While lockdown is active, normal insecure code cannot safely perform protected-frame mutation such as:
- Show/Hide protected frames;
- SetAttribute on protected frames;
- move/re-anchor protected frames;
- mutate normal/override key bindings;
- pick up actions from action slots.

Important timing detail retained from Phase 0:
`PLAYER_REGEN_DISABLED` can fire before `InCombatLockdown()` reports true.

Code must read the actual lockdown state rather than assuming event timing.

## 3. Secure state drivers

SecureStateDriver / AttributeDriver can:
- drive protected visibility;
- drive protected attributes;
- react to macro-condition state changes inside the secure environment.

Preferred modern terminology:
- `RegisterAttributeDriver`;
- StateDriver remains a bridge/deprecated naming layer.

Phase C may use a secure visibility/attribute driver where in-combat context switching is genuinely required.

Do not solve ordinary out-of-combat layout work with unnecessary secure snippets.

## 4. Action-slot presentation APIs

Forever 1.60.1 provides current `C_ActionBar` action presentation APIs including:
- `C_ActionBar.HasAction`;
- `C_ActionBar.GetActionTexture`;
- `C_ActionBar.IsUsableAction`;
- `C_ActionBar.IsActionInRange`;
- `C_ActionBar.EnableActionRangeCheck`;
- `C_ActionBar.GetActionCooldown`;
- `C_ActionBar.GetActionCooldownDuration`;
- `C_ActionBar.GetActionCharges`;
- `C_ActionBar.GetActionDisplayCount`;
- `C_ActionBar.RegisterActionUIButton`.

`GetActionInfo(slot)` also remains available on Forever 1.60.1.

## 5. Secret cooldown/count handling

Cooldown/charge/count APIs can return secrets under cooldown restrictions.

Do not:
- compare secret cooldown times/durations;
- subtract start/end times;
- stringify secret counts in Lua;
- branch on secret current-charge values.

Preferred cooldown path:

```text
C_ActionBar.GetActionCooldownDuration(slot)
    -> DurationObject
    -> Cooldown:SetCooldownFromDurationObject(duration)
```

`Cooldown:SetCooldownFromDurationObject` is the current native path intended to accept restricted duration information.

Preferred count path:

```text
C_ActionBar.GetActionDisplayCount(slot)
    -> FontString:SetText(secretOrOrdinaryString)
```

Do not read the FontString back for logic.

## 6. Ordinary action presentation data

Current source marks these as ordinary/usable for addon presentation:
- action occupancy;
- icon FileID;
- usability booleans;
- range booleans/events.

Initial Logres buttons may use those values for:
- icon texture;
- subdued unusable state;
- out-of-range visual state.

## 7. Native action-button registration

`C_ActionBar.RegisterActionUIButton(checkButton, actionID, cooldownFrame)` is available on Forever 1.60.1.

Its documented behavior includes native action-button checked-state registration and action visibility participation.

C.2 should use this registration for each Logres action button rather than recreating checked-state semantics unnecessarily.

## 8. Key bindings

Forever provides:
- `GetBindingKey`;
- `SetOverrideBindingClick`;
- `ClearOverrideBindings`.

`SetOverrideBindingClick`:
- is no-combat;
- creates session-only override bindings;
- does not permanently rewrite the user's saved binding set.

`ClearOverrideBindings` restores the overridden bindings.

### C.2 binding policy

For primary buttons 1–12:
- read existing `ACTIONBUTTON1` … `ACTIONBUTTON12` keys;
- point those keys at the corresponding named Logres secure button with non-persistent override click bindings;
- clear overrides when the action module is disabled;
- refresh after `UPDATE_BINDINGS`;
- if refresh is requested during combat, defer until `PLAYER_REGEN_ENABLED`.

Do not use `SetBinding`/`SaveBindings` to silently rewrite user bindings.

## 9. Drag/drop editing

`PickupAction(slot)` is explicitly no-combat.

C.2 does not need drag/drop editing to prove secure action execution.

Initial C.2 should therefore:
- display/execute existing action slots;
- leave action arrangement editing to a later Phase C work item;
- keep stock Blizzard action bars visible during C.2 so the user retains a familiar editing surface.

This follows D-017:
replacement must be proven before suppression.

## 10. Action events

Useful Forever/current action events include:
- `ACTIONBAR_SLOT_CHANGED`;
- `ACTIONBAR_UPDATE_COOLDOWN`;
- `ACTION_USABLE_CHANGED`;
- `ACTION_RANGE_CHECK_UPDATE`;
- `UPDATE_BINDINGS`;
- `ACTIONBAR_PAGE_CHANGED`;
- shapeshift/override-related updates as required.

C.2 should start with the minimum event set needed for the primary cluster and expand only when runtime evidence requires it.

## 11. Blizzard source precedent

Current Blizzard ActionButton source demonstrates the native pattern:
- secure action attributes;
- action-button registration;
- action slot updates;
- usability/range/cooldown event routing;
- hotkey lookup;
- drag/drop through action-slot APIs.

This source is architectural precedent, not proof that every current Retail FrameXML mixin/template is flavor-identical on Forever.

Forever API availability above is verified separately through API documentation.

## Sources

Warcraft Wiki:
- `https://warcraft.wiki.gg/wiki/SecureActionButtonTemplate`
- `https://warcraft.wiki.gg/wiki/API:UseAction`
- `https://warcraft.wiki.gg/wiki/InCombatLockdown`
- `https://warcraft.wiki.gg/wiki/SecureStateDriver`
- `https://warcraft.wiki.gg/wiki/API:SetOverrideBindingClick`
- `https://warcraft.wiki.gg/wiki/API:ClearOverrideBindings`
- `https://warcraft.wiki.gg/wiki/API:PickupAction`
- `https://warcraft.wiki.gg/wiki/API:C_ActionBar.RegisterActionUIButton`
- `https://warcraft.wiki.gg/wiki/API:C_ActionBar.GetActionTexture`
- `https://warcraft.wiki.gg/wiki/API:C_ActionBar.IsUsableAction`
- `https://warcraft.wiki.gg/wiki/API:C_ActionBar.EnableActionRangeCheck`
- `https://warcraft.wiki.gg/wiki/API:C_ActionBar.GetActionCooldownDuration`
- `https://warcraft.wiki.gg/wiki/API:C_ActionBar.GetActionDisplayCount`
- `https://warcraft.wiki.gg/wiki/API:Cooldown_SetCooldownFromDurationObject`
- `https://warcraft.wiki.gg/wiki/ACTIONBAR_SLOT_CHANGED`
- `https://warcraft.wiki.gg/wiki/ACTION_USABLE_CHANGED`
- `https://warcraft.wiki.gg/wiki/ACTION_RANGE_CHECK_UPDATE`

Reference source:
- `https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_ActionBar/Shared/ActionButton.lua`
