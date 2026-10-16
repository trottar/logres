---
memory_schema: 1
as_of: 2026-10-16
project: logres
---

# Current State

## Active Objective
Phase H.3: finish the real sheet-12 compass with focused quest destination and source-backed nearby POI/tracking roles. GitHub main verified P0222 `b1fa844`. Manual waypoint and now accepted quest-map position markers have live visual evidence; native minimap remains accessible until missing marker families have safe, proven replacements.

## Current Work Item
**P0223 candidate `0.0.132-dev`** fixes P0222's major quest overpopulation and fixed-size glyph. Compass renders only the ordinary super-tracked quest's accepted positioned destination, using exactly the existing manual waypoint bounded distance-depth interpolation. It retains complete quest-source diagnostics and independently rendered local POI/tracking roles. No change to interaction, heading, absolute bearings, range gates, secret sources or native fallback. WoW runtime validation pending.

## Verified State
- P0222 committed and pushed `b1fa844` (2026-10-16); 0.0.131-dev loadCount 295 source probe map 1432 has questMap scanned:3 accepted:3 at 663.01, 966.81, 733.38 yards, super-track quest 237, zero source failures and secret skips. User sees accepted quest glyphs and correct focused quest name. This is a partial positive **quest** marker runtime result.
- Failure: unfocused quest markers also visible; quest glyph is fixed-size (no depth scaling). In that same capture AreaPOI=0, vignette=0 and availableQuestLines=0, so local world POIs, unaccepted quests and generic tracking remain OPEN and must NOT be called implemented/accepted.
- P0221's quest-line request was a live negative test. Previous P0219 visual previews prove only art. Stock minimap is retained as deliberate fallback.

## Next Action
Apply P0223 guarded ZIP at P0222 clean baseline, deploy, `/reload`, run Phase H Navigation Source Probe, Phase E Compass Check, Phase H Layout Check and Phase 0 Run All. Inspect the one focused quest's marker at different distances or during natural travel: scale should follow waypoint depth ranges; only quest 237 shown when focused in the recorded scenario. If no quest data in new natural context, defer that specific run rather than asserting PASS. Following P0223, continue a separate evidence-driven position-source investigation for available quests, service POIs and tracked results.

## Success Criteria
- Only the valid ordinary current super-tracked accepted quest marker appears, with coherent name and exact true bearing; other accepted map rows do not render. No supertrack/matching position means no quest glyph.
- The selected glyph uses existing waypoint depth/scale interpolation, bounded 0.70–1.20, with scale/depth reported by the developer panel. Local-POI and tracking rendering unchanged.
- Full static checks and diff hygiene, absence of Lua/secret/protected errors and retention of native minimap/Immersion OFF restoration. Runtime PASS only for behaviors visually observed; sources returning zero remain OPEN/DEFERRED.

## Do Not Reopen Without New Evidence
Do not treat Compass Check generic PASS as POI/tracking functionality, fabricate quest or minimap tracking coordinates, hook/scrape protected Blizzard pins, poll for unreproduced markers, disturb accepted pet/action/quest presentation, or remove the stock minimap fallback.

## Relevant References
- `docs/memory/evidence/P0223_COMPASS_FOCUS_DEPTH_RUNTIME.md`
- `docs/memory/evidence/P0222_COMPASS_NATIVE_MAP_PROVIDERS.md`
- `docs/memory/evidence/P0221_NAVIGATION_EMPTY_SOURCE_AND_REQUEST.md`
- `docs/memory/decisions/D-037_NAVIGATION_MARKER_ROLES_AND_MINIMAP_DIRECTION.md`
- `docs/memory/decisions/D-038_COMPASS_VISUAL_FOCUS_AND_DEPTH_CONTRACT.md`
- `docs/design/approved/12_compass_glyph_and_state_sheet.png`
