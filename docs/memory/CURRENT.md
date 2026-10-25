---
memory_schema: 1
as_of: 2026-10-24
project: logres
---

# Current State

## Active Objective
Prepare an evidence-gated public-alpha-quality WoW Forever Logres, followed by D-048 five-independent-domain 1.0. Preserve D-046 same-renderer preview-first, native Blizzard fallback, and frozen D-047 Camera/DynamicCam. November 4 is a contingent runtime opportunity, not a client PASS or release date.

## Current Work Item
**P0337 — L-030 only native-corroborated possible quest givers; PREPARED / WoW UNVERIFIED.** Verified pushed GitHub `main` P0336 `d535906efe86d9502b595f884efd3118cc7da724` (2026-10-25), 207/207 PRE/POST static manifest; one-baseline compass visuals still client UNVERIFIED. Audit of `QuestieDBNearby` confirmed it provides NPCs with historical `questStarts`, not the current live quest-eligibility state. Compass previously displayed these as nearby possible quest givers regardless of prerequisites/completion. P0337 allows an optional provider quest-giver glyph only when its quest ID matches an ordinary native current-map quest-start candidate from existing `NavigationSourceProbe` rows (role `poi` or `eligible==true`); counts excluded historical rows. Native positioned sources take precedence, while native-confirmed offers without usable native coordinates can use provider fallback position. No new source API, native UI manipulation, provider indexing change, service removal, polling, camera, or settings mutation. Static contract count 208. WoW closed until November 4.

## Verified State
- P0337 R0 PREWRITE REFUSED 1/208 at checker 174: stale checker expected `if add(...) then`, while the guarded expression correctly uses `if not seenQuest[...] and add(...) then`. R1 repairs the assertion only; no tracked writes occurred on R0.
- Verified GitHub main P0336 `d535906` (2026-10-25) pushed; 207/207 PREWRITE/POSTWRITE manifest. L-032 visual/runtime UNVERIFIED.
- Verified GitHub main P0335 `ffdbbca` (2026-10-25) pushed, manifest 206/206 PREWRITE/POSTWRITE; L-027 popup owner remains unidentified and WoW UNVERIFIED.
- Verified GitHub main P0334 R3 push `1b7b1ff` (2026-10-25), 205/205 PRE/POST static manifest; R0/R1/R2 historic contract failures retained. L-023 PvP in-client visual/source remains UNVERIFIED.
- Verified GitHub `main` P0333 push `68c0955` (2026-10-25), manifest records 204/204 PREWRITE and POSTWRITE static checks. Pet keybind/active outline runtime remains UNVERIFIED.
- Verified GitHub main P0332 `cbc2015` pushed (2026-10-24); full static execution recorded in P0332 manifest, source fallback corrected; native aura client behavior UNVERIFIED.
- Verified P0331 push `dce2355` (2026-10-24), 202-checker manifest; L-025/L-029 layering remains WoW UNVERIFIED.
- P0330 `1f48bbe` verified pushed, 201/201 checker manifest; death/ghost behavior remains UNVERIFIED while client is closed.
- Verified remote `main` P0329 `126d165` (2026-10-24) includes 200/200 checker manifest; gameplay snapshot and L-020–L-032 intake are committed, but WoW runtime is DEFERRED until November 4.
- P0328 internal-only alpha staging and November 4 runbook are pushed, **not validated in WoW**, and no public release is approved. P0328's CURRENT text was stale about the P0328 push; P0329 reconciles that fact.
- Source-history compatibility: P0317, P0318, P0319, P0320 (native-backed gossip), P0322, P0323, P0324, P0325 (five-domain models), and P0326, P0327 (native merchant/flight preparation) remain separately evidenced; no new client PASS is implied.
- P0321 GossipFrame single-window parking was pushed `9a180c8` but WoW runtime remains **UNVERIFIED / DEFERRED until November 4**. P0317–P0320 gossip/quest links have positive observations only in tested scopes; Quest 237 is reserved. Merchant/flight native services remain Blizzard-owned and flight frame identity unresolved.
- The five D-048 live selectors and saved-variable migration **do not exist**: schema 3 still stores `immersionEnabled` and `activeQuestEnabled`; Camera/DynamicCam remains frozen D-047. Existing pet, action, target and compass boundaries remain accepted unless runtime evidence proves a defect.
- L-020–L-032 are user-reported needs and regressions. P0329 offers capture only; L-021–L-032 are OPEN / not fixed. Live player HP and secret-capable aura values are never read or serialized by the new command.
- License/distribution gate L-019 remains unresolved; LibCamera notice retained, optional QuestieDB not bundled. Internal stage ZIP is not an approved release.

