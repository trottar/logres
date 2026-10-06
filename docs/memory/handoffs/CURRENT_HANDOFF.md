# Current Handoff

Authoritative state:
`../CURRENT.md`.

Latest verified durable checkpoint:
P0155 R1 `e9be312d24c89d6b2d4d9935ea6eb6f9424ca698` / `0.0.76-dev`.

## P0155 runtime result

After `/reload`, the user reported the camera was extremely zoomed out.

The Phase G diagnostic showed:
- start/current/final `50`;
- target `5`;
- elapsed about `23.523s`;
- exactly one transition sample;
- zero inward commands;
- zero outward commands;
- zero direction switches;
- one timeout failure;
- no secret-value failure.

Separate Run All repeated the same camera failure.

Therefore P0155's stop-before-reverse path was not exercised at all.

## Narrow cause

`BeginTransition()` currently stores `transitionStartTime = GetTime()` during `PLAYER_ENTERING_WORLD`.

The first actual OnUpdate in this sample did not run until about `23.5s` later. `OnUpdate()` checks timeout before calling `ApplyTransitionMotion()`, so the transition immediately timed out on its first sample without issuing a camera command.

This is direct runtime evidence for a first-drivable-frame clock correction. It does not justify a timer, arbitrary delayed reconcile, polling, CVar mutation, or broader camera ownership.

## P0156

P0156:
- records event-time `armZoom`;
- records delay from arm to first OnUpdate;
- starts the transition motion/timeout clock on that first actual OnUpdate frame;
- rebases transition start zoom/min/max/previous/expected state to that first drivable sample;
- retains P0154/P0155 diagnostics and direction-switch hygiene;
- changes no target, transition duration, timeout allowance, context policy, CVar, event, or Taxi policy.

After deployment:
1. `/reload`;
2. Phase G -> **Camera World/Combat Check**;
3. Phase 0 -> **Run All**;
4. upload refreshed diagnostics.

## Key references

- `../CURRENT.md`
- `../evidence/P0156_P0155_FIRST_UPDATE_TIMEOUT_2026-10-06.md`
- `../investigations/CAMERA_WORLD_ENTRY_TRANSITION_TIMEOUT_2026-10-06.md`
- `../patches/P0156_FIRST_DRIVABLE_FRAME_CAMERA_TRANSITION.md`
- `../roadmap/PHASE_G_CINEMATIC_CAMERA.md`
