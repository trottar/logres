# G.6 — Captured DynamicCam Profile Parity

Status: **OPEN — P0161 ACCEPTED; P0162 REACTIVE ZOOM PREPARED**

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

P0161 is durable at `2a959094` / `0.0.80-dev` and runtime-accepted for the observed Taxi/settings/shoulder-offset scope. Accepted evidence includes Taxi target `50`, continuous yaw `-20`, City landing return about `4.97-5.01`, rotate-back completion, City max-distance factor `1` with original factor `4`, and zero profile/camera secret/runtime failures.

Teleport/NPC/Fishing/Gathering and unobserved AFK behavior remain environmental deferrals. UI fading remains Phase H policy.

## Layer 4 — P0162 reactive mouse-wheel zoom

P0162 is the final planned Camera-only behavior before Phase G closure, subject to runtime evidence. It adapts pinned DynamicCam `MouseZoom.lua`, uses the captured effective reactive settings, reuses P0160 motion with `OutQuad`, and restores exact pre-ownership CameraZoom functions.

Naturally unavailable P0161 contexts may close as explicit environmental deferrals rather than requiring contrived gameplay.
