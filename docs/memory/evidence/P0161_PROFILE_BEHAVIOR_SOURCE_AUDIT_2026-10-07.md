# P0161 — Captured Profile Rotation / Camera-Setting Source Audit — 2026-10-07

Status: **SOURCE + PROFILE RESOLVED — IMPLEMENTATION AUTHORIZED**

DynamicCam:
`mpstark/DynamicCam@ae586a9c973c3f868c10440358d4a6e8c2fab5ff`

LibCamera:
`mpstark/LibCamera@c0b23135a0b24fbca24b41cb53dd7afc9114e352`

Canonical profile:
`G1_DYNAMICCAM_RPG_PROFILE_2026-10-02.json`

## Rotation defaults

DynamicCam situation defaults provide:
- rotation type `continuous`;
- speed `10`;
- yaw/pitch `0`;
- `rotateBack = true`.

The captured profile overrides only the values stored in its situation rows.

Therefore effective captured rotations are:

| Context | Effective behavior |
| --- | --- |
| Taxi | continuous yaw `-20`, rotate back |
| Hearth/Teleport | continuous yaw `+15`, rotate back |
| NPC Interaction | degree yaw `-45`, pitch `0`, rotate back |
| Fishing | degree yaw `+10`, pitch `+10`, rotate back |
| Gathering | degree yaw `-15`, pitch `+15`, rotate back |

World, City, Combat, and AFK have no enabled rotation override.

## DynamicCam transition ordering

On situation change DynamicCam:
1. stops old rotation;
2. uses the new situation enter time as the preferred exit/return duration;
3. if rotateBack is enabled, returns the old yaw/pitch;
4. starts the new situation rotation.

Starting a new rotation cancels an in-progress return on the same axis, matching LibCamera behavior.

## LibCamera motion semantics

Continuous yaw:
- ramps linearly from 0 to requested degrees/second over the transition duration;
- converts requested degrees/second using live `cameraYawMoveSpeed`;
- accumulates elapsed yaw so StopYawing can return it;
- rotate-back normalizes continuous accumulated yaw to the shortest `[-180, 180]` return.

Degree yaw/pitch:
- uses InOutQuad finite-difference velocity;
- duration 0 becomes 0.05 seconds;
- interrupted rotations return the actually accumulated easing position;
- completed rotations return the configured full angle when DynamicCam exits the situation.

## Captured standard camera settings

Explicit stored standard values:
- `cameraZoomSpeed = 15.5`;
- `test_cameraDynamicPitch = 1`;
- `test_cameraDynamicPitchBaseFovPad = 0.75`;
- `test_cameraDynamicPitchBaseFovPadDownScale = 1`;
- `test_cameraDynamicPitchBaseFovPadFlying = 0.5`;
- `test_cameraDynamicPitchSmartPivotCutoffDist = 25`;
- enemy target focus enabled;
- enemy yaw/pitch strength `0.75 / 0.5`;
- interact target focus enabled;
- interact yaw/pitch strength `0.75 / 0.5`.

Standard zoom-based shoulder:
- zoom 0 -> 0;
- zoom 2 -> 0;
- zoom 7 -> +1;
- zoom 50 -> +1.

NPC Interaction overrides shoulder:
- zoom 0 -> 0;
- zoom 2 -> 0;
- zoom 7 -> -2;
- zoom 50 -> -2.

City explicitly stores:
- `cameraDistanceMaxZoomFactor = 1`;
- `cameraZoomSpeed = 15.5`.

The standard profile does not store a max-distance override. P0161 therefore captures the live pre-ownership factor and treats it as the standard/restoration baseline, applying the City `1` only while City owns the profile.

## Restoration policy

Logres must not permanently overwrite account camera settings.

P0161 captures each owned CVar as an opaque restoration token before mutation.

On disable, coexistence block, or any relinquish path:
- stop rotation;
- stop settings easing;
- restore the exact captured tokens;
- fail open if restoration reports an error.

Secret-capable tokens are never inspected, formatted, compared, or converted. Numeric behavior that requires inspection is skipped/fails open when a value is secret.

## Scope boundary

P0161 intentionally excludes:
- DynamicCam UI fading;
- reactive mouse-wheel CameraZoomIn/Out replacement.

Reactive zoom remains the last non-presentation Camera parity slice after this checkpoint.
