# G.6 — Captured DynamicCam Profile Parity

Status: **OPEN — P0159 R1 DURABLE; PROFILE/CONTEXT BASE + TAXI ENTRY PASS; SHARED ZOOM DRIVER FAIL; P0160 R2 SOURCE-BACKED REPLACEMENT NEXT**

Opened: 2026-10-06

Canonical profile:
`../evidence/G1_DYNAMICCAM_RPG_PROFILE_2026-10-02.json`

Canonical parity audit:
`../evidence/G6_DYNAMICCAM_PROFILE_PARITY_AUDIT_2026-10-06.md`

Zoom-engine source audit:
`../evidence/P0160_LIBCAMERA_ZOOM_SOURCE_AUDIT_2026-10-07.md`

## Objective

Replace the remaining dependency on the user's DynamicCam `RPG` profile with deliberate Logres ownership, but reuse the audited DynamicCam/LibCamera behavior instead of independently reconstructing the camera engine.

## Layer 1 — P0159 R1

P0159 R1 is durable at:
`8ddcf09844961adec7bc90621f0f5ca294f15aef`.

Observed runtime:
- ordinary profile/base PASS;
- secretSkips=0;
- readFailures=0;
- Taxi entry/target 50 PASS twice;
- post-Taxi destination zoom FAIL.

The failure is not in situation priority/predicate selection. It is in the shared custom zoom transition engine.

## P0160 R2 — zoom engine correction

P0160 R2 ports the ordinary zoom semantics of:

`mpstark/LibCamera@c0b23135a0b24fbca24b41cb53dd7afc9114e352`.

Ported:
- InOutQuad easing;
- source finite-difference easing velocity;
- source >0.5 position/time rebase;
- 0.005 rebase precision;
- max 100 iterations;
- final two-frame linear correction;
- final 0.1-second correction with temporary cameraZoomSpeed ownership;
- exact cameraZoomSpeed restoration.

Retained Logres boundaries:
- secret-first reads;
- DynamicCam coexistence;
- stop-before-reverse;
- no cameraDistanceMaxZoomFactor mutation;
- no polling/ticker.

The initial P0160 artifact refused in shadow preflight because of a stale historical checker anchor. It made no tracked writes and is preserved as a delivery failure.

## Remaining profile layer after zoom acceptance

Consolidated camera-motion/settings parity:
- Taxi continuous yaw `-20`, rotate back;
- Hearth/Teleport continuous yaw `+15`, rotate back;
- NPC Interaction yaw `-45`, rotate back;
- Fishing yaw/pitch `+10/+10`, rotate back;
- Gathering yaw/pitch `-15/+15`, rotate back;
- source-compatible rotation interruption/return;
- standard/profile camera-setting ownership with exact restoration;
- zoom-based shoulder-offset behavior;
- reactive zoom only after its mouse-wheel ownership contract is explicit.

DynamicCam UI fades are presentation policy and remain a Phase H integration boundary rather than a camera-engine side effect.

## Closure

G.6 closes only when the captured camera behaviors Logres deliberately claims to replace are source-backed and runtime-proven or explicitly deferred with evidence.

A new DynamicCam export is required only if the user's profile changes.
