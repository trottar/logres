---
memory_schema: 1
as_of: 2026-10-02
project: logres
---

# Current State

## Active Objective

**Phase G — Cinematic Camera.**

## Current Work Item

**G.3 — Production World/Combat camera ownership.**

P0096 is verified pushed at:
`a556a19a569fe2c539b6b61ab5946f6fa7e91c68`.

P0097 world-first layout direction is verified pushed at:
`86d062d3a6be264a29f3b9d36cccdc7ac1ff5987`.

P0098 parallel World Ghost art direction is verified pushed at:
`903e65c88dde36cc31d6f64af8cc6ff3da4623fd`.

Current pushed runtime:
`0.0.40-dev`.

G.2 status:
**CLOSED — RUNTIME + INTEGRATION PASS.**

P0099 is the docs/evidence transition checkpoint that records that closure and
opens G.3. It does not change runtime code.

## Verified State

- Phase F is complete.
- G.1 is complete.
- G.2 is complete.
- P0096 is durable at `a556a19a`.
- P0097 is durable at `86d062d3`; D-032 records future world-first layout and action-role direction without changing Phase G camera scope.
- P0098 is durable at `903e65c8`; D-033 records parallel World Ghost visual direction without changing Phase G runtime scope.
- P0096 corrected only the camera probe's combat classifier:
  - `combat` = live `UnitAffectingCombat("player")`;
  - `lockdown` = live `InCombatLockdown()`;
  - `cachedCombat` = existing Logres state;
  - `mismatch` = live combat versus cached combat disagreement.
- The captured `0.0.40-dev` diagnostics contain two genuine live-combat probes,
  both with:
  - `combat=true`;
  - `lockdown=true`;
  - `cachedCombat=false`;
  - `mismatch=true`;
  - `targetReached=true`;
  - `moved=true`;
  - `restored=true`;
  - `secret=false`;
  - `error=nil`.
- The out-of-combat probe path remained clean.
- A post-combat probe returned to `combat=false` and restoration PASS.
- Run All was performed on the current `0.0.40-dev` runtime and every emitted
  check passed through `checkall: complete`.
- The `cachedCombat=false` / `mismatch=true` result is retained as evidence that
  camera context must use DynamicCam's actual live combat predicate rather than
  cached Logres combat state.
- Core `State.combat` semantics are not changed by G.2.
- Automatic Logres production camera ownership is still absent at this
  checkpoint.

## G.3 Production Contract

Context selection for this first production slice follows the captured profile:
- World (Combat): not in an instance and live
  `UnitAffectingCombat("player") == true`; this has priority over World.
- World: not resting and not in an instance when World (Combat) is not active.
- Other contexts are outside G.3 and must not acquire invented camera behavior.

Camera behavior:
- World conditionally targets zoom `5` only when currently farther than 5.
- World (Combat) conditionally targets zoom `15` only when currently closer
  than 15.
- Ordinary World <-> World (Combat) transition time is `2.5` seconds.
- Zoom restore remains `never`.
- Use the proven `GetCameraZoom` + `MoveView*Start/Stop` mechanism.
- Do not adopt the unproven temporary-`SetCVar` / `CameraZoomIn/Out` fallback.
- `InCombatLockdown()` is a separate restriction signal, not the camera-context
  predicate.
- Stop active movement cleanly on interruption, disable, ownership loss, or
  failure.
- DynamicCam and Logres must never drive camera movement simultaneously.
- Fail open to a usable current camera position.

## Next Action

After P0099 is verified pushed, implement G.3 production World/Combat camera
ownership from the above contract.

The implementation must remain capability-gated and event/state-driven; active
animation frames are allowed only while a camera transition is running and must
not become context polling.

Parallel Phase H+ art-direction work remains valid under D-032/D-033 and does
not change this runtime next action.

## Success Criteria

G.3 completes only after production ownership proves:
- World conditional target behavior;
- live-combat World (Combat) conditional target behavior;
- ordinary 2.5-second transition behavior;
- no invented pre-combat zoom restoration;
- clean interruption/disable/ownership-loss handling;
- no simultaneous DynamicCam movement ownership;
- no Lua, taint, protected-action, or secret-value errors;
- integrated checks remain clean on the current runtime.

## Do Not Reopen Without New Evidence

- **Phase F:** complete.
- **F.6 contextual objective progress pulse:** complete.
- **G.1 DynamicCam profile capture:** complete.
- **G.2 World/Combat camera capability:** runtime + integration PASS.
- **G.2 DynamicCam zoom semantics:** conditional absolute targets, not deltas.
- **P0095 out-of-combat primary camera path:** PASS.
- **P0095 combat classifier:** INVALID for G.2; used cached State.combat.
- **P0096 live-combat classifier and primary path:** PASS.
- **Core State.combat redesign:** not authorized by the camera investigation.
- **Instance camera custom profile:** absent from captured RPG profile.
- **Temporary camera CVar fallback:** unproven and not accepted.
- **Quest destination / compass marker:** unsupported until runtime-proven.
- **D-032 world-first layout direction:** accepted future Phase H+ direction.
- **D-033 World Ghost art direction:** accepted parallel visual hypothesis.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/G1_DYNAMICCAM_PROFILE_CAPTURE_2026-10-02.md`
- `docs/memory/evidence/G2_DYNAMICCAM_ZOOM_SOURCE_AUDIT_2026-10-02.md`
- `docs/memory/evidence/G2_P0095_COMBAT_CLASSIFICATION_FAIL_2026-10-02.md`
- `docs/memory/evidence/G2_P0096_RUNTIME_PASS_2026-10-02.md`
- `docs/memory/investigations/G2_WORLD_COMBAT_CAMERA_CAPABILITY.md`
- `docs/memory/investigations/G3_WORLD_COMBAT_CAMERA_OWNERSHIP.md`
- `docs/memory/architecture/CAMERA.md`
- `docs/memory/patches/P0096_FIX_CAMERA_COMBAT_CLASSIFICATION.md`
- `docs/memory/patches/P0099_CLOSE_G2_OPEN_G3.md`
- `docs/memory/decisions/D-032_WORLD_FIRST_LAYOUT_AND_ACTION_ROLES.md`
- `docs/memory/decisions/D-033_PARALLEL_ART_DIRECTION_AND_WORLD_GHOST.md`
- `docs/memory/architecture/WORLD_FIRST_LAYOUT.md`
- `docs/memory/architecture/VISUAL_SYSTEM_DIRECTION.md`
- `docs/memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
