---
memory_schema: 1
as_of: 2026-10-05
project: logres
---

# Current State

## Active Objective

**Runtime-prove the P0149/D-044 class, pet, and special-control source families without taking production ownership or suppressing Blizzard fallback surfaces.**

Formal Phase G / G.5 remains open and paused while the approved visual sequence is finished.

## Current Work Item

**P0150 — bounded read-only class / pet / special-control runtime probe.**

Latest verified durable checkpoint:
P0149 `dbe468f7994a947e9e350e0f66b214679bd110f5`.

Current pushed/tested runtime:
`0.0.72-dev`.

P0149 result:
- exact Forever source generation `Gethe/wow-ui-source@e3ecc27b64d30fdc735a3f6579b866858f9f9df1` / `1.60.1.70205` is pinned;
- D-044 separates pet secure casting, stance/form, totem, discrete class resources, alternate power, PetFrame, and integrated special modes;
- no Blizzard class/pet/special presentation or control surface is suppressed by source evidence alone.

P0150 candidate runtime:
`0.0.73-dev`.

P0150 adds one diagnostic-only `ClassPetSpecialProbe` that:
- reads pet-action-bar presence and at most ten pet slots;
- reads current stance/form count, state, and cooldowns;
- reads bounded totem state secret-first;
- reads player class, primary power, a bounded class-specific discrete resource candidate, charged points where applicable, and DK runes only when naturally class-applicable;
- reads possess/vehicle/override/temp-shapeshift/extra-action mode flags and ordinary bar indexes;
- invalidates from source-owned pet/form/totem/power/rune/special/world events and discards event payloads;
- stores only sanitized addon-owned diagnostic state.

P0150 deliberately does **not** cast, toggle autocast, reorder pet actions, cast forms, dismiss totems, mutate action pages/state drivers, exit vehicles, cancel possession, invoke extra/override controls, or touch Blizzard presentation.

Secret observations are counted and deferred rather than treated as failures. Environmental absence is DEFERRED, not FAIL.

P0148 manual-waypoint depth remains the accepted production baseline at `6f381a77` / `0.0.72-dev`; further amplitude refinement is deferred to whole-interface polish.

Navigation boundaries remain unchanged:
- quest/current-navigation destination remains environmental DEFERRED;
- current-map AreaPOI/service usefulness remains environmental DEFERRED;
- individual tracking-result/service-instance positions remain source-blocked;
- Blizzard minimap remains stock and available.

## Verified State

Accepted production baselines include:
- P0120 shared percentage/resource bar;
- P0121 player cast cue, target cast/channel deferred;
- P0122 Context-message primitive;
- P0123 heading/manual-waypoint Compass bearing + visual baseline;
- P0124 organic player-health tunnel;
- P0126 one-focus Active Quest;
- P0130 bounded/paged quest-offer narrative;
- P0133 Accept-left / Decline-right offer controls for the proven offer state;
- P0137 passive player `HELPFUL|PLAYER` aura lane;
- P0148 manual-waypoint live-radius depth baseline.

World target:
- P0140 fallback/reaction runtime paths pass for the observed scope;
- positive accessible-nameplate anchoring, behind-camera behavior, and hidden addon-owned attachment remain environmentally deferred;
- production target placement remains screen-space.

Class / pet / special-control territory:
- P0149/D-044 source families and fallback policy are durable;
- P0150 is diagnostic-only and runtime proof is pending;
- PetFrame, RuneFrame, TotemFrame, alternate-power, PetActionBar, StanceBar, PossessActionBar, OverrideActionBar, ExtraActionBar, and unsupported vehicle/special controls remain Blizzard-owned;
- pet secure casting remains only a source-plausible future control candidate, not replacement completeness.

Camera:
- P0119 remains durable at `c342bc176a9d5de80ec116d0c6b31fa595cd75b3`;
- normal-Taxi landing retest remains pending/frozen, not PASS.

## Next Action

Apply P0150, deploy `0.0.73-dev`, then use the Phase-H developer-panel action **Class / Pet / Special Probe** in the player's natural current state.

Required in-client proof:
1. run **Class / Pet / Special Probe** once after `/reload`;
2. preserve all returned probe lines in diagnostics;
3. treat absent pet/forms/totems/runes/special modes as environmental DEFERRED rather than manufacturing gameplay state;
4. run **Run All** separately after the probe;
5. upload the refreshed diagnostics artifact.

A secret skip is valid evidence when safely recorded. A Lua error, secret-value misuse, invalid payload/type failure, taint/protected-action error, or unexpected mutation is a real failure.

## Success Criteria

P0150 succeeds for the observed scope when:
- `ClassPetSpecialProbe` initializes/enables and all source-owned event registrations succeed;
- the exact required API set is present;
- manual capture completes with `failureCount=0`;
- ordinary current-state fields are sanitized into addon-owned diagnostics;
- secret-capable results are checked before nil/type/value inspection and only counted/deferred when secret;
- pet/form/totem/resource/rune/special-mode absence is classified as environmental deferral where applicable;
- DK rune reads occur only when the ordinary class identity is Death Knight;
- no casts, autocast changes, pet rearrangement, form activation, totem dismissal, action-page mutation, vehicle/possess mutation, state-driver mutation, or Blizzard presentation mutation occurs;
- **Run All** remains clean.

P0150 does not by itself authorize any production replacement or stock suppression.

## Do Not Reopen Without New Evidence

- no conventional player health bar;
- harmful/urgent player and populated target aura production remain deferred;
- target aura/status remains separately gated from world-target anchoring;
- positive world-target nameplate anchoring/attachment remains deferred;
- individual tracking-result positions are source-blocked by P0142/D-043;
- stock minimap remains until D-037/D-043 replacement completeness is proven;
- party/CompactPartyFrame remain stock until secure interaction and required group/aura information are safely replaced;
- PetFrame remains stock independent of pet-action work;
- RuneFrame, TotemFrame, alternate-power, direct class-resource children, and unsupported special-control surfaces remain Blizzard-owned until separately runtime/capability-proven;
- possess/override/vehicle/extra-action surfaces are not ordinary Bar 2–3 roles;
- Continue/Complete/reward/gossip quest ownership remains separately gated;
- P0119 Taxi landing retest remains pending/frozen;
- no max-distance CVar mutation, Taxi rotation, or Taxi UI fade is authorized.

## Relevant References

- `docs/memory/decisions/D-044_CLASS_PET_SPECIAL_CONTROL_SOURCE_AND_FALLBACK_POLICY.md`
- `docs/memory/evidence/P0149_CLASS_PET_SPECIAL_CONTROL_SOURCE_CAPABILITY_AUDIT_2026-10-05.md`
- `docs/memory/investigations/FUTURE_CLASS_PET_SPECIAL_CONTROL_CAPABILITY.md`
- `docs/memory/patches/P0150_CLASS_PET_SPECIAL_CONTROL_READ_ONLY_PROBE.md`
- `docs/memory/patches/P0149_CLASS_PET_SPECIAL_CONTROL_SOURCE_CAPABILITY_AUDIT.md`
- `docs/memory/decisions/D-026_SELECTIVE_UNIT_FRAME_SUPPRESSION.md`
- `docs/memory/architecture/VISUAL_IMPLEMENTATION_STATUS.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`
- `docs/ROADMAP.md`
