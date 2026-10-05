---
memory_schema: 1
as_of: 2026-10-05
project: logres
---

# Current State

## Active Objective

**Record the accepted P0148 manual-waypoint depth baseline and resolve the class/pet/special-control source/ownership layer before any new runtime ownership.**

Formal Phase G / G.5 remains open and paused while the approved visual sequence is finished.

## Current Work Item

**P0149 — class / pet / special-control source-capability audit; docs/source evidence only.**

Latest verified durable checkpoint:
P0148 `6f381a77f857cb9305cf6870fc2621e6aff826dc`.

Current pushed/tested runtime:
`0.0.72-dev`.

P0148 result:
- live `C_Minimap.GetViewRadius()` close/near/medium/far semantics remain proven;
- stronger depth anchors `1.20 / 1.05 / 0.85 / 0.70` are exercised in client;
- representative observed scales include far `0.700`, medium `0.875`, and close `1.200–1.280`;
- integrated `Run All` passed;
- the user confirmed the size cue now works;
- further amplitude refinement is deferred to later whole-interface polish rather than blocking sequencing.

P0149 source pin:
`Gethe/wow-ui-source@e3ecc27b64d30fdc735a3f6579b866858f9f9df1`
matching Forever `1.60.1.70205`.

P0149 source conclusions:
- pet actions have bounded public read state and a source-proven secure cast path through `SecureActionButtonTemplate` with `type="pet"`, but stock PetActionBar also owns autocast, drag/reorder, bindings, and restoration responsibilities;
- stance/form state is readable, but the audited secure-template surface has no dedicated stance/shapeshift action type; mutation ownership remains runtime/security-gated;
- totem state is source-available but secret-capable; dismiss mutation is separate and unproven;
- runes and class resources are class-specific/discrete, with `UnitPower`/`UnitPowerMax` and charged-point reads secret-capable where documented; they must not be collapsed into the shared percentage-bar primitive;
- alternate power remains specialized and secret-capable;
- `PetFrame` is a separate `SecureUnitButtonTemplate` surface and is not replaced by pet-action ownership;
- possess/override/vehicle/extra-action surfaces are integrated special action-bar modes with paging, exit/cancel, and additional controls; they remain Blizzard-owned and are not ordinary Secondary/Utility routing.

D-044 records the source/fallback policy.

Navigation boundaries remain unchanged:
- P0148 manual-waypoint depth is accepted as the production baseline, with later polish allowed;
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
- P0148 manual-waypoint live-radius depth baseline at `6f381a77` / `0.0.72-dev`.

World target:
- P0140 fallback/reaction runtime paths pass for the observed scope;
- positive accessible-nameplate anchoring, behind-camera behavior, and hidden addon-owned attachment remain environmentally deferred;
- production target placement remains screen-space.

Class / pet / special-control territory:
- source families and ownership boundaries are resolved by P0149/D-044;
- no stock class/pet/special surface is suppressed by P0149;
- runtime ordinary/secret behavior still requires a bounded read-only probe before production work;
- PetFrame, RuneFrame, TotemFrame, alternate-power, and special-mode controls remain stock.

Camera:
- P0119 remains durable at `c342bc176a9d5de80ec116d0c6b31fa595cd75b3`;
- normal-Taxi landing retest remains pending/frozen, not PASS.

## Next Action

After P0149 is durable, prepare **P0150 — bounded read-only class/pet/special-control source probe**.

P0150 should re-query addon-safe state from source-owned invalidation only and must not mutate controls or Blizzard presentation. Candidate diagnostic scope:
1. pet action-bar presence and at most 10 pet slots;
2. current stance/form count/state;
3. bounded totem slots secret-first;
4. current class/resource state secret-first, including runes only when naturally applicable;
5. special-mode flags/indexes for possess/override/vehicle/temp-shapeshift/extra-action;
6. integrated diagnostics only; no casts, dismissals, paging, exits, autocast changes, drag/reorder, or suppression.

Environmental absence is DEFERRED, not failure.

## Success Criteria

P0149 succeeds when:
- exact Forever source generation is pinned;
- readable state, control ownership, event/update model, and Blizzard fallback are separated per domain;
- secret-capable class/totem/power reads are explicitly marked secret-first;
- discrete class mechanics remain discrete;
- pet secure casting is not mistaken for full PetActionBar replacement completeness;
- stance/totem mutation ownership remains gated;
- possess/override/vehicle/extra-action remain outside ordinary action routing;
- PetFrame remains a separate secure unit-frame surface;
- P0150 is limited to a non-mutating read-only runtime probe;
- no runtime code or stock suppression changes in P0149.

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

- `docs/memory/evidence/P0149_P0148_WAYPOINT_DEPTH_RUNTIME_VISUAL_PASS_2026-10-05.md`
- `docs/memory/evidence/P0149_CLASS_PET_SPECIAL_CONTROL_SOURCE_CAPABILITY_AUDIT_2026-10-05.md`
- `docs/memory/decisions/D-044_CLASS_PET_SPECIAL_CONTROL_SOURCE_AND_FALLBACK_POLICY.md`
- `docs/memory/investigations/FUTURE_CLASS_PET_SPECIAL_CONTROL_CAPABILITY.md`
- `docs/memory/patches/P0149_CLASS_PET_SPECIAL_CONTROL_SOURCE_CAPABILITY_AUDIT.md`
- `docs/memory/patches/P0148_INCREASE_MANUAL_WAYPOINT_DEPTH_AMPLITUDE.md`
- `docs/memory/decisions/D-026_SELECTIVE_UNIT_FRAME_SUPPRESSION.md`
- `docs/memory/decisions/D-043_NAVIGATION_SOURCE_AND_MINIMAP_FALLBACK_POLICY.md`
- `docs/memory/architecture/VISUAL_IMPLEMENTATION_STATUS.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`
- `docs/ROADMAP.md`
