---
memory_schema: 1
as_of: 2026-10-17
project: logres
---

# Current State

## Active Objective
Phase H.3: make Logres's own compass the usable dynamic nearby-navigation surface. The native minimap is HIDDEN during normal immersion and is NOT a visible fallback for missing Logres markers. P0223 accepted focused-quest/waypoint bearings remain preserved. Additional nearby quest-giver, services, and live tracking POI coverage is still OPEN.

## Current Work Item
**P0234 — audited POI type coverage and priority, now prepare P0235 implementation.** P0233 docs-only push `27e9e36` verified. Source evidence confirms native-positioned POI/vignettes and focused quest direction are already distinguished from QuestieDB's 50-yard *possible* quest-giver candidates, with native-first POI pool ordering. Native tracking filter names/states do not provide live blip positions. QuestieDB v1.0.6 publishes historical NPC service flags and spawn coordinates; its provider NPC flag enum is guaranteed only by `RequireContract(4)`, not the existing v1 consumer gate. Source audit: `docs/memory/evidence/P0234_NEARBY_POI_SOURCE_AND_PRIORITY_AUDIT.md`. No runtime/presentation changes in P0234.

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
P0234 is a docs-only capability audit. Next H.3 runtime item: **P0235 capability-gated historical service candidates (flight master, innkeeper, repair)** using loaded QuestieDB v4 NPC flag enum plus ordinary canonical-zone spawn data. Add in the already bounded finite index, without a second full scan, and make service candidates lower priority than live native sources, focused quest and existing quest-giver candidates. Display *possible*, never claim live services, and do not use the hidden Blizzard minimap as visible fallback. Preserve 50-yard radius, optional dependency, original quest marker and P0223 waypoint. Runtime proof remains necessary; if contract 4 is not loaded, services must fail open without breaking P0233.

## Success Criteria
- **P0234 source audit PASS:** identify independent native POI/quest/vignette feeds, existing native-before-historical glyph priority, and exact upstream v1.0.6 `NpcDB.npcFlags`, `Enum.npcFlags`, `RequireContract(4)` support. No new service rendering is claimed.
- **P0235 runtime OPEN:** gate provider flags and use the same finite zone index/canonical projection; report separate service counts and real visible glyph state, without reducing prior quest-giver markers and bearings. Capture missing-provider/v4-disabled state without crash or secret access.
- **Preserve P0233 proof:** unassisted startup and one physical quest-giver route PASS in the tested map; map transitions/eligibility/broader coverage remain OPEN. No speculative radius adjustment.

## Do Not Reopen Without New Evidence
Do not infer addon installation from one guessed filesystem path or the presence/absence of a Lua global alone. No hard QuestieDB dependency, package bundling, unknown CurseForge project ID, global quest ID scans on updates, guessed quest availability, invented coordinates or native pin scraping. Do not hide the Blizzard minimap, alter user-accepted waypoint/focused-quest bearings, or treat missing locations as PASS. Baked flavor must not be guessed from a Source-only indicator. Keep negative and deferred evidence explicit.

## Relevant References
- `docs/memory/evidence/P0234_NEARBY_POI_SOURCE_AND_PRIORITY_AUDIT.md`
- `docs/memory/evidence/P0231_DYNAMIC_MAP_BRIDGE_FAILURE.md`
- `docs/memory/evidence/P0230_DYNAMIC_NEARBY_QUEST_CANDIDATES.md`
- `docs/memory/evidence/P0229_QUESTIEDB_DIAGNOSTIC_HANDOFF_FAILURE.md`
- `docs/memory/decisions/D-043_NAVIGATION_SOURCE_AND_MINIMAP_FALLBACK_POLICY.md`
- `docs/DEPENDENCIES.md`
