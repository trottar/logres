# P0070 — Waypoint Probe Developer-Panel Integration

Date: 2026-10-01
Result: PREPARED — RUNTIME PROOF PENDING

## Baseline

P0069 verified pushed:

`9e637d5aa68fe8c11da95b91f3668fbb3c84dcb0`

Production runtime:

`0.0.28-dev`

## Purpose

Correct the P0069 runtime workflow so E.3 validation uses the established Logres
developer panel.

## Changes

- exposes the temporary waypoint probe through `LogresWaypointAudit_Run(output)`;
- adds `runWaypointProbe()` to Logres commands;
- adds `Waypoint Probe` developer-panel action;
- routes probe evidence into the existing panel result output;
- keeps `/lwpa` only as fallback/debug access;
- records the P0069 handoff failure durably.

## Non-scope

No:
- waypoint marker implementation;
- minimap mutation/suppression;
- navigation-state mutation;
- production compass policy change.

## Runtime next

After deployment and `/reload`, use the developer panel:
`Waypoint Probe`.

Run it for:
1. no user waypoint;
2. active user waypoint at known direction;
3. after waypoint change/clear;
4. super-tracked quest with visible destination.

The panel output is the evidence source.
