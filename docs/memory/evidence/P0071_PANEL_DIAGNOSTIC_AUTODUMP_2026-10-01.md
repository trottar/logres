# P0071 Panel Diagnostic Autodump — 2026-10-01

Status: PREPARED
Date: 2026-10-01
Baseline: `f99afa9b74029a59ec78021715acdf1f32ded078`

## User evidence immediately before P0071

The user provided the persisted waypoint audit reason index.

It proved:
- repeated `developer-panel` snapshots were captured;
- `USER_WAYPOINT_UPDATED` fired;
- `SUPER_TRACKING_CHANGED` fired.

Therefore P0070 panel integration is working.

## Workflow defect

The panel result text itself was not persisted by the core developer panel.

That forced external reconstruction from the structured probe database even
though the panel is the established runtime validation surface.

## Correction

P0071 adds generic developer-panel diagnostic persistence:

`LogresDiagnosticsDB`

Each `Panel:RunCommand(...)` stores:
- command;
- timestamp;
- emitted human-readable result lines.

Retention is bounded:
- 100 runs;
- 120 lines per run.

The data is a standard WoW SavedVariables global and is written by WoW on
`/reload` or logout.

## Export helper

`tools/export_panel_diagnostics.py`

The helper locates the newest Forever `Logres.lua` SavedVariables file and
copies it to:

`LOGRES_DIAGNOSTICS_LATEST.lua`

This gives one stable file to provide for evidence review.

## Limitation

WoW addons cannot arbitrarily write files to the filesystem at runtime.

Therefore the correct automatic persistence boundary is SavedVariables, flushed
by `/reload`/logout.

No manual copying from the in-game panel is required.
