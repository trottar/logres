# P0162 — Reactive Mouse-Wheel Zoom Source Audit

Date: 2026-10-07

Pinned DynamicCam source:
`mpstark/DynamicCam@ae586a9c973c3f868c10440358d4a6e8c2fab5ff`

Primary file audited:
`MouseZoom.lua`

Existing Logres zoom-engine source baseline:
`mpstark/LibCamera@c0b23135a0b24fbca24b41cb53dd7afc9114e352`

Canonical captured profile:
`G1_DYNAMICCAM_RPG_PROFILE_2026-10-02.json`

## Effective captured settings

The captured standard profile explicitly stores:
- `reactiveZoomAddIncrementsAlways = 0.1000000000000001`;
- `reactiveZoomMaxZoomTime = 2.5`.

The pinned DynamicCam defaults supply the unstored effective values:
- `reactiveZoomEnabled = true`;
- `reactiveZoomAddIncrements = 2.5`;
- `reactiveZoomIncAddDifference = 1.2`;
- `reactiveZoomEasingFunc = "OutQuad"`.

Captured City situation `001` independently stores the same effective enabled/add/threshold/max-time tuple, so the active captured situations do not require a context-specific reactive-zoom policy layer.

## Audited DynamicCam behavior

Pinned `MouseZoom.lua`:
- captures the prior `CameraZoomIn` and `CameraZoomOut` functions;
- replaces the globals while reactive zoom is active;
- ignores zero-increment wheel noise;
- treats increment `1` as the reactive mouse-wheel path;
- passes non-`1` increments through the non-reactive/native path;
- adds the always increment to every wheel tick;
- adds the quick increment when the existing reactive target is more than the configured threshold from current zoom;
- clears the old target when wheel direction reverses;
- bases a new target on the old target when still moving in the same direction;
- clamps zoom-in target to `0`;
- from first person, sends native outward zoom `0.05` to enter third person;
- clamps zoom-out target to `cameraDistanceMaxZoomFactor * 15`;
- uses `min(maxZoomTime, distance / cameraZoomSpeed)` as transition duration;
- falls back to native zoom when the required eased movement is shorter than one frame;
- uses `OutQuad` easing for the reactive eased transition;
- tracks native non-reactive movement and corrects a stale reactive target after motion settles.

## Logres adaptation

P0162 does not create a second camera-motion driver.

Instead:
- a small `Camera/ReactiveZoom.lua` adapter owns the global mouse-wheel hook and source target semantics;
- P0160 `WorldCombat.lua` is extended to support a named easing function so reactive movement uses `OutQuad` while situation transitions retain `InOutQuad`;
- the adapter asks the existing P0160 transition engine to drive the eased reactive movement;
- non-wheel increments continue to the exact captured native functions so P0160/LibCamera source-correction behavior is not reinterpreted as wheel input;
- a same-context manual-zoom marker prevents an unrelated reconcile in the same camera situation from immediately reapplying that situation's entry zoom action;
- the marker clears when the camera context actually changes.

## Restoration / coexistence policy

Logres captures the exact pre-ownership `CameraZoomIn` and `CameraZoomOut` function references.

On release:
- if a global still points to the Logres wrapper, Logres restores the exact captured function;
- if another owner has replaced the global meanwhile, Logres does not overwrite that newer function;
- the conflict is diagnostic evidence rather than authorization to clobber another addon's hook.

DynamicCam-loaded coexistence remains fail-open through the existing controller gate.

## Secret and failure policy

Every value read from `GetCameraZoom` or `GetCVar` is checked with `issecretvalue` before comparison, conversion, arithmetic, or formatting.

A secret/unreadable wheel input does not get inspected. The adapter clears its reactive target and passes the request to the captured native zoom function where possible.

A per-frame correction read failure relinquishes Logres camera ownership rather than polling/retrying indefinitely.

No new CVar mutation, timer, periodic context polling, UI fade, or Blizzard-surface suppression is part of P0162.

## Scope conclusion

This source audit supports a narrow P0162 implementation of reactive mouse-wheel behavior only.

DynamicCam UI fading remains Phase H presentation policy. P0161 environmental context deferrals remain environmental and need not be manufactured for this slice.
