---
memory_schema: 1
as_of: 2026-10-25
project: logres
---

# Current State

## Active Objective
Prepare an evidence-gated public-alpha-quality WoW Forever Logres, followed by D-048 five-independent-domain 1.0. Preserve D-046 same-renderer preview-first, native Blizzard fallback, and frozen D-047 Camera/DynamicCam. November 4 is a contingent runtime opportunity, not a client PASS or release date.

## Current Work Item

**P0340 — A0/A3 internal prefreeze source inventory and installation guidance; DOCS/TOOLS ONLY / WoW UNVERIFIED.** Verified GitHub `main` P0339 `8a5d3f86c557745de6b2e61bf7a5f0273930c129` pushed (2026-10-25), P0339 manifest 210/210 PREWRITE/POSTWRITE static checkers, addon version `0.0.232-dev` unchanged. `README.md` currently has a stale QuestieDB diagnostic-only description despite P0230–P0231 compass historical coordinates and P0337 current-native-offer gate. P0340 corrects the guidance, adds a read-only in-memory alpha staging inventory/content-byte audit and a #211 contract, and retains all distribution and real-client gates. No addon code, version, dependencies, source queries, saved preferences, protected or native UI mutation, live five-domain toggles or D-047 camera changes. L-019 public release BLOCKED; P0321 and gameplay P0330–P0338 WoW UNVERIFIED pending contingent November 4.

## Verified State
- Verified GitHub `main` P0339 `8a5d3f86c557745de6b2e61bf7a5f0273930c129` pushed on 2026-10-25; manifest records 210/210 static PREWRITE and POSTWRITE. The P0339 test matrix is prepared, not WoW-executed. Next optional offline P0340 audit cannot establish installed-client behavior or release authorization.
- Verified GitHub `main` P0338 R1 `342cab97` pushed on 2026-10-25; `P0338_MANIFEST.txt` reports 209/209 PREWRITE and POSTWRITE static checks. P0338 R0 8/209 PREWRITE errors are preserved, while all P0330–P0338 client behavior remains UNVERIFIED pending November 4.
- Verified GitHub `main` P0337 R1 `cfdc07af` pushed on 2026-10-25; its manifest reports 208/208 PREWRITE and POSTWRITE static checks; P0337 actual WoW quest-giver eligibility remains UNVERIFIED.
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

Apply guarded P0340 to clean verified P0339 `8a5d3f86`, run all **211** PREWRITE shadow and POSTWRITE static contracts, candidate diff hygiene, record manifest, and verify the user-owned GitHub push. Before the proposed November 3 freeze, run `python3 tools/alpha_prefreeze_audit.py` and `python3 tools/stage_alpha_candidate.py --check`; do not publish a ZIP. On contingent November 4 access, test P0321 native GossipFrame status/restoration first, then naturally available P0330–P0338 cases from `NOV04_GAMEPLAY_REGRESSION_MATRIX.md`. L-019 root licensing, L-022 quest screenshot and L-027 `/fstack` frame identity remain OPEN.

## Success Criteria

A read-only audit verifies the exact current TOC-loaded Lua files, allowed staged media, attribution, optional external QuestieDB exclusion, deterministic internal ZIP member bytes/CRC and installation documentation accuracy. Distinguish **source inventory PASS** from real Forever install/secure/restoration checks and explicit human licensing and release approval. No runtime Lua or TOC/version changes; no WoW redeploy. Full WSL static checker execution must precede any commit.

## Do Not Reopen Without New Evidence
Do not change P0321 gossip parking, frozen camera, protected action routing, pet secure state, native UI suppression, fifth-domain live preferences, user save migration, quest 237 or unverified merchant/flight ownership in P0329. No periodic hooks, secret-value introspection or blanket visual frame suppression. Preserve D-046 preview-first, D-048 five systems, optional QuestieDB, no exact player HP, sparse target, Blizzard aura/group fallback, and all existing release blockers and negative evidence.

## Relevant References
- `docs/memory/evidence/P0340_ALPHA_PREFREEZE_AUDIT.md`, `docs/memory/patches/P0340_ALPHA_PREFREEZE_AUDIT.md`, `tools/alpha_prefreeze_audit.py`, `docs/memory/roadmap/LAUNCH_READINESS.md` — source-only freeze candidate audit and blockers.
- `docs/memory/roadmap/NOV04_GAMEPLAY_REGRESSION_MATRIX.md` and `docs/memory/evidence/P0339_GAMEPLAY_RUNTIME_MATRIX.md` — exact P0330–P0338 developer-panel actions, per-issue acceptance/deferred criteria, and source diagnostic limitations.
- `docs/memory/evidence/P0338_FOCUSED_COMPASS_YARDS.md` and `docs/memory/patches/P0338_FOCUSED_COMPASS_YARDS.md` — L-031 source, shared focus label and November 4 gates.
- `docs/memory/evidence/P0337_QUEST_GIVER_ELIGIBILITY.md` and `docs/memory/patches/P0337_QUEST_GIVER_ELIGIBILITY.md` — L-030 historical source, corroboration rule, fallback and remaining limits.
- `docs/memory/evidence/P0336_COMPASS_SINGLE_BASELINE.md` and `docs/memory/patches/P0336_COMPASS_SINGLE_BASELINE.md` — source defect, deterministic declutter tradeoff, visual acceptance gate.
- `docs/memory/evidence/P0335_NATIVE_POPUP_PROVENANCE.md` and `docs/memory/patches/P0335_NATIVE_POPUP_PROVENANCE.md` — L-027 unresolved native owner/source boundaries and one-shot capture.
- `docs/memory/evidence/P0334_PVP_BADGES.md` and `docs/memory/patches/P0334_PVP_BADGES.md` — L-023 source correction, preview and runtime gates.
- `docs/memory/investigations/ISSUE_REGISTER.md` (L-020–L-032); `docs/memory/evidence/P0329_GAMEPLAY_SNAPSHOT.md`; `docs/memory/patches/P0329_GAMEPLAY_SNAPSHOT.md`
- `docs/memory/roadmap/NOV04_VALIDATION_RUNBOOK.md`; `docs/memory/roadmap/LAUNCH_READINESS.md`
- `docs/memory/architecture/P0328_ALPHA_STAGE_READINESS.md`; `docs/memory/evidence/P0321_GOSSIP_SINGLE_WINDOW.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`; `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`; `docs/memory/decisions/D-048_FIVE_INDEPENDENT_SYSTEMS.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`; `docs/memory/investigations/ACTIVE.md`; `docs/memory/roadmap/STATUS.md`; `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`; `docs/ROADMAP.md`
