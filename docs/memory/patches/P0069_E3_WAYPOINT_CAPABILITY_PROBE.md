# P0069 — E.3 Waypoint Capability Probe

Date: 2026-10-01
Result: INSTALLED / PUSHED — RUNTIME PROOF PENDING (`9e637d5a`)

## Baseline

P0068 verified pushed:

`740ebe15ae933dc50cbcd9482528a9ae6eb7f846`

Production runtime:

`0.0.28-dev`

## Purpose

Gather narrow Forever runtime evidence required by E.3 before production
waypoint presentation.

## Changes

Adds temporary diagnostic addon:
`tools/probes/LogresWaypointAudit`

Adds static probe contract:
`tools/check_waypoint_probe_contract.py`

Synchronizes E.3 investigation/current/roadmap memory.

## Probe scope

Records:
- player map/world position;
- current user waypoint;
- super-tracked quest ID/state;
- quest next-waypoint output;
- map->world conversion;
- event registration/firing counts;
- raw world delta;
- two candidate bearing-axis conventions.

## Safety

The probe:
- checks secret-capable inputs before inspection/arithmetic;
- never sets/clears a waypoint;
- never changes super-tracking;
- never mutates the minimap;
- never sends chat;
- never changes production Compass behavior.

## Runtime proof next

Run the E.3 matrix in:
`docs/memory/investigations/E3_WAYPOINT_BEARING_CAPABILITY_PROOF.md`

No production waypoint marker is authorized by this patch alone.

## Workflow correction

The initial runtime handoff incorrectly used `/lwpa` as the primary validation
surface instead of the established Logres developer panel.

P0070 corrects that workflow.
