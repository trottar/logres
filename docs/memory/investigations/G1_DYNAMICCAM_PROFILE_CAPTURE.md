# G.1 — Current DynamicCam Profile Capture

Status: CLOSED — PASS
Opened: 2026-10-02
Closed: 2026-10-02

Architecture:
`../architecture/CAMERA.md`

Phase roadmap:
`../roadmap/PHASE_G_CINEMATIC_CAMERA.md`

Canonical evidence:
`../evidence/G1_DYNAMICCAM_PROFILE_CAPTURE_2026-10-02.md`

Machine-readable profile:
`../evidence/G1_DYNAMICCAM_RPG_PROFILE_2026-10-02.json`

## Question

What exact DynamicCam behavior is the user currently running, and which of those
behaviors should become the first evidence-backed Logres camera slice?

## Evidence received

The user supplied:

- `DynamicCam.lua`
- `DynamicCam.lua.bak`

SHA-256 values are preserved in canonical evidence.

The files parse to the same semantic data.

The exact stored `RPG` profile is preserved as canonical JSON in repository
evidence.

## Result

**PASS.**

The `RPG` profile is the migration target:
- referenced by 12 of 15 profile keys;
- schema version 5;
- nine enabled situation IDs;
- exact stored settings preserved.

Enabled contexts:
- City;
- World;
- World (Combat);
- Taxi;
- Hearth/Teleport;
- NPC Interaction;
- Fishing;
- AFK;
- Gathering.

No explicit instance situation is enabled in the stored `RPG` profile.

## Selected next slice

**G.2 — World/Combat camera zoom capability contract and runtime proof.**

Selected profile behavior:
- World: zoom in by 5, enter 2.5, exit 0;
- World (Combat): zoom out by 15, enter 2.5, exit 0.

This is the narrowest useful slice because it requires zoom only and reuses
already-proven Logres world/combat state.

UI hiding, rotation, shoulder offset, taxi, teleport, fishing, gathering, City,
and AFK remain later slices.

## Source interpretation boundary

Situation names/conditions/priorities are mapped using upstream DynamicCam
`DefaultSettings.lua` at:

`ae586a9c973c3f868c10440358d4a6e8c2fab5ff`

Stored numeric/profile values come exclusively from the supplied files.

Omitted SavedVariables fields remain inherited/unknown until G.2 source review.

## Closure

**G.1 CLOSED — PASS.**
