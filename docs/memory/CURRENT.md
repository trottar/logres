---
memory_schema: 1
as_of: 2026-10-16
project: logres
---

# Current State

## Active Objective
Phase H.3 compass functionality, not artwork previews. P0220 verified on GitHub main `09175bc`. P0221 `0.0.130-dev` locally applied (uncommitted): live trial failed to produce non-waypoint markers. User requires real available quest starts, accepted quest destinations, nearby POIs and tracking detections. Manual user waypoint is proven geometry/reference; native minimap must remain available until genuinely replaced.

## Current Work Item
**P0222 candidate (`0.0.131-dev`)** combines optional public position feeds: `C_QuestLog.GetQuestsOnMap` for started vs already-accepted quest markers, existing AreaPOI positions, and `C_VignetteInfo` positioned minimap vignettes, with P0220/P0221 quest-line fallback retained. It reuses exact-bearing waypoint projection with role-specific lanes, local range restrictions and map/eligibility/secret gates. No invented blips, protected presentation reads, periodic scans or Blizzard suppression. Runtime NOT yet verified.

## Verified State
- P0220 pushed `09175bc`. P0221 latest in-game `0.0.130-dev` loadCount 293: map 1432, view radius 133.33y, quest lines 0 despite single successful request + QUESTLINE_UPDATE, AreaPOI 0, tracking filters active 4 but no per-object coordinates. User screenshot: native available `!` visible, compass still no other markers. P0221 FAILS live marker objective; generic Compass Check PASS covers heading/manual only.
- Forever API docs declare QuestPOIMapInfo with `questID`, `x`, `y`, `mapID`, `isQuestStart`, plus vignette APIs with onMinimap and position. These sources have not been proven populated in this specific client. Separate unavailable/secret/zero source results rather than asserting native minimap parity.
- P0219 sheet-12 glyph assets are available; existing accurate manual-waypoint bearing projection is the foundation. General tracking category selection does NOT enumerate individual herb/ore detections.

## Next Action
On locally applied P0221 worktree, apply P0222 guarded ZIP (do not commit P0221 separately), deploy, `/reload`, run Phase H Navigation Source Probe, Phase E Compass Check, Phase H Layout Check, Phase 0 Run All. Compare source rows and real marker bearings near naturally visible map objects. If providers remain empty, preserve OPEN source limitation, investigate safe map/Questie-compatible database alternatives; do not claim success from a generic check.

## Success Criteria
- Native map quest starts become quiet local POIs only when ordinary unaccepted/not-completed; accepted non-start quest map entries use major quest lane. Other local POIs/vignettes are within true minimap radius. Role-specific glyphs retain exact bearings and vertical-only collision resolution.
- Observability: each provider reports scanned/eligible/nearby counts; compass reports actual non-waypoint marker count, role and candidate counts separately. Visual PASS only after positive positioned marker and correct in-game bearing.
- No source secret comparisons or protected surface reads, no polling or minimap suppression. Existing runtime checkers and diff hygiene pass; all untested scenarios remain DEFERRED/OPEN.

## Do Not Reopen Without New Evidence
Do not rework accepted pet/action/UI visuals, pretend tracking filters are detected coordinates, assert a nonexistent quest line request success from 0 rows, add native pin scraping/hooking or polling, or remove stock minimap fallback.

## Relevant References
- `docs/memory/evidence/P0222_COMPASS_NATIVE_MAP_PROVIDERS.md`
- `docs/memory/evidence/P0221_NAVIGATION_EMPTY_SOURCE_AND_REQUEST.md`
- `docs/memory/evidence/P0220_COMPASS_AVAILABLE_QUEST_POI_SOURCE.md`
- `docs/memory/decisions/D-037_NAVIGATION_MARKER_ROLES_AND_MINIMAP_DIRECTION.md`
- `docs/memory/decisions/D-038_COMPASS_VISUAL_FOCUS_AND_DEPTH_CONTRACT.md`
- `docs/design/approved/12_compass_glyph_and_state_sheet.png`
