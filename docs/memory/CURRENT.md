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

P0095 is verified pushed at `b65ea1af`.

Current pushed runtime:
`0.0.39-dev`.

P0096 runtime target:
`0.0.40-dev`.

G.2 status:
**PRIMARY CAMERA PATH PASS OUT OF COMBAT; COMBAT CLASSIFICATION DEFECT PROVEN; IN-COMBAT PROOF PENDING.**

## Verified State

- Phase F is complete.
- G.1 is complete.
- P0095 is durable at `b65ea1af`.
- G.2 source semantics remain:
  - World conditionally targets zoom 5 when farther than 5;
  - World (Combat) conditionally targets zoom 15 when closer than 15;
  - ordinary transition 2.5 seconds;
  - zoom restore `never`.
- DynamicCam's actual World (Combat) predicate is
  `UnitAffectingCombat("player")` while not in an instance.
- P0095 primary-path runtime movement is proven out of combat:
  - DynamicCam not loaded;
  - camera APIs available;
  - `cameraZoomSpeed = 15.5`;
  - two reversible probe runs PASS;
  - target reached, movement observed, starting zoom restored;
  - no secret/error result.
- Both P0095 probe results reported `combat=false`.
- P0095 sampled that value from cached `Logres:GetState().combat`.
- Core `State.combat` is derived from `InCombatLockdown()` only when registered
  state events refresh the cache.
- Existing I-001 runtime evidence already proved combat ordering can expose
  `PLAYER_REGEN_DISABLED` and `ADDON_RESTRICTION_STATE_CHANGED` while
  `InCombatLockdown()` is still false, with true appearing only later.
- Therefore cached `State.combat` is not a valid classifier for the DynamicCam
  World (Combat) situation and can remain false for the probe run.
- P0096 does not redefine the core state engine.
- P0096 changes only the capability diagnostic:
  - `combat` = live `UnitAffectingCombat("player")` at probe start;
  - `lockdown` = live `InCombatLockdown()` at probe start;
  - `cachedCombat` = existing Logres state value;
  - `mismatch` records disagreement.
- Automatic Logres camera ownership remains absent.

## Next Action

Apply and push P0096.

After verified push:
- keep DynamicCam disabled for the isolated test;
- deploy Logres `0.0.40-dev`;
- `/reload`;
- run one out-of-combat Camera Zoom Probe and record the second-click result;
- engage a mob naturally;
- while `UnitAffectingCombat("player")` is active, run one Camera Zoom Probe;
- the second-click result must show `combat=true` and movement/target/restoration
  PASS;
- record `lockdown`, `cachedCombat`, and `mismatch` as observed rather than
  forcing them to agree;
- run Run All once;
- `/reload` and export diagnostics.

Do not change the core state engine from this G.2 result alone.

## Success Criteria

G.2 completes only after:
- primary camera path PASS out of combat remains preserved;
- one probe starts with live DynamicCam-equivalent `combat=true`;
- that probe reaches its target and restores the starting zoom;
- live lockdown/cached-state values are recorded without being used to fake the
  DynamicCam combat predicate;
- no Lua, taint, protected-action, or secret-value errors;
- DynamicCam is not simultaneously driving the camera;
- production World/Combat behavior can be implemented from proven signals.

## Do Not Reopen Without New Evidence

- **Phase F:** complete.
- **F.6 contextual objective progress pulse:** complete.
- **G.1 DynamicCam profile capture:** complete.
- **G.2 DynamicCam zoom semantics:** conditional absolute targets, not deltas.
- **P0095 out-of-combat primary camera path:** PASS.
- **P0095 combat classifier:** INVALID for G.2; used cached State.combat.
- **Core State.combat redesign:** not authorized by this camera investigation.
- **Instance camera custom profile:** absent from captured RPG profile.
- **Quest destination / compass marker:** unsupported until runtime-proven.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/G2_DYNAMICCAM_ZOOM_SOURCE_AUDIT_2026-10-02.md`
- `docs/memory/evidence/G2_P0095_COMBAT_CLASSIFICATION_FAIL_2026-10-02.md`
- `docs/memory/evidence/I001_RUNTIME_PASS_01_2026-09-30.md`
- `docs/memory/investigations/G2_WORLD_COMBAT_CAMERA_CAPABILITY.md`
- `docs/memory/architecture/CAMERA.md`
- `docs/memory/patches/P0095_CAMERA_ZOOM_CAPABILITY_PROBE.md`
- `docs/memory/patches/P0096_FIX_CAMERA_COMBAT_CLASSIFICATION.md`
- `docs/memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`
