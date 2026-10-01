# B.3 — Target Presentation

Status: IMPLEMENTATION PREPARED; RUNTIME PROOF NEXT
Opened: 2026-10-01

## Goal

Add the minimum target information necessary for combat/world awareness without restoring a conventional target frame.

## Source resolution

### Target identity

`UnitName("target")` is available on Forever 1.60.1.

The name can become secret when unit-identity restrictions apply.

`FontString:SetText` accepts secret text arguments and adds the native Text secret aspect.

Therefore:

```text
UnitName("target")
    -> targetNameText:SetText(secretOrOrdinaryName)
```

No Lua inspection/conversion is required.

### Target existence

`UnitExists("target")` provides the ordinary existence branch used to show/hide the target block.

No target-name value is used for control flow.

### Target health

Use the native percent scale curve already introduced by B.2:

```text
UnitHealthPercent("target", true, percentScaleCurve)
    -> targetHealthText:SetFormattedText("%.0f%%", secretPercent)
```

### Events

Initial implementation refreshes on:
- `PLAYER_TARGET_CHANGED`;
- `UNIT_HEALTH` for target;
- `UNIT_MAXHEALTH` for target;
- `UNIT_NAME_UPDATE` for target.

## P0023 implementation

Adds to the existing HUD module:
- `LogresHUDTarget`;
- target name FontString;
- target health percentage FontString;
- target event frame;
- `UpdateTarget`;
- immersion re-enable refresh;
- hudcheck structural coverage.

Also renames the B.2 internal curve field from `resourceScaleCurve` to the more accurate `percentScaleCurve`, since B.3 shares it.

## Layout

First pass:

```text
center y=-54:
    Target Name
    Health %

center y=-118:
    Player Resource %
```

This leaves space for future cast-confirmation/action layout work.

## Disclosure

P0023 intentionally does not call:
- `UnitLevel`;
- `UnitClassification`.

It does not create:
- portrait;
- StatusBar;
- classification label.

Static HUD checks guard these boundaries.

## Target resource

Deferred from initial B.3.

Reason:
name + health percentage satisfies the minimum product need and avoids clutter/scope expansion.

## Runtime plan

After deploy:
1. confirm `0.0.10-dev`;
2. existing checks + `/logres hudcheck` pass;
3. clear target -> target block absent;
4. acquire ordinary target -> name + health % appear;
5. damage target -> health % updates;
6. switch target -> name/health update;
7. clear target -> block disappears;
8. immersion off/on -> hides/restores current target;
9. inspect an elite target if one is naturally convenient and confirm no level/classification is shown;
10. report any secret/Lua errors.

No dungeon travel is required solely to test elite disclosure.

## Coverage

Target identity may become secret in combat.

The runtime proof should include ordinary combat if practical so name/health forwarding is exercised under the restrictions that matter.

## Exit

B.3 completes when sparse target name + health percentage is runtime proven and D-003 disclosure remains intact.
