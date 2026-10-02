# P0067 — E.2 Heading-Only World Compass

Date: 2026-10-01
Result: INSTALLED / PUSHED — USER-REPORTED REQUESTED RUNTIME PASS (`931f068e`)

## Baseline

P0066 verified pushed:

`586d188d`

Runtime:

`0.0.27-dev`

## Runtime

Version:

`0.0.27-dev -> 0.0.28-dev`

## Purpose

Implement the first D-029 Phase E runtime slice.

## Changes

- adds `Navigation/Compass.lua`;
- top-center cardinal/intercardinal heading tape;
- Immersion + existing State context gating;
- secret-safe `GetPlayerFacing()` sampling;
- no stale/fabricated heading fallback;
- throttled world-only facing refresh;
- addon-owned Compass diagnostics;
- `/logres compasscheck`;
- `Compass Check` developer-panel action;
- Compass Check in Run All;
- new D-029/E.2 static checker;
- version-neutral repair to the older D.6 restoration checker;
- synchronized Phase E durable memory.

## Delivery failures preserved

P0067 delivery exposed several assistant/static-tooling failures before the final
successful apply.

Canonical record:
`docs/memory/evidence/E2_P0067_STATIC_CHECKER_FAILURE_2026-10-01.md`

The final pushed checkpoint preserves those failures rather than erasing them.

## Explicit non-scope

No:
- C_Map position dependency;
- waypoint markers;
- quest presentation;
- distance;
- route/path guidance;
- minimap suppression.

## Runtime proof

Commit:
`931f068e`

The user reported all requested final runtime checks passed:
- open-world Compass Check;
- heading movement;
- N/E/S/W orientation;
- Immersion OFF suspension;
- Immersion ON restoration;
- Run All;
- no Lua/taint/secret regression reported;
- minimap unchanged.

Direct natural-instance transition behavior for the P0067 module was not
separately exercised in that final requested validation sequence.

That remains an explicit environmental deferral under the accepted E.2 exit
rule, with I-001 restricted-context evidence preserved.

Runtime evidence:
`docs/memory/evidence/E2_P0067_RUNTIME_PASS_2026-10-01.md`

## Result

E.2 is COMPLETE.

Next:
E.3 waypoint-bearing capability/proof.
