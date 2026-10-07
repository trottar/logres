---
memory_schema: 1
as_of: 2026-10-06
project: logres
---

# Current State

## Active Objective

**Resume Phase G.5 with the still-pending normal-Taxi landing retest after closing the observed world-entry regression.**

P0152 remains accepted on `0.0.74-dev`; exact pet-button ornament/contrast refinement remains deferred to later whole-interface polish.

P0156 is verified durable at `e1be731bd64db2acb62480f62fafaea58515989f` on `0.0.77-dev`.

## Current Work Item

**G.5 — normal-Taxi landing retest for the shared camera transition driver.**

P0156 runtime evidence on loadCount `187` / Forever `1.60.1.70245`:
- Phase G **Camera World/Combat Check** PASS;
- context `world`, ownership retained;
- current/start/final about `5.0795`, requested/effective target `5`;
- `targetReached=true`;
- `failures=0`, `secret=false`, `error=nil`;
- first-frame diagnostic `armZoom≈5.0795`, `firstDelay=0`;
- separate Phase 0 **Run All** repeated the camera PASS and completed cleanly.

The prior world-entry timeout/max-zoom failures remain preserved in evidence. The long-delay branch that motivated P0156 was not naturally reproduced in this passing run, so do not claim direct runtime proof of a large nonzero `firstDelay`.

## Verified State

P0154 remains a diagnostic PASS.

P0155 R1 remains installed. Its stop-before-reverse branch was not exercised by the accepted P0156 sample (`0` direction switches), so that branch is not separately runtime-proven.

P0156 is **INSTALLED / PUSHED — OBSERVED NORMAL WORLD-ENTRY RUNTIME PASS**.

The initial P0157 and R1 docs deliveries both failed memory-schema validation and rolled back. R2 corrects the delivery mechanism, records both failures, and preflights the rendered candidate in a temporary checkout.

The original G.5 normal-Taxi landing proof from P0119 is still pending. That is now the exact next capability gate.

## Next Action

Use the developer panel GUI only.

1. Take one normal Taxi flight.
2. During flight: Phase G -> **Camera World/Combat Check**.
   - expect context `taxi`, owns=true, requested target `50`, duration `5`;
   - engine-clamped effective/final zoom is acceptable if the Taxi contract reports no failure.
3. After landing, allow the destination transition to settle.
4. Phase G -> **Camera World/Combat Check** again.
   - City/World must finish near requested target `5`, not at `0`;
   - require `failures=0`, `secret=false`, `error=nil`.
5. Phase 0 -> **Run All** separately.
6. Upload refreshed `LOGRES_DIAGNOSTICS_LATEST.lua`.

Do not add new camera code unless this Taxi retest produces new runtime evidence.

## Success Criteria

P0157 R2 is complete when:
- P0156 observed normal-world-entry PASS is recorded durably;
- P0154/P0155 failures remain preserved;
- large-first-delay and direction-switch branches remain explicitly unexercised rather than falsely marked PASS;
- both failed P0157 delivery attempts are preserved;
- repository memory validation counts actual schema headings rather than incidental prose mentions;
- CURRENT/handoff/roadmap state identify normal-Taxi landing proof as the exact next gate;
- memory health, checker-version policy, camera first-frame contract, and `git diff --check` pass.

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
- no max-distance CVar mutation, Taxi rotation, Taxi UI fade, polling, broad hooks, periodic camera reassertion, or arbitrary delayed reconcile is authorized.

## Relevant References

- `docs/memory/evidence/P0157_DELIVERY_FAILURES_2026-10-06.md`
- `docs/memory/evidence/P0157_P0156_WORLD_ENTRY_CAMERA_PASS_2026-10-06.md`
- `docs/memory/investigations/CAMERA_WORLD_ENTRY_TRANSITION_TIMEOUT_2026-10-06.md`
- `docs/memory/patches/P0157_RECORD_P0156_CAMERA_PASS.md`
- `docs/memory/patches/P0156_FIRST_DRIVABLE_FRAME_CAMERA_TRANSITION.md`
- `docs/memory/patches/P0119_FIX_CAMERA_TRANSITION_OVERSHOOT.md`
- `docs/memory/evidence/G5_P0117_TAXI_LANDING_OVERSHOOT_2026-10-03.md`
- `docs/memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`
- `docs/memory/roadmap/STATUS.md`
- `docs/ROADMAP.md`
