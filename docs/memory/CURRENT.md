---
memory_schema: 1
as_of: 2026-10-16
project: logres
---

# Current State

## Active Objective
Phase H.3: complete approved compass marker coverage without inventing world positions or suppressing the Blizzard minimap fallback. P0223's manually user-verified waypoint and focused-quest bearings remain accepted. Available quest, service POI, and tracking detections remain OPEN / SOURCE LIMITED.

## Current Work Item
**P0230 automatic current-zone QuestieDB nearby candidate producer**. GitHub main P0229 `d010f64` verified; P0228 R1 runtime is locally tested at Logres 0.0.135-dev loadCount 304, but not yet committed. Two panel probes confirmed QuestieDB 1.0.6 Forever baked loaded and contract-compatible. User rejected an assistant-proposed Loch Modan-only implementation; the scope is dynamic map selection wherever official provider mapping can be resolved. Native positions lead; cached QuestieDB NPC locations are *possible quest givers*, not confirmed offers. Real individual tracking blip coordinates still have no supported public Blizzard source.

## Verified State
- **P0228 runtime provider PASS, newly observed**: uploaded 0.0.135-dev diagnostics loadCount 304 show QuestieDB registered=yes loaded=yes tocVersion=1.0.6 tocFlavor=Forever tocMode=baked contract=1 mode=baked provider=contract-compatible in two panel runs. Quest location/gossip remains DEFERRED; no compass glyph results were part of P0228.
- **P0230 scope corrections**: discarded hardcoded Loch Modan-only suggestion; use dynamic current-zone mapping and 50-yard candidate radius. The user reports the Blizzard minimap is HIDDEN during normal immersion: it must NOT be used as the visible fallback to justify missing compass features. Database-only spawns never establish quest availability.

- P0229 process correction: user reported QuestieDB visible in WoW; prior `not-installed` claim inferred absence from one path and old loadCount 300 diagnostics despite loadCount 302. The first P0228 applier failed pre-write `CURRENT.md` EOF hygiene, then R1 repaired the generator. The existing developer panel already offers **E — Compass and Navigation → QuestieDB Location Probe** (fifth action); open with `/logres panel`. The assistant omitted these steps and repeatedly requested unchanged diagnostics. This is documented assistant failure, not proof that QuestieDB is absent or that any new glyphs should appear. P0228 runtime remains UNVERIFIED. Evidence: `docs/memory/evidence/P0229_QUESTIEDB_DIAGNOSTIC_HANDOFF_FAILURE.md`.
- GitHub main P0227 `7c6850b` verified. Existing waypoint and focused accepted quest direction are P0223 user-accepted. Additional native POI feeds remain empty in tested Loch Modan environment; additional POI glyphs remain OPEN.
- P0226 0.0.134-dev last recorded `provider=not-installed` meant unavailable `_G.LibQuestieDB` in that run; it does **not** prove absent installation or failure of newer load count 302. Prior lack of proper state separation is an integration defect.
- `Questie/QuestieDB` v1.0.6 Source `ModeIndicator.GetStatus().expansion` is nil for Baked; generated baked TOC declares `X-Flavor: Forever`; Questie checks `RequireContract`, PlateSmith optional companion uses `OptionalDeps: QuestieDB`. Those are source findings, not yet new WoW runtime proof.
- QuestieDB remains optional for Logres as a whole; third-party data may miss hidden, patch-specific and phased quests. Redistribution/license unresolved; do not bundle it or claim CurseForge-managed dependency.

## Next Action
Apply guarded P0230 on local P0228 R1 + pushed P0229 baseline, deploy, `/reload`, `/logres panel` → **E — Compass and Navigation** → **QuestieDB Location Probe**, then **Compass Check**. Evaluate zone mapping, finite index completion, nearby candidate count, any visible muted candidate bearing, and Lua/taint/secret errors. Do not demand a specific zone or questgiver interaction. If unsupported maps or empty surroundings prevent a glyph, record DEFERRED rather than PASS. Commit/push user-owned P0228 plus P0230 only after actual evidence; verify main.

## Success Criteria
- Dynamic area selection comes from QuestieDB's canonical Forever map mapping, without a Loch Modan literal or guessed client MapID conversion; unsupported maps fail open.
- The one-shot zone index completes without Lua/taint/secret errors; 50-yard DB candidates never depend on `C_Minimap.GetViewRadius()` (minimap normally hidden), and possible quest givers are visually muted behind native source points.
- Preserve P0223 waypoint/focused accepted quest. The minimap is HIDDEN in Logres immersion mode and MUST NOT be treated as a visible fallback; this patch does not change native-dock control. Do not advertise complete eligibility or live resource/service blip mirroring.
- Static prewrite checks run against exact generated candidate; WoW runtime PASS limited to observations actually made.

## Do Not Reopen Without New Evidence
Do not infer addon installation from one guessed filesystem path or the presence/absence of a Lua global alone. No hard QuestieDB dependency, package bundling, unknown CurseForge project ID, global quest ID scans on updates, guessed quest availability, invented coordinates or native pin scraping. Do not hide the Blizzard minimap, alter user-accepted waypoint/focused-quest bearings, or treat missing locations as PASS. Baked flavor must not be guessed from a Source-only indicator. Keep negative and deferred evidence explicit.

## Relevant References
- `docs/memory/evidence/P0230_DYNAMIC_NEARBY_QUEST_CANDIDATES.md`
- `docs/memory/evidence/P0229_QUESTIEDB_DIAGNOSTIC_HANDOFF_FAILURE.md`
- `docs/memory/evidence/P0228_QUESTIEDB_LOAD_FLAVOR_REPAIR.md`
- `docs/memory/decisions/D-043_NAVIGATION_SOURCE_AND_MINIMAP_FALLBACK_POLICY.md`
- `docs/DEPENDENCIES.md`
