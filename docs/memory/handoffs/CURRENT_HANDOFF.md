# Current Handoff

Authoritative state:
`../CURRENT.md`.

Latest verified durable checkpoint:
P0142 `82682ece15ad21aa7d5ee2dfaba5e5a3c68c97b6`.

Current pushed/tested runtime before P0143 deployment:
`0.0.68-dev`.

P0142:
**INSTALLED / PUSHED — SOURCE-CAPABILITY LAYER RESOLVED; D-043 ACCEPTED.**

## Active work stream

Current objective:
**P0143 — read-only navigation-source runtime probe.**

Candidate runtime after applying P0143:
`0.0.69-dev`.

The diagnostic is event-driven and read-only. It samples current map/player
geometry, minimap view radius, tracking selector metadata/state, current
super-tracking/navigation, ordinary quest waypoints when naturally present, and a
bounded current-map `C_AreaPoiInfo` set.

It does not:
- mutate tracking or supertracking;
- create/clear waypoints;
- modify minimap CVars/zoom/pings/presentation;
- inspect Blizzard pins/frames for hidden blip coordinates;
- poll;
- add production navigation markers;
- suppress the minimap.

Runtime proof is pending. Environmental absence of a waypoint or AreaPOI is a
deferral. Secret/call/Lua failures are failures.

World-target positive anchoring remains environmentally deferred. Camera remains
frozen, not complete.

## Key references

- `../CURRENT.md`
- `../patches/P0143_NAVIGATION_SOURCE_READ_ONLY_PROBE.md`
- `../evidence/P0142_NAVIGATION_MINIMAP_SOURCE_CAPABILITY_AUDIT_2026-10-05.md`
- `../decisions/D-043_NAVIGATION_SOURCE_AND_MINIMAP_FALLBACK_POLICY.md`
- `../patches/P0142_NAVIGATION_MINIMAP_SOURCE_CAPABILITY_AUDIT.md`
- `../investigations/FUTURE_NAVIGATION_POI_TRACKING_CAPABILITY.md`
- `../decisions/D-037_NAVIGATION_MARKER_ROLES_AND_MINIMAP_DIRECTION.md`
- `../decisions/D-038_COMPASS_VISUAL_FOCUS_AND_DEPTH_CONTRACT.md`
- `../roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `../roadmap/PHASE_G_CINEMATIC_CAMERA.md`
