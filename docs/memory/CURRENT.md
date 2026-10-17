---
memory_schema: 1
as_of: 2026-10-17
project: logres
---

# Current State

## Active Objective
Phase H — source-safe integration of remaining NPC quest interaction, preserving accepted UI baselines. P0236 compass/POIs and P0238 two-setting access are runtime-accepted in their tested scope. Native minimap remains hidden during ordinary immersion with deliberate access. D-035 eventual quest ownership requires separate runtime gates for progress, completion/reward, and quest-related gossip.

## Current Work Item
**P0240 — quest lifecycle source/capability delta audit (DOCS ONLY).** Verified pushed P0239 `22ba7ab`. Read current `Quest/InteractionProbe.lua`, `Dialogue.lua`, `OfferActionProbe.lua`, offer stock suppression, D-031/D-035, and historical P0128/P0129/P0131 evidence. The read-only probe already owns `QUEST_PROGRESS`/`QUEST_COMPLETE` capture, but those events were not naturally observed; current UI renders only quest offers and mutation is intentionally limited to Accept/Decline. Next narrow slice P0241 is optional additive progress reading/presentation, gated on ordinary current quest source and with Blizzard Continue accessible; no new action, reward claim or gossip mutation. See `docs/memory/evidence/P0240_QUEST_LIFECYCLE_CAPABILITY_AUDIT.md`.

## Verified State
- **P0240 SOURCE AUDIT:** P0239 `22ba7ab` verified. Existing event-owned read probe covers progress/complete but no naturally observed runtime state; Continue, final reward claim and quest gossip mutation remain gated. Details in P0240 evidence.
- **P0238 Settings UI RUNTIME ACCEPTED (2026-10-17):** pushed `0eb1976`; uploaded `0.0.140-dev` load 312 reports `/logres settings`, `preferencecheck` PASS (revision=8 callbacks=2), saved Immersion/Active Quest ON, and user-observed no UI issues. Per-button transitions and full error log not captured. See P0239 evidence.
- **P0237 R1 pushed and verified:** GitHub main `bb1f772` records the accepted P0236 POI result and the P0237 R0 prewrite manifest failure. P0238 settings access remains pending in-client validation.
- **P0236 broad POIs RUNTIME PASS (2026-10-17):** loadCount 311, nearby source ready, supportedKinds=13, nearbyKinds=5, final 4 service + 2 historical quest glyphs; 6 distance-sized glyphs with distinct scales, user visually accepted. Not all-map or current-quest proof; fine polish deferred. See P0237 evidence.
- **P0235 live result**: user saw flight masters, innkeepers and repair services with different colors; 0.0.138-dev loadCount 310 `compass nearby ready candidates=1 shown=1`, `compass services ready candidates=1 shown=1`, compasscheck PASS. Distinct categories observed by user over movement, not simultaneous count. P0236 follow-up fixes breadth/size; historical quest starts still not current offers.
- **User-identified P0235 classification gap (2026-10-17):** flight masters may be shown as possible quest givers only if they have any historical quest start, while service-only flight masters and innkeepers are missing entirely. Confirmed by inspecting `QuestieDBNearby:ScanChunk` quest-only spawn gate; this is a feature coverage FAIL in P0234, not proof service NPCs are absent. P0235 adds service-only support but remains live UNVERIFIED. Evidence `docs/memory/evidence/P0235_INDEPENDENT_SERVICE_ROLES.md`.
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
P0241: inspect the existing quest read-only event snapshots and implement the smallest **additive, fail-open** quest-progress read/presentation slice consistent with accepted paging, without assuming currently available quest-progress data. Preserve stock Continue, Complete, reward choices, and gossip. Prefer the existing developer panel H — Quest Interaction Probe for natural-state evidence, with no travel requirement or synthetic PASS; a preview is visual-only. Do not touch accepted compass/settings or reopen unified style polish here.

## Success Criteria
P0240 must record observed source boundaries, API semantics and negative/absent runtime evidence, not introduce production code. P0129 progress/complete and active-gossip event absence remain environmental deferrals; the existing probe reads a maximum four item/list rows and does not prove final reward completeness. P0241 may only show valid ordinary data in additive presentation while Blizzard retains controls. Separate player-initiated, identity-bound probes and error/taint/fail-open proof are necessary before any Continue, reward claim or gossip action, and before stock suppression. Docs-only P0240 needs `git diff --check` and memory-health PASS; no WoW redeploy.

## Do Not Reopen Without New Evidence
Do not infer addon installation from one guessed filesystem path or the presence/absence of a Lua global alone. No hard QuestieDB dependency, package bundling, unknown CurseForge project ID, global quest ID scans on updates, guessed quest availability, invented coordinates or native pin scraping. Do not hide the Blizzard minimap, alter user-accepted waypoint/focused-quest bearings, or treat missing locations as PASS. Baked flavor must not be guessed from a Source-only indicator. Keep negative and deferred evidence explicit.

## Relevant References
- `docs/memory/evidence/P0240_QUEST_LIFECYCLE_CAPABILITY_AUDIT.md`
- `docs/memory/evidence/P0128_NPC_QUEST_INTERACTION_SOURCE_AUDIT_2026-10-05.md`
- `docs/memory/evidence/P0129_NPC_QUEST_INTERACTION_RUNTIME_READ_PASS_2026-10-05.md`
- `docs/memory/evidence/P0239_SETTINGS_UI_RUNTIME_ACCEPTANCE.md`
- `docs/memory/decisions/D-035_QUEST_INTERACTION_OWNERSHIP.md`
- `docs/memory/evidence/P0238_PLAYER_SETTINGS_SCOPE.md`
- `docs/memory/evidence/P0237_P0236_RUNTIME_POI_ACCEPTANCE.md`
- `docs/memory/evidence/P0236_POI_COVERAGE_AND_PROXIMITY_TEST.md`
- `docs/memory/evidence/P0235_INDEPENDENT_SERVICE_ROLES.md`
- `docs/memory/evidence/P0234_NEARBY_POI_SOURCE_AND_PRIORITY_AUDIT.md`
- `docs/memory/evidence/P0234_NEARBY_POI_SOURCE_AND_PRIORITY_AUDIT.md`
- `docs/memory/evidence/P0231_DYNAMIC_MAP_BRIDGE_FAILURE.md`
- `docs/memory/evidence/P0230_DYNAMIC_NEARBY_QUEST_CANDIDATES.md`
- `docs/memory/evidence/P0229_QUESTIEDB_DIAGNOSTIC_HANDOFF_FAILURE.md`
- `docs/memory/decisions/D-043_NAVIGATION_SOURCE_AND_MINIMAP_FALLBACK_POLICY.md`
- `docs/DEPENDENCIES.md`
