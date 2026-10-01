# Developer / Control Panel Architecture

## Purpose

Provide one in-game surface for repeated Logres validation and basic development controls.

The panel reduces command-copying friction during runtime test loops.

## Ownership

`Core/Commands.lua` owns:
- command handlers;
- diagnostic behavior;
- output routing;
- panel-action registration.

`Dev/Panel.lua` owns:
- window/frame construction;
- action buttons;
- scrolling result display;
- movable/close behavior.

The GUI calls the command contract. It does not implement independent versions of checks.

## Command output routing

Normal slash invocation:

```text
command handler
    -> emit(...)
    -> chat print
```

Panel invocation:

```text
DevPanel button
    -> Logres:RunDevCommand(command, outputSink)
    -> emit(...)
    -> scrolling panel results
```

## Action registration

Commands intended for the panel register:

```text
Logres:RegisterDevPanelAction(id, label, command)
```

The panel enumerates current registrations at initialization/show time.

## Immersion separation

`LogresDevPanel` is parented to `UIParent`, not `LogresHUDRoot`.

It therefore survives immersion-off presentation changes.

This is required so the control that restores immersion remains accessible.

## Current status

P0029:
- first implementation;
- development-only visual language;
- movable;
- auto-opens on reload;
- supports Run All + individual checks + immersion/preview controls.

Final menu/settings design remains later work.
