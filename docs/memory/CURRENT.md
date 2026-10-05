---
memory_schema: 1
as_of: 2026-10-05
project: logres
---

# Current State

## Active Objective

**Approved visual implementation translation — P0143 navigation-source runtime evidence passes for the observed scope; P0144 records the result and opens manual-waypoint distance/depth next.**

This remains parallel Phase-H preparation while formal Phase G / G.5 is open and
explicitly frozen until the approved visual sequence is finished.

## Current Work Item

**P0144 docs/evidence checkpoint — record P0143 runtime PASS with environmental navigation/AreaPOI deferrals; open P0145 manual-waypoint comparable-distance/depth slice.**

Latest verified durable checkpoint:
P0143 `b9b2f90b37ad9d10b4ce6d55ef932e113172d3b3`.

Current pushed/tested runtime:
`0.0.69-dev`.

P0143 observed result:
**RUNTIME PASS FOR THE TESTED READ-ONLY SOURCE SCOPE, WITH DESTINATION/AREA-POI DEFERRALS.**

Proven ordinary in the observed sample:
- current player map ID `1432`;
- player map position approximately `0.35,0.50`;
- map world size approximately `2758.33 x 1839.58` yards;
- `C_Minimap.GetViewRadius()` approximately `133.33` yards;
- tracking selector enumeration `23/23`, with four independently active selectors;
- required source APIs and event-driven diagnostic path;
- zero secret skips and zero call/shape failures;
- integrated `Run All` PASS.

Observed active tracking selectors:
- Flight Master;
- Innkeeper;
- Account Completed Quests;
- Track Quest POIs.

Environmental/absent in this sample:
- `C_AreaPoiInfo.GetAreaPOIForMap` returned no current-map rows;
- no current super-tracking/navigation waypoint;
- no super-tracked quest waypoint;
- no user waypoint;
- therefore no actual destination-distance arithmetic branch was exercised;
- `C_Minimap.GetUiMapID()` yielded no map ID in the captured context.

D-043 consequences remain unchanged:
- tracking selector metadata/state does not provide individual detected-result positions;
- service tracking filters do not provide service-instance positions;
- repeated tracking-result/service-instance compass glyphs remain source-blocked;
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
- P0137 passive player `HELPFUL|PLAYER` aura lane.

World target:
- P0140 fallback/reaction runtime paths pass for the observed scope;
- positive accessible-nameplate anchoring, behind-camera behavior, and hidden
  addon-owned attachment remain environmentally deferred;
- production target placement remains screen-space.

Navigation:
- heading/manual waypoint are production-proven;
- P0142 source/fallback policy is durable;
- P0143 proves ordinary current-map/player geometry, map world size, minimap view
  radius, and bounded multi-select tracking selector metadata/state in runtime;
- current-map AreaPOI population, current-navigation output, and ordinary quest
  waypoint output were absent and remain environmental DEFERRED;
- actual comparable destination-distance output was not exercised because no
  destination source was present in the captured state;
- individual tracking-result and service-instance positions remain source-blocked;
- Blizzard minimap remains stock and available.

Camera:
- P0119 remains durable at `c342bc176a9d5de80ec116d0c6b31fa595cd75b3`;
- the normal-Taxi landing retest remains pending/frozen, not PASS.

## Next Action

After P0144 is pushed and verified, prepare P0145 as one **manual-waypoint
comparable-distance / bounded-depth slice**.

P0145 should:
1. preserve the existing P0123 manual-waypoint source and exact-bearing behavior;
2. secret-first re-query current map, player map position, map world size, and the
   existing user-waypoint destination position;
3. compute yard distance only when all inputs are ordinary, same-map, numeric, and
   compatible;
4. fail open to the current fixed waypoint-marker treatment whenever distance is
   absent, secret, invalid, or incompatible;
5. apply only D-038's restrained bounded depth cue to the proven manual waypoint;
   do not add an exact distance number or persistent label;
6. expose addon-owned diagnostic distance/scale state for in-client proof;
7. add no quest, AreaPOI, service, or tracking-result production marker;
8. leave Blizzard minimap presentation and controls untouched;
9. run integrated `Run All` after the targeted manual-waypoint proof.

The in-client proof should intentionally place a normal manual user waypoint so the
distance branch is actually exercised. No travel or unrelated gameplay state is
required.

## Success Criteria

P0145 succeeds only when:
- the existing manual waypoint still reports a truthful bearing and off-tape
  suppression;
- a placed user waypoint produces an ordinary same-map yard distance;
- the bounded D-038 depth cue changes only marker presence/scale within its capped
  range and never becomes a numeric distance meter;
- distance unavailability fails open to the existing accepted marker treatment;
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
- P0143 empty AreaPOI/current-navigation/quest-waypoint results are environmental
  deferrals, not positive capability proof;
- stock minimap remains until D-037/D-043 replacement completeness is proven;
- party/CompactPartyFrame remain stock until secure interaction and required
  group/aura information are safely replaced;
- Continue/Complete/reward/gossip quest ownership remains separately gated;
- P0119 Taxi landing retest remains pending/frozen;
- no max-distance CVar mutation, Taxi rotation, or Taxi UI fade is authorized.

## Relevant References

- `docs/memory/evidence/P0144_P0143_NAVIGATION_RUNTIME_PASS_WITH_DEFERRALS_2026-10-05.md`
- `docs/memory/patches/P0144_RECORD_P0143_NAVIGATION_RUNTIME_RESULT.md`
- `docs/memory/patches/P0143_NAVIGATION_SOURCE_READ_ONLY_PROBE.md`
- `docs/memory/evidence/P0142_NAVIGATION_MINIMAP_SOURCE_CAPABILITY_AUDIT_2026-10-05.md`
- `docs/memory/decisions/D-043_NAVIGATION_SOURCE_AND_MINIMAP_FALLBACK_POLICY.md`
- `docs/memory/investigations/FUTURE_NAVIGATION_POI_TRACKING_CAPABILITY.md`
- `docs/memory/decisions/D-037_NAVIGATION_MARKER_ROLES_AND_MINIMAP_DIRECTION.md`
- `docs/memory/decisions/D-038_COMPASS_VISUAL_FOCUS_AND_DEPTH_CONTRACT.md`
- `docs/memory/architecture/VISUAL_IMPLEMENTATION_STATUS.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`
