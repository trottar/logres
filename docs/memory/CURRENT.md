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

P0094 is verified pushed at `9db11d2b`.

Current pushed runtime:
`0.0.38-dev`.

P0095 runtime target:
`0.0.39-dev`.

G.2:
**SOURCE REVIEW PASS; FOREVER RUNTIME PROBE PENDING.**

## Verified State

- Phase F is complete.
- G.1 is complete.
- P0094 is durable at `9db11d2b`.
- Exact current DynamicCam `RPG` settings remain preserved as canonical JSON.
- G.2 source review corrected P0094's derived `by 5` / `by 15` wording:
  DynamicCam `in/out` use conditional absolute targets, not deltas.
- World (`004`):
  - if current zoom > 5, target zoom 5;
  - otherwise leave the closer current zoom unchanged.
- World (Combat) (`006`):
  - if current zoom < 15, target zoom 15;
  - otherwise leave the farther current zoom unchanged.
- Ordinary World <-> World (Combat) transitions use the entering situation's
  `timeToEnter = 2.5` seconds.
- `zoomRestoreSetting = never`; combat exit does not restore pre-combat zoom.
- DynamicCam source uses `LibCamera:SetZoom()` for ordinary situation zoom.
- LibCamera primary zoom uses:
  - `GetCameraZoom()`;
  - read-only `cameraZoomSpeed`;
  - frame-based `MoveViewOutStart` / `MoveViewInStart`;
  - matching stop functions.
- LibCamera also contains a temporary-CVar `CameraZoomIn/Out` corrective
  fallback; Logres has not accepted that fallback.
- P0095 adds only a manual reversible camera capability probe.
- P0095 refuses to run while DynamicCam is loaded.
- P0095 does not subscribe to state or implement automatic camera behavior.
- P0095 does not call `SetCVar`.
- Runtime proof is required once out of combat and once in combat.

## Next Action

Apply and push P0095.

After verified push:
- disable DynamicCam for one isolated validation session;
- deploy Logres `0.0.39-dev`;
- `/reload`;
- out of combat, click `Camera Zoom Probe` once;
- wait about two seconds and click it again to record the result;
- expect PASS with `combat=false`, movement/target/restoration true;
- enter combat naturally;
- repeat the same two-click probe;
- expect PASS with `combat=true`, movement/target/restoration true;
- run Run All once;
- `/reload`;
- export `LOGRES_DIAGNOSTICS_LATEST.lua`;
- re-enable DynamicCam after the isolated proof if desired.

Do not implement automatic World/Combat camera behavior until both probe runs
are captured.

## Success Criteria

G.2 completes only after:
- source semantics correction remains accepted;
- manual primary camera path PASS out of combat;
- manual primary camera path PASS in combat;
- each probe restores its starting zoom;
- no Lua, taint, protected-action, or secret-value errors;
- DynamicCam was not simultaneously driving the proof;
- production World/Combat ownership can be specified without guessing or
  importing the unproven LibCamera CVar fallback.

## Do Not Reopen Without New Evidence

- **Phase F:** complete.
- **F.6 contextual objective progress pulse:** complete.
- **G.1 DynamicCam profile capture:** complete.
- **Current DynamicCam RPG exact stored settings:** canonical JSON.
- **P0094 `by 5/by 15` interpretation:** incorrect; superseded by G.2 source audit.
- **Instance camera custom profile:** absent from captured RPG profile.
- **Quest destination / compass marker:** unsupported until runtime-proven.
- **Quest interaction controls:** Blizzard-owned.
- **Stock Objective Tracker:** Blizzard-owned.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/G1_DYNAMICCAM_PROFILE_CAPTURE_2026-10-02.md`
- `docs/memory/evidence/G1_DYNAMICCAM_RPG_PROFILE_2026-10-02.json`
- `docs/memory/evidence/G2_DYNAMICCAM_ZOOM_SOURCE_AUDIT_2026-10-02.md`
- `docs/memory/investigations/G2_WORLD_COMBAT_CAMERA_CAPABILITY.md`
- `docs/memory/architecture/CAMERA.md`
- `docs/memory/patches/P0094_CAPTURE_DYNAMICCAM_PROFILE.md`
- `docs/memory/patches/P0095_CAMERA_ZOOM_CAPABILITY_PROBE.md`
- `docs/memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`
