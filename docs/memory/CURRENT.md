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

P0101 is verified pushed at:
`86660959f4ba7d48a0d205c992e39712343a6aca`.

Current pushed runtime:
`0.0.41-dev`.

P0102 runtime target:
`0.0.42-dev`.

G.2 status:
**CLOSED — RUNTIME + INTEGRATION PASS.**

G.3 status:
**ACTIVE — FIRST P0100 MOVEMENT OBSERVATION ENVIRONMENTALLY DEFERRED; DEV-PANEL OVERFLOW DEFECT PROVEN.**

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
- P0099 is durable at `10c7255f`; G.2 is closed and G.3 is active.
- P0100 is durable at `31a2a7f6`, runtime `0.0.41-dev`; production runtime proof
  remains pending.
- P0101 is durable at `86660959`; D-034 refines the parallel visual anchor to
  Selective Hybrid E and establishes the canonical visual-component inventory /
  percentage-bar direction without changing G.3 runtime scope.
- The P0096 `cachedCombat=false` / `mismatch=true` evidence remains authoritative:
  camera combat selection uses live `UnitAffectingCombat("player")`, not cached
  `State.combat`.
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
- The first P0100 production-controller screenshot did not exercise World
  movement because addon-owned state reported `outside-slice:resting`:
  - selected context `none`;
  - ownership false;
  - live combat false;
  - DynamicCam false;
  - camera API available;
  - no secret/error result.
- Classification of that camera observation:
  **ENVIRONMENTAL DEFERRAL — EXPECTED RESTING RELINQUISH; MOVEMENT UNPROVEN.**
- The same screenshot proved a separate developer-panel presentation defect: the
  flat action grid exceeded its fixed button area and overlapped diagnostic
  output.
- Accepted corrective panel direction is one tab per roadmap phase
  `0/A/B/C/D/E/F/G/H`, with only the selected phase's controls rendered.
- Global addon version synchronization is already enforced by
  `tools/check_addon_structure.py`; feature-specific camera checks must not pin
  the whole addon to one exact runtime version.

## Next Action

Apply and push P0102 from verified P0101 baseline `86660959`.

After verified push:
- deploy `0.0.42-dev`;
- `/reload`;
- confirm the developer panel presents phase tabs without control/result overlap;
- use Phase G for camera controls;
- leave resting/City and retry G.3 World movement from zoom >5;
- continue the P0100 G.3 acceptance sequence only after World movement is
  actually exercised.

Do not classify the resting observation as a camera movement PASS or FAIL.

## Success Criteria

G.3 completes only after production ownership proves:
- World conditional target behavior outside resting/City;
- live-combat World (Combat) conditional target behavior;
- ordinary 2.5-second transition behavior;
- no invented pre-combat zoom restoration;
- clean interruption/disable/ownership-loss handling;
- no simultaneous DynamicCam movement ownership;
- no Lua, taint, protected-action, or secret-value errors;
- integrated checks remain clean on the current runtime.

The P0102 developer-panel correction additionally requires:
- tabs `0/A/B/C/D/E/F/G/H`;
- only the selected phase's actions rendered;
- no control/result overlap at the supported panel size;
- diagnostics persistence unchanged;
- camera feature checks remain independent of unrelated global version bumps.

## Do Not Reopen Without New Evidence

- **Phase F:** complete.
- **G.1 DynamicCam profile capture:** complete.
- **G.2 World/Combat camera capability:** runtime + integration PASS.
- **G.2 DynamicCam zoom semantics:** conditional absolute targets, not deltas.
- **P0096 live-combat classifier and primary path:** PASS.
- **Core State.combat redesign:** not authorized by the camera investigation.
- **Temporary camera CVar fallback:** unproven and not accepted.
- **P0100 first resting observation:** environmental deferral, not movement failure.
- **D-032 world-first layout direction:** accepted future Phase H+ direction.
- **D-033 World Ghost art direction:** accepted parallel visual hypothesis.
- **D-034 Selective Hybrid E + component taxonomy:** accepted parallel art-direction refinement; no Lua implementation implied.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/G2_P0096_RUNTIME_PASS_2026-10-02.md`
- `docs/memory/evidence/G3_P0100_RESTING_DEFERRAL_PANEL_OVERFLOW_2026-10-02.md`
- `docs/memory/investigations/G3_WORLD_COMBAT_CAMERA_OWNERSHIP.md`
- `docs/memory/architecture/CAMERA.md`
- `docs/memory/architecture/DEV_PANEL.md`
- `docs/memory/patches/P0100_G3_WORLD_COMBAT_CAMERA_OWNERSHIP.md`
- `docs/memory/patches/P0101_VISUAL_COMPONENT_INVENTORY_AND_HYBRID_E.md`
- `docs/memory/patches/P0102_PHASE_TABBED_DEV_PANEL.md`
- `docs/memory/decisions/D-032_WORLD_FIRST_LAYOUT_AND_ACTION_ROLES.md`
- `docs/memory/decisions/D-033_PARALLEL_ART_DIRECTION_AND_WORLD_GHOST.md`
- `docs/memory/decisions/D-034_SELECTIVE_HYBRID_E_AND_VISUAL_COMPONENTS.md`
- `docs/memory/architecture/VISUAL_COMPONENT_INVENTORY.md`
- `docs/memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
