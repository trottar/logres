# P0003 — I-001 runtime pass 01

Date: 2026-09-30  
Result: PREPARED — not durable until user commits/pushes

## Intent

Preserve the first WoW Forever runtime evidence and fix the diagnostic probe compatibility failure discovered during that run.

## Negative result preserved

Initial `/lapi snapshot` failed at probe line 38 because `table.pack` is unavailable in the Forever Lua environment.

No API conclusion was drawn from that failed attempt.

Fix:
- local `pack(...)` compatibility helper;
- all `table.pack(...)` usages replaced.

## Probe extension for pass 02

Adds a guarded custom inverse/threshold curve diagnostic built with `C_CurveUtil.CreateCurve()` and `AddPoint(...)`. The probe records whether the curve can consume secret health percentage and drive bar value/alpha without exposing the value to Lua.

## Runtime findings promoted

- Forever build/interface/project identity;
- secret player health/power behavior;
- secret-safe text/bar/alpha display transport;
- ordinary target metadata;
- open-world position/facing;
- chat-lockdown read;
- camera/CVar read;
- SavedVariables persistence;
- combat event/restriction timing nuance.

## Raw evidence policy

The raw user SavedVariables file is not committed because it contains session-specific map coordinates.

Commit only the sanitized evidence summary.

## Validation

Before commit:
- `python3 tools/check_memory_health.py`
- `git diff --check`
- review `git diff --stat`
- verify probe contains no `table.pack(`

## Next

After P0003 is pushed:
- copy the updated probe into the live AddOns folder;
- `/reload`;
- run targeted runtime pass 02.
