# Current Handoff

Authoritative state:
`../CURRENT.md`.

Latest verified durable checkpoint:
P0160 R2 `ae75989bc0acadf550bd26e39c9bc70acee3e46c`.

## P0160 runtime result

`0.0.79-dev`, loadCount `191`, client `1.60.1.70245`.

Base:
- Camera Profile Check PASS;
- Run All PASS;
- failures=0.

Taxi:
- start about `4.0096`;
- requested/effective target `50`;
- final `50`;
- elapsed about `4.936s`;
- 347 samples;
- 346 toward / 0 away;
- 0 direction switches;
- 2 source rebases;
- failures=0.

Landing:
- World start `50`;
- target `5`;
- final about `4.9806`;
- elapsed about `2.426s`;
- 158 samples;
- 156 toward / 1 away;
- 0 direction switches;
- 2 source rebases;
- failures=0.

User visual confirmation:
Taxi zoomed out and returned close after landing.

Classification:
**P0160 RUNTIME PASS; G.5 TAXI ZOOM CONVERGENCE CLOSED FOR OBSERVED SCOPE.**

## P0161

P0161 is the next consolidated profile layer.

It ports:
- Taxi continuous yaw -20 + return;
- Teleport continuous yaw +15 + return;
- NPC yaw -45 + return;
- Fishing yaw/pitch +10/+10 + return;
- Gathering yaw/pitch -15/+15 + return;
- captured standard dynamic-pitch and target-focus settings;
- standard +1 zoom-based shoulder curve;
- NPC -2 shoulder curve;
- City max-distance factor 1;
- exact pre-ownership CVar restoration.

It uses the audited DynamicCam/LibCamera source behavior and preserves fail-open DynamicCam coexistence.

P0161 does not yet replace CameraZoomIn/Out for reactive mouse-wheel zoom and does not implement DynamicCam UI fades.

Candidate runtime:
`0.0.80-dev`.

## Runtime gate

1. `/reload`;
2. Phase G -> Camera Profile Check;
3. Phase 0 -> Run All;
4. verify ordinary manual zoom remains usable;
5. normal Taxi:
   - visible continuous left yaw in flight;
   - Camera Profile Check in flight;
   - visible return after landing;
   - Camera Profile Check after settle;
6. upload diagnostics.

Do not require contrived Teleport/Fishing/Gathering/NPC proof.

## Key references

- `../CURRENT.md`
- `../evidence/P0161_P0160_ZOOM_DRIVER_PASS_2026-10-07.md`
- `../evidence/P0161_PROFILE_BEHAVIOR_SOURCE_AUDIT_2026-10-07.md`
- `../patches/P0161_PROFILE_ROTATION_SETTINGS_PARITY.md`
- `../investigations/G6_DYNAMICCAM_PROFILE_PARITY.md`
- `../architecture/CAMERA.md`
- `../roadmap/PHASE_G_CINEMATIC_CAMERA.md`
