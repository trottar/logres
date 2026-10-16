---
memory_schema: 1
as_of: 2026-10-16
project: logres
---

# Current State

## Active Objective
Phase H.3: finish actual compass visual and source capabilities against the accepted D-037/D-038/D-039 compass direction. The user explicitly corrected the premature classification of sheet 12 as mostly done. P0218 is verified on GitHub `main` at `157e09c`; in-game `0.0.127-dev` loadCount 288 panel status/preview/Run All passed the tested state; harmful live population remains deferred. P0219's focus is the compass, not NPC quest controls.

## Current Work Item
**P0219 candidate (`0.0.128-dev`):** produce the missing quest pennon / POI roundel / tracking pip textures from approved sheet 12, register the three separate lane-role dimensions in Theme, and expose a clearly marked developer-panel compass **art preview**. Preview glyph positions are illustrative **only** and never feed real compass bearings. Retain heading and manual waypoint exact-source pipeline unchanged; preserve Blizzard minimap and all other fallbacks. The three roles remain unavailable in ordinary live display until a supported source proves individual world positions.

## Verified State
- GitHub `main` `157e09c` P0218 verified; P0218 has no observed failure in uploaded 0.0.127-dev load count 288 panel preview/test, though naturally populated harmful aura remains unverified. Historical failures/deferrals preserved.
- Existing Compass module renders a heading tape + fixed center gnomon + manual user-waypoint diamond. P0213 only improved cardinal/intercardinal label contrast. Missing approved role art: quest, POI, tracking, plus multi-role production lanes, center-focus identity, name fade and collision logic.
- P0142/P0143 navigation source evidence: tracking-selection metadata supports multi-select but does not yield detected entity positions. Quest destination and current-map AreaPOI positioned outputs were not observed in the tested environment. `NavigationSourceProbe.lua` is an existing read-only source probe; do not fake data, patch in polling, or suppress native minimap.
- P0219 remains WoW UNVERIFIED until user performs the developer-panel test. Art preview is not runtime proof of navigation source capability.

## Next Action
Apply P0219 guarded applier, deploy, `/reload`. Developer panel Phase E Compass Art Preview ON then OFF + Compass Check; Phase H Navigation Source Probe and H.2 Map / Layout Check; Phase 0 Run All. Visually compare the quest, POI and tracking glyphs/lanes to sheet 12. Check preview OFF leaves only true heading/manual glyphs, no orphan markers, and no errors. Capture read-only navigation probe result and determine the next capability-gated producer slice from actual available outputs.

## Success Criteria
- Three distinct approved navigation glyph assets exist at Theme-owned production paths and use approximate 10x18, 9x9, and 4x5 actual-UI role sizes in a **development-only** preview.
- The production compass still shows only real source-backed markers; preview OFF, Immersion OFF and module disable remove all preview artifacts. Existing heading/manual controls and stock minimap are unmodified.
- No newly invented bearings, names, POI services, tracking instances, or magic data; no Lua/taint/secret regressions in tested context. Source capability remains explicitly deferred where not observed.

## Do Not Reopen Without New Evidence
Accepted P0214–P0218 presentation, protected pet driver, action routing, native Blizzard minimap/POI/quest controls, player HP/target information policy, earlier failed and environmental tests, and D-045 v4 anchors. Real navigation roles are not authorized by a visual mock or an unpopulated source probe.

## Relevant References
- `docs/design/approved/12_compass_glyph_and_state_sheet.png`
- `docs/memory/decisions/D-037_NAVIGATION_MARKER_ROLES_AND_MINIMAP_DIRECTION.md`
- `docs/memory/decisions/D-038_COMPASS_VISUAL_FOCUS_AND_DEPTH_CONTRACT.md`
- `docs/memory/decisions/D-039_APPROVED_VISUAL_BASELINE.md`
- `docs/memory/evidence/P0219_COMPASS_SHEET12_AND_CAPABILITY_GAP.md`
- `docs/memory/patches/P0219_COMPASS_SHEET12_AND_CAPABILITY_GAP.md`
- `docs/memory/evidence/P0144_P0143_NAVIGATION_RUNTIME_PASS_WITH_DEFERRALS_2026-10-05.md`
