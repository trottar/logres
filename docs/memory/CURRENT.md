---
memory_schema: 1
as_of: 2026-10-05
project: logres
---

# Current State

## Active Objective

**Approved visual implementation translation — P0145 manual-waypoint comparable-distance / bounded-depth runtime result accepted; P0146 evidence checkpoint prepared; P0147 class/pet/special-control source audit next.**

This remains parallel Phase-H preparation while formal Phase G / G.5 is open and
explicitly frozen until the approved visual sequence is finished.

## Current Work Item

**P0146 docs/evidence checkpoint — record the P0145 `0.0.70-dev` result without widening navigation ownership, then advance to P0147 source/capability audit for class, pet, and special-control territory.**

Latest verified durable checkpoint:
P0145 `60244841d0ecfa35b58c7db60293145b8962b6dc`.

Current pushed/tested runtime:
`0.0.70-dev`.

P0145 result:
- current-map manual user-waypoint distance is ordinary and usable;
- populated Compass checks recorded `115.8`, `45.5`, `51.7`, and `116.0` yards;
- populated depth remained `1.050` and render scale stayed within the accepted `0.90–1.12` bound;
- waypoint removal returned cleanly to `waypoint=false`, `marker=false`, `distance=false`, `yards=nil`, `depth=1.000`, `renderScale=nil`, with `waypoint-absent` reasons;
- integrated `Run All` passed on the same runtime before the targeted clear-state capture;
- no Lua, secret-value, taint, protected-action, or source failure was reported in the tested scope.

P0123 remains the runtime authority for off-tape suppression (`relative=115.5`,
`marker=false`). P0145 did not obtain a new off-tape diagnostic row; its new depth
application remains downstream of the existing off-tape early-return path. Do not
rewrite that as a newly sampled P0145 runtime result.

Navigation boundaries remain unchanged:
- manual waypoint bearing + comparable distance/depth are production-proven;
- current-map AreaPOI population and current/quest navigation output remain environmental DEFERRED;
- individual tracking-result and service-instance positions remain source-blocked;
- Blizzard minimap remains stock and available.

## Verified State

Accepted production baselines remain:
- P0120 shared percentage/resource bar;
- P0121 player cast cue, with target cast/channel environmentally deferred;
- P0122 Context-message primitive;
- P0123 heading/manual-waypoint Compass;
- P0124 organic player-health tunnel;
- P0126 one-focus Active Quest;
- P0130 bounded/paged quest-offer narrative;
- P0133 Accept-left / Decline-right offer controls for the proven offer state;
- P0137 passive player `HELPFUL|PLAYER` aura lane;
- P0145 same-map manual-waypoint distance with bounded depth scale.

World target:
- P0140 fallback/reaction runtime paths pass for the observed scope;
- positive accessible-nameplate anchoring, behind-camera behavior, and hidden addon-owned attachment remain environmentally deferred;
- production target placement remains screen-space.

Navigation:
- heading/manual waypoint remain production-proven;
- P0145 closes the comparable-distance / bounded-depth branch for normal same-map user waypoints;
- quest/current-navigation, AreaPOI/service, and tracking-result roles remain deferred/blocked exactly as before;
- stock minimap remains the completeness fallback.

Class / pet / special-control territory:
- Blizzard-owned direct player class-resource children, RuneFrame, TotemFrame, PetFrame, alternate-power, and unsupported possess/override/vehicle surfaces remain preserved;
- approved visual language exists only at the shared-button / broad composition level;
- source, secure interaction, mutation, restoration, and class-specific discrete-resource ownership have not yet been audited as one coherent capability layer.

Camera:
- P0119 remains durable at `c342bc176a9d5de80ec116d0c6b31fa595cd75b3`;
- the normal-Taxi landing retest remains pending/frozen, not PASS.

## Next Action

Apply and push P0146 as a docs/evidence-only checkpoint.

After P0146 is durable, perform **P0147 source/capability audit only** for:
- pet action controls;
- stance/form controls;
- totem/class-special controls;
- discrete class resources such as runes/combo-point-style pips;
- possess/override/vehicle/special control fallback;
- secure action ownership, combat restrictions, events, restoration, and Blizzard coexistence for each domain.

The audit must pin the exact Forever source generation before proposing runtime
replacement. It must distinguish information presentation from secure interaction
and action mutation. No Blizzard class/pet/special surface is suppressed from
source availability alone.

## Success Criteria

P0146 succeeds when repository memory records exactly what P0145 proved, preserves
its unsampled/deferred boundaries, and identifies P0147 as the next independent
source-only work item.

P0147 may authorize a later runtime probe only where the source audit establishes a
supported, bounded, fail-open path. It does not itself authorize stock suppression
or production replacement.

## Do Not Reopen Without New Evidence

- no conventional player health bar;
- harmful/urgent player and populated target aura production remain deferred;
- target aura/status remains separately gated from world-target anchoring;
- positive world-target nameplate anchoring/attachment remains deferred;
- individual tracking-result positions are source-blocked by P0142/D-043;
- town/service tracking filters do not imply enumerable service-instance positions;
- P0143 empty AreaPOI/current-navigation/quest-waypoint results remain environmental deferrals;
- stock minimap remains until D-037/D-043 replacement completeness is proven;
- party/CompactPartyFrame remain stock until secure interaction and required group/aura information are safely replaced;
- direct player class-resource children, RuneFrame, TotemFrame, PetFrame, alternate-power, and unsupported special-control surfaces remain Blizzard-owned until separately capability-proven;
- Continue/Complete/reward/gossip quest ownership remains separately gated;
- P0119 Taxi landing retest remains pending/frozen;
- no max-distance CVar mutation, Taxi rotation, or Taxi UI fade is authorized.

## Relevant References

- `docs/memory/evidence/P0146_P0145_MANUAL_WAYPOINT_DISTANCE_DEPTH_RUNTIME_PASS_2026-10-05.md`
- `docs/memory/patches/P0146_RECORD_P0145_RUNTIME_RESULT.md`
- `docs/memory/patches/P0145_MANUAL_WAYPOINT_DISTANCE_DEPTH.md`
- `docs/memory/patches/P0123_COMPASS_VISUAL_TRANSLATION.md`
- `docs/memory/decisions/D-043_NAVIGATION_SOURCE_AND_MINIMAP_FALLBACK_POLICY.md`
- `docs/memory/decisions/D-038_COMPASS_VISUAL_FOCUS_AND_DEPTH_CONTRACT.md`
- `docs/memory/investigations/FUTURE_NAVIGATION_POI_TRACKING_CAPABILITY.md`
- `docs/memory/investigations/FUTURE_CLASS_PET_SPECIAL_CONTROL_CAPABILITY.md`
- `docs/memory/decisions/D-026_SELECTIVE_UNIT_FRAME_SUPPRESSION.md`
- `docs/memory/architecture/VISUAL_IMPLEMENTATION_STATUS.md`
- `docs/memory/architecture/VISUAL_COMPONENT_INVENTORY.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`
- `docs/ROADMAP.md`
