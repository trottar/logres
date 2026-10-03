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

P0100 is verified pushed at:
`31a2a7f63298252325938897ba653d33d8e384ec`.

Current pushed runtime:
`0.0.41-dev`.

G.2 status:
**CLOSED — RUNTIME + INTEGRATION PASS.**

P0100 implements the first production World/Combat camera controller. Runtime
acceptance remains pending until the pushed build is deployed and exercised in
WoW Forever.

## Verified State

- Phase F is complete.
- G.1 is complete.
- G.2 is complete.
- P0096 is durable at `a556a19a`; its two genuine live-combat probes proved the
  primary MoveView path with live `UnitAffectingCombat("player")`.
- P0097 is durable at `86d062d3`; D-032 records future world-first layout and
  action-role direction without changing Phase G camera scope.
- P0098 is durable at `903e65c8`; D-033 records parallel World Ghost visual
  direction without changing Phase G runtime scope.
- D-034 refines the visual anchor to Selective Hybrid E and establishes the canonical visual-component inventory / percentage-bar direction for parallel art work.
- P0099 is durable at `10c7255f`; G.2 is closed and G.3 is active.
- P0100 is durable at `31a2a7f`, runtime `0.0.41-dev`; G.3 production runtime proof remains pending.
- The P0096 `cachedCombat=false` / `mismatch=true` evidence remains authoritative:
  camera combat selection uses live `UnitAffectingCombat("player")`, not cached
  `State.combat`.
- Core `State.combat` semantics remain unchanged.
- G.3 profile semantics remain:
  - World conditionally targets zoom `5` only when farther than 5;
  - World (Combat) conditionally targets zoom `15` only when closer than 15;
  - ordinary transition duration is `2.5` seconds;
  - zoom restore is `never`.
- G.3 uses the proven `GetCameraZoom` + read-only `cameraZoomSpeed` +
  `MoveView*Start/Stop` mechanism.
- The temporary `SetCVar` / `CameraZoomIn/Out` corrective fallback remains
  unproven and is not adopted.
- DynamicCam and Logres must never drive camera movement simultaneously.

## G.3 P0100 Implementation

P0100 adds `CameraWorldCombat`, an auto-enabled production module.

Selection is event/state-driven:
- cached state subscription handles ordinary instance/resting/taxi/interaction
  changes;
- targeted combat/restriction events force reevaluation of the live
  `UnitAffectingCombat("player")` predicate even when cached State publishes no
  change;
- `OnUpdate` exists only while an active camera transition is running and is
  not context polling.

Known higher/out-of-slice contexts gated by current proven state are:
- instance;
- taxi;
- NPC interaction;
- resting/City when not overridden by live combat.

Unimplemented later DynamicCam contexts such as fishing, gathering,
hearth/teleport, and AFK remain future Phase G slices and are not newly modeled
by P0100.

Ownership/fail-open behavior:
- DynamicCam loaded -> Logres relinquishes movement ownership;
- historical G.2 probe running -> production controller relinquishes;
- historical probe refuses to start while production controller is enabled;
- active movement stops before replacement transitions and on disable,
  ownership loss, or failure;
- no speculative camera restoration occurs.

Developer diagnostics add:
- Camera World/Combat Check;
- Camera World/Combat Reconcile;
- Camera World/Combat ON;
- Camera World/Combat OFF.

The non-mutating Camera World/Combat Check is included in Run All. Manual
Reconcile is deliberately excluded from Run All because it may move the camera.

## Next Action

Deploy pushed P0100 runtime `0.0.41-dev` and validate with DynamicCam disabled:
- World target transition from farther than 5;
- World no-op at 5 or closer;
- automatic live-combat transition from closer than 15;
- combat no-op at 15 or farther;
- automatic combat-exit World transition without remembered pre-combat restore;
- movement interruption by controller disable;
- clean re-enable/reconcile;
- Run All PASS with Camera World/Combat Check PASS;
- no Lua, taint, protected-action, or secret-value errors.

A separate coexistence validation with DynamicCam loaded must show Logres
blocked/relinquished with no simultaneous movement.

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
- **D-034 Selective Hybrid E + component taxonomy:** accepted parallel art-direction refinement; no Lua implementation implied.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/G1_DYNAMICCAM_PROFILE_CAPTURE_2026-10-02.md`
- `docs/memory/evidence/G2_DYNAMICCAM_ZOOM_SOURCE_AUDIT_2026-10-02.md`
- `docs/memory/evidence/G2_P0096_RUNTIME_PASS_2026-10-02.md`
- `docs/memory/investigations/G3_WORLD_COMBAT_CAMERA_OWNERSHIP.md`
- `docs/memory/architecture/CAMERA.md`
- `docs/memory/patches/P0099_CLOSE_G2_OPEN_G3.md`
- `docs/memory/patches/P0100_G3_WORLD_COMBAT_CAMERA_OWNERSHIP.md`
- `docs/memory/decisions/D-032_WORLD_FIRST_LAYOUT_AND_ACTION_ROLES.md`
- `docs/memory/decisions/D-033_PARALLEL_ART_DIRECTION_AND_WORLD_GHOST.md`
- `docs/memory/decisions/D-034_SELECTIVE_HYBRID_E_AND_VISUAL_COMPONENTS.md`
- `docs/memory/architecture/WORLD_FIRST_LAYOUT.md`
- `docs/memory/architecture/VISUAL_SYSTEM_DIRECTION.md`
- `docs/memory/architecture/VISUAL_COMPONENT_INVENTORY.md`
- `docs/memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
