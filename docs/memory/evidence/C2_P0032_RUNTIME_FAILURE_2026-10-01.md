# C.2 P0032 Runtime Failure — 2026-10-01

Status: REAL RUNTIME FAILURE
Baseline: `9f9f97dd1be2a770e42855f9d0ff003dcb85429c`

## Observed

Working:
- Logres 4 x 3 action cluster rendered;
- action icons/presentation updated;
- buttons turned red when actions were out of range.

Failed:
- clicking Logres action buttons did not execute actions;
- existing action keybinds stopped executing after Logres automatically
  routed them through the nonfunctional buttons.

Visual issue:
- buttons showed both internal `1–12` labels and actual keybind labels.

## Interpretation

The ordinary presentation/event path is alive.

The protected execution path failed.

Because P0032 installed override click bindings automatically, the execution
failure also caused a critical input regression.

## Source-supported correction hypothesis

Current Blizzard action-button setup includes:

```lua
SetAttribute("type", "action")
SetAttribute("typerelease", "actionrelease")
RegisterForClicks(
    "AnyUp",
    "LeftButtonDown",
    "RightButtonDown"
)
```

P0032 only registered `AnyUp`.

P0033 adopts the fuller secure click/release configuration.

This remains a hypothesis until runtime-proven.

## Safety correction

P0033 changes action-key takeover to fail open.

Default after reload:
- no Logres override key routing;
- normal Blizzard ACTIONBUTTON keybinds remain active;
- Logres still displays the key labels.

Developer panel controls:
- Action Keys ON;
- Action Keys OFF.

Both mouse and keyboard paths are still tested in the same validation pass,
but the routing toggle provides an immediate recovery path.

## Visual correction

P0033 removes the extra internal `1–12` slot labels.

Only meaningful keybind/count/cooldown presentation remains.

## Retry criteria

P0033 must prove:
- stock keys work with Action Keys OFF;
- Logres mouse execution works;
- Action Keys ON makes existing keys execute via Logres;
- Action Keys OFF releases temporary routing;
- ordinary combat execution works;
- no protected/taint/Lua/secret errors occur.
