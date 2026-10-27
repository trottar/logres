---
memory_schema: 1
as_of: 2026-10-27
project: logres
---

# Current State

## Active Objective
Prepare an evidence-gated public-alpha-quality WoW Forever Logres, followed by D-048 five-independent-domain 1.0. Preserve D-046 same-renderer preview-first, native Blizzard fallback, and frozen D-047 Camera/DynamicCam. November 4 is a contingent runtime opportunity, not a client PASS or release date.

## Current Work Item

**P0363 — Quest-offer stock suppression diagnostic ownership; WoW UNVERIFIED.** Verified pushed P0362 main `ea4077d00c71e1b6720a3e9b7286ec108fcb9ad7` 233/233 STATIC. Extract the read-only questofferstocksuppressioncheck report to preloaded Quest/OfferStockSuppression; Commands routes kept. Candidate `0.0.252-dev`, #234, Lua94/actions120/previews38, schema3/D-048/camera unchanged. P0321 FIRST client gate; L-022/L-027/L-028 OPEN; L-019 BLOCKED.

## Verified State

- Verified pushed P0362 `ea4077d00c71e1b6720a3e9b7286ec108fcb9ad7` 233/233 PRE/POST STATIC; P0361 R1 232/232, P0360 231/231, P0359 230/230, P0358 R1 229/229, P0357 228/228 and P0356 227/227. WoW UNVERIFIED; prior refusals retained.
- P0352 main `61f0f49c2cf990168c1415dd2100a0f286627a91` 223/223 STATIC, `0.0.241-dev`; WoW UNVERIFIED.
- Verified pushed P0351 `e8b71bc59a04f3077925bb24f0d6850a71340841`: 222/222 PRE/POST STATIC, `0.0.240-dev`; WoW UNVERIFIED.
- Verified pushed P0350 `fd2d2676ffb41d509143b398b61b8474ecacf53d`: 221/221 PRE/POST STATIC, `0.0.239-dev`; WoW UNVERIFIED.
- Verified pushed P0349 R1 `4e59c8f2f03daf30b630fb15e3e14d5f38cc8da6`: 220/220 PRE/POST STATIC, `0.0.238-dev`; R0 2/220 PREWRITE refusal remains recorded, WoW UNVERIFIED.
- Verified pushed P0348 `4b7481d731d5f90e214b285bc7cce16ec826176f` with manifest 219/219 PREWRITE/POSTWRITE STATIC, version unchanged `0.0.237-dev`; D-048 surface ownership model remains OFFLINE ONLY.
- Verified pushed P0347 R1 `b94beb4706005757497002927d80845d5355037f` with manifest 218/218 PREWRITE/POSTWRITE STATIC; version `0.0.237-dev`, WoW UNVERIFIED. R0 historical P0346 ceiling refusal remains recorded.
- P0347 R0 PREWRITE shadow REFUSED 1/218: P0346 historic exact 217-checker assertion rejected the new #218; no tracked writes. R1 migrates that assertion to a 217-checker floor, retains inventory checks and requires 218/218 static contracts.
- Verified pushed P0346 `26370095bd092d076868cd3d2e5e6a74f6b845d3` with 217/217 PREWRITE and POSTWRITE STATIC PASS; source audit confirmed 94 Lua/120 actions/38 previews. WoW UNVERIFIED.
- P0345 main `626b22038d09e738bd3fa90684e3a95e36905d45`: 216/216 STATIC, target debuff client UNVERIFIED.
- P0344 main `e44f66ba0838045ad6d44f1afe3e4afdb4a473ec`: 215/215 STATIC, native popup owner L-027 UNVERIFIED.
- P0343 R1 `ef4d96040fa15c0fc1a49766b1e0efcec6fe1cb1` 214/214 STATIC; R0 REFUSED before writes, L-022 OPEN.
- P0342 R2 `be3be5e80cf65cf1bf6d261b84b573f1f1effca2` 213/213 STATIC; R0/R1 PREWRITE REFUSED; L-028 OPEN.
- P0341 R1 `fb3b2658985e7f6d05f7730a3de6eb7b7dca6ad9` 212/212 STATIC; R0 historical-version checker REFUSED before writes; WoW UNVERIFIED.
- P0340 `27fb9eb` 211/211 static PASS; P0339 `8a5d3f86` 210/210 static PASS. Source-only internal packaging and November 4 matrix do not establish in-client behavior.
- P0338 R1 `342cab97` 209/209; P0337 R1 `cfdc07af` 208/208. Historical PREWRITE failures, narrow remedies and deferred L-031 focused-yard/quest-giver validation remain in their evidence files.
- P0336 `d535906` 207/207; P0335 `ffdbbca` 206/206; P0334 R3 `1b7b1ff` 205/205; P0333 `68c0955` 204/204; P0332 `cbc2015` 203/203; P0331 `dce2355` 202/202; P0330 `1f48bbe` 201/201; P0329 `126d165` 200/200. All counts are pushed static manifests, not client PASS. P0332 targets only ordinary aura fallback; the native AuraContainer remains a separate owner.
- P0328 internal alpha packaging/runbook only; P0317, P0318, P0319, P0320 are historical native gossip observations; P0321 `9a180c8` native GossipFrame parking is runtime UNVERIFIED and first November 4 safety gate. P0322, P0323, P0324, P0325 are inert D-048 five-domain planning/model checks; P0326 and P0327 assess native merchant/flight source and models only. Stock UI/Quest 237 preserved.
- D-048 independent live domain selectors and saved migration do not exist: schema 3 still stores `immersionEnabled` and `activeQuestEnabled`. D-046 preview-first and D-047 frozen Camera/DynamicCam remain required. Native UI and protected/secret fallbacks remain accessible.
- L-020–L-032 are tracked user reports; source fixes are not client-accepted. L-028 duplicated/missing target debuffs remains OPEN; L-022 focused quest artifact requires screenshot, L-027 Blizzard transient popup requires `/fstack` owner evidence. L-019 root project license remains unresolved, public distribution NOT APPROVED.

