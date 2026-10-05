---
memory_schema: 1
as_of: 2026-10-05
project: logres
---

# Current State

## Active Objective

**Approved visual implementation translation — P0142 D-037 navigation/minimap source-capability audit resolved; P0143 read-only runtime probe next.**

This remains parallel Phase-H preparation while formal Phase G / G.5 is open and
explicitly frozen until the approved visual sequence is finished.

## Current Work Item

**P0142 source/policy checkpoint prepared — D-043 accepted; P0143 narrow read-only navigation runtime proof next after P0142 is durable.**

Latest verified durable checkpoint:
P0141 `44720c22f0206c37dc6c1559f51b9319f3ee6647`.

Current pushed/tested runtime:
`0.0.68-dev`.

P0142 source generation:
`Gethe/wow-ui-source@e3ecc27b64d30fdc735a3f6579b866858f9f9df1`
(`1.60.1.70205`).

P0142 result:
**SOURCE-CAPABILITY LAYER RESOLVED — PRODUCTION NAVIGATION EXPANSION REMAINS GATED.**

Source findings:
- normal focused/super-tracked quest waypoints use
  `C_QuestLog.GetNextWaypointForMap`; prior Phase-E empty results remain valid
  negative runtime evidence for the tested quests;
- `C_Navigation.GetNextWaypointForMap` is a separate current-navigation source
  used by Blizzard for broader super-tracked content/world-quest waypoint paths;
- `C_Minimap` exposes tracking-filter metadata, active state, update events, and
  `GetViewRadius()`, but no public per-detected-entity result/position enumerator;
- Blizzard tracking selection is multi-select, not singular;
- current minimap tracking-filter enums include service categories, but those APIs
  expose filter definitions/state rather than service-instance coordinates;
- `C_AreaPoiInfo` is a separate positioned map-POI source with name/position and
  `AREA_POIS_UPDATED`; runtime usefulness on Forever ordinary maps is unproven;
- `C_Map.GetPlayerMapPosition`, `GetMapWorldSize`, and map/world conversion make
  same-map yard-distance computation source-plausible, but secret-first runtime
  proof is still required;
- stock minimap responsibilities include at least zone/PvP context, click ping,
  zoom, tracking management, Blizzard blips/hover interaction, and world-map
  access; `MINIMAP_PING` has restricted secret payloads.

D-043 consequences:
- manual waypoint remains the only production-proven moving marker role;
- repeated generic tracking-result glyphs are source-blocked on the current public
  API surface unless new evidence exposes individual detected-object positions;
- service/townsfolk minimap filters do not authorize local service markers;
- bounded current-map AreaPOIs are the only surviving new local-POI candidate for
  runtime proof;
- the Blizzard minimap remains stock and available;
- no tracking-filter mutation, minimap CVar mutation, polling, broad hooks, or
  production marker expansion is authorized.

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
- ordinary quest destination remains runtime-unproven beyond the prior negative
  tested quests;
- broader current-navigation and current-map AreaPOI source paths are plausible
  and require P0143 runtime proof;
- individual tracked-result positions and service-instance positions are not
  exposed by the audited public source surface;
- comparable distance remains runtime-gated;
- Blizzard minimap remains stock and available.

Camera:
- P0119 remains durable at `c342bc176a9d5de80ec116d0c6b31fa595cd75b3`;
- the normal-Taxi landing retest remains pending/frozen, not PASS.

## Next Action

After P0142 is pushed and verified, prepare P0143 as one **read-only navigation
source runtime probe** on `0.0.69-dev`.

P0143 should:
1. re-query the current player map with `C_Map.GetBestMapForUnit("player")`;
2. secret-first sample player map position and `C_Map.GetMapWorldSize`;
3. read `C_Minimap.GetViewRadius()` without changing zoom/tracking/settings;
4. enumerate tracking **types/state only** with bounded
   `GetNumTrackingTypes` / `GetTrackingInfo` / `GetTrackingFilter`;
5. read current super-tracking state and compare:
   - `C_QuestLog.GetNextWaypoint*` for a super-tracked quest when present;
   - `C_Navigation.GetNextWaypointForMap(currentMapID)` for current navigation;
6. bounded-scan current-map `C_AreaPoiInfo.GetAreaPOIForMap` results and
   secret-first inspect only ordinary name/position fields;
7. prove or defer same-map comparable-distance arithmetic using ordinary player,
   map-size, and POI/waypoint coordinates;
8. invalidate only from existing events such as `PLAYER_MAP_CHANGED`,
   `SUPER_TRACKING_CHANGED`, `SUPER_TRACKING_PATH_UPDATED`, `QUEST_LOG_UPDATE`,
   `AREA_POIS_UPDATED`, `MINIMAP_UPDATE_TRACKING`, and
   `PLAYER_ENTERING_WORLD`;
9. discard event payloads and retain only sanitized addon-owned diagnostic state;
10. make no production presentation or Blizzard minimap change.

Do not create a runtime path for individual tracking-result glyphs in P0143; the
source audit found no supported result enumerator to probe.

## Success Criteria

P0143 succeeds when the tested client establishes which of the surviving
source-plausible inputs are ordinary and usable in real runtime:
- current player map/position/world-size;
- minimap view radius;
- tracking type/state metadata;
- current navigation/quest waypoint output when naturally present;
- bounded current-map AreaPOI rows when naturally present;
- comparable same-map distance only when all inputs are ordinary.

Environmental absence of a waypoint or AreaPOI is DEFERRED, not FAIL. Secret,
call, or Lua errors are failures. Source-blocked individual tracking-result
positions remain CLOSED unless new primary source evidence appears.

## Do Not Reopen Without New Evidence

- no conventional player health bar;
- harmful/urgent player and populated target aura production remain deferred;
- target aura/status remains separately gated from world-target anchoring;
- positive world-target nameplate anchoring/attachment remains deferred;
- individual tracking-result positions are source-blocked by P0142/D-043;
- town/service tracking filters do not imply enumerable service-instance positions;
- stock minimap remains until D-037/D-043 replacement completeness is proven;
- party/CompactPartyFrame remain stock until secure interaction and required
  group/aura information are safely replaced;
- Continue/Complete/reward/gossip quest ownership remains separately gated;
- P0119 Taxi landing retest remains pending/frozen;
- no max-distance CVar mutation, Taxi rotation, or Taxi UI fade is authorized.

## Relevant References

- `docs/memory/evidence/P0142_NAVIGATION_MINIMAP_SOURCE_CAPABILITY_AUDIT_2026-10-05.md`
- `docs/memory/decisions/D-043_NAVIGATION_SOURCE_AND_MINIMAP_FALLBACK_POLICY.md`
- `docs/memory/patches/P0142_NAVIGATION_MINIMAP_SOURCE_CAPABILITY_AUDIT.md`
- `docs/memory/investigations/FUTURE_NAVIGATION_POI_TRACKING_CAPABILITY.md`
- `docs/memory/decisions/D-037_NAVIGATION_MARKER_ROLES_AND_MINIMAP_DIRECTION.md`
- `docs/memory/decisions/D-038_COMPASS_VISUAL_FOCUS_AND_DEPTH_CONTRACT.md`
- `docs/memory/evidence/E3_P0071_RUNTIME_EVIDENCE_2026-10-01.md`
- `docs/memory/evidence/F2_P0078_QUEST_XP_RUNTIME_EVIDENCE_2026-10-02.md`
- `docs/memory/architecture/VISUAL_IMPLEMENTATION_STATUS.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`
