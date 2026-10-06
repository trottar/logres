---
memory_schema: 1
as_of: 2026-10-06
project: logres
---

# Current State

## Active Objective

**Correct the reproduced world-entry camera direction-switch defect, then retest normal world entry without widening camera ownership.**

P0152 remains accepted on `0.0.74-dev`; exact pet-button ornament/contrast refinement remains deferred to later whole-interface polish.

P0154 is verified durable at `40dec1874a587156c88319a9caed940088e25db7` on candidate `0.0.75-dev`. Its targeted motion diagnostic reproduced the timeout and exposed a concrete P0119 driver defect.

## Current Work Item

**P0155 R1 — stop the previously active MoveView direction before P0119 correction reverses camera motion.**

P0154 runtime evidence on loadCount `184`:
- world-entry start about `23.148`, requested/effective target `5`, final/current `50`;
- elapsed about `3.252s`, `targetReached=false`, one timeout failure;
- `145` samples: `1` toward, `1` away, `143` flat;
- observed range `0 -> 50`, with final easing position error `45`;
- Logres issued `142` inward commands and `1` outward command.

The one outward command is significant. The observed camera crossed the target during world-entry initialization, so P0119's corrective path reversed direction. Current code starts the new MoveView direction but does not stop the previously active direction until transition cleanup. That is a concrete driver defect independent of the still-unproven external source of the `0/50` world-entry jumps.

P0155 R1 changes only direction-switch hygiene. The initial P0155 artifact refused before tracked writes because it incorrectly treated the differently-indented module and per-transition counter blocks as one repeated baseline fragment. R1 validates them separately. It does not add polling, delay ownership, rebase easing time, mutate CVars, change targets/durations/timeouts, or alter Taxi policy.

## Verified State

P0152 R12 remains accepted for the bounded pet-action slice.

The world-entry camera failure is **REPRODUCED**. P0154 itself is a **DIAGNOSTIC PASS**: it captured the required command-versus-observed evidence and identified a narrow stop-before-reverse defect.

The origin of the discrete world-entry camera displacement remains unresolved. P0155 does not claim to solve that external displacement; it prevents Logres from leaving opposite MoveView directions concurrently active when correction reverses.

## Next Action

Apply P0155 R1, redeploy, then:
1. `/reload` in normal world state;
2. developer panel -> Phase G -> **Camera World/Combat Check**;
3. developer panel -> Phase 0 -> **Run All** separately;
4. upload refreshed diagnostics.

Success requires the world transition to converge near target `5` with `failures=0`, `secret=false`, and no Lua/taint/protected-action error. The motion line must retain P0154 data and report direction-switch count. If the timeout persists after correct stop-before-reverse behavior, use that result to decide whether positional rebasing or a narrower world-entry ownership rule is justified.

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
- no max-distance CVar mutation, Taxi rotation, Taxi UI fade, polling, broad hooks, periodic camera reassertion, or arbitrary world-entry delay is authorized.

## Relevant References

- `docs/memory/evidence/P0155_P0154_CAMERA_MOTION_RESULT_2026-10-06.md`
- `docs/memory/investigations/CAMERA_WORLD_ENTRY_TRANSITION_TIMEOUT_2026-10-06.md`
- `docs/memory/patches/P0155_CAMERA_DIRECTION_SWITCH_STOP.md`
- `docs/memory/patches/P0154_WORLD_ENTRY_CAMERA_MOTION_DIAGNOSTIC.md`
- `docs/memory/patches/P0119_FIX_CAMERA_TRANSITION_OVERSHOOT.md`
- `docs/memory/evidence/G2_DYNAMICCAM_ZOOM_SOURCE_AUDIT_2026-10-02.md`
- `docs/memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`
- `docs/memory/roadmap/STATUS.md`
- `docs/ROADMAP.md`