## Next Action

P0363: require 234/234 PREWRITE/POSTWRITE STATIC and `git diff --check`; user verifies push. No WoW deployment. P0321 FIRST contingent client gate.

## Success Criteria

Quest-offer PASS/FAIL and stock-ownership report, native restore/opaque-token guards and Run All/slash/panel unchanged; Lua94, actions120/previews38, schema3. WoW UNVERIFIED.

## Do Not Reopen Without New Evidence
Do not change P0321 gossip parking, frozen camera, protected action routing, pet secure state, native UI suppression, fifth-domain live preferences, user save migration, quest 237 or unverified merchant/flight ownership in P0329. No periodic hooks, secret-value introspection or blanket visual frame suppression. Preserve D-046 preview-first, D-048 five systems, optional QuestieDB, no exact player HP, sparse target, Blizzard aura/group fallback, and all existing release blockers and negative evidence.

## Relevant References
- `docs/memory/evidence/P0363_QUEST_OFFER_DIAGNOSTIC_SEAM.md` and `docs/memory/patches/P0363_QUEST_OFFER_DIAGNOSTIC_SEAM.md`
- `docs/memory/evidence/P0362_STOCK_DIAGNOSTIC_SEAM.md` and `docs/memory/patches/P0362_STOCK_DIAGNOSTIC_SEAM.md`
- `docs/memory/evidence/P0361_IMMERSION_DIAGNOSTIC_SEAM.md` and `docs/memory/patches/P0361_IMMERSION_DIAGNOSTIC_SEAM.md`
- `docs/memory/evidence/P0360_TARGET_FRAME_DIAGNOSTIC_SEAM.md` and `docs/memory/patches/P0360_TARGET_FRAME_DIAGNOSTIC_SEAM.md`
- `docs/memory/evidence/P0356_XP_DIAGNOSTIC_SEAM.md` and `docs/memory/patches/P0356_XP_DIAGNOSTIC_SEAM.md`
- `docs/memory/evidence/P0355_PRIMARY_OWNERSHIP_SEAM.md` and `docs/memory/patches/P0355_PRIMARY_OWNERSHIP_SEAM.md`
- `docs/memory/evidence/P0354_HUD_DIAGNOSTIC_SEAM.md` and `docs/memory/patches/P0354_HUD_DIAGNOSTIC_SEAM.md`
- `docs/memory/evidence/P0353_LAYOUT_SEAM.md` and `docs/memory/patches/P0353_LAYOUT_SEAM.md`
- `docs/memory/evidence/P0352_LIFECYCLE_SEAM.md` and `docs/memory/patches/P0352_LIFECYCLE_SEAM.md`
- `docs/memory/evidence/P0351_PREFERENCE_SEAM.md` and `docs/memory/patches/P0351_PREFERENCE_SEAM.md`
- `docs/memory/evidence/P0350_STATE_SENSOR_SEAM.md` and `docs/memory/patches/P0350_STATE_SENSOR_SEAM.md`
- `docs/memory/evidence/P0349_NATIVE_AUDIT_SEAM.md` and `docs/memory/patches/P0349_NATIVE_AUDIT_SEAM.md`
- `docs/memory/architecture/P0348_SURFACE_OWNERSHIP_MATRIX.md`, `docs/memory/evidence/P0348_SURFACE_HANDOFF.md` and `docs/memory/patches/P0348_SURFACE_HANDOFF.md`
- `docs/memory/evidence/P0347_SUBSCRIPTION_LIFECYCLE.md` and `docs/memory/patches/P0347_SUBSCRIPTION_LIFECYCLE.md`
- `docs/memory/architecture/P0346_ARCHITECTURE_GAP_REGISTER.md`, `docs/memory/evidence/P0346_ARCHITECTURE_HEALTH_AUDIT.md` and `docs/memory/patches/P0346_ARCHITECTURE_HEALTH_AUDIT.md`
- `docs/memory/evidence/P0345_AURA_ACTIVATION_PROVENANCE.md` and `docs/memory/patches/P0345_AURA_ACTIVATION_PROVENANCE.md`
- `docs/memory/evidence/P0344_FOREVER_POPUP_FAMILIES.md` and `docs/memory/patches/P0344_FOREVER_POPUP_FAMILIES.md` — first-party Forever popup mechanisms and unresolved client owner.
- `docs/memory/evidence/P0343_ACTIVE_QUEST_UNKNOWN_PREVIEW.md` and `docs/memory/patches/P0343_ACTIVE_QUEST_UNKNOWN_PREVIEW.md`
- `docs/memory/evidence/P0342_TARGET_AURA_ROUTE.md` and `docs/memory/patches/P0342_TARGET_AURA_ROUTE.md`
- `docs/memory/evidence/P0341_FOCUSED_MARKER_DIAGNOSTICS.md` and `docs/memory/patches/P0341_FOCUSED_MARKER_DIAGNOSTICS.md`
- `docs/memory/evidence/P0340_ALPHA_PREFREEZE_AUDIT.md`, `docs/memory/patches/P0340_ALPHA_PREFREEZE_AUDIT.md`, `tools/alpha_prefreeze_audit.py`, `docs/memory/roadmap/LAUNCH_READINESS.md`
- `docs/memory/roadmap/NOV04_GAMEPLAY_REGRESSION_MATRIX.md` and `docs/memory/evidence/P0339_GAMEPLAY_RUNTIME_MATRIX.md`
- `docs/memory/evidence/P0338_FOCUSED_COMPASS_YARDS.md` and `docs/memory/patches/P0338_FOCUSED_COMPASS_YARDS.md`
- `docs/memory/evidence/P0337_QUEST_GIVER_ELIGIBILITY.md` and `docs/memory/patches/P0337_QUEST_GIVER_ELIGIBILITY.md`
- `docs/memory/evidence/P0336_COMPASS_SINGLE_BASELINE.md` and `docs/memory/patches/P0336_COMPASS_SINGLE_BASELINE.md`
- `docs/memory/evidence/P0335_NATIVE_POPUP_PROVENANCE.md` and `docs/memory/patches/P0335_NATIVE_POPUP_PROVENANCE.md`
- `docs/memory/evidence/P0334_PVP_BADGES.md` and `docs/memory/patches/P0334_PVP_BADGES.md`
- `docs/memory/investigations/ISSUE_REGISTER.md` (L-020–L-032); `docs/memory/evidence/P0329_GAMEPLAY_SNAPSHOT.md`; `docs/memory/patches/P0329_GAMEPLAY_SNAPSHOT.md`
- `docs/memory/roadmap/NOV04_VALIDATION_RUNBOOK.md`; `docs/memory/roadmap/LAUNCH_READINESS.md`
- `docs/memory/architecture/P0328_ALPHA_STAGE_READINESS.md`; `docs/memory/evidence/P0321_GOSSIP_SINGLE_WINDOW.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`; `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`; `docs/memory/decisions/D-048_FIVE_INDEPENDENT_SYSTEMS.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`; `docs/memory/investigations/ACTIVE.md`; `docs/memory/roadmap/STATUS.md`; `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`; `docs/ROADMAP.md`
