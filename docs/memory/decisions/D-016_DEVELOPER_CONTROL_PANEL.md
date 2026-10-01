# D-016 — Developer control panel

Status: ACCEPTED
Date: 2026-10-01

## Decision

Logres provides a rudimentary in-game control/diagnostic panel during development.

The panel is the preferred manual validation surface for recurring runtime checks.

Slash commands remain supported as a fallback.

## Current controls

The panel exposes:
- Run All;
- Status;
- State Check;
- Sensor Check;
- Preference Check;
- Lifecycle Check;
- HUD Check;
- Immersion ON;
- Immersion OFF;
- HUD Preview ON;
- HUD Preview OFF;
- Clear results.

## Shared implementation

The GUI must not duplicate diagnostic logic.

`Core/Commands.lua` owns reusable command execution:

```text
Logres:RunDevCommand(command, outputSink)
```

Slash commands call the same execution path.

The panel captures output through `outputSink` and displays it in a scrolling result area.

## Extensibility

Future diagnostic/control buttons register through:

```text
Logres:RegisterDevPanelAction(id, label, command)
```

The panel builds its buttons from:

```text
Logres:GetDevPanelActions()
```

This keeps future validation commands from requiring a second GUI-specific implementation.

## Visibility

The developer panel is independent of the Phase B HUD root.

Therefore:
- `/logres immersion off` may hide the immersive HUD;
- the developer panel remains visible so immersion can be restored.

This independence is intentional.

## Access

During the current development phase:
- the panel auto-opens on module enable/reload;
- `/logres panel` toggles it;
- `/logres` with no argument also toggles it.

Auto-opening is a development workflow choice, not a final product-menu decision.

## Future

The panel is intentionally rudimentary.

It may later evolve into or inform the real Logres in-game settings/menu, but production settings architecture remains a later roadmap concern.
