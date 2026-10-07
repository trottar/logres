---
memory_schema: 1
as_of: 2026-10-07
project: logres
---

# Current State

## Active Objective

**Finish captured DynamicCam `RPG` camera parity from the audited DynamicCam/LibCamera source, then enter Phase H integration/layout and final polish.**

The canonical profile is already stored in repository evidence. Do not request another export unless the user's profile changes.

P0160 R2 is verified durable at `ae75989bc0acadf550bd26e39c9bc70acee3e46c` on runtime `0.0.79-dev`.

## Current Work Item

**P0161 — captured-profile rotations plus camera-setting ownership/restoration.**

P0160 R2 closes the shared zoom-driver blocker.

Observed `0.0.79-dev`, loadCount `191`:
- ordinary Camera Profile Check PASS;
- separate Run All PASS;
- Taxi `4.0096 -> 50` completed at `50`;
- Taxi motion: `347` samples, `346` toward, `0` away, `0` direction switches, `2` source rebases;
- post-Taxi World `50 -> 5` completed at `4.9806`;
- landing motion: `158` samples, `156` toward, `1` away, `0` direction switches, `2` source rebases;
- failures `0`, secret=false, error=nil;
- user visually confirmed the camera zoomed out in Taxi and returned close after landing.

This replaces the P0159 `0 <-> 50` oscillation and closes G.5 Taxi zoom convergence in the tested scope.

P0161 now ports the next coherent profile layer:
- Taxi continuous yaw `-20`, rotate back;
- Hearth/Teleport continuous yaw `+15`, rotate back;
- NPC Interaction yaw `-45`, rotate back;
- Fishing yaw/pitch `+10/+10`, rotate back;
- Gathering yaw/pitch `-15/+15`, rotate back;
- standard captured camera settings:
  - `cameraZoomSpeed = 15.5`;
  - dynamic pitch enabled with captured pad/cutoff values;
  - enemy/interact focus enabled with captured yaw/pitch strengths;
- zoom-based standard shoulder curve `0 -> 0`, `2 -> 0`, `7 -> +1`, `50 -> +1`;
- NPC shoulder curve `0 -> 0`, `2 -> 0`, `7 -> -2`, `50 -> -2`;
- City `cameraDistanceMaxZoomFactor = 1` as an explicit situation-specific override;
- exact pre-ownership CVar capture and restoration on disable/relinquish/DynamicCam coexistence.

The max-distance rule is therefore narrowed again: arbitrary or global max-distance mutation remains forbidden, but the **captured City override `1`** is now source/profile-authorized and must restore the exact pre-ownership value outside City.

Reactive mouse-wheel zoom remains the last non-presentation Camera parity slice after P0161. DynamicCam UI fades remain Phase H presentation policy.

## Verified State

P0160 R2:
- commit `ae75989b`;
- runtime `0.0.79-dev`;
- client `1.60.1.70245`;
- loadCount `191`;
- source-backed LibCamera zoom path runtime PASS for base, Taxi entry, and Taxi landing;
- source rebase branch runtime-exercised in both outbound and return transitions;
- final correction branch was not needed in the accepted Taxi sample (`corrections=0`);
- prior high-frequency direction switching did not recur (`switches=0`).

P0159 context/profile selection remains accepted for the observed ordinary/Taxi scope.

The following captured contexts remain environmental runtime deferrals unless naturally exercised:
- Hearth/Teleport;
- NPC Interaction;
- Fishing;
- Gathering;
- AFK priority behavior.

## Next Action

Apply/deploy P0161 (`0.0.80-dev`), then:

1. `/reload`.
2. Phase G -> **Camera Profile Check**.
3. Phase 0 -> **Run All** separately.
4. Use normal mouse zoom briefly and confirm ordinary camera control remains usable.
5. Take one normal Taxi:
   - confirm visible continuous left yaw while airborne;
   - Phase G -> **Camera Profile Check** while airborne;
   - after landing/settling, confirm the yaw returns while zoom returns close;
   - Phase G -> **Camera Profile Check** again.
6. Upload refreshed `LOGRES_DIAGNOSTICS_LATEST.lua`.

Do not manufacture Teleport/Fishing/Gathering/NPC contexts solely for proof. Naturally observed contexts can be accepted later from evidence.

If P0161 is clean, the only remaining non-presentation Camera parity slice is source-backed reactive mouse-wheel zoom; after that, Phase G can close with explicit environmental deferrals and Phase H becomes primary.

## Success Criteria

P0161 succeeds when:
- P0160 zoom behavior remains clean;
- Taxi continuous yaw `-20` is visibly active in flight;
- Taxi exit rotates back without leaving persistent camera rotation;
- standard captured camera CVar settings are applied while Logres owns the profile;
- City max-distance factor `1` is situation-scoped and the prior value is restored outside City;
- shoulder offset follows the standard/NPC captured curves;
- profile behavior diagnostics show zero settings/rotation failures;
- DynamicCam coexistence and module disable restore all captured CVar tokens and stop rotation;
- no UI fade/suppression is added;
- no reactive mouse-wheel hook is added yet;
- all static checks and `git diff --check` pass;
- no Lua, taint, protected-action, or secret-value failure occurs.

## Do Not Reopen Without New Evidence

- no conventional player health bar;
- no arbitrary/global `cameraDistanceMaxZoomFactor` ownership beyond the captured City override;
- no periodic context polling;
- no DynamicCam UI fade in Phase G;
- no reactive mouse-wheel override in P0161;
- P0152 pet execution/state presentation remains accepted;
- stock minimap, Party/CompactPartyFrame, target aura/status, target-of-target, and unsupported class/special surfaces remain available until their replacement gates are satisfied;
- player harmful/urgent and populated target aura production remain deferred;
- positive world-target nameplate attachment remains deferred;
- individual tracking-result positions remain source-blocked by D-043;
- possess/override/vehicle/extra-action surfaces remain separate domains.

## Relevant References

- `docs/memory/evidence/P0161_P0160_ZOOM_DRIVER_PASS_2026-10-07.md`
- `docs/memory/evidence/P0161_PROFILE_BEHAVIOR_SOURCE_AUDIT_2026-10-07.md`
- `docs/memory/patches/P0161_PROFILE_ROTATION_SETTINGS_PARITY.md`
- `docs/memory/patches/P0160_R2_LIBCAMERA_ZOOM_DRIVER.md`
- `docs/memory/evidence/G1_DYNAMICCAM_RPG_PROFILE_2026-10-02.json`
- `docs/memory/evidence/G6_DYNAMICCAM_PROFILE_PARITY_AUDIT_2026-10-06.md`
- `docs/memory/investigations/G6_DYNAMICCAM_PROFILE_PARITY.md`
- `docs/memory/architecture/CAMERA.md`
- `docs/memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`
- `docs/memory/roadmap/STATUS.md`
- `docs/ROADMAP.md`
