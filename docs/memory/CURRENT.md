---
memory_schema: 1
as_of: 2026-10-06
project: logres
---

# Current State

## Active Objective

**Finish the bounded Phase G.5 Taxi camera gate, then enter Phase H in an integration-first order: suppress only safely replaced stock surfaces, establish the authored UI composition/positions, and only then perform final polish and remaining visual work.**

P0156 remains accepted on `0.0.77-dev` for the observed normal-world-entry scope.

P0157 R2 is durable at `328f15431b8b3cc3f4d78d2edf4c40d987f78341`; it records that pass and hardens repository-memory validation.

## Current Work Item

**G.5 — one normal-Taxi landing retest for the shared camera transition driver.**

This is the final currently authorized Camera gate, not a reopening of broader Camera feature work.

After G.5 closes, the next execution order is explicit:

1. **Phase H integration / stock-surface ownership pass**
   - audit the live screen surface by surface;
   - actually suppress/hide Blizzard presentation only where Logres already has a deliberate, capability-proven replacement plus safe restoration/fail-open behavior;
   - keep Blizzard surfaces where replacement completeness is still unproven.

2. **Phase H authored layout / positioning**
   - put Logres-owned surfaces into their intended semantic regions and proper default positions;
   - remove incidental cross-module anchoring where integration should own geometry;
   - validate realistic combat/noncombat density and coexistence with stock fallbacks.

3. **Phase H final polish / remaining visuals**
   - spacing, contrast, scale, ornament, opacity, density, and whole-screen calibration;
   - pet-button ornament/contrast, health-tunnel calibration, compass calibration, action-density details, residual state variants;
   - settings/accessibility presentation and other genuinely remaining visual work;
   - capability-deferred domains remain deferred until evidence exists.

## Verified State

Phases 0 through F are complete.

Phase G is active only because G.5 still lacks the normal-Taxi landing runtime proof after P0119.

The world-entry regression that interrupted the visual sequence is closed for the accepted P0156 sample. No further world-entry camera code is justified without new failure evidence.

A substantial approved visual baseline is already implemented and runtime-proven, but the interface is **not** visually finished. The repository still explicitly carries final whole-screen positioning/calibration, stock-surface coexistence/suppression work, settings/accessibility, and several residual visual refinements.

The new high-level sequence supersedes the older temporary statement that Camera must remain frozen until all visual translation is finished. We will finish the existing bounded G.5 gate now, then make integration/layout the primary workstream before final polish.

## Next Action

Use the developer panel GUI only.

1. Take one normal Taxi flight.
2. While airborne: Phase G -> **Camera World/Combat Check**.
   - expect context `taxi`, owns=true, requested target `50`, duration `5`;
   - engine-clamped effective/final zoom is acceptable if the Taxi contract reports no failure.
3. After landing, let the destination transition settle.
4. Phase G -> **Camera World/Combat Check** again.
   - City/World must finish near requested target `5`, not at `0`;
   - require `failures=0`, `secret=false`, `error=nil`.
5. Phase 0 -> **Run All** separately.
6. Upload refreshed `LOGRES_DIAGNOSTICS_LATEST.lua`.

If this passes, close G.5 and open Phase H with the stock-surface suppression/coexistence and authored-layout pass. If it fails, preserve the exact Taxi evidence and investigate narrowly before entering Phase H.

## Success Criteria

The current sequence is satisfied when:
- G.5 Taxi entry/landing behavior is either runtime-proven clean or a newly reproduced defect is explicitly classified;
- no unrelated Camera expansion is added merely to delay integration work;
- Phase H begins with a surface-by-surface replacement/suppression audit, never blanket hiding;
- only capability-proven replacements may displace Blizzard presentation, with safe restoration/fail-open behavior preserved;
- Logres surfaces are placed on stable authored integration anchors in their intended semantic regions;
- final visual polish begins only after the coexistence/suppression and layout baseline is stable;
- unresolved capability-gated stock surfaces remain available until a deliberate replacement exists.

## Do Not Reopen Without New Evidence

- no conventional player health bar;
- P0152 pet execution/default-on/state-presentation is accepted; exact ornament/contrast belongs to later whole-interface polish;
- PetActionBar suppression, pet edit/reorder, binding replacement, and PetFrame ownership remain separately gated;
- player harmful/urgent and populated target aura production remain deferred;
- positive world-target nameplate anchoring/attachment remains deferred;
- individual tracking-result positions remain source-blocked by P0142/D-043;
- stock minimap remains until the complete replacement gate is satisfied;
- party/CompactPartyFrame remain stock until secure interaction and required group/aura information are replaced safely;
- RuneFrame, TotemFrame, alternate-power, direct class-resource children, stance/form, and unsupported special-control surfaces remain Blizzard-owned until separately runtime/capability-proven;
- target auras/status and target-of-target remain Blizzard-owned until deliberately replaced;
- possess/override/vehicle/extra-action surfaces are not ordinary Bar 2–3 roles;
- Continue/Complete/reward/gossip quest ownership remains separately gated;
- no max-distance CVar mutation, Taxi rotation, Taxi UI fade, polling, broad hooks, periodic camera reassertion, or arbitrary delayed reconcile is authorized.

## Relevant References

- `docs/memory/patches/P0158_SEQUENCE_CAMERA_INTEGRATION_POLISH.md`
- `docs/memory/evidence/P0157_P0156_WORLD_ENTRY_CAMERA_PASS_2026-10-06.md`
- `docs/memory/patches/P0119_FIX_CAMERA_TRANSITION_OVERSHOOT.md`
- `docs/memory/evidence/G5_P0117_TAXI_LANDING_OVERSHOOT_2026-10-03.md`
- `docs/memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/memory/architecture/WORLD_FIRST_LAYOUT.md`
- `docs/memory/architecture/VISUAL_IMPLEMENTATION_STATUS.md`
- `docs/memory/decisions/D-017_BLIZZARD_UI_SUPPRESSION_AND_RESTORATION.md`
- `docs/memory/roadmap/STATUS.md`
- `docs/ROADMAP.md`
