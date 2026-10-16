---
memory_schema: 1
as_of: 2026-10-16
project: logres
---

# Current State

## Active Objective
Phase H.3: complete approved sheet-12 compass navigation without sacrificing truthful positions or Blizzard's minimap fallback. GitHub main P0223 `27505f1` verified. Manual waypoint and focused accepted quest bearings are user-validated; local unaccepted quest, service POI and generic tracking result families remain OPEN / SOURCE LIMITED.

## Current Work Item
**P0224 docs-only QuestieDB public API/provider audit.** Research a possible optional source of quest-giver and service-NPC coordinates, not a claim that the database is loaded, client-compatible or a verified quest-availability source. P0223 gameplay implementation and near-range glyph size remain unchanged. No WoW deployment for P0224.

## Verified State
- P0223 `0.0.132-dev` pushed `27505f1`; user confirmed one focused quest glyph, true bearing, appropriate title and some depth-scaling response. Size below ~half minimap radius changes little; final visual tuning DEFERRED.
- The latest run reports source-backed accepted quest ID 237 at approximately 0.66 yards, and three accepted quest map rows. Local AreaPOI=0, vignette=0 and available quest-line=0; no source failures reported for this sample.
- Tracking selections provide categories, not object coordinates. P0221 request test remains negative; P0220/P0221 artwork/API checks never proved live local markers. Blizzard minimap remains the fallback.
- QuestieDB public API offers quest-start entity references and zone spawn lists as an EXTERNAL DATA CANDIDATE; map identity, character eligibility, phase, client-version compatibility and performance are unresolved. QuestieDB is neither installed nor enabled by this patch; no dependency has been accepted.

## Next Action
Test one positive and one negative quest-giver candidate from an explicitly loaded, contract-compatible QuestieDB on a known Forever map, using only public APIs and validated AreaID/UiMapID mapping. Then develop a bounded optional bridge with strict eligibility if evidence supports it. Do not run a global GetAllIds scan on each compass event or infer that historical spawns are live minimap blips. Generic tracked resource detections need a separate actual-position source.

## Success Criteria
- One QuestieDB candidate must have a verified ordinary coordinate aligned with a real map identity and a specific observed quest giver; one negative control must be filtered out. No experimental glyph shown as definitive quest availability.
- Provider versions, flavor, coordinate conversion, client data and map matching checked before any production icon; no protected/secret-state inspection or uncontrolled background scans.
- Existing P0223 quest/waypoint capabilities and available Blizzard fallback remain untouched; runtime PASS requires a real user-observed icon with matching bearing.

## Do Not Reopen Without New Evidence
Do not rework accepted quest-marker geometry or close-range scaling yet; do not treat QuestieDB quest starts as current offer eligibility, tracking filters as positions, static candidates as live service units, or generic Compass Check PASS as full navigation completeness. No native pin scraping, unbounded polling, mass data vendoring or premature minimap suppression.

## Relevant References
- `docs/memory/evidence/P0224_QUESTIEDB_NAVIGATION_PROVIDER_AUDIT.md`
- `docs/memory/evidence/P0223_COMPASS_FOCUS_DEPTH_RUNTIME.md`
- `docs/memory/evidence/P0222_COMPASS_NATIVE_MAP_PROVIDERS.md`
- `docs/memory/decisions/D-037_NAVIGATION_MARKER_ROLES_AND_MINIMAP_DIRECTION.md`
- `docs/memory/decisions/D-038_COMPASS_VISUAL_FOCUS_AND_DEPTH_CONTRACT.md`
- `docs/memory/decisions/D-043_NAVIGATION_SOURCE_AND_MINIMAP_FALLBACK_POLICY.md`
- `docs/design/approved/12_compass_glyph_and_state_sheet.png`
