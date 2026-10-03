# P0105 — G.4 City Camera Runtime Implementation

Date: 2026-10-03
Result: **INSTALLED / PUSHED — G.4 RUNTIME + INTEGRATION PASS**
Commit: `6956008033b3f86c5b70d68c50486a4bed0ecdf1`

## Baseline

P0104 verified pushed:
`0b6760838441a896b97a656099e38e6c6f399bfd`.

## Runtime

`0.0.42-dev -> 0.0.43-dev`.

## Purpose

Implement only the resolved G.4 City/resting zoom slice on top of the
runtime-proven G.3 production controller.

## Runtime change

`Logres/Camera/WorldCombat.lua` keeps its stable internal identifier for this
narrow compatibility-preserving extension and:
- defines City target 5;
- records resting state in addon-owned diagnostics;
- selects contexts in the accepted order: proven exclusions -> live combat ->
  City/resting -> World;
- uses the existing 2.5-second MoveView path for City;
- treats City <=5 as a no-op and never zooms outward to reach 5;
- preserves interruption, fail-open, DynamicCam coexistence, and probe gates.

No new resting event hook or poller was introduced; the existing State
subscription publishes resting changes.

## Diagnostics / static contract

The existing `cameraworldcombat` command IDs remain stable, while diagnostics
accept `context=city` and print resting state.

Added:
`tools/check_camera_city_contract.py`

The checker enforces City target/conditional behavior, live-combat-before-City
ordering, State-subscription reuse, City-aware diagnostics, and explicit scope
exclusions.

## Runtime acceptance

Canonical evidence:
`../evidence/G4_P0105_RUNTIME_PASS_2026-10-03.md`

Accepted runtime proof:
1. automatic resting transition selects `context=city`;
2. clean City >5 transition reaches target-5 tolerance;
3. City <=5 reports no-op and does not zoom outward;
4. leaving City fresh-evaluates the destination without remembered restore;
5. Run All completes cleanly;
6. DynamicCam loaded blocks/relinquishes Logres ownership;
7. accepted diagnostics retain `failures=0`, `secret=false`, `error=nil`.

The first City attempt from zoom 18 ending at reported zoom 0 is retained as
ambiguous environmental evidence. A later targeted retest passed cleanly.

Natural combat + resting overlap remains an environmental deferral while static
ordering remains enforced.

## Explicit exclusions

P0105 does not implement:
- DynamicCam City UI hide/fade;
- `cameraDistanceMaxZoomFactor`;
- reactive zoom;
- DynamicCam first-situation startup snapping;
- later DynamicCam situations;
- rotation or shoulder offsets.

## Deployment

Runtime code changed and was deployed for the accepted runtime proof.
