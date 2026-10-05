---
memory_schema: 1
as_of: 2026-10-05
project: logres
---

# Current State

## Active Objective

**Approved visual implementation translation — P0143 read-only navigation-source runtime probe prepared; in-client proof next.**

This remains parallel Phase-H preparation while formal Phase G / G.5 is open and
explicitly frozen until the approved visual sequence is finished.

## Current Work Item

**P0143 diagnostic-only navigation-source probe on candidate runtime `0.0.69-dev`; runtime proof pending.**

Latest verified durable checkpoint:
P0142 `82682ece15ad21aa7d5ee2dfaba5e5a3c68c97b6`.

Current pushed/tested runtime before P0143 deployment:
`0.0.68-dev`.

P0142 / D-043 remains authoritative:
- tracking selection is multi-select;
- tracking/filter APIs expose selector metadata/state, not individual detected-object
  positions;
- service/town tracking filters do not expose individual service-instance positions;
- bounded current-map `C_AreaPoiInfo` is the surviving local-POI runtime candidate;
- `C_Navigation.GetNextWaypointForMap` is a distinct broader current-navigation
  candidate;
- ordinary quest waypoint behavior remains on `C_QuestLog.GetNextWaypoint*`, with
  prior tested empty results preserved as negative evidence;
- same-map comparable distance is source-plausible through ordinary player
  position + map world size + destination map coordinates;
- Blizzard minimap remains stock.

P0143 adds no production marker or Blizzard presentation change. It observes only
sanitized addon-owned diagnostic state.

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
- P0142 source capability and fallback policy are durable;
- individual tracking-result and service-instance positions remain source-blocked;
- quest/current-navigation, current-map AreaPOI, minimap view radius, and comparable
  distance remain runtime-gated until P0143 evidence;
- Blizzard minimap remains stock and available.

Camera:
- P0119 remains durable at `c342bc176a9d5de80ec116d0c6b31fa595cd75b3`;
- the normal-Taxi landing retest remains pending/frozen, not PASS.

## Next Action

Deploy P0143 and run the Phase-H **Navigation Source Probe** in ordinary current
gameplay.

The probe must establish, without mutation:
1. current map, player map position, and map world size;
2. minimap view radius;
3. bounded tracking type/filter metadata and active-state enumeration;
4. bounded current-map AreaPOI rows;
5. current super-tracking state and `C_Navigation.GetNextWaypointForMap`;
6. ordinary quest `C_QuestLog.GetNextWaypoint*` output when a naturally
   super-tracked quest exists;
7. same-map distance only when all required inputs are ordinary;
8. event registration/counts, secret skips, and call failures.

Then run integrated `Run All`.

Environmental absence of a waypoint or AreaPOI is DEFERRED, not FAIL. Any secret
skip, API/call failure, Lua error, taint/protected-action issue, or other runtime
failure must be preserved and investigated before production work advances.

Do not change tracking selection, supertracking, map/waypoint state, minimap CVars,
Blizzard pins/frames, player location, or gameplay state merely to manufacture
proof.

## Success Criteria

P0143 can close its tested runtime scope only when:
- the diagnostic loads and all required events register;
- required pinned-source APIs are present;
- the manual capture completes with zero secret skips and zero call failures;
- ordinary values are recorded only after secret preflight;
- current-map comparable distance is reported only from compatible ordinary inputs;
- environmental absence remains explicitly deferred;
- integrated `Run All` remains PASS;
- no production presentation or Blizzard minimap behavior changes.

A P0143 PASS does not authorize repeated tracking-result glyphs or minimap
suppression.

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

- `docs/memory/patches/P0143_NAVIGATION_SOURCE_READ_ONLY_PROBE.md`
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
