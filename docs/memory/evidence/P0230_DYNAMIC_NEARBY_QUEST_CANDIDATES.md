# P0230 — Dynamic nearby QuestieDB candidate locations

Date: 2026-10-17. Prepared / WoW UNVERIFIED. No commit or push performed by the assistant.

## Evidence and revised user requirement

- User's fresh Logres 0.0.135-dev `loadCount=304` diagnostic recorded `registered=yes loaded=yes provider=contract-compatible tocFlavor=Forever tocMode=baked tocVersion=1.0.6 contract=1 mode=baked flavor=Forever`, twice. Provider runtime compatibility is **PASS**, location sample was **DEFERRED**, and no QuestieDB compass glyph was implemented at P0228.
- Assistant initially proposed a Loch Modan-only 50-yard implementation and the user rejected it. That candidate was **ABANDONED BEFORE DELIVERY**: hardcoded zone restrictions do not satisfy user-requested automatic location awareness. This is a design failure and must not be retried unchanged.
- The assistant incorrectly described the hidden native minimap as an available visible fallback. The user corrected this: during immersion it is HIDDEN. The existing Compass POI renderer gated all markers on `C_Minimap.GetViewRadius()`. P0230 removes that dependency for its fixed 50-yard DB candidates; native radius-dependent glyphs remain gated by a genuine radius. Candidate is WoW runtime UNVERIFIED.
- Canonical project policy D-043: Blizzard public tracking filters have settings/selection metadata but not a supported API providing individual live detected blip positions. Reading protected/secret native minimap presentation to manufacture coordinates is prohibited. Existing C_Map/C_QuestLog/AreaPOI/Vignette public positioned feeds remain first priority.
- Official QuestieDB v1.0.6 `Support.Get("ZoneDB").private.uiMapIdToAreaId` holds the provider's Forever **canonical** UiMap→Area map as a string. Its 54 direct AreaIDs cover many outdoor maps, cities, and selected zones; compatibility alias/floor maps must not be treated as live zone support. This patch parses only numeric pairs, without `loadstring`, avoids a single-zone restriction, and selects zone on map change. Canonical map coverage is finite, NOT universal map coverage.

## Candidate implementation

- `QuestieDBNearby` is optional and fail-open. It checks `RequireContract(1)`, baked `X-Flavor=Forever`, and official QuestieDB map mapping; no hard dependency, third-party bundling, addon auto-load, invented AreaIDs, or protected state inspection.
- On entering world or map change, derive the actual `C_Map.GetBestMapForUnit("player")` and parent map (bounded five levels). The resulting canonical provider AreaID selects a **new zone-specific finite index**, not a fixed Loch Modan ID. For subzones, player position/map dimensions are read together from the selected canonical map. Unsupported map/frame pairs remain `DEFERRED`, not zero-POI proof.
- The index reads QuestieDB's existing NPC ID list only once per selected area, 96 IDs per frame until done; narrows by `NpcDB.zoneID` (primary/most-common zone) and `NpcDB.questStarts`, samples bounded `NpcDB.spawns` and caches at most 1024 positioned entries. No global QuestDB enumeration, periodic global re-scans, polling timer, native pin scanning, or continuous reassertion. `zoneID` filtering is incomplete for NPCs that also spawn outside their primary zone; the coverage label says so. A zero-candidate result does not imply no available quests.
- On compass update, only cached positions are filtered against the current in-game player position for **50 yards**; at most eight unique quest-start NPC candidates are returned. Public C_QuestLog quest availability is not invented: these are **possible quest-giver locations**, not confirmed quests. Native positioned POIs sort first; database candidates have reduced opacity and an explicit `Possible quest giver: ` focus label. Existing heading, waypoint, focused accepted quest, other POIs, remain untouched. The Blizzard minimap is hidden during normal immersion; deliberate native-dock access is not a visible navigation fallback.
- Phase E already has **QuestieDB Location Probe**. That same panel action now includes a second `questiedbnearby` index line with map, AreaID, radius, scanning progress, cached locations, truncation, and nearby count. No slash-only test or fake preview proof.

## Deferrals and safety

- No live individual herb/ore/service minimap blip coordinate feed was verified. Therefore P0230 does **not** claim to mirror all Blizzard minimap blips or complete quest eligibility. Normal immersion hides the Blizzard minimap. Its dock access must not be treated as a live navigation fallback; P0230 must provide its own markers.
- Runtime CPU budget, exact matching of source coordinates to the live map, and rendered glyph bearings remain **UNVERIFIED** pending an in-game run. All Lua/taint/secret failures are failures; no static test may be recorded as runtime PASS.
- When the user moves to a different canonical map, the active finite index rebuilds. When the current map has no canonical pairing, no DB glyph appears; native feeds remain usable as source feeds; the minimap is hidden in immersion and cannot substitute for missing Logres markers.

## Panel-first runtime validation

1. Deploy P0230 runtime patch, `/reload`.
2. `/logres panel` → **E — Compass and Navigation** → **QuestieDB Location Probe** (fifth button). Read the additional `questiedbnearby` line. `indexing` is not empty; `ready` or `ready-partial` provides the completed scope. Inspect `map`, `area`, `ids`, `scanned`, `zoneNPCs`, `questNPCs`, `spawns`, `nearby`, `radius=50`.
3. In the same **E** tab click **Compass Check**. When a database candidate is within 50 yards, it should show as a muted local POI with `Possible quest giver:` label near center; expected output is source-candidate behavior, not confirmed quest availability. If none nearby, no new glyph is expected; preserve this as an environmental negative.
4. Without forced travel, verify that a natural map transition changes the `map/area` fields if one occurs. Immersion OFF retains normal hide behavior, existing native-dock behavior stays unchanged (the minimap is hidden in normal immersion), and no Lua, taint or protected errors may occur.
5. Export `LOGRES_DIAGNOSTICS_LATEST.lua`. No contrived quest NPC interaction is required to build the index.

## Durability

P0228's local 0.0.135-dev provider PASS is observed but its runtime code is not on remote main at time of patch preparation (main currently P0229 `d010f64`). P0230 requires local P0228 R1 files and preserves P0229 memory. User owns staging/committing both runtime patches; verify pushed state before claiming durability.
