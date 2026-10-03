# G.5 Taxi Camera Source Audit — 2026-10-03

Status: **SOURCE/PROFILE CONTRACT RESOLVED — TARGET-50 CAPABILITY PROBE REQUIRED BEFORE PRODUCTION TAXI OWNERSHIP**
Date: 2026-10-03
Logres baseline: P0107 `ab83882f`
Current pushed runtime: `0.0.43-dev`
DynamicCam source: `ae586a9c973c3f868c10440358d4a6e8c2fab5ff`

## Question

Define the smallest safe Taxi camera contract from the captured DynamicCam
profile without silently importing rotation, UI presentation, or global camera
CVar ownership.

## Captured profile facts

The canonical `RPG` profile stores Taxi situation `160` as enabled with:
- `timeToEnter = 5`;
- `timeToExit = 5`;
- `viewZoom.enabled = true`;
- `zoomType = out`;
- `zoomValue = 50`;
- rotation enabled with `rotationSpeed = -20`;
- UI hide enabled with opacity `0`;
- profile-wide `zoomRestoreSetting = never`.

The Taxi profile does **not** store a Taxi-specific
`cameraDistanceMaxZoomFactor` override.

Canonical profile:
`G1_DYNAMICCAM_RPG_PROFILE_2026-10-02.json`.

## Activation and sensor authority

Pinned DynamicCam `DefaultSettings.lua` defines Taxi `160` with:
- events `PLAYER_CONTROL_LOST` and `PLAYER_CONTROL_GAINED`;
- priority `1000`;
- condition `UnitOnTaxi("player")`.

Logres already has the same raw fact:
`state.onTaxi`, sourced from `UnitOnTaxi("player")`.

The Logres state engine already refreshes from both control events, and A.2
runtime evidence proved the true Taxi path and the later return from Taxi.

Therefore G.5 does not require:
- a new sensor;
- a Taxi polling loop;
- treating `PLAYER_CONTROL_LOST` itself as Taxi authority.

`PLAYER_CONTROL_LOST` remains only a refresh signal. `UnitOnTaxi("player")`
remains authoritative.

## Precedence

DynamicCam evaluates all active situations and chooses the one with the highest
numeric priority.

Relevant captured/default priorities:
- Taxi `160`: `1000`;
- NPC Interaction `300`: `110`;
- World (Combat) `006`: `50`;
- City `001`: `1`;
- World `004`: `0`.

Therefore Taxi wins over interaction, live combat, City, and World whenever the
Taxi predicate is true.

The user's captured profile does not enable Vehicle, so the separate stock
Vehicle priority `1000` is not part of the migration target.

Logres keeps its existing instance fail-open boundary outside this Taxi slice.
Within the non-instance production slice, the accepted order becomes:

1. Taxi;
2. active interaction remains fail-open/out-of-slice;
3. live combat;
4. City/resting;
5. World.

This changes the current Taxi behavior from relinquish to eventual ownership only
after the target-50 capability gate below is proven.

## Zoom semantics

The already-resolved DynamicCam `out` contract applies unchanged:
- if current zoom is less than `50`, target absolute zoom `50`;
- if current zoom is already `50` or farther, do not zoom inward to `50`.

The value is an absolute conditional target, not a delta.

## Transition and exit semantics

DynamicCam `ChangeSituation()`:
- stops the old zoom before changing situation;
- uses the entering situation's `timeToEnter` for ordinary destination
  transitions;
- uses stored old-situation zoom only when the configured restoration policy
  allows it.

Because the captured profile uses `zoomRestoreSetting = never`:
- ordinary World/City/Combat -> Taxi uses Taxi `timeToEnter = 5`;
- ordinary Taxi -> World uses World `2.5`;
- ordinary Taxi -> City uses City `2.5`;
- ordinary Taxi -> Combat uses Combat `2.5`;
- no remembered pre-Taxi zoom is restored.

Taxi's stored `timeToExit = 5` remains real profile data, but it is **not** the
ordinary destination zoom time when another situation takes ownership under the
current restore-never policy.

DynamicCam's first-situation-after-login instant transition remains a separate
global startup behavior and is not introduced through G.5.

