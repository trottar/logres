# C.2 — Primary Action Cluster

Status: IMPLEMENTATION PREPARED; RUNTIME PROOF NEXT
Opened: 2026-10-01

## Goal

Prove the first Logres secure action cluster without suppressing Blizzard's
stock action bars.

## P0032 implementation

Adds 12 named secure buttons:

```text
LogresPrimaryActionButton1
...
LogresPrimaryActionButton12
```

Layout:
- 4 columns;
- 3 rows;
- 38 px buttons;
- 5 px gaps;
- lower-center anchor around y = -260.

This is first-pass functional geometry, not final art.

## Secure execution

Each button is a `CheckButton` inheriting:

```text
SecureActionButtonTemplate
```

Attributes:

```text
type = "action"
action = current action slot
```

The button registers `AnyUp`.

Logres does not call protected `UseAction`.

## Current action page

On enable, P0032 reads:

```text
C_ActionBar.GetActionBarPage()
```

and maps the visible 12-button cluster to that page's 12 action slots.

Out-of-combat `ACTIONBAR_PAGE_CHANGED` updates secure action attributes and
native action-button registration.

If a page change occurs during combat:
- ordinary protected mutation is not attempted;
- `pendingPageRefresh` is set;
- refresh occurs on `PLAYER_REGEN_ENABLED`.

### C.2 limitation

This is intentionally not the final combat-time paging architecture.

If the primary bar page changes while combat lockdown is active, the Logres
cluster retains its previously configured secure slots until combat ends.

Stock Blizzard action bars remain visible.

A later Phase C item must use a verified secure state-driver solution before
stock action-bar suppression can be considered safe.

## Native action presentation

Each button uses:
- `C_ActionBar.RegisterActionUIButton`;
- `C_ActionBar.GetActionTexture`;
- `C_ActionBar.GetActionCooldownDuration`;
- `Cooldown:SetCooldownFromDurationObject`;
- `C_ActionBar.GetActionDisplayCount`;
- `C_ActionBar.IsUsableAction`;
- `C_ActionBar.IsActionInRange`;
- `C_ActionBar.EnableActionRangeCheck`.

## Secret boundary

Display count:

```text
GetActionDisplayCount
    -> FontString:SetText
```

No Lua inspection.

Cooldown:

```text
GetActionCooldownDuration
    -> DurationObject
    -> Cooldown:SetCooldownFromDurationObject
```

No Lua timing arithmetic/comparison.

## Binding strategy

Existing:

```text
ACTIONBUTTON1
...
ACTIONBUTTON12
```

keys are read with `GetBindingKey`.

All returned keys are temporarily routed through:

```text
SetOverrideBindingClick
```

to the matching named Logres button.

Rules:
- no saved binding rewrite;
- no `SaveBindings`;
- overrides are session-only;
- binding refresh in combat is deferred;
- module cleanup clears overrides out of combat.

The first key is displayed on each button.

## Events

P0032 listens for:
- ACTIONBAR_SLOT_CHANGED;
- ACTIONBAR_UPDATE_COOLDOWN;
- ACTIONBAR_UPDATE_STATE;
- ACTIONBAR_UPDATE_USABLE;
- ACTION_USABLE_CHANGED;
- ACTION_RANGE_CHECK_UPDATE;
- ACTIONBAR_PAGE_CHANGED;
- UPDATE_BINDINGS;
- PLAYER_REGEN_ENABLED;
- PLAYER_ENTERING_WORLD.

## Diagnostics

Adds:

```text
/logres actioncheck
```

and developer-panel:

```text
Action Check
```

`Run All` now includes Action Check.

## Stock Blizzard UI

Stock action bars remain visible.

C.2 is proof of Logres execution/presentation, not replacement/suppression.

## Runtime proof plan

After deployment:
1. panel version is `0.0.14-dev`;
2. Run All includes Action Check PASS;
3. Logres cluster appears as 4x3;
4. actions/icons match the current primary bar page;
5. click at least one safe action in Logres;
6. use its existing keyboard key and confirm action fires;
7. trigger a cooldown and observe the sweep;
8. observe count/charge text if a current action naturally has one;
9. observe unusable/resource/range tint if convenient;
10. enter ordinary combat and confirm click/key actions still work;
11. confirm no forbidden-action/taint/Lua/secret error;
12. stock Blizzard action bars remain present.

Optional out-of-combat page test:
- switch primary action page if available;
- cluster should remap after page change.

Do not deliberately manufacture a combat-time page change solely for C.2.
That path is a documented limitation awaiting secure paging work.

## Exit

C.2 completes when:
- 12-button secure cluster is structurally proven;
- mouse execution works;
- existing keyboard binding execution works;
- icon/cooldown/count transport is error-free;
- combat execution works;
- no protected mutation error appears;
- stock bars remain available.
