---
memory_schema: 1
as_of: 2026-10-02
project: logres
---

# Current State

## Active Objective

**Phase G — Cinematic Camera.**

## Current Work Item

**G.2 — World/Combat camera zoom capability contract and runtime proof.**

P0093 is verified pushed at `de30c6f3`.

Current pushed runtime:
`0.0.38-dev`.

G.1:
**COMPLETE — CURRENT DYNAMICCAM PROFILE CAPTURED.**

G.2:
**ACTIVE — SOURCE REVIEW / RUNTIME PROOF PENDING.**

## Verified State

- Phase F is complete.
- P0093 is durable at `de30c6f3`.
- The user supplied current `DynamicCam.lua` and `DynamicCam.lua.bak`.
- The two files have different byte hashes but parse to identical semantic data.
- The exact stored `RPG` profile is preserved in:
  `docs/memory/evidence/G1_DYNAMICCAM_RPG_PROFILE_2026-10-02.json`.
- `RPG` is referenced by 12 of 15 profile keys and is the richly customized
  migration target.
- `RPG` schema version is 5.
- `zoomRestoreSetting = never`.
- Enabled current contexts are:
  - City;
  - World;
  - World (Combat);
  - Taxi;
  - Hearth/Teleport;
  - NPC Interaction;
  - Fishing;
  - AFK;
  - Gathering.
- No explicit enabled instance camera situation exists in the captured `RPG`
  profile.
- Global stored camera behavior includes:
  - camera zoom speed `15.5`;
  - dynamic pitch enabled;
  - standard shoulder offset `1` with a zoom-based 0 -> 1 curve;
  - enemy/interact target focus enabled with yaw `0.75`, pitch `0.5`;
  - reactive zoom max time `2.5`;
  - zoom restore `never`.
- World (`004`) stores:
  - zoom in **by 5**;
  - enter `2.5`;
  - exit `0`.
- World (Combat) (`006`) stores:
  - zoom out **by 15**;
  - enter `2.5`;
  - exit `0`.
- World/Combat is the first selected capability slice because it is camera-only:
  no stored UI-hide or rotation override in those situations.
- DynamicCam UI-hide, rotation, shoulder, taxi, teleport, fishing, gathering,
  City, and AFK behavior remain later slices.
- Situation names/conditions/priorities are mapped using current upstream
  DynamicCam `DefaultSettings.lua` at `ae586a9c`.
- Omitted SavedVariables fields remain inherited behavior to resolve from source;
  they are not guessed from the export.

## Next Action

Perform G.2 source review:

- inspect current DynamicCam zoom-transition implementation;
- identify the exact WoW/Forever camera API and CVar path for `zoomType=in/out`;
- determine how `zoomValue` and `transitionTime` are applied;
- establish safe interruption/restoration behavior;
- establish how Logres and DynamicCam can coexist during staged testing;
- only then add a developer-panel capability probe if runtime evidence is
  needed.

Do not write automatic production camera behavior until the capability contract
is proven.

P0094 is docs/evidence-only; no WoW redeploy is required.

## Success Criteria

G.2 completes only after:
- DynamicCam World/Combat zoom semantics are source-understood;
- the relevant Forever camera APIs/CVars are identified;
- combat/world mutation safety is established;
- temporary/probe CVar changes restore cleanly;
- transition interruption/fail-open behavior is explicit;
- coexistence with DynamicCam during validation is safe;
- the first production World/Combat camera implementation can be specified
  without guessing.

## Do Not Reopen Without New Evidence

- **Phase F:** complete.
- **F.6 contextual objective progress pulse:** complete.
- **G.1 DynamicCam profile capture:** complete.
- **Current DynamicCam RPG exact settings:** use canonical G.1 evidence.
- **Instance camera custom profile:** absent from captured RPG profile.
- **Quest destination / compass marker:** unsupported until runtime-proven.
- **Quest interaction controls:** Blizzard-owned.
- **Stock Objective Tracker:** Blizzard-owned.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/G1_DYNAMICCAM_PROFILE_CAPTURE_2026-10-02.md`
- `docs/memory/evidence/G1_DYNAMICCAM_RPG_PROFILE_2026-10-02.json`
- `docs/memory/investigations/G1_DYNAMICCAM_PROFILE_CAPTURE.md`
- `docs/memory/investigations/G2_WORLD_COMBAT_CAMERA_CAPABILITY.md`
- `docs/memory/architecture/CAMERA.md`
- `docs/memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`
- `docs/memory/patches/P0094_CAPTURE_DYNAMICCAM_PROFILE.md`
