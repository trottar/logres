# P0002 — I-001 source audit and runtime probe

Date: 2026-09-30  
Result: PREPARED — not durable until user commits/pushes

## Intent

Advance Phase 0.2 from a queued audit to an evidence-backed source pass and prepare the first in-client runtime probe.

## Source findings recorded

- Forever project-ID ambiguity;
- interface/TOC 16001 source evidence;
- modern secret-value system;
- health/power percentage APIs;
- secret-safe curves and widget aspects;
- level/classification availability;
- casting restrictions;
- secure-action/combat lockdown;
- world-only map position/facing;
- quest waypoint API;
- chat lockdown/restrictions;
- camera primitives.

## Diagnostic tool

Adds `tools/probes/LogresAPIAudit`.

The probe:
- performs no protected actions;
- sends no chat;
- changes no camera CVars;
- stores no secret values;
- records only sanitized booleans/non-secret scalar results.

## Negative-result policy

Any failed API call, secret result, unavailable value, instance restriction, or display-path failure is retained in the probe data. These are valid results, not reasons to discard a run.

## Validation required before commit

- `python3 tools/check_memory_health.py`
- `git diff --check`
- inspect `git status --short`
- inspect probe source before installing in WoW.

## Next result

After the user pushes P0002, run the in-client probe and create a separate runtime-evidence checkpoint. Do not mark I-001 runtime verified in this patch.
