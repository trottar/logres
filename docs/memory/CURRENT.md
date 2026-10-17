---
memory_schema: 1
as_of: 2026-10-17
project: logres
---

# Current State

## Active Objective
Phase H.3: make Logres's own compass the usable dynamic nearby-navigation surface. The native minimap is HIDDEN during normal immersion and is NOT a visible fallback for missing Logres markers. P0223 accepted focused-quest/waypoint bearings remain preserved. Additional nearby quest-giver, services, and live tracking POI coverage is still OPEN.

## Current Work Item
**P0233 — unassisted compass startup and one confirmed physical quest-giver destination.** P0232 pushed to GitHub `main` at `ca639c9`. The user's 0.0.137-dev loadCount 307 after normal reload records `compasscheck` *before any QuestieDB Location Probe in that load*: `provider=ready candidates=4 shown=2`. The user saw usable POI glyphs and followed one directly to a quest giver. This is startup/source/renderer PASS in the observed local context and one user-observed location match, NOT proof of eligibility, all-map coverage or all tracking/service POIs. P0230 load 305 failure and P0231 load 306 manual-retry dependency remain preserved in evidence; no speculative radius adjustment from perceived marker density. Canonical proof: `docs/memory/evidence/P0233_UNASSISTED_COMPASS_AND_PHYSICAL_QUEST_GIVER_PROOF.md`.

## Verified State
- **P0233 runtime evidence (load 307):** `compasscheck` without preceding `questiedbprobe` in this load reports `provider=ready candidates=4 shown=2`. User-followed glyph reached a real quest giver; one physical path validated. Exact NPC identity, eligibility, broad map coverage, and all service/tracking markers not established. See P0233 evidence.
- **P0231 new runtime proof (0.0.137-dev loadCount 306):** QuestieDB 1.0.6 loaded Forever baked contract-compatible; nearby `index=ready map=1432 area=38 scanned=13392 ids=13392 zoneNPCs=153 questNPCs=30 spawns=38 nearby=5 radius=50 truncated=false`; canonical map trace `requested=1432 chain=1432 entries=54 failure=- trigger=panel-map-diagnostic`; Compass Check `provider=ready candidates=4 shown=2`. This establishes in-game indexing and addon-owned marker show state **after manual panel retry**. Autonomous startup, general map coverage, visual accuracy and eligible quest offers remain unverified. Evidence: `docs/memory/evidence/P0232_P0231_RUNTIME_NEARBY_EVIDENCE.md`.
- **P0230 FAIL, new 0.0.136-dev runtime evidence**: loadCount 305, QuestieDB v1.0.6 compatible, near index `map-not-in-provider-zone-table`, `map=- area=- scanned=0 ids=0`, compass `candidates=0 shown=0`. Native compasscheck PASS checks heading/waypoint policy, not nearby glyphs. A missing map mapping aborts index before positions are read; no evidence of zero nearby NPCs. No new Lua error is recorded by these panel lines, but a full WoW Lua/taint log was not provided. See P0231 evidence.
- **P0228 runtime provider PASS, newly observed**: uploaded 0.0.135-dev diagnostics loadCount 304 show QuestieDB registered=yes loaded=yes tocVersion=1.0.6 tocFlavor=Forever tocMode=baked contract=1 mode=baked provider=contract-compatible in two panel runs. Quest location/gossip remains DEFERRED; no compass glyph results were part of P0228.
- **P0230 scope corrections**: discarded hardcoded Loch Modan-only suggestion; use dynamic current-zone mapping and 50-yard candidate radius. The user reports the Blizzard minimap is HIDDEN during normal immersion: it must NOT be used as the visible fallback to justify missing compass features. Database-only spawns never establish quest availability.

- P0229 process correction: user reported QuestieDB visible in WoW; prior `not-installed` claim inferred absence from one path and old loadCount 300 diagnostics despite loadCount 302. The first P0228 applier failed pre-write `CURRENT.md` EOF hygiene, then R1 repaired the generator. The existing developer panel already offers **E — Compass and Navigation → QuestieDB Location Probe** (fifth action); open with `/logres panel`. The assistant omitted these steps and repeatedly requested unchanged diagnostics. This is documented assistant failure, not proof that QuestieDB is absent or that any new glyphs should appear. P0228 runtime remains UNVERIFIED. Evidence: `docs/memory/evidence/P0229_QUESTIEDB_DIAGNOSTIC_HANDOFF_FAILURE.md`.
- GitHub main P0227 `7c6850b` verified. Existing waypoint and focused accepted quest direction are P0223 user-accepted. Additional native POI feeds remain empty in tested Loch Modan environment; additional POI glyphs remain OPEN.
- P0226 0.0.134-dev last recorded `provider=not-installed` meant unavailable `_G.LibQuestieDB` in that run; it does **not** prove absent installation or failure of newer load count 302. Prior lack of proper state separation is an integration defect.
- `Questie/QuestieDB` v1.0.6 Source `ModeIndicator.GetStatus().expansion` is nil for Baked; generated baked TOC declares `X-Flavor: Forever`; Questie checks `RequireContract`, PlateSmith optional companion uses `OptionalDeps: QuestieDB`. Those are source findings, not yet new WoW runtime proof.
- QuestieDB remains optional for Logres as a whole; third-party data may miss hidden, patch-specific and phased quests. Redistribution/license unresolved; do not bundle it or claim CurseForge-managed dependency.

## Next Action
P0233 is a **docs-only acceptance checkpoint**. Next H.3 item: narrow review of nearby POI type coverage, existing renderer prioritization and the distinction between live-positioned native data, QuestieDB possible historical quest-giver coordinates, and unsupported live tracking blips. Preserve the working automatic startup, 50-yard database filter, hidden-minimap immersion policy, and P0223 quest/waypoint bearings. Do not force further gameplay for this already observed proof. Before future runtime changes, choose the next missing capability from evidence and prepare a bounded patch with its own validation.

## Success Criteria
- **Observed PASS (load 307):** nearby source was ready without a manual panel retry; two addon-owned glyphs were reported; the user visually followed one to a quest-giver NPC. This is local evidence, not universal coverage.
- **Retained OPEN:** repeatability through map transitions, all-zone data coverage, quest eligibility, service/harvest/tracking POIs, identity-level matching and visual density preferences.
- Retain prior P0230 negative runtime evidence and P0231 manual-retry qualification; no unsupported conversion, broad polling, fabricated available-quest label, or reliance on the hidden minimap.

## Do Not Reopen Without New Evidence
Do not infer addon installation from one guessed filesystem path or the presence/absence of a Lua global alone. No hard QuestieDB dependency, package bundling, unknown CurseForge project ID, global quest ID scans on updates, guessed quest availability, invented coordinates or native pin scraping. Do not hide the Blizzard minimap, alter user-accepted waypoint/focused-quest bearings, or treat missing locations as PASS. Baked flavor must not be guessed from a Source-only indicator. Keep negative and deferred evidence explicit.

## Relevant References
- `docs/memory/evidence/P0231_DYNAMIC_MAP_BRIDGE_FAILURE.md`
- `docs/memory/evidence/P0230_DYNAMIC_NEARBY_QUEST_CANDIDATES.md`
- `docs/memory/evidence/P0229_QUESTIEDB_DIAGNOSTIC_HANDOFF_FAILURE.md`
- `docs/memory/decisions/D-043_NAVIGATION_SOURCE_AND_MINIMAP_FALLBACK_POLICY.md`
- `docs/DEPENDENCIES.md`
