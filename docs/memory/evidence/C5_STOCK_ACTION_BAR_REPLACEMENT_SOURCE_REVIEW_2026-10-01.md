# C.5 Stock Action-Bar Replacement Source Review — 2026-10-01

Status: SOURCE-RESOLVED FOR FIRST REPLACEMENT PASS
Date: 2026-10-01

## Goal

Identify the first Blizzard action-bar surfaces Logres can suppress without:
- changing the player's stock action-bar configuration;
- hiding unsupported action domains;
- breaking special vehicle/override/form actions;
- fighting Blizzard's protected visibility lifecycle.

## Source-confirmed multi-bar ownership

Current Blizzard `MultiActionBars.xml` defines:

### Stock Action Bar 2

Frame:
`MultiBarBottomLeft`

Binding prefix:
`MULTIACTIONBAR1`

Edit Mode system:
`Bar2`

Action page:
`6`

Concrete normal slots:
`61–72`

This matches Logres Secondary.

### Stock Action Bar 3

Frame:
`MultiBarBottomRight`

Binding prefix:
`MULTIACTIONBAR2`

Edit Mode system:
`Bar3`

Action page:
`5`

Concrete normal slots:
`49–60`

This matches Logres Utility.

## Blizzard owns shown/hidden state

Current `MultiActionBars.lua` evaluates the player's stock action-bar settings
and calls `frame:SetShown(true/false)` from `MultiActionBar_Update()`.

It also hides normal multi-bars when `MainActionBar` is not in the normal shown
state.

Therefore Logres should not attempt to own these stock frames by repeatedly
calling `Hide()`.

A later Blizzard update can legitimately call `SetShown(true)` again.

## First suppression mechanism

For the first C.5 proof, preserve Blizzard's own shown/hidden ownership.

When replacement is enabled out of combat:

1. snapshot the stock frame/button presentation state;
2. set the stock bar frame alpha to `0`;
3. disable mouse input on the stock bar and its action buttons;
4. enable the matching Logres key-routing domain.

The stock frame may remain technically shown according to Blizzard, but:
- it is visually absent;
- it has no invisible mouse interaction zone;
- keys route through the Logres replacement.

On replacement disable:
- restore the exact captured alpha;
- restore the exact captured mouse-enabled states;
- restore the prior Logres routing state.

Do not modify Blizzard's `PROXY_SHOW_ACTIONBAR_*` settings.

Those are player configuration and remain Blizzard/Edit Mode owned.

## Combat boundary

Action buttons are protected regions.

Protected-frame interactivity/visibility mutation is restricted in combat.

Therefore C.5 suppression/restoration transitions are out-of-combat
operations.

If the user requests a transition during combat:
- record the requested state;
- perform it after `PLAYER_REGEN_ENABLED`.

Once suppression is applied, its alpha/mouse state may remain through combat.

## MainActionBar is not first-pass suppressible

Current `ActionBarController.lua` shows that Blizzard can use `MainActionBar`
for multiple special states:

- bonus action bar;
- vehicle action bar;
- override action bar;
- temporary shapeshift action bar;
- normal primary page.

In some skinned vehicle/override states Blizzard hides `MainActionBar` and uses
`OverrideActionBar` instead.

Therefore globally suppressing `MainActionBar` before Logres has complete
special-state fallback is unsafe.

First C.5 proof leaves:
- `MainActionBar`;
- `OverrideActionBar`;
- possess/stance/special surfaces;

fully Blizzard-owned and visible as Blizzard decides.

## Unsupported stock bars remain visible

Current Logres does not yet replace every action domain the user uses.

Do not suppress:
- stock Bar 4;
- stock Bar 5;
- additional extra bars;
- compact six-slot layout domains.

Their future Logres representation belongs to D-020 profile/layout expansion.

## Reload behavior for first proof

The first runtime implementation should be fail-open and session-only:

- replacement defaults OFF after `/reload`;
- stock bars are therefore visible after reload;
- Logres replacement routing defaults to its existing safe state.

Do not persist stock suppression yet.

Persistence can be added after:
- suppression proof;
- restoration proof;
- combat deferral proof;
- failure recovery proof.

## First runtime target

P0044 should expose developer controls:

```text
Stock Bars Replace ON
Stock Bars Replace OFF
```

First ON scope:
- suppress `MultiBarBottomLeft`;
- suppress `MultiBarBottomRight`;
- enable Secondary key routing;
- enable Utility key routing.

First OFF scope:
- restore both stock bars exactly;
- restore prior Secondary/Utility routing state.

Primary stock bar remains visible.

## Required diagnostics

Replacement Check should report:
- requested replacement state;
- applied replacement state;
- pending combat-deferred state;
- Bar 2 frame found;
- Bar 3 frame found;
- saved/restored alpha;
- saved/restored mouse state count;
- Secondary routing state;
- Utility routing state;
- MainActionBar suppression = false;
- Bars 4–5 suppression = false.

## Sources

Current Blizzard source:
- `Interface/AddOns/Blizzard_ActionBar/Shared/MultiActionBars.xml`
- `Interface/AddOns/Blizzard_ActionBar/Shared/MultiActionBars.lua`
- `Interface/AddOns/Blizzard_ActionBarController/ActionBarController.lua`

Warcraft Wiki:
- `API:InCombatLockdown`
- `Object security`
- `API:ScriptRegion_IsProtected`
