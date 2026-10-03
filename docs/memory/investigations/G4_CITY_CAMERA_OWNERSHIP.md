# G.4 — City Camera Ownership

Status: IMPLEMENTATION PREPARED — RUNTIME PROOF PENDING
Opened: 2026-10-03
Contract resolved: 2026-10-03

## Objective

Extend the runtime-proven G.3 controller with the smallest deliberate
City/resting zoom slice without importing unrelated DynamicCam presentation or
CVar policy.

## Canonical source/profile audit

`../evidence/G4_CITY_CAMERA_SOURCE_AUDIT_2026-10-03.md`

The audit resolves:
- City activation: existing `state.resting`, sourced from `IsResting()`;
- precedence: live World (Combat) wins over City;
- City conditional target: zoom `5` only when currently farther than 5;
- ordinary City entry: `2.5` seconds;
- City exit: fresh destination evaluation, never remembered zoom restoration;
- coexistence/fail-open behavior: reuse proven G.3 ownership;
- City UI hide/fade: explicitly outside the camera slice;
- City `cameraDistanceMaxZoomFactor = 1`: known deferred CVar parity item;
- City reactive-zoom values: no effective City-specific delta from captured
  standard settings;
- DynamicCam first-situation instant transition: global startup special case,
  deferred rather than introduced through City.

## Accepted context order

Inside the existing proven G.3 safety exclusions:
1. instance / taxi / active interaction -> relinquish;
2. live `UnitAffectingCombat("player")` -> `combat`;
3. resting -> `city`;
4. otherwise -> `world`.

Targets:
- combat -> conditional target `15`;
- city -> conditional target `5`;
- world -> conditional target `5`.

Zoom restoration remains `never`.

## Implementation boundary

The next patch should make the smallest coherent extension to the existing
production controller:
- add `city` context selection after live combat and before World;
- map City to target 5 using the existing conditional-in behavior;
- keep the existing MoveView transition mechanism and 2.5-second duration;
- reuse state subscription; no new resting poller;
- preserve DynamicCam/probe coexistence and fail-open interruption behavior;
- extend diagnostics/static contracts so `city` is observable and precedence is
  enforced.

Existing internal command/module identifiers may remain for compatibility in
this narrow slice; any broader naming consolidation is separate from City
capability proof.

## Explicit exclusions

G.4 does not authorize:
- City UI hide/fade;
- City/global camera CVar ownership;
- reactive-zoom implementation;
- login/reload startup-snap parity;
- Taxi;
- Hearth/Teleport;
- NPC Interaction;
- Fishing;
- AFK;
- Gathering;
- rotation;
- shoulder offsets.

## P0105 implementation checkpoint

P0105 prepares runtime `0.0.43-dev` by extending the existing
`CameraWorldCombat` controller without renaming stable module/command identifiers:
- adds explicit `CITY_TARGET = 5`;
- records `state.resting` in addon-owned diagnostics;
- selects `city` only after live combat and before World;
- maps City to conditional-in target 5;
- reuses the same 2.5-second MoveView transition and fail-open logic;
- extends integrated diagnostics to accept/print City;
- adds `tools/check_camera_city_contract.py` for City target, ordering, and scope
  exclusions.

Runtime behavior is not considered proven until the deployed acceptance sequence
is completed.

## Runtime acceptance

Required after implementation/deployment:
- automatic City selection on a real resting transition;
- City >5 transition PASS;
- City <=5 no-op PASS;
- clean City exit with destination reevaluation and no remembered restore;
- Run All PASS;
- DynamicCam coexistence still blocks Logres ownership;
- no Lua, taint, protected-action, or secret-value errors.

Live combat + resting overlap should be tested only if naturally available.
Otherwise record it as an environmental deferral while retaining the static
live-combat-before-City contract.