## Target-50 camera-distance boundary

Pinned DynamicCam source permits a maximum situation zoom target of `50` on
non-mainline clients.

However DynamicCam's own reactive-zoom path also derives the current camera
distance ceiling from:

`GetCVar("cameraDistanceMaxZoomFactor") * 15`

The captured `RPG` JSON contains no explicit standard
`cameraDistanceMaxZoomFactor` override. DynamicCam's default table derives that
standard setting at runtime from `GetCVarDefault("cameraDistanceMaxZoomFactor")`.

Therefore the stored profile and source establish that target `50` is intended,
but they do **not** prove that the current Forever session can physically reach
zoom `50` without changing camera-distance CVar state.

The proven Logres camera architecture does not mutate that CVar.

G.5 must therefore **not**:
- assume target `50` is reachable;
- silently clamp the intended target to a lower value;
- set `cameraDistanceMaxZoomFactor`;
- adopt DynamicCam/LibCamera temporary-CVar fallback behavior.

## Required capability gate

Before production Taxi ownership is authorized, add one targeted developer-panel
capability probe that:

1. refuses while DynamicCam is loaded;
2. reads `cameraDistanceMaxZoomFactor` without mutating it;
3. records the source-derived effective ceiling (`factor * 15`);
4. uses the already-proven `MoveView*Start/Stop` path to attempt absolute target
   `50`;
5. records whether target `50` is actually reached;
6. restores the captured starting zoom through the proven movement path;
7. records secret/error state;
8. never calls `SetCVar`, `CameraZoomIn`, or `CameraZoomOut`.

This capability probe does not require a real flight path because it tests camera
reachability rather than Taxi context ownership.

If the probe passes, production Taxi zoom ownership may be implemented.

If it cannot reach `50`, preserve that as a negative result and open a separate
camera-distance CVar ownership decision. Do not ship a degraded Taxi target by
guessing.

## Rotation boundary

DynamicCam source implements rotation separately from zoom.

The effective Taxi rotation uses the situation defaults:
- `rotationType = continuous`;
- configured speed `-20`;
- `rotateBack = true`.

`StartRotation()` invokes the rotation path independently after zoom/CVar
transition setup.

Therefore rotation is **separable** from Taxi zoom ownership.

The first Taxi production slice will remain zoom-only. Continuous rotation
requires its own Forever capability proof and explicit ownership/cleanup contract
before it may be added.

## UI hide/fade boundary

Taxi UI hide/fade is presentation policy, not camera movement.

It remains outside the first Taxi camera slice and must be reconciled with
Logres Immersion/Quiet/Phase H presentation policy rather than copied into the
camera controller.

## Coexistence and fail-open behavior

G.5 reuses the proven G.3/G.4 architecture:
- DynamicCam loaded blocks/relinquishes Logres camera ownership;
- the manual camera probe and production controller never drive the camera
  simultaneously;
- active movement is stopped on disable, ownership loss, replacement transition,
  or failure;
- failures leave a usable current camera position;
- no periodic context polling is added.

Until the target-50 capability gate passes and production Taxi ownership is
implemented, the current Taxi fail-open exclusion remains authoritative.

## Smallest production runtime proof after capability PASS

After target-50 capability passes and a production Taxi zoom slice exists, runtime
acceptance should cover:

1. a real flight-path transition automatically selects Taxi;
2. Taxi from zoom `<50` reaches target `50` over the accepted `5` second entry;
3. Taxi at target does not perform an unnecessary inward correction;
4. Taxi exit fresh-evaluates World/City/Combat using the destination transition
   and does not restore pre-Taxi zoom;
5. DynamicCam coexistence remains fail-open;
6. Run All remains clean;
7. diagnostics show no Lua, taint, protected-action, secret-value, or camera
   ownership failure.

Do not manufacture a Taxi + live-combat overlap solely for proof.

## Result

**G.5 SOURCE/PROFILE CONTRACT RESOLVED.**

Production Taxi ownership remains **NOT AUTHORIZED** until a targeted,
read-only-CVar target-50 camera capability probe passes.
