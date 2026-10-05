# Current Handoff

Authoritative state:
`../CURRENT.md`.

Latest verified durable checkpoint:
P0144 `47534363bd5754306c31d5e860739289504417de`.

Current pushed/tested runtime before P0145 deployment:
`0.0.69-dev`.

P0144:
**INSTALLED / PUSHED — P0143 RUNTIME PASS RECORDED WITH DESTINATION/AREA-POI DEFERRALS.**

## Active work stream

Current objective:
**P0145 — manual-waypoint comparable-distance / bounded-depth integration.**

Candidate runtime:
`0.0.70-dev`.

P0145 preserves the proven P0123 bearing path and adds a non-fatal distance side
channel only when:
- player/current map ID is ordinary;
- user waypoint `uiMapID` is ordinary and matches the current map;
- player and destination normalized coordinates are ordinary;
- `C_Map.GetMapWorldSize` returns ordinary positive yard dimensions.

The distance result drives only restrained Theme-owned scale:
- distance depth scale: `0.90–1.05`;
- combined render scale after existing near-center focus: `0.90–1.12`.

If distance is unavailable, secret, invalid, or cross-map, depth returns to `1.0`
and the existing waypoint marker remains usable.

P0145 adds no distance label, waypoint identity, quest/POI/tracking marker, minimap
mutation, or stock suppression.

Runtime + visual proof is pending. Place one normal current-map user waypoint,
run **Phase E -> Compass Check**, rotate to confirm bearing/off-tape behavior, clear
the waypoint, then run **Phase 0 -> Run All**.

World-target positive anchoring remains environmentally deferred. Camera remains
frozen, not complete.

## Key references

- `../CURRENT.md`
- `../patches/P0145_MANUAL_WAYPOINT_DISTANCE_DEPTH.md`
- `../evidence/P0144_P0143_NAVIGATION_RUNTIME_PASS_WITH_DEFERRALS_2026-10-05.md`
- `../decisions/D-043_NAVIGATION_SOURCE_AND_MINIMAP_FALLBACK_POLICY.md`
- `../decisions/D-038_COMPASS_VISUAL_FOCUS_AND_DEPTH_CONTRACT.md`
- `../investigations/FUTURE_NAVIGATION_POI_TRACKING_CAPABILITY.md`
- `../patches/P0123_COMPASS_VISUAL_TRANSLATION.md`
- `../roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `../roadmap/PHASE_G_CINEMATIC_CAMERA.md`
