---
memory_schema: 1
as_of: 2026-10-06
project: logres
---

# Current State

## Active Objective

**Correct the reproduced world-entry camera transition by starting its motion/timeout clock only when the first drivable frame actually runs.**

P0152 remains accepted on `0.0.74-dev`; exact pet-button ornament/contrast refinement remains deferred to later whole-interface polish.

P0155 R1 is verified durable at `e9be312d24c89d6b2d4d9935ea6eb6f9424ca698` on `0.0.76-dev`. Its stop-before-reverse correction is installed, but the runtime retest failed before that path could execute.

## Current Work Item

**P0156 — first-drivable-frame camera transition start.**

P0155 runtime evidence on loadCount `185`:
- the user reported the camera was extremely zoomed out;
- Phase G reported start/current/final `50`, target `5`;
- elapsed was about `23.523s`;
- only `1` transition sample ran;
- `inCommands=0`, `outCommands=0`, `switches=0`;
- no secret-value error;
- separate Run All repeated the same camera failure.

This proves the transition timeout clock started during `PLAYER_ENTERING_WORLD` before the camera OnUpdate loop had a drivable frame. By the first OnUpdate, elapsed time already exceeded the `2.5s + timeout-extra` budget, so `FinishTransition()` ran before `ApplyTransitionMotion()` could issue any command.

P0156 defers only the transition motion/timeout clock to the first actual OnUpdate frame and rebases the transition start zoom to that first drivable sample. It does not add a timer, delay, polling loop, new event, CVar mutation, target change, duration change, or Taxi-policy expansion.

## Verified State

P0154 remains a diagnostic PASS.

P0155 R1 is **INSTALLED / PUSHED — RUNTIME FAIL / NOT EXERCISED** for the intended reversal behavior: its runtime sample had zero MoveView commands and zero direction switches, so the stop-before-reverse correction was not actually tested.

The new failure is narrower than the previous competing-motion hypothesis. The immediate cause of this sample is stale event-time elapsed state, not a wrong camera target and not a failed direction-switch stop.

The external reason the camera entered world state at zoom `50` remains unproven.

## Next Action

Apply P0156, redeploy, then:
1. `/reload` in normal world state;
2. developer panel -> Phase G -> **Camera World/Combat Check**;
3. developer panel -> Phase 0 -> **Run All** separately;
4. upload refreshed diagnostics.

The motion line now reports `armZoom` and `firstDelay`. A large `firstDelay` is acceptable if the transition still receives its full motion budget after the first drivable frame.

PASS requires convergence near target `5`, `failures=0`, `secret=false`, and no Lua/taint/protected-action error.

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
- no max-distance CVar mutation, Taxi rotation, Taxi UI fade, polling, broad hooks, periodic camera reassertion, or arbitrary delayed reconcile is authorized.

## Relevant References

- `docs/memory/evidence/P0156_P0155_FIRST_UPDATE_TIMEOUT_2026-10-06.md`
- `docs/memory/investigations/CAMERA_WORLD_ENTRY_TRANSITION_TIMEOUT_2026-10-06.md`
- `docs/memory/patches/P0156_FIRST_DRIVABLE_FRAME_CAMERA_TRANSITION.md`
- `docs/memory/patches/P0155_CAMERA_DIRECTION_SWITCH_STOP.md`
- `docs/memory/patches/P0154_WORLD_ENTRY_CAMERA_MOTION_DIAGNOSTIC.md`
- `docs/memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`
- `docs/memory/roadmap/STATUS.md`
- `docs/ROADMAP.md`
