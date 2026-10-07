# P0160 — LibCamera Zoom Source Audit — 2026-10-07

Status: **SOURCE RESOLVED — REPLACE BESPOKE ZOOM DRIVER WITH AUDITED LIBCAMERA SEMANTICS**

DynamicCam:
`mpstark/DynamicCam@ae586a9c973c3f868c10440358d4a6e8c2fab5ff`

Audited LibCamera:
`mpstark/LibCamera@c0b23135a0b24fbca24b41cb53dd7afc9114e352`

## Finding

DynamicCam does not implement the camera-motion easing engine itself. It delegates zoom/yaw/pitch motion to LibCamera.

Logres had reconstructed the zoom path incrementally:
- first-frame timing;
- eased MoveView velocity;
- stop-before-direction-reversal;
- bounded target correction.

The reproduced P0159 landing failure shows that reconstruction is not behaviorally equivalent.

## Ordinary LibCamera SetZoom path

The audited source:
1. stops prior zoom motion;
2. captures begin time and begin zoom on the first actual update frame;
3. uses InOutQuad by default;
4. approximates easing velocity with a 1/60-second finite difference;
5. compares actual position with expected easing position;
6. after the first frame, if absolute error exceeds `0.5`, searches the easing timeline for the time corresponding to actual position;
7. uses precision `0.005` and at most `100` iterations;
8. shifts effective begin time to that rebased point;
9. uses direct linear correction during the final two frame intervals;
10. when ordinary easing ends or crosses the target, stops MoveView motion;
11. if target error is still greater than `0.05`, performs a final 0.1-second correction.

## Final correction

The source final correction:
- captures current `cameraZoomSpeed`;
- temporarily sets `cameraZoomSpeed` to the speed needed for the correction, capped at `50`;
- on the next frame issues one `CameraZoomIn` or `CameraZoomOut`;
- stops on timeout or wrong-way motion;
- restores the exact prior `cameraZoomSpeed`.

This is different from changing `cameraDistanceMaxZoomFactor`.

## Logres adaptation

P0160 R2 ports those zoom semantics into the existing production controller rather than importing the whole Ace/LibStub stack.

Logres-specific safety retained:
- secret-first read checks;
- pcall around mutable camera operations;
- exact restoration token for cameraZoomSpeed;
- DynamicCam-loaded coexistence block;
- stop-before-reverse from P0155;
- fail-open relinquish on source-correction error;
- no C_Timer polling/ticker;
- no cameraDistanceMaxZoomFactor mutation.

## Scope boundary

This source audit resolves the zoom engine only.

The same source family already resolves rotation behavior and will be used after the zoom gate:
- Taxi continuous yaw -20, rotate back;
- Teleport continuous yaw +15, rotate back;
- NPC yaw -45, rotate back;
- Fishing yaw/pitch +10/+10, rotate back;
- Gathering yaw/pitch -15/+15, rotate back.

Profile camera settings / reactive zoom and UI fading remain separate ownership/presentation boundaries.
