# P0033 — Fix C.2 secure execution

Date: 2026-10-01
Result: PREPARED — runtime proof pending

## Trigger

P0032 runtime:
- cluster/presentation loaded;
- range tint worked;
- mouse execution failed;
- routed key execution failed;
- automatic override routing made normal primary keys unusable.

## Fix

Secure buttons now include:
- `typerelease = actionrelease`;
- `AnyUp`;
- `LeftButtonDown`;
- `RightButtonDown`;
- self/focus/mouseover secure cast checks.

## Key safety

Automatic key takeover removed.

Default:
- Action Keys OFF;
- stock key commands active.

Developer panel:
- Action Keys ON;
- Action Keys OFF.

Both mouse and keyboard are tested in the same pass.

The toggle exists as an immediate recovery mechanism.

## Visual cleanup

Removes internal `1–12` labels.

## Version

`0.0.14-dev -> 0.0.15-dev`
