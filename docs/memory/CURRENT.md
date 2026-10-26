---
memory_schema: 1
as_of: 2026-10-25
project: logres
---

# Current State

## Active Objective
Prepare an evidence-gated public-alpha-quality WoW Forever Logres, followed by D-048 five-independent-domain 1.0. Preserve D-046 same-renderer preview-first, native Blizzard fallback, and frozen D-047 Camera/DynamicCam. November 4 is a contingent runtime opportunity, not a client PASS or release date.

## Current Work Item

**P0341 — cached generic focused compass marker diagnostics; PREPARED / WoW UNVERIFIED.** Verified pushed GitHub `main` P0340 `27fb9eb69bae6b844433ed4bbf3170cae2542dc2` (2026-10-25), manifest 211/211 PREWRITE/POSTWRITE STATIC, version `0.0.232-dev`. P0338 already exposes addon-owned source-guarded generic marker kind/distance in `Compass:GetDebugStatus`, but current Phase E Compass Check and Phase 0 Gameplay Snapshot omit those fields. P0341 adds read-only cached output only, updates source-verified November 4 matrix and deliberately migrates P0339's obsolete absence assertion. New #212 checker; version in parity `0.0.233-dev`. No new map/NPC/player query, compass painting/focus/movement, native controls, secret, protected/action, camera, event/polling, save migration or public distribution. P0321 native GossipFrame restoration remains first runtime test on contingent November 4; P0330–P0338 client behavior remains UNVERIFIED, with L-022 screenshot, L-027 `/fstack` owner and L-019 license OPEN.

## Verified State
- Verified GitHub `main` P0340 `27fb9eb69bae6b844433ed4bbf3170cae2542dc2` pushed on 2026-10-25. `P0340_MANIFEST.txt` reports 211/211 PREWRITE and POSTWRITE static checks. Read-only source staging is prepared, no client install/security PASS or distribution approval. The baseline version is `0.0.232-dev`.
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

Apply guarded P0341 to exact clean P0340 `27fb9eb`, run **212/212** PREWRITE shadow and POSTWRITE checkers, candidate diff hygiene, record manifest, and verify user-pushed GitHub `main`. No gameplay feature should be declared complete until November 4 client testing. On contingent client access, first validate P0321 native GossipFrame parking and restoration; then compare P0341 Phase E Compass Check and Phase 0 Gameplay Snapshot cached focus outputs to the actual P0338 world marker and changed yard value. Run the remaining P0330–P0338 natural-context regression matrix; L-022 screenshot and L-027 native popup `/fstack` identity remain unproven. L-019 public release licensing still BLOCKS distribution.

## Success Criteria

Phase E Compass Check and Phase 0 Gameplay Snapshot each print one additive, bounded read-only `kind`, `distanceAvailable`, and `distanceYards` line using existing cached Compass debug state. Existing focused quest output, gameplay capture export, 94 Lua load inventory, P0321 controls and source-guarded compass painting are preserved. Empty focus prints `none`/`false`/`unavailable`. No new native or secret observation. Offline 212-checker PASS proves source contract only, not in-game distance correctness, rendering or human release acceptance.

## Do Not Reopen Without New Evidence
Do not change P0321 gossip parking, frozen camera, protected action routing, pet secure state, native UI suppression, fifth-domain live preferences, user save migration, quest 237 or unverified merchant/flight ownership in P0329. No periodic hooks, secret-value introspection or blanket visual frame suppression. Preserve D-046 preview-first, D-048 five systems, optional QuestieDB, no exact player HP, sparse target, Blizzard aura/group fallback, and all existing release blockers and negative evidence.

## Relevant References
- `docs/memory/evidence/P0341_FOCUSED_MARKER_DIAGNOSTICS.md` and `docs/memory/patches/P0341_FOCUSED_MARKER_DIAGNOSTICS.md` — source gap, additive cached read-only output, historical checker migration and client deferral.
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
