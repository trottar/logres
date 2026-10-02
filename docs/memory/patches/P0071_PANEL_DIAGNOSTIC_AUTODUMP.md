# P0071 — Developer-Panel Diagnostic Autodump

Date: 2026-10-01
Result: PREPARED

## Baseline

P0070 verified pushed:

`f99afa9b74029a59ec78021715acdf1f32ded078`

## Runtime

`0.0.28-dev -> 0.0.29-dev`

## Purpose

Make the established developer panel the complete diagnostic workflow.

## Changes

- adds `LogresDiagnosticsDB` SavedVariables persistence;
- records every developer-panel command run;
- records every emitted human-readable result line;
- bounded to 100 runs / 120 lines per run;
- adds stable WSL export helper:
  `tools/export_panel_diagnostics.py`;
- updates developer-panel static contract;
- records the workflow correction durably.

## Runtime workflow

1. use developer panel;
2. `/reload` to flush SavedVariables;
3. `python3 tools/export_panel_diagnostics.py`;
4. provide `LOGRES_DIAGNOSTICS_LATEST.lua`.

No in-game text copying.

## Scope

No waypoint UI implementation.
No minimap change.
No navigation-state mutation.
