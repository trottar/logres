# Current Handoff

Authoritative state: `../CURRENT.md`.

P0070 is verified pushed at `f99afa9b`.

Phase E / E.3 is active.

P0071 is prepared to make the developer panel auto-persist every diagnostic run
to `LogresDiagnosticsDB`.

Runtime target:
`0.0.29-dev`

Canonical runtime workflow after P0071:
- use developer-panel actions;
- panel output auto-persists to SavedVariables;
- `/reload` flushes;
- `python3 tools/export_panel_diagnostics.py`;
- review `LOGRES_DIAGNOSTICS_LATEST.lua`.

No manual copying from WoW text.

User performs all commits/pushes.
