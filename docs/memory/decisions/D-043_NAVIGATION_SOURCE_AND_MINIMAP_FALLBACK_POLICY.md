# D-043 — Navigation Source and Minimap Fallback Policy

Status: ACCEPTED — SOURCE POLICY; RUNTIME-GATED
Date: 2026-10-05

## Decision

Refine D-037/D-038 using the exact Forever `1.60.1.70205` source audit from P0142.

The four-role visual direction remains useful as a long-term product model, but
production eligibility now follows the source distinctions below.

## Manual waypoint

No change.

The P0123 heading/manual-waypoint path remains production-proven.

## Quest destination

Ordinary quest destination remains capability-gated.

The canonical quest-specific candidates remain:
- `C_QuestLog.GetNextWaypoint`;
- `C_QuestLog.GetNextWaypointForMap`;
- `C_QuestLog.GetNextWaypointText`.

Earlier tested super-tracked quests returned no usable waypoint and remain negative
runtime evidence for those states.

`C_Navigation.GetNextWaypointForMap` is accepted as a separate broader
current-navigation candidate because Blizzard uses it for general super-tracked
waypoint paths. It does not retroactively convert the earlier quest negatives into
success.

P0143 must read both paths without mutating supertracking.

## Tracking

Tracking-filter selection is multi-select capable on current source.

`C_Minimap` exposes filter metadata/state, but the audited public source surface
does not expose individual detected tracking results or their positions/bearings.

Therefore:
- repeated addon-owned tracking-result glyphs are **source-blocked**;
- Logres must not inspect Blizzard minimap presentation to recover hidden result
  positions;
- Logres must not force tracking into a singular mode to make the visual design
  easier;
- the generic tracking-glyph concept remains visual-only until a supported
  per-result source exists.

## Local POI / services

Minimap tracking filters include service categories but expose only filter
definition/state, not individual service instances.

Those filters do not authorize service-position markers.

`C_AreaPoiInfo` is accepted as a **separate candidate family** because it exposes
map POI IDs, names, and positions with `AREA_POIS_UPDATED`.

P0143 may bounded-probe AreaPOIs on the current map. Production use requires
runtime evidence that the returned Forever data is ordinary, spatially usable, and
semantically appropriate for Logres local awareness.

## Local radius and distance

`C_Minimap.GetViewRadius()` is the preferred source candidate for minimap-scale
local awareness because its unit is explicitly yards.

For comparable same-map distance, P0143 may test:
- `C_Map.GetPlayerMapPosition`;
- `C_Map.GetMapWorldSize`;
- `C_Map.GetWorldPosFromMapPos`.

No distance/depth/focus policy may use these until every required runtime value is
ordinary and compatible.

Do not combine unrelated distance APIs or normalized coordinate deltas under an
assumed common unit.

## Invalidation

Use source-owned invalidation rather than production polling:
- `PLAYER_MAP_CHANGED`;
- `QUEST_LOG_UPDATE`;
- `SUPER_TRACKING_CHANGED`;
- `SUPER_TRACKING_PATH_UPDATED`;
- `AREA_POIS_UPDATED`;
- `MINIMAP_UPDATE_TRACKING`;
- `PLAYER_ENTERING_WORLD`.

Event payloads are not required for the probe; re-query current state.

## Minimap fallback

D-030/D-037 remain strict:
**the Blizzard minimap stays stock and available.**

P0142 confirms that the stock surface currently covers responsibilities beyond
direction markers, including zone/PvP context, click ping, zoom, tracking
configuration, Blizzard blip/hover interaction, and world-map access.

`MINIMAP_PING` has restricted secret payloads and is not a new Logres ownership
surface.

No minimap suppression is authorized until every required responsibility has a
deliberate safe replacement or an explicit product decision to omit it.

## Fail-open

When a surviving navigation source is missing, secret, invalid, stale, or
environmentally absent:
- omit the unsupported Logres marker/state;
- preserve the stock minimap;
- retain already-proven heading/manual waypoint behavior;
- do not mutate tracking or map/minimap settings to manufacture data.

## Next proof

P0143 is a diagnostic-only, read-only runtime probe for the surviving source
candidates.

Individual tracking-result and service-instance coordinates are not part of that
probe because P0142 found no supported source to test.
