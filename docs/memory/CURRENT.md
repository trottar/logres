---
memory_schema: 1
as_of: 2026-10-16
project: logres
---

# Current State

## Active Objective
Phase H.3: complete approved sheet-12 compass marker coverage with truthful positions and native minimap fallback. Working manual waypoint and focused accepted quest bearings remain user-accepted. Unaccepted quests, services and tracking detections remain OPEN.

## Current Work Item
**P0226 OPTIONAL QuestieDB Forever source positive/negative compatibility probe** atop locally applied, uncommitted P0225. The user explicitly chose QuestieDB to supplement native positions despite patch-maintenance cost. P0225 `0.0.133-dev`, loadCount 299, returned zero force-visible quests, zero task starts, zero hubs, zero AreaPOIs, zero vignettes and zero unaccepted quest-lines in Loch Modan; FAIL for live POI coverage despite zero source failures. P0226 tests the packaged QuestieDB 1.0.6 Forever flavor against one observed gossip offer and one already accepted quest. It does NOT yet display QuestieDB markers, install the database, or claim hidden-quest completeness.

## Verified State
- Verified GitHub main P0224 `d4a39d1`; P0225 is installed/tested locally but remains unpushed as of this candidate. Never treat P0225 as committed.
- P0223 manual waypoint/focused accepted quest positions, bearing/name and distance scaling were visually verified. Close-end marker size refinement DEFERRED.
- Native source P0225 feeds returned ordinary empty arrays on map 1432, 0 secret skips, 0 failures. Accepted `C_QuestLog.GetQuestsOnMap` rows remain positive (3).
- QuestieDB 1.0.6's official release includes `QuestieDB-Forever.zip`, contract versions 1–4, and October 10 Forever base data. Public `QuestDB.startedBy`/`NpcDB.spawns` return potential quest NPC locations, NOT current offer eligibility. The user recognizes missing hidden/patch/phased quests as a coverage risk.

## Next Action
Apply and deploy P0226 with P0225 worktree intact. Install official QuestieDB 1.0.6 Forever ZIP (not a source archive) separately if desired; confirm it loads and its public ModeIndicator reports Forever, contract 1 supported. In an ordinary nearby quest interaction, use Phase E QuestieDB Location Probe. Record status, positive offer/NPC/spawn agreement, negative accepted-quest exclusion, actual compass behavior and any Lua/taint errors. If the provider is absent, incompatible, or no natural positive context exists, record DEFERRED, not PASS. Only after source proof build a bounded, map-scoped optional location index, classifying DB-only rows as *candidates*, not verified live offers. Retain public Blizzard native feeds for dynamically visible hidden quests.

## Success Criteria
- Static full checker suite and diff hygiene pass at apply time; WoW runs without new errors.
- Read-only positive proof of a real native gossip offer against public DB startedBy and spawn on audited map 1432→38; one ordinary accepted quest excluded as negative control.
- No hidden-quest claims from absence in QuestieDB. Preserve the native minimap UI and no unproven marker or protected/secret pin inspection.

## Do Not Reopen Without New Evidence
No global `QuestDB.GetAllIds` scanning each update, private QuestieDB map strings, guessed current eligibility, blind glyphs, native minimap suppression, polling loops, changes to proven compass bearing/scaling, or claim that DB reflects all Forever hidden/new content.

## Relevant References
- `docs/memory/evidence/P0226_QUESTIEDB_SOURCE_ACCEPTANCE_GATE.md`
- `docs/memory/evidence/P0225_NATIVE_MINIMAP_OFFER_SOURCE_EXPANSION.md`
- `docs/memory/evidence/P0224_QUESTIEDB_NAVIGATION_PROVIDER_AUDIT.md`
- `docs/memory/evidence/P0223_COMPASS_FOCUS_DEPTH_RUNTIME.md`
- `docs/memory/decisions/D-043_NAVIGATION_SOURCE_AND_MINIMAP_FALLBACK_POLICY.md`
