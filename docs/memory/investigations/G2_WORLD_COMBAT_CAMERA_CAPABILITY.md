# G.2 — World/Combat Camera Zoom Capability

Status: ACTIVE — SOURCE REVIEW / RUNTIME PROOF PENDING
Opened: 2026-10-02

Profile evidence:
`../evidence/G1_DYNAMICCAM_PROFILE_CAPTURE_2026-10-02.md`

Phase roadmap:
`../roadmap/PHASE_G_CINEMATIC_CAMERA.md`

## Question

Can Logres safely reproduce the current `RPG` World / World (Combat) camera zoom
behavior on WoW Forever without introducing polling, stealing unrelated camera
ownership, or touching DynamicCam's more complex UI-hide/rotation behaviors?

## Target profile behavior

Situation 004 — World:
- not resting;
- not in an instance;
- zoom `in` by `5`;
- enter transition `2.5`;
- exit transition `0`.

Situation 006 — World (Combat):
- not in an instance;
- player in combat;
- priority above World;
- zoom `out` by `15`;
- enter transition `2.5`;
- exit transition `0`.

The word `by` is intentional: the export uses DynamicCam `zoomType = in/out`,
not a fixed target-distance `set` mode.

## Existing Logres state inputs

Use existing observed state where sufficient:
- combat;
- instance/world;
- resting.

Do not create duplicate world/combat sensors merely for the camera module.

## Source-review questions

Before runtime mutation, determine:

1. how current DynamicCam implements timed `zoomType = in/out`;
2. which WoW APIs/CVars it uses on Forever;
3. whether `GetCameraZoom`, `CameraZoomIn`, `CameraZoomOut`,
   `MoveViewInStop`, `MoveViewOutStop`, and/or `cameraZoomSpeed` are involved;
4. whether those values/calls are safe in and out of combat on Forever;
5. how a transition can be stopped/replaced when context changes;
6. how Logres can fail open without leaving a stale zoom transition;
7. how staged testing coexists with DynamicCam so both addons do not fight for
   camera ownership.

## Runtime proof boundary

A probe, if required, must:
- be developer-panel driven;
- preserve current camera usability;
- capture addon-owned diagnostic state;
- avoid polling/tickers as a substitute for event evidence;
- avoid permanent CVar mutation;
- restore temporary CVar changes after the probe;
- not implement automatic production behavior yet.

## Out of scope

G.2 does not implement:
- City UI fading;
- NPC interaction yaw/shoulder/UI hiding;
- Taxi UI hiding/rotation;
- Hearth/Teleport detection/rotation;
- Fishing rotation;
- Gathering rotation;
- AFK behavior;
- global target-focus/dynamic-pitch ownership;
- instance-specific camera policy.

## Success criteria

G.2 completes only after:
- current DynamicCam zoom semantics are source-understood;
- the required Forever API path is identified;
- a safe fail-open/restoration contract is explicit;
- any required runtime probe passes or a limitation is recorded;
- the first production World/Combat camera implementation can be specified
  without guessing.

## Next action

Audit current DynamicCam zoom implementation and relevant Forever camera APIs.
