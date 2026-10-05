# Current Handoff

Authoritative state:
`../CURRENT.md`.

Latest verified durable checkpoint:
P0141 `44720c22f0206c37dc6c1559f51b9319f3ee6647`.

Current pushed/tested runtime:
`0.0.68-dev`.

P0142:
**SOURCE-CAPABILITY AUDIT RESOLVED IN THE PREPARED DOCS CHECKPOINT; P0143 RUNTIME PROBE NEXT AFTER PUSH.**

## Active work stream

P0142 pins exact Forever source
`Gethe/wow-ui-source@e3ecc27b64d30fdc735a3f6579b866858f9f9df1`
(`1.60.1.70205`) and accepts D-043.

Key result:
- ordinary quest waypoint source remains `C_QuestLog.GetNextWaypoint*`; earlier
  negative tested quests remain negative evidence;
- `C_Navigation.GetNextWaypointForMap` is a distinct current-navigation candidate;
- tracking types/state are enumerable and multi-select;
- individual tracked-result positions are not exposed by audited public APIs;
- service tracking filters expose categories/state, not service-instance positions;
- positioned `C_AreaPoiInfo` rows are a separate local-POI candidate;
- `C_Minimap.GetViewRadius` plus `C_Map` map/world geometry are source-plausible
  local-radius/comparable-distance inputs;
- minimap stock ownership remains mandatory.

Next after P0142 durability:
**P0143 read-only navigation source runtime probe.**

Do not add tracking-result glyphs, mutate tracking filters, change minimap CVars,
suppress the minimap, or fabricate bearings.

World-target positive anchoring remains environmentally deferred. Camera remains
frozen, not complete.

## Key references

- `../evidence/P0142_NAVIGATION_MINIMAP_SOURCE_CAPABILITY_AUDIT_2026-10-05.md`
- `../decisions/D-043_NAVIGATION_SOURCE_AND_MINIMAP_FALLBACK_POLICY.md`
- `../patches/P0142_NAVIGATION_MINIMAP_SOURCE_CAPABILITY_AUDIT.md`
- `../investigations/FUTURE_NAVIGATION_POI_TRACKING_CAPABILITY.md`
- `../decisions/D-037_NAVIGATION_MARKER_ROLES_AND_MINIMAP_DIRECTION.md`
- `../decisions/D-038_COMPASS_VISUAL_FOCUS_AND_DEPTH_CONTRACT.md`
- `../architecture/VISUAL_IMPLEMENTATION_STATUS.md`
- `../roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `../roadmap/PHASE_G_CINEMATIC_CAMERA.md`
