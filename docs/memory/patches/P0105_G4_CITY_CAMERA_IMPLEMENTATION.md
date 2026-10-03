# P0105 — G.4 City Camera Runtime Implementation

Date: 2026-10-03
Result: PREPARED — RUNTIME IMPLEMENTATION; PROOF PENDING

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
narrow compatibility-preserving extension and now:
- defines City target 5;
- records resting state in addon-owned diagnostics;
- selects contexts in the accepted order: proven exclusions -> live combat ->
  City/resting -> World;
- uses the existing 2.5-second MoveView path for City;
- treats City <=5 as a no-op and never zooms outward to reach 5;
- preserves existing interruption, fail-open, DynamicCam coexistence, and probe
  gates.

No new resting event hook or poller is introduced; the existing State subscription
already publishes `PLAYER_UPDATE_RESTING` changes.

## Diagnostics / static contract

The existing `cameraworldcombat` command IDs remain stable, but diagnostics now
accept `context=city` and print `resting=<bool>`.

Adds:
`tools/check_camera_city_contract.py`

The G.4 checker enforces City target/conditional behavior, live-combat-before-City
ordering, State-subscription reuse, City-aware diagnostics, and the explicit
exclusion of UI fade, reactive zoom, camera-distance CVar ownership, timers, and
a new direct resting hook.

## Explicit exclusions

P0105 does not implement:
- DynamicCam City UI hide/fade;
- `cameraDistanceMaxZoomFactor`;
- reactive zoom;
- DynamicCam first-situation startup snapping;
- later DynamicCam situations;
- rotation or shoulder offsets.

## Runtime acceptance required

After verified push/deployment:
1. automatic resting transition selects `context=city`;
2. City from zoom >5 moves toward target 5 and reaches tolerance;
3. City at zoom <=5 reports no-op and does not zoom outward;
4. leaving City fresh-evaluates the destination with no remembered restore;
5. Run All completes cleanly;
6. DynamicCam loaded still blocks/relinquishes Logres ownership;
7. no Lua, taint, protected-action, or secret-value error is observed.

Live combat + resting overlap is tested only if naturally available; otherwise it
is recorded as environmental deferral while static ordering remains enforced.

## Deployment

Runtime code changes. WoW redeploy is required after verified push.
