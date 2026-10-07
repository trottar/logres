# P0161 — Captured Profile Rotation + Camera Settings Parity

Date: 2026-10-07
Baseline: `ae75989bc0acadf550bd26e39c9bc70acee3e46c`
Candidate runtime: `0.0.80-dev`
Result: **PREPARED — RUNTIME EVIDENCE REQUIRED**

## Trigger

P0160 R2 is runtime-accepted for base, Taxi outbound, and Taxi landing convergence.

The shared zoom engine is no longer the blocker.

## Implementation

New:
`Logres/Camera/ProfileBehavior.lua`.

It is a source-backed adapter for the remaining situation motion/settings behavior.

### Rotation

Implements:
- Taxi continuous yaw -20;
- Teleport continuous yaw +15;
- NPC yaw -45;
- Fishing yaw/pitch +10/+10;
- Gathering yaw/pitch -15/+15;
- inherited rotateBack=true behavior;
- interrupted degree return using actual eased position;
- continuous-yaw accumulated-angle shortest-path return.

### Camera settings

Captures/restores the profile-owned CVar set.

Applies the exact stored standard dynamic-pitch/focus values.

Implements zoom-based shoulder curves:
- standard +1;
- NPC -2.

Implements the explicit City max-distance factor 1 override while restoring the captured pre-ownership value outside City.

Settings transitions use the captured situation transition duration and InOutQuad blending.

### Safety

- profile CVar originals are captured before mutation;
- secret-capable originals are opaque restoration tokens only;
- numeric inspection never occurs on a secret token;
- DynamicCam coexistence relinquishes and restores;
- module disable relinquishes and restores;
- rotation failures relinquish;
- settings failures relinquish;
- no C_Timer polling;
- no UI fade/suppression;
- no reactive CameraZoomIn/Out replacement.

### Attribution

The adapted LibCamera behavior carries the upstream MIT notice in:
`Logres/Camera/LIBCAMERA_NOTICE.txt`.

## Runtime gate

1. reload;
2. Camera Profile Check;
3. Run All;
4. ordinary manual zoom usability;
5. normal Taxi:
   - continuous left yaw visible;
   - Camera Profile Check in flight;
   - landing zoom + yaw return;
   - Camera Profile Check after settle;
6. refreshed diagnostics.

Unobserved profile situations remain environmental deferrals rather than PASS.
