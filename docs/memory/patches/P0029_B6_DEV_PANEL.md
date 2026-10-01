# P0029 — B.6 developer/control panel

Date: 2026-10-01
Result: PREPARED — runtime proof pending

## Trigger

B.6 manual validation required repeatedly issuing:

```text
/logres status
/logres statecheck
/logres preferencecheck
/logres lifecyclecheck
/logres hudcheck
```

The user requested a small in-game GUI to remove that repeated copy/paste and provide the foundation for a later real menu.

## Runtime changes

Adds:
- `Dev/Panel.lua`;
- reusable command-output routing;
- command/action registration for panel buttons;
- `/logres panel`;
- `/logres checkall`;
- `/logres` with no argument toggles panel.

Panel controls:
- Run All;
- Status;
- State Check;
- Sensor Check;
- Preference Check;
- Lifecycle Check;
- HUD Check;
- Immersion ON/OFF;
- HUD Preview ON/OFF;
- Clear.

## Architecture

The panel calls:

```text
Logres:RunDevCommand(command, outputSink)
```

It does not duplicate diagnostic logic.

Future panel actions can register through:

```text
Logres:RegisterDevPanelAction(id, label, command)
```

## Immersion behavior

The panel is parented directly to `UIParent`.

It intentionally remains visible while the immersive HUD is hidden.

## Version

`0.0.12-dev -> 0.0.13-dev`

## B.6

The B.6 integrated runtime pass is reset to use this panel as the validation surface.

Runtime proof of P0029 is required before Phase B can close.