## Next Action
Apply P0337 to exact clean pushed P0336 `d535906` with all 208 PREWRITE shadow/POSTWRITE static checkers, manifest, strict baseline blobs and diff hygiene. User commits/pushes and GitHub `main` verified before advancing to L-031 focused-marker yard distance. On November 4 prioritize P0321 gossip restoration, then visual preview and natural source observations for L-030/L-032; no invented quest eligibility. L-022 superficial quest artifact remains screenshot-gated and L-027 Blizzard transient popup identity OPEN. No WoW deployment while client closed.

## Success Criteria
No QuestieDB historical-only quest giver appears in the active Logres compass without matching, ordinary current native quest-start evidence. The historical data and missing-native-source cases do not imply the NPC cannot offer a quest; stock map and quest information remain available. Native quest and vignette markers, optional QuestieDB service markers, collision, heading, player waypoint, focused quest and native action flows are unchanged. Only an actually placed native row deduplicates provider fallback. Exclusion counter reports source uncertainty, not a count of unavailable quests. Source/static 208 PRE/POST checkers and six deterministic fixtures do not prove client correctness or NPC requirements; L-030 remains **WoW UNVERIFIED** pending natural in-game testing.

## Do Not Reopen Without New Evidence
Do not change P0321 gossip parking, frozen camera, protected action routing, pet secure state, native UI suppression, fifth-domain live preferences, user save migration, quest 237 or unverified merchant/flight ownership in P0329. No periodic hooks, secret-value introspection or blanket visual frame suppression. Preserve D-046 preview-first, D-048 five systems, optional QuestieDB, no exact player HP, sparse target, Blizzard aura/group fallback, and all existing release blockers and negative evidence.

## Relevant References
- `docs/memory/evidence/P0337_QUEST_GIVER_ELIGIBILITY.md` and `docs/memory/patches/P0337_QUEST_GIVER_ELIGIBILITY.md` — L-030 historical source, corroboration rule, fallback and remaining limits.
- `docs/memory/evidence/P0336_COMPASS_SINGLE_BASELINE.md` and `docs/memory/patches/P0336_COMPASS_SINGLE_BASELINE.md` — source defect, deterministic declutter tradeoff, visual acceptance gate.
- `docs/memory/evidence/P0335_NATIVE_POPUP_PROVENANCE.md` and `docs/memory/patches/P0335_NATIVE_POPUP_PROVENANCE.md` — L-027 unresolved native owner/source boundaries and one-shot capture.
- `docs/memory/evidence/P0334_PVP_BADGES.md` and `docs/memory/patches/P0334_PVP_BADGES.md` — L-023 source correction, preview and runtime gates.
- `docs/memory/investigations/ISSUE_REGISTER.md` (L-020–L-032); `docs/memory/evidence/P0329_GAMEPLAY_SNAPSHOT.md`; `docs/memory/patches/P0329_GAMEPLAY_SNAPSHOT.md`
- `docs/memory/roadmap/NOV04_VALIDATION_RUNBOOK.md`; `docs/memory/roadmap/LAUNCH_READINESS.md`
- `docs/memory/architecture/P0328_ALPHA_STAGE_READINESS.md`; `docs/memory/evidence/P0321_GOSSIP_SINGLE_WINDOW.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`; `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`; `docs/memory/decisions/D-048_FIVE_INDEPENDENT_SYSTEMS.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`; `docs/memory/investigations/ACTIVE.md`; `docs/memory/roadmap/STATUS.md`; `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`; `docs/ROADMAP.md`
