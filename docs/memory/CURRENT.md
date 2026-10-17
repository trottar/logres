---
memory_schema: 1
as_of: 2026-10-16
project: logres
---

# Current State

## Active Objective
Phase H.3: make Logres's own compass the usable dynamic nearby-navigation surface. The native minimap is HIDDEN during normal immersion and is NOT a visible fallback for missing Logres markers. P0223 accepted focused-quest/waypoint bearings remain preserved. Additional nearby quest-giver, services, and live tracking POI coverage is still OPEN.

## Current Work Item
P0231 — isolate the in-game dynamic map/QuestieDB AreaID bridge failure from the user's first P0230 WoW run. GitHub main P0230 `92de16d` verified. User 0.0.136-dev `loadCount=305` QuestieDB panel output shows provider contract-compatible but `questiedbnearby index=map-not-in-provider-zone-table map=- area=- scanned=0 ids=0 spawns=0 nearby=0`; Compass Check `candidates=0 shown=0`. This is a **navigation feature FAIL**, not a geographic zero-match. P0230 cleared the original map id on failure, obscuring cause. P0231 adds bounded map/parent tracing (12 levels), retains observed leaf map, records provider mapping count and stop reason, and retries once on existing Phase E panel action. No guessed AreaID or fabricated markers.

## Verified State
- **P0230 FAIL, new 0.0.136-dev runtime evidence**: loadCount 305, QuestieDB v1.0.6 compatible, near index `map-not-in-provider-zone-table`, `map=- area=- scanned=0 ids=0`, compass `candidates=0 shown=0`. Native compasscheck PASS checks heading/waypoint policy, not nearby glyphs. A missing map mapping aborts index before positions are read; no evidence of zero nearby NPCs. No new Lua error is recorded by these panel lines, but a full WoW Lua/taint log was not provided. See P0231 evidence.
- **P0228 runtime provider PASS, newly observed**: uploaded 0.0.135-dev diagnostics loadCount 304 show QuestieDB registered=yes loaded=yes tocVersion=1.0.6 tocFlavor=Forever tocMode=baked contract=1 mode=baked provider=contract-compatible in two panel runs. Quest location/gossip remains DEFERRED; no compass glyph results were part of P0228.
- **P0230 scope corrections**: discarded hardcoded Loch Modan-only suggestion; use dynamic current-zone mapping and 50-yard candidate radius. The user reports the Blizzard minimap is HIDDEN during normal immersion: it must NOT be used as the visible fallback to justify missing compass features. Database-only spawns never establish quest availability.

- P0229 process correction: user reported QuestieDB visible in WoW; prior `not-installed` claim inferred absence from one path and old loadCount 300 diagnostics despite loadCount 302. The first P0228 applier failed pre-write `CURRENT.md` EOF hygiene, then R1 repaired the generator. The existing developer panel already offers **E — Compass and Navigation → QuestieDB Location Probe** (fifth action); open with `/logres panel`. The assistant omitted these steps and repeatedly requested unchanged diagnostics. This is documented assistant failure, not proof that QuestieDB is absent or that any new glyphs should appear. P0228 runtime remains UNVERIFIED. Evidence: `docs/memory/evidence/P0229_QUESTIEDB_DIAGNOSTIC_HANDOFF_FAILURE.md`.
- GitHub main P0227 `7c6850b` verified. Existing waypoint and focused accepted quest direction are P0223 user-accepted. Additional native POI feeds remain empty in tested Loch Modan environment; additional POI glyphs remain OPEN.
- P0226 0.0.134-dev last recorded `provider=not-installed` meant unavailable `_G.LibQuestieDB` in that run; it does **not** prove absent installation or failure of newer load count 302. Prior lack of proper state separation is an integration defect.
- `Questie/QuestieDB` v1.0.6 Source `ModeIndicator.GetStatus().expansion` is nil for Baked; generated baked TOC declares `X-Flavor: Forever`; Questie checks `RequireContract`, PlateSmith optional companion uses `OptionalDeps: QuestieDB`. Those are source findings, not yet new WoW runtime proof.
- QuestieDB remains optional for Logres as a whole; third-party data may miss hidden, patch-specific and phased quests. Redistribution/license unresolved; do not bundle it or claim CurseForge-managed dependency.

## Next Action
Apply P0231 on verified P0230 main, deploy, `/reload`, `/logres panel` → **E — Compass and Navigation** → **QuestieDB Location Probe** once, then **Compass Check**. Read `questiedbmap requested/chain/entries/failure/trigger` and `questiedbnearby index/map/area/scanned`. If a real canonical area is resolved, allow the 96-ID/frame one-time index to finish; otherwise use the actual map ancestry to make the narrow next correction. Do not repeat probes without changing source/context. No forced travel, no claim that hidden minimap covers missing POIs.

## Success Criteria
- P0231 records the raw ordinary current map ID and bounded ancestry for P0230 map-resolution failures; full provider mapping count and stop reason remain observable after Unavailable() clears the active area.
- With a matching canonical area, automatic index begins and may complete; with none, record DEFERRED / FEATURE FAIL rather than zero nearby locations, without guessing zone IDs.
- No Lua, taint, protected or secret-value failures. Existing compass waypoint/accepted quest behavior and 50-yard candidate policy unchanged. No reliance on a visible native minimap, which is folded in immersion.
- Static checks must pass, but do not count them as successful live marker evidence.

## Do Not Reopen Without New Evidence
Do not infer addon installation from one guessed filesystem path or the presence/absence of a Lua global alone. No hard QuestieDB dependency, package bundling, unknown CurseForge project ID, global quest ID scans on updates, guessed quest availability, invented coordinates or native pin scraping. Do not hide the Blizzard minimap, alter user-accepted waypoint/focused-quest bearings, or treat missing locations as PASS. Baked flavor must not be guessed from a Source-only indicator. Keep negative and deferred evidence explicit.

## Relevant References
- `docs/memory/evidence/P0231_DYNAMIC_MAP_BRIDGE_FAILURE.md`
- `docs/memory/evidence/P0230_DYNAMIC_NEARBY_QUEST_CANDIDATES.md`
- `docs/memory/evidence/P0229_QUESTIEDB_DIAGNOSTIC_HANDOFF_FAILURE.md`
- `docs/memory/decisions/D-043_NAVIGATION_SOURCE_AND_MINIMAP_FALLBACK_POLICY.md`
- `docs/DEPENDENCIES.md`
