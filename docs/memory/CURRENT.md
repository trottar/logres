---
memory_schema: 1
as_of: 2026-10-16
project: logres
---

# Current State

## Active Objective
Phase H.3: complete approved compass marker coverage without inventing world positions or suppressing the Blizzard minimap fallback. P0223's manually user-verified waypoint and focused-quest bearings remain accepted. Available quest, service POI, and tracking detections remain OPEN / SOURCE LIMITED.

## Current Work Item
**P0227 docs-only external QuestieDB installation/dependency/public-release policy**, after verifying P0225+P0226 pushed together at `45bbd0e` on `main`. The user reported no new compass POIs; uploaded 0.0.134-dev diagnostics show `questiedbprobe: DEFERRED provider=not-installed`, `contract=not-checked`, `gossip=not-observed`, `positive=deferred`, with `negative=accepted-quest-excluded`. Installing the external database and obtaining a positive source proof are next. The current P0226 module is a read-only optional probe, **not** a live database-backed compass provider.

## Verified State
- P0226 commit `45bbd0e` verified on GitHub main (includes locally tested P0225 native-source changes). P0225's extra native source feeds returned empty ordinary lists in the user's tested Loch Modan environment, not POI functional PASS.
- P0226 runtime 0.0.134-dev executed without proving QuestieDB availability or coordinate accuracy; missing provider is an environmental DEFERRED result, not a QuestieDB algorithm failure or PASS. P0226 does not add POI glyphs by design.
- The approved external source is `Questie/QuestieDB`, not the separate CurseForge `LibQuestDB`. Official QuestieDB `v1.0.6` has a `QuestieDB-Forever.zip` release, with published SHA-256 and `QuestieDB/QuestieDB_Forever.toc` package structure.
- QuestieDB is presently **optional for Logres as a whole**; supported base navigation still runs without it. Database-dependent markers are planned, not yet implemented. It is NOT currently declared a hard TOC or CurseForge required dependency, and there is no verified CurseForge package mapping for this exact database.
- No repository-top-level QuestieDB LICENSE file was found in the inspected upstream tree. Until distribution permission/license is verified, install separately from the official upstream release; do not vendor QuestieDB into Logres archives.

## Next Action
User installs QuestieDB Forever v1.0.6 separately using `docs/DEPENDENCIES.md`, enables it on the game character, opens a naturally available quest-giver gossip in Loch Modan, and runs Phase E `QuestieDB Location Probe` (`/logres questiedbprobe`). Verify public contract 1, Forever flavor, map 1432→area 38, observed offered quest ID, NPC identity and nearby spawn match, and accepted-quest negative control. Capture the resulting diagnostics. If source proof is positive, plan a separate bounded map-scoped database adapter with candidate vs confirmed distinction and native live feed priority. If provider remains absent, keep result DEFERRED.

## Success Criteria
- Dependency installation works and the probe shows the expected contract/flavor/map/real gossip source agreement without Lua/taint/secret errors. No production glyph PASS is implied by a successful diagnostic.
- Public publishing docs distinguish optional from required features, name the exact upstream download, document version/updates/checksum and missing-provider behavior, do not conflate LibQuestDB, and prohibit assuming CurseForge automation or bundling rights.
- Maintain working P0223 navigation and Blizzard minimap access; do not generate quest availability merely from historical spawns or silently drop hidden/newly patched quests.

## Do Not Reopen Without New Evidence
Do not globally enumerate `QuestDB.GetAllIds` in production updates; mistake historical database spawns for currently available, visible or hidden quest offers; guess AreaID/UiMapID mappings or character eligibility; or turn absent-provider and ordinary-empty source results into PASS. No unverified CurseForge dependency slug, bundled QuestieDB redistribution, or hard TOC dependency without source and permission proof. Preserve the native Blizzard minimap and native position feed; do not scrape protected/secret presentation or change the accepted waypoint and focused-quest bearing/scaling behavior without fresh evidence.

## Relevant References
- `docs/DEPENDENCIES.md`
- `docs/memory/evidence/P0227_QUESTIEDB_DEPENDENCY_DISTRIBUTION_CHECKPOINT.md`
- `docs/memory/evidence/P0226_QUESTIEDB_SOURCE_ACCEPTANCE_GATE.md`
- `docs/memory/evidence/P0225_NATIVE_MINIMAP_OFFER_SOURCE_EXPANSION.md`
- `docs/memory/decisions/D-043_NAVIGATION_SOURCE_AND_MINIMAP_FALLBACK_POLICY.md`
