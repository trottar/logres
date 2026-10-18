---
memory_schema: 1
as_of: 2026-10-17
project: logres
---

# Current State

## Active Objective
Phase H — recover quest reward identity when the native reward API intermittently lacks an ordinary name, without fabricating items or claiming Blizzard's final quest action.
## Current Work Item
**P0245 — bounded quest-item name cache fallback (RUNTIME UNVERIFIED).** Verified pushed P0244 `1ce1de1`, visual money PASS for quest 237 (7s, 1050 XP), but item name absent from Logres although native reward is Lesser Healing Potion x3. Probe reveals itemID=858 / quantity 3 with name empty and link nil; similar prior captures show intermittent availability. Try one guarded `GetItemInfo(itemID)` read only if the ordinary name is absent, keep stock-review fallback, all Blizzard quest controls, and existing cash/XP display. Evidence `docs/memory/evidence/P0245_QUEST_REWARD_ITEM_NAME_CACHE.md`.
## Verified State
- **P0244 SCOPED MONEY RUNTIME PASS; ITEM OPEN / INTERMITTENT:** main `1ce1de1`; user screenshot shows 7s, 1050 XP, native Complete Quest, but Logres item-review fallback while stock shows Lesser Healing Potion x3. Load318 probe captures itemID858/count3 with empty name/link and zero mutations; P0245 one-shot cache candidate remains UNVERIFIED.
- **P0243 RUNTIME VISUAL ACCEPTED (SCOPED):** pushed `e8455bc`, screenshot confirms quest 237 Logres prose, item x3, XP 1050 and usable Blizzard Complete Quest. Missing **7 silver** in Logres; P0244 adds money candidate. Latest 0.0.143-dev load316 checkall PASS; completion dialogue counters sampled before event.
- **P0243 CANDIDATE:** P0242 pushed `18b0fa0`, load 315 registered; user reports quest panel without Complete/rewards; natural quest 237 probe has ordinary guaranteed item and XP, but no post-event QuestDialogue check. Reward readout candidate only; R0 prewrite checker FAIL (empty footer expected), R1 corrected checker and full-suite prewrite gate; runtime UNVERIFIED.
- **P0242 CANDIDATE:** P0241 pushed `ee1cbd3`; load 313 questdialoguecheck PASS, natural QUEST_COMPLETE quest 237 observed but reward name/link incomplete; progress events zero. Additive completion text only; runtime appearance UNVERIFIED.
- **P0241 CANDIDATE:** Verified pushed P0240 `048cd77`; additive event-driven quest progress read/paging only; runtime UNVERIFIED until natural state; Blizzard Continue/claim/gossip stock. P0241 evidence.
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
Apply P0245, deploy and `/reload`; `/logres panel` → **F — Quest Experience → Quest Dialogue Check**, then **Phase 0 → Run All**. On a natural QUEST_COMPLETE, verify item name/quantity if available, XP and cash, and usable native Complete Quest. Record cache source reason `guaranteed-item-cache` only if actually observed. If metadata is still unavailable, fallback stays usable and the cache attempt is a negative result, not PASS. No travel solely to manufacture the quest. After this gate, audit user-clicked Complete/Claim separately; no new reward choice or gossip ownership.
## Success Criteria
Complete static suite PASS and no demonstrated regression to money, XP, narrative paging, or Blizzard Complete Quest. A naturally observed ordinary single-reward completion may use a nonsecret `GetItemInfo` name for a nonsecret bounded quest itemID, otherwise retains explicit stock-review fallback. No polling, mutation, secret-value inspection, unproven native suppression, or automatic quest completion. Cache fallback visual status is DEFERRED until observed.
## Do Not Reopen Without New Evidence
Do not infer addon installation from one guessed filesystem path or the presence/absence of a Lua global alone. No hard QuestieDB dependency, package bundling, unknown CurseForge project ID, global quest ID scans on updates, guessed quest availability, invented coordinates or native pin scraping. Do not hide the Blizzard minimap, alter user-accepted waypoint/focused-quest bearings, or treat missing locations as PASS. Baked flavor must not be guessed from a Source-only indicator. Keep negative and deferred evidence explicit.

## Relevant References
- `docs/memory/evidence/P0245_QUEST_REWARD_ITEM_NAME_CACHE.md`
- `docs/memory/evidence/P0244_QUEST_MONEY_AND_COMPLETION_VISUAL_ACCEPTANCE.md`
- `docs/memory/evidence/P0243_QUEST_REWARD_VISIBILITY_AND_STOCK_FALLBACK.md`
- `docs/memory/evidence/P0242_QUEST_COMPLETION_NARRATIVE.md`
- `docs/memory/evidence/P0241_ADDITIVE_QUEST_PROGRESS.md`
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
