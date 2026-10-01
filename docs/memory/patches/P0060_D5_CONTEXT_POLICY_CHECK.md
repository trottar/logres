# P0060 — D.5 Context Policy Check

Date: 2026-10-01
Result: PREPARED — runtime proof pending

## Baseline

P0059 verified pushed:
`b245170`

Runtime:
`0.0.25-dev`

## Runtime

Version:
`0.0.25-dev -> 0.0.26-dev`

Adds:
- `/logres contextpolicycheck`;
- `Context Policy Check` developer-panel control;
- Context Policy Check to Run All;
- static D-028 context-policy checker.

## Behavior

No orchestration behavior changes.

The new diagnostic validates:
- State world/instance shape;
- immersion-owned replacement domains;
- Quiet Mode world-only policy;
- legal protected pending state in combat;
- ActionContext combat > PvP > instance > world precedence;
- expected action alpha values;
- Party/Primary capability gates.

## Secret safety

The check uses addon-owned state only.

It does not inspect Blizzard protected frame alpha, visibility, mouse, or
secret-capable presentation values.

## Runtime proof

World idle + Immersion ON/OFF are required.

Combat/PvP should be tested where safe.

Instance transition may remain environmental.
