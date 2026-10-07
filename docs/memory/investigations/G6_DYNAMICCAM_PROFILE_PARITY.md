# G.6 — Captured DynamicCam Profile Parity

Status: **OPEN — P0160 ZOOM PASS; P0161 ROTATION/SETTINGS PARITY PREPARED**

Opened: 2026-10-06

Canonical profile:
`../evidence/G1_DYNAMICCAM_RPG_PROFILE_2026-10-02.json`

Canonical profile audit:
`../evidence/G6_DYNAMICCAM_PROFILE_PARITY_AUDIT_2026-10-06.md`

Zoom source:
`../evidence/P0160_LIBCAMERA_ZOOM_SOURCE_AUDIT_2026-10-07.md`

P0160 runtime acceptance:
`../evidence/P0161_P0160_ZOOM_DRIVER_PASS_2026-10-07.md`

Rotation/settings source:
`../evidence/P0161_PROFILE_BEHAVIOR_SOURCE_AUDIT_2026-10-07.md`

## Objective

Replace the user's DynamicCam `RPG` behavior with deliberate Logres ownership while reusing audited DynamicCam/LibCamera semantics rather than independently reconstructing the camera engine.

## Layer 1 — context and conditional zoom

P0159 R1 is durable at `8ddcf098`.

Observed:
- ordinary profile/base PASS;
- Taxi context/target PASS;
- first shared zoom implementation failed Taxi landing.

## Layer 2 — source-backed zoom engine

P0160 R2 is durable at `ae75989b` / `0.0.79-dev`.

Runtime:
- base PASS;
- Run All PASS;
- Taxi `~4.01 -> 50` PASS;
- landing `50 -> ~4.98` PASS;
- source rebase exercised both directions;
- no direction-switch oscillation;
- zero runtime camera failures.

G.5 Taxi zoom convergence is closed for observed scope.

## Layer 3 — P0161 rotations and camera settings

P0161 ports:
- Taxi -20 continuous yaw;
- Teleport +15 continuous yaw;
- NPC -45 yaw;
- Fishing +10/+10 yaw/pitch;
- Gathering -15/+15 yaw/pitch;
- rotate-back behavior;
- captured standard dynamic-pitch/focus CVars;
- standard and NPC zoom-based shoulder curves;
- explicit City max-distance factor 1;
- exact pre-ownership restoration.

UI fading remains Phase H policy.

## Remaining non-presentation slice

After P0161:
- source-backed reactive mouse-wheel zoom.

That is the final planned Camera-only behavior before Phase G closure, subject to runtime evidence.

Naturally unavailable Teleport/NPC/Fishing/Gathering contexts may close as explicit environmental deferrals rather than requiring contrived gameplay.
