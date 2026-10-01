# Action Cluster Architecture

## Visual model

Logres uses compact square/rectangular button groups rather than treating the primary action interface as one long row.

Logical groups:
- Primary Cluster
- Secondary/Tertiary Clusters
- Utility Clusters

## Presentation intent

- Primary: persistently legible.
- Secondary/Tertiary: nearby and visually related; low opacity or hidden depending on state.
- Utility: normally absent/faded, revealed intentionally.
- Combat: increases relevant visibility.
- PvP flagged: increases caution/secondary visibility before combat.
- Instance: may use more conservative visibility rules.

## Secure execution contract

D-018 is authoritative.

Protected actions execute through `SecureActionButtonTemplate`.

Standard action-slot buttons use secure:
- `type = "action"`;
- `action = slot`.

Ordinary presentation code must not directly invoke protected `UseAction`.

## Protected mutation boundary

Protected action buttons and affected parents cannot be freely:
- shown/hidden;
- moved/re-anchored;
- re-attributed;
- rebound;

during combat lockdown.

Ordinary code checks `InCombatLockdown()`.

If an out-of-combat mutation is requested during combat:
- remember the requested refresh/change;
- apply after `PLAYER_REGEN_ENABLED`.

If a genuine combat-time conditional protected transition is needed, use a verified SecureStateDriver/AttributeDriver design.

## C.2 primary cluster

Initial implementation target:
- 12 buttons corresponding to the primary action-button domain;
- compact rectangular/square layout;
- named secure buttons;
- existing ACTIONBUTTON1–12 keys preserved through session override click bindings.

Stock Blizzard bars remain visible during C.2 proof.

## Action presentation

Prefer current Forever `C_ActionBar` APIs.

Ordinary:
- occupancy;
- icon;
- usability;
- range.

Secret-capable:
- cooldown duration;
- charges/count.

Cooldown:

```text
GetActionCooldownDuration
    -> DurationObject
    -> Cooldown:SetCooldownFromDurationObject
```

Count:

```text
GetActionDisplayCount
    -> FontString:SetText
```

Do not inspect secret cooldown/count values in Lua.

## Bindings

Do not silently rewrite the user's saved bindings.

For C.2:
- inspect `ACTIONBUTTON1`–`ACTIONBUTTON12` with `GetBindingKey`;
- install session override clicks to named Logres buttons;
- clear overrides on disable;
- update out of combat on `UPDATE_BINDINGS`;
- defer updates until combat ends if necessary.

## Editing

Full drag/drop editing is not part of C.2.

Stock Blizzard bars remain the action-layout editing surface until later Phase C work proves a Logres editing path.

## Suppression

D-017 governs stock-bar suppression.

Action bars stay visible until Logres:
- executes actions reliably;
- preserves keybinds;
- handles required page/special-bar behavior;
- provides restoration.
## C.2 implementation boundary

P0032 implements the first live secure cluster.

Geometry:
- 12 buttons;
- 4 x 3;
- lower center;
- stock Blizzard action bars retained.

The current primary action page is mapped to 12 secure action attributes
out of combat.

Binding:
- reads `ACTIONBUTTON1` through `ACTIONBUTTON12`;
- applies temporary override clicks;
- displays the first existing key;
- never saves/reassigns the user's persistent bindings.

Presentation:
- icon;
- native cooldown DurationObject;
- direct display count;
- usability tint;
- range tint;
- native checked-state registration.

Combat:
- action execution remains secure;
- ordinary page/binding protected mutation is deferred until combat ends.

Known C.2 limitation:
combat-time primary-page changes are not yet secure-driven and therefore do
not reconfigure Logres buttons until `PLAYER_REGEN_ENABLED`.

This limitation blocks stock action-bar suppression, not the C.2 proof.
## C.2 execution failure correction

P0032 demonstrated that presentation and secure execution are separate proof
domains.

Presentation updated correctly while secure action execution was inert.

P0033 aligns the click/release setup with Blizzard action-button precedent:
- `type = action`;
- `typerelease = actionrelease`;
- `AnyUp`;
- `LeftButtonDown`;
- `RightButtonDown`.

P0033 also makes temporary primary-key routing opt-in until runtime proof is
complete.

The test still covers both mouse and keyboard execution.

The toggle exists to guarantee fail-open recovery, not to reduce test scope.
## C.2 final result

C.2 secure primary action execution is production-proven after the P0033
correction.

Verified:
- mouse secure execution;
- existing-key secure execution;
- range presentation;
- 4 x 3 primary geometry.

P0032's failed automatic key takeover is retained as negative evidence.

P0033's fail-open Action Keys controls remain the safe development model.

Known non-blocking visual debt:
cast/channel cues still appear but their color differentiation became
imperceptible during the P0033 test. Cause remains unisolated.

## C.3 entry

C.3 extends the proven secure-button architecture to secondary/utility action
domains.

Implementation should first refactor common secure action-button behavior into
reusable cluster primitives rather than cloning the primary module.

Contextual visibility policy remains primarily C.4 work.

Stock Blizzard bars remain visible during C.3 proof.
## C.3 source resolution

D-019 selects the first persistent extra-action domains:

Secondary:
- slots 61–72;
- MULTIACTIONBAR1BUTTON1–12.

Utility:
- slots 49–60;
- MULTIACTIONBAR2BUTTON1–12.

These are fixed-slot clusters, so unlike Primary they do not need page
remapping.

Initial geometry:

```text
Secondary      Primary       Utility
   3 x 4         4 x 3         3 x 4
```

C.3 extracts common secure button/presentation construction but deliberately
does not replace all proven Primary orchestration in one step.

C.4 remains the owner of state-driven cluster visibility.

Bars 4–8 remain stock-only after the first C.3 implementation and therefore
cannot be suppressed.
## C.3 P0036 implementation

Reusable secure presentation now lives in:

```text
Actions/Button.lua
```

It provides common button construction and action presentation.

Primary retains its proven page/binding orchestration.

New fixed clusters:

Secondary:
- slots 61–72;
- 3 x 4;
- left of Primary;
- MULTIACTIONBAR1BUTTON binding labels/routing.

Utility:
- slots 49–60;
- 3 x 4;
- right of Primary;
- MULTIACTIONBAR2BUTTON binding labels/routing.

All new key routing is fail-open and opt-in during proof.

Static alpha weighting is presentation-only.

C.4 remains responsible for context-driven visibility.

No stock bar suppression occurs in P0036.
