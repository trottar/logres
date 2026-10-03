# Developer / Control Panel Architecture

## Purpose

Provide one in-game surface for repeated Logres validation and basic development
controls without allowing the validation UI itself to become an unreadable
flat control wall.

The panel reduces command-copying friction during runtime test loops.

## Ownership

`Core/Commands.lua` owns:
- command handlers;
- diagnostic behavior;
- output routing;
- panel-action registration and roadmap-phase metadata.

`Dev/Panel.lua` owns:
- window/frame construction;
- roadmap-phase tabs;
- selected-phase action buttons;
- scrolling result display;
- movable/close behavior.

The GUI calls the command contract. It does not implement independent versions
of checks.

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
Logres:RegisterDevPanelAction(id, label, command, phase)
```

`phase` must be exactly one roadmap phase ID:
`0`, `A`, `B`, `C`, `D`, `E`, `F`, `G`, or `H`.

The panel enumerates registrations through:

```text
Logres:GetDevPanelActions()
```

Each returned action includes its phase. The panel renders only actions assigned
to the currently selected phase.

## Phase-tab contract

The panel always exposes one compact tab for each roadmap phase:
- 0 — Foundation;
- A — Core State Engine;
- B — Core HUD;
- C — Action Interface;
- D — Immersion Controller;
- E — Compass and Navigation;
- F — Quest Experience;
- G — Cinematic Camera;
- H — Integration and Polish.

Phase G is the default selected tab while G.3 is active. Empty phases remain
visible; an empty selected phase shows a small no-diagnostics message rather than
collapsing the roadmap structure.

The current selected-phase control area supports at most 12 actions arranged as
three columns by four rows. The static panel contract enforces that bound.

Global/foundation diagnostics such as Run All and Status belong to Phase 0.

## Diagnostic persistence

Tab selection does not partition or discard results. Command runs continue to
append to the shared scrolling output and persist through
`LogresDiagnosticsDB` under the existing bounded run/line retention contract.

## Immersion separation

`LogresDevPanel` is parented to `UIParent`, not `LogresHUDRoot`.

It therefore survives immersion-off presentation changes. This is required so
the control that restores immersion remains accessible.

## Current status

P0029:
- first implementation;
- development-only visual language;
- movable;
- auto-opens on reload;
- supports Run All + individual checks + immersion/preview controls.

P0102:
- replaces the overflowing flat action grid with roadmap-phase tabs;
- requires phase metadata on every developer-panel action;
- preserves shared diagnostic persistence and slash-command behavior.

Final menu/settings visual design remains later work.
