# P0066 — Resolve E.1 Compass / Navigation Contract

Date: 2026-10-01
Result: INSTALLED / PUSHED (`586d188d`)

## Baseline

P0065 verified pushed:

`46271f97`

Runtime:

`0.0.27-dev`

## Purpose

Close E.1 with a source-backed navigation capability contract and open E.2.

## Decision

D-029 accepted.

First runtime slice:
**heading-only world compass**.

It uses:
- `GetPlayerFacing()`;
- existing State world/instance context;
- persisted Immersion preference;
- module-local throttled refresh.

It does not use:
- player position;
- quest/user waypoints;
- distance;
- minimap suppression.

## Waypoint boundary

Position and waypoint APIs are available enough to justify later focused work,
but not enough to declare waypoint bearing runtime-safe.

E.3 will separately prove waypoint retrieval, events, map/world conversion, and
bearing orientation.

## Runtime

No runtime-code change.

No WoW redeploy is required.

## Next

P0066 is verified pushed at `586d188d`.

Implement E.2 on runtime target `0.0.28-dev`.
