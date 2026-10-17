---
memory_schema: 1
as_of: 2026-10-16
project: logres
---

# Current State

## Active Objective
Phase H.3: complete approved compass marker coverage without inventing world positions or suppressing the Blizzard minimap fallback. P0223's manually user-verified waypoint and focused-quest bearings remain accepted. Available quest, service POI, and tracking detections remain OPEN / SOURCE LIMITED.

## Current Work Item
**P0228 optional QuestieDB load-order and baked-flavor diagnostic correction candidate**, based on independently inspected `Questie` and `PlateSmith` consumer code and QuestieDB official v1.0.6 source. GitHub main P0227 `7c6850b` verified. The user reports that QuestieDB is visible in the WoW AddOns list; earlier assistant inference from one WSL path that it is missing was unjustified. Latest uploaded file's P0226 probe is at loadCount 300 while session reaches 302; no post-install new QuestieDB probe was recorded. P0226 incorrectly gates library compatibility behind map/gossip and incorrectly expects Source-only ModeIndicator.expansion in a packaged Baked release.

## Verified State

- P0229 process correction: user reported QuestieDB visible in WoW; prior `not-installed` claim inferred absence from one path and old loadCount 300 diagnostics despite loadCount 302. The first P0228 applier failed pre-write `CURRENT.md` EOF hygiene, then R1 repaired the generator. The existing developer panel already offers **E — Compass and Navigation → QuestieDB Location Probe** (fifth action); open with `/logres panel`. The assistant omitted these steps and repeatedly requested unchanged diagnostics. This is documented assistant failure, not proof that QuestieDB is absent or that any new glyphs should appear. P0228 runtime remains UNVERIFIED. Evidence: `docs/memory/evidence/P0229_QUESTIEDB_DIAGNOSTIC_HANDOFF_FAILURE.md`.
- GitHub main P0227 `7c6850b` verified. Existing waypoint and focused accepted quest direction are P0223 user-accepted. Additional native POI feeds remain empty in tested Loch Modan environment; additional POI glyphs remain OPEN.
- P0226 0.0.134-dev last recorded `provider=not-installed` meant unavailable `_G.LibQuestieDB` in that run; it does **not** prove absent installation or failure of newer load count 302. Prior lack of proper state separation is an integration defect.
- `Questie/QuestieDB` v1.0.6 Source `ModeIndicator.GetStatus().expansion` is nil for Baked; generated baked TOC declares `X-Flavor: Forever`; Questie checks `RequireContract`, PlateSmith optional companion uses `OptionalDeps: QuestieDB`. Those are source findings, not yet new WoW runtime proof.
- QuestieDB remains optional for Logres as a whole; third-party data may miss hidden, patch-specific and phased quests. Redistribution/license unresolved; do not bundle it or claim CurseForge-managed dependency.

## Next Action
Apply guarded P0228 on verified P0227 baseline, deploy Logres, `/reload`, run `/logres questiedbprobe` once and inspect `registered/loaded/tocFlavor/tocMode/provider/contract/mode/flavor` independently of gossip and map. Record the result and any Lua errors. `contract-compatible` with `mode=baked` and `flavor=Forever` establishes provider compatibility only, not quest-position agreement. A natural gossip offer on audited map 1432→38 can then supply separate positive/negative source evidence, if available. Do not travel solely to manufacture a test or integrate DB markers before accepted coordinates.

## Success Criteria
- Full pre-write static checker suite, diff hygiene and baseline guards pass, and runtime has no new Lua/taint/secret errors.
- An installed, initialized packaged QuestieDB has independent addon registration/load/library/contract/flavor diagnostics; Baked metadata is used for Forever flavor, not Source-only expansion.
- Map/gossip absence results in location DEFERRED without hiding provider compatibility, no unverified POI PASS, and native Blizzard positions and minimap remain intact.

## Do Not Reopen Without New Evidence
Do not infer addon installation from one guessed filesystem path or the presence/absence of a Lua global alone. No hard QuestieDB dependency, package bundling, unknown CurseForge project ID, global quest ID scans on updates, guessed quest availability, invented coordinates or native pin scraping. Do not hide the Blizzard minimap, alter user-accepted waypoint/focused-quest bearings, or treat missing locations as PASS. Baked flavor must not be guessed from a Source-only indicator. Keep negative and deferred evidence explicit.

## Relevant References
- `docs/memory/evidence/P0228_QUESTIEDB_LOAD_FLAVOR_REPAIR.md`
- `docs/DEPENDENCIES.md`
- `docs/memory/evidence/P0227_QUESTIEDB_DEPENDENCY_DISTRIBUTION_CHECKPOINT.md`
- `docs/memory/evidence/P0226_QUESTIEDB_SOURCE_ACCEPTANCE_GATE.md`
- `docs/memory/decisions/D-043_NAVIGATION_SOURCE_AND_MINIMAP_FALLBACK_POLICY.md`
