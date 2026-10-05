---
memory_schema: 1
as_of: 2026-10-05
project: logres
---

# Current State

## Active Objective

**Approved visual implementation translation — P0145 R2 manual-waypoint comparable-distance / bounded-depth integration prepared; in-client proof next.**

This remains parallel Phase-H preparation while formal Phase G / G.5 is open and
explicitly frozen until the approved visual sequence is finished.

## Current Work Item

**P0145 runtime candidate `0.0.70-dev` — extend only the proven manual user-waypoint marker with fail-open same-map yard distance and restrained D-038 depth scale.**

Latest verified durable checkpoint:
P0144 `47534363bd5754306c31d5e860739289504417de`.

Current pushed/tested runtime before P0145 deployment:
`0.0.69-dev`.

P0143/P0144 remain authoritative:
- current player map position and map world size are ordinary in the observed runtime;
- the tested map's world size was approximately `2758.33 x 1839.58` yards;
- minimap view radius was ordinary;
- tracking selector metadata/state is ordinary and multi-select;
- current-map AreaPOI population and current/quest navigation output remain environmental DEFERRED;
- individual tracking-result and service-instance positions remain source-blocked;
- Blizzard minimap remains stock and available.

P0145 preserves the existing P0123 manual-waypoint source/bearing path. It adds only:
- secret-first `UiMapPoint.uiMapID` inspection;
- `C_Map.GetMapWorldSize` yard dimensions;
- same-map distance from ordinary normalized player/destination coordinates;
- a Theme-owned bounded scale cue;
- addon-owned diagnostic distance/depth state.

Distance failure is non-fatal to the existing waypoint marker: absent, secret,
invalid, or cross-map distance state falls back to depth scale `1.0`.

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
- P0137 passive player `HELPFUL|PLAYER` aura lane.

World target:
- P0140 fallback/reaction runtime paths pass for the observed scope;
- positive accessible-nameplate anchoring, behind-camera behavior, and hidden addon-owned attachment remain environmentally deferred;
- production target placement remains screen-space.

Navigation:
- heading/manual waypoint are production-proven through P0123;
- P0143 proves ordinary current-map/player geometry and map world size;
- P0145 is the first production use of those geometry inputs and is runtime-unproven until in-client validation;
- current-map AreaPOI, current-navigation, and ordinary quest-waypoint output remain environmental DEFERRED;
- individual tracking-result and service-instance positions remain source-blocked;
- Blizzard minimap remains stock and available.

Camera:
- P0119 remains durable at `c342bc176a9d5de80ec116d0c6b31fa595cd75b3`;
- the normal-Taxi landing retest remains pending/frozen, not PASS.

## Next Action

Deploy P0145, `/reload`, then place a normal manual user waypoint on the current map.

Run **Phase E -> Compass Check** while the waypoint exists and record:
- `waypoint=true`;
- ordinary bearing/relative state;
- `distance=true` with a non-negative yard value;
- `depth` within the bounded `0.90–1.05` distance range;
- when the marker is visible, `renderScale` within `0.90–1.12`;
- `distanceReason=distance-available`;
- no waypoint or distance error.

Rotate normally to verify the exact-bearing stem/off-tape behavior is unchanged and
the depth cue remains restrained. Clear the waypoint and confirm fallback state
returns cleanly without stale distance presentation.

Then run **Phase 0 -> Run All**.

Do not add quest, AreaPOI, service, or tracking-result markers and do not modify
Blizzard minimap presentation or controls.

## Success Criteria

P0145 succeeds only when:
- the existing manual waypoint still reports a truthful bearing and off-tape suppression;
- a normal current-map user waypoint produces ordinary same-map yard distance;
- the depth cue remains bounded and visually restrained;
- no exact distance number or persistent waypoint identity is presented to the player;
- distance absence/secret/invalid/cross-map state fails open to the accepted fixed marker treatment;
- no secret, Lua, taint, protected-action, or source failure occurs;
- integrated `Run All` remains PASS;
- no new quest/POI/tracking role or minimap ownership is implied.

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
- Continue/Complete/reward/gossip quest ownership remains separately gated;
- P0119 Taxi landing retest remains pending/frozen;
- no max-distance CVar mutation, Taxi rotation, or Taxi UI fade is authorized.

## Relevant References

- `docs/memory/patches/P0145_MANUAL_WAYPOINT_DISTANCE_DEPTH.md`
- `docs/memory/evidence/P0144_P0143_NAVIGATION_RUNTIME_PASS_WITH_DEFERRALS_2026-10-05.md`
- `docs/memory/patches/P0144_RECORD_P0143_NAVIGATION_RUNTIME_RESULT.md`
- `docs/memory/decisions/D-043_NAVIGATION_SOURCE_AND_MINIMAP_FALLBACK_POLICY.md`
- `docs/memory/decisions/D-038_COMPASS_VISUAL_FOCUS_AND_DEPTH_CONTRACT.md`
- `docs/memory/investigations/FUTURE_NAVIGATION_POI_TRACKING_CAPABILITY.md`
- `docs/memory/patches/P0123_COMPASS_VISUAL_TRANSLATION.md`
- `docs/memory/architecture/VISUAL_IMPLEMENTATION_STATUS.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`
