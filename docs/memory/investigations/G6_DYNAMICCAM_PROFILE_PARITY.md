# G.6 — Captured DynamicCam Profile Parity

Status: **OPEN — P0159 R1 CONTEXT+ZOOM PARITY PREPARED; INITIAL SHADOW-PREFLIGHT DELIVERY FAILURE PRESERVED**

Opened: 2026-10-06

Canonical profile:
`../evidence/G1_DYNAMICCAM_RPG_PROFILE_2026-10-02.json`

Canonical parity audit:
`../evidence/G6_DYNAMICCAM_PROFILE_PARITY_AUDIT_2026-10-06.md`

## Objective

Replace the remaining dependency on the user's DynamicCam `RPG` profile with a small number of coherent Logres parity layers.

## Layer 1 — P0159

Context + zoom parity:
- all nine enabled situations represented;
- source priorities preserved;
- secret-safe Teleport/Gathering/Fishing reads;
- AFK no-zoom situation;
- Fishing one-second exit hold;
- no CVar mutation, rotation, shoulder mutation, or UI fade.

Runtime proof must include the ordinary reload/base path, integrated Run All, and the still-pending real Taxi entry/landing gate. Other situations may be recorded naturally rather than contrived.

## Layer 2 — after P0159 acceptance

Consolidated camera-motion/settings parity:
- Taxi continuous yaw `-20`;
- Hearth/Teleport continuous yaw `+15`;
- NPC Interaction yaw `-45`;
- Fishing yaw/pitch `+10/+10`;
- Gathering yaw/pitch `-15/+15`;
- source-compatible rotate-back behavior;
- NPC shoulder-offset curve and profile-wide camera-setting ownership only with explicit capture/restore/fail-open semantics;
- no max-distance mutation unless separately reopened by evidence.

DynamicCam UI hide/fade is presentation policy and should be integrated with Phase H stock-surface suppression/coexistence rather than copied blindly into the camera controller.

## Closure

G.6 closes when Logres represents the captured camera behaviors it deliberately claims to replace, with explicit evidence-backed deferrals for anything unsafe/unavailable.

A new DynamicCam export is required only if the user's profile changes.


## P0159 delivery correction

The first artifact refused before tracked writes because its renderer deleted the
new context-helper block after inserting it. R1 fixes the transformation order
and adds a static ordering assertion.

Canonical failure evidence:
`../evidence/P0159_INITIAL_SHADOW_PREFLIGHT_FAIL_2026-10-06.md`.
