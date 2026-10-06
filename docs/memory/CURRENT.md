---
memory_schema: 1
as_of: 2026-10-06
project: logres
---

# Current State

## Active Objective

**Diagnose the reproduced `PLAYER_ENTERING_WORLD` camera transition conflict without changing camera behavior speculatively.**

P0152 remains accepted on `0.0.74-dev`; exact pet-button ornament/contrast refinement remains deferred to later whole-interface polish.

The targeted P0153 retest reproduced the Camera World/Combat timeout after a normal `/reload`, so the camera issue is now a real reproduced runtime defect rather than an intermittent watch.

## Current Work Item

**P0154 — instrument the existing camera transition driver to distinguish commanded motion from observed camera motion during world-entry transitions.**

Latest verified durable checkpoint:
P0153 `7ad9be7ecc24c1136bf9a843689f90fb377b2012` (docs/evidence), with P0152 code at `00aef4a90e5999140dc9082e68e934cfc854cb05` / `0.0.74-dev`.

Reproduced camera evidence on loadCount `182`:
- Phase G **Camera World/Combat Check** failed after normal `/reload`;
- requested/effective target `5`;
- transition start about `8.524`;
- final/current about `12.632` after about `3.258s`;
- `targetReached=false`, `failures=1`;
- separate Phase 0 **Run All** repeated the same camera failure while the other listed integrated checks passed.

Because the requested motion was inward (`8.524 -> 5`) while the observed final zoom moved outward to `12.632`, the next question is whether Logres was commanding inward while the client camera moved away from target. Static source review confirms the existing MoveView direction mapping matches the audited LibCamera path; however the exact competing runtime source is not yet proven.

P0154 changes diagnostics only. It does not alter target selection, transition duration, velocity policy, timeout, CVar ownership, Taxi policy, or camera event ownership.

## Verified State

P0152 R12 remains accepted for the bounded pet-action slice: default-on pet controls, working user-triggered execution, ten effective pet bindings, seven readable slots, two active indicators, one autocast indicator, and stock PetActionBar fallback.

The camera timeout is now **REPRODUCED**. Two distinct world-entry sessions have timed out toward target `5`; the newest targeted retest is stronger because the camera moved from start `8.524` to final `12.632`, away from the requested target.

The current P0119 transition driver computes an easing velocity from the original transition start/time and does not currently record per-frame observed-versus-commanded motion. Audited LibCamera source includes positional-error rebasing when the actual camera position departs materially from its expected easing path. That difference is a narrow investigation lead, not yet an accepted fix.

## Next Action

Apply P0154, redeploy, then perform one normal world-entry diagnostic:
1. `/reload` in normal world state;
2. developer panel -> Phase G -> **Camera World/Combat Check**;
3. developer panel -> Phase 0 -> **Run All** separately;
4. upload refreshed diagnostics.

Inspect the new motion line. The key evidence is whether an inward-target transition records `inCommands>0`, `outCommands=0`, while `away>0`, `maxZoom>startZoom`, and position error grows. If so, the stale easing plan is demonstrably being displaced by motion outside Logres' commanded direction and the next patch may address positional rebasing/correction. If not, narrow the driver cause from the recorded command/observation data before changing behavior.

## Success Criteria

P0154 succeeds as a diagnostic checkpoint if:
- the existing reproduced timeout is preserved, not hidden by changed behavior;
- addon-owned state records observed samples, toward/away counts, min/max zoom, easing position error, and MoveView command direction/counts;
- diagnostics remain secret-safe and introduce no polling/timers/CVar mutation;
- the Phase G panel action exposes the new evidence;
- no unrelated runtime behavior changes;
- the separate Run All result is preserved exactly.

## Do Not Reopen Without New Evidence

- no conventional player health bar;
- P0152 pet execution/default-on/state-presentation is accepted; exact ornament/contrast refinement belongs to later whole-interface polish;
- PetActionBar suppression, pet edit/reorder, binding replacement, and PetFrame ownership remain separately gated;
- harmful/urgent player and populated target aura production remain deferred;
- positive world-target nameplate anchoring/attachment remains deferred;
- individual tracking-result positions remain source-blocked by P0142/D-043;
- stock minimap remains until replacement completeness is proven;
- party/CompactPartyFrame remain stock until secure interaction and required group/aura information are replaced safely;
- RuneFrame, TotemFrame, alternate-power, direct class-resource children, stance/form, and unsupported special-control surfaces remain Blizzard-owned until separately runtime/capability-proven;
- possess/override/vehicle/extra-action surfaces are not ordinary Bar 2–3 roles;
- Continue/Complete/reward/gossip quest ownership remains separately gated;
- normal-Taxi landing proof remains pending independently of this world-entry regression;
- no max-distance CVar mutation, Taxi rotation, Taxi UI fade, polling, broad hooks, or periodic camera reassertion is authorized.

## Relevant References

- `docs/memory/evidence/P0154_WORLD_ENTRY_CAMERA_TIMEOUT_REPRODUCED_2026-10-06.md`
- `docs/memory/investigations/CAMERA_WORLD_ENTRY_TRANSITION_TIMEOUT_2026-10-06.md`
- `docs/memory/evidence/G2_DYNAMICCAM_ZOOM_SOURCE_AUDIT_2026-10-02.md`
- `docs/memory/patches/P0119_FIX_CAMERA_TRANSITION_OVERSHOOT.md`
- `docs/memory/patches/P0154_WORLD_ENTRY_CAMERA_MOTION_DIAGNOSTIC.md`
- `docs/memory/evidence/P0153_P0152_RUNTIME_ACCEPTANCE_CAMERA_TIMEOUT_2026-10-06.md`
- `docs/memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`
- `docs/memory/roadmap/STATUS.md`
- `docs/ROADMAP.md`
