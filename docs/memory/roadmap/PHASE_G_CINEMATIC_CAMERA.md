# Phase G — Cinematic Camera

Status: ACTIVE — G.2
Opened: 2026-10-02

## Product Objective

Translate the user's established contextual DynamicCam behavior into Logres so
camera behavior can eventually be owned by the addon rather than a separate
profile.

## Evidence Boundary

Canonical camera architecture:
`../architecture/CAMERA.md`.

Current profile evidence:
- `../evidence/G1_DYNAMICCAM_PROFILE_CAPTURE_2026-10-02.md`
- `../evidence/G1_DYNAMICCAM_RPG_PROFILE_2026-10-02.json`

Current source audit:
`../evidence/G2_DYNAMICCAM_ZOOM_SOURCE_AUDIT_2026-10-02.md`.

## G.1 — Current DynamicCam profile capture

**COMPLETE — PASS.**

Enabled `RPG` contexts:
- City;
- World;
- World (Combat);
- Taxi;
- Hearth/Teleport;
- NPC Interaction;
- Fishing;
- AFK;
- Gathering.

No explicit enabled instance situation is present.

## G.2 — World/Combat camera zoom capability

**ACTIVE — SOURCE REVIEW PASS; RUNTIME PROBE PENDING.**

Correct target behavior:

World:
- if current zoom > 5, target 5;
- otherwise no zoom;
- ordinary transition 2.5 seconds.

World (Combat):
- if current zoom < 15, target 15;
- otherwise no zoom;
- ordinary transition 2.5 seconds.

Zoom restoration:
`never`.

The earlier `by 5/by 15` interpretation is closed as incorrect.

Primary source path:
- `GetCameraZoom`;
- read `cameraZoomSpeed`;
- `MoveViewInStart/Stop`;
- `MoveViewOutStart/Stop`;
- frame-based transition animation.

P0095 probe:
- manual panel action only;
- DynamicCam must be disabled;
- reversible small movement;
- no `SetCVar`;
- must pass both out of combat and in combat.

## Later Phase G Work

After G.2 capability proof, specify and implement World/Combat ownership before
advancing to more complex contexts.

Later evidence-backed contexts include:
- City;
- NPC interaction;
- Gathering;
- Fishing;
- Taxi;
- Hearth/Teleport;
- AFK;
- global camera settings.

Do not invent an instance camera slice while the captured profile has none.
