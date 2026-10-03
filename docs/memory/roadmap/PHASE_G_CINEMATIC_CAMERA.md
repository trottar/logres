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

Exact camera values must come from durable evidence, not conversational memory.

## G.1 — Current DynamicCam profile capture

**COMPLETE — PASS.**

The user supplied current `DynamicCam.lua` and `.bak` files.

They parse to identical semantic data.

The canonical `RPG` profile is preserved as machine-readable JSON and mapped
against current upstream DynamicCam situation IDs.

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

**ACTIVE — SOURCE REVIEW / RUNTIME PROOF PENDING.**

Evidence-backed target:

World:
- zoom in by 5;
- enter 2.5;
- exit 0.

World (Combat):
- zoom out by 15;
- enter 2.5;
- exit 0.

G.2 intentionally excludes:
- UI hiding;
- rotation;
- shoulder offsets;
- spell-detection contexts;
- global camera CVar ownership.

Use existing Logres world/combat/resting/instance state where sufficient.

## G.2 Success Criteria

- current DynamicCam zoom implementation understood from source;
- Forever camera API/CVar path identified;
- combat/world safety established;
- transition interruption/restoration contract explicit;
- coexistence with DynamicCam during staged validation is safe;
- first production World/Combat camera patch can be specified without guessing.

## Later Phase G Work

After World/Combat zoom is proven, select later slices from captured evidence:
- City;
- NPC interaction;
- Gathering;
- Fishing;
- Taxi;
- Hearth/Teleport;
- AFK;
- standard/global camera settings.

Do not invent an instance camera slice while the captured profile has none.

Exact later ordering remains evidence-driven.
