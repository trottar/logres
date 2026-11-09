---
memory_schema: 1
as_of: 2026-11-08
project: logres
---

# Current State

## Active Objective
Alpha blocked. D-046/D-047/D-048.

## Current Work Item

**P0410** Chat staging; P0409 R1; P0408; P0407 refused; P0406 main; P0405; P0404 L-004; P0403 L-001; P0402–P0397 flight; P0396; P0395; P0394; P0393; P0392; P0391 session 46; P0390; P0389; P0388 L-027; P0387 late-accept; P0386 L-001; P0385 greeting/L-002; P0384 L-005 input map, P0383 turn-in PASS scoped, P0382 Continue scoped, L-040 EST; P0381 b672104 R0/P0241 R2/R3 REFUSED; P0380 R4; P0379 285be52 FAIL R0/R1 REFUSED. P0381 L-001/L-002/L-005/L-025/L-029/L-033/L-034/L-038/L-039; P0373/P0374/P0376/P0378; L-020 PARTIAL, L-021 PASS, L-035/L-037 OPEN.

## Verified State

- P0383 `cc783a0` 253 STATIC; client 0.0.267-dev quest18 TURNED_IN; hotspot offset and stock greeting OPEN. L-005 PARTIAL, L-001/L-002 OPEN. P0384 quest21 aligned hover in 0.0.268-dev incident 3196; P0385 observed; P0386 UNVERIFIED.

- P0379 `285be528` 249 STATIC; 0.0.264-dev no claim. L-002 native, L-005 FAIL. R0/R1 refused; P0378 screenshots inferred.

- P0370 240 STATIC; no-pet labels user PASS. P0369 P0368 P0367 P0366 R1 P0365 R1 P0364 R1 P0363 P0362 P0361 R1 P0360 P0359 P0358 R1 P0357 P0356: 239–227 STATIC, client checks pending; prior refusals in evidence. L-001/L-002/L-005 FAIL.
- P0352 223, P0351 222, P0350 221 STATIC; client UNVERIFIED.
- P0349 R1 `4e59c8f2f03daf30b630fb15e3e14d5f38cc8da6` 220/220 STATIC; R0 REFUSED, WoW UNVERIFIED.
- P0348 `4b7481d731d5f90e214b285bc7cce16ec826176f` 219/219 STATIC; D-048 model OFFLINE ONLY.
- P0347 R1 `b94beb4706005757497002927d80845d5355037f` 218/218 STATIC; R0 PREWRITE REFUSED, WoW UNVERIFIED.
- P0347 R0 REFUSED 1/218; R1 corrected, no writes on R0.
- P0346 `26370095bd092d076868cd3d2e5e6a74f6b845d3` 217/217 PRE/POST STATIC; WoW UNVERIFIED.
- P0345 `626b220` 216/216 STATIC; target aura client UNVERIFIED.
- P0344 `e44f66ba` 215/215 STATIC; L-027 owner UNVERIFIED.
- P0343 R1 `ef4d96040fa15c0fc1a49766b1e0efcec6fe1cb1` 214/214 STATIC; R0 REFUSED before writes, L-022 OPEN.
- P0342 R2 `be3be5e80cf65cf1bf6d261b84b573f1f1effca2` 213/213 STATIC; R0/R1 PREWRITE REFUSED; L-028 OPEN.
- P0341 R1 `fb3b2658985e7f6d05f7730a3de6eb7b7dca6ad9` 212/212 STATIC; R0 historical-version checker REFUSED before writes; WoW UNVERIFIED.
- P0338 R1 `342cab97` 209/209; P0337 R1 `cfdc07af` 208/208. Historical PREWRITE failures, narrow remedies and deferred L-031 focused-yard/quest-giver validation remain in their evidence files.
- P0340 prefreeze; P0336/P0335/P0334 R3/P0333/P0332/P0331/P0330/P0329: 207–200 STATIC. See PATCH_INDEX.
- P0328 alpha runbook; P0317/P0318/P0319/P0320 gossip observations; P0321 `9a180c8` parking UNVERIFIED. P0322/P0323/P0324/P0325 D-048 inert models; P0326/P0327 merchant/flight models only. Stock UI/quest 237 kept.
- D-048 independent live domain selectors and saved migration do not exist: schema 3 still stores `immersionEnabled` and `activeQuestEnabled`. D-046 preview-first and D-047 frozen Camera/DynamicCam remain required. Native UI and protected/secret fallbacks stay usable.
- L-020–L-032 are tracked user reports; runtime gates apply. L-028 duplicated/missing target debuffs remains OPEN; L-022 focused quest artifact requires screenshot, L-027 Blizzard transient popup requires `/fstack` owner evidence. L-019 license unresolved, release blocked.

## Next Action

Chat staging trial. NPC/L-002 deferred; L-027/L-033/L-041 OPEN.

## Success Criteria

P0409 R1 user PASS. P0404 layout PASS; travel and P0403 unverified.

## Do Not Reopen Without New Evidence
Preserve P0321/P0329, camera, secure actions, quest 237. No polling or secret reads.

## Relevant References
- docs/memory/evidence/P0403_QUEST_STAGE_HANDOFF.md
- docs/memory/evidence/P0408_CHAT_PREFLIGHT.md
- docs/memory/evidence/P0404_CENTERED_FLIGHT_MASTER.md
- docs/memory/evidence/P0406_CHAT_CHANGE_RUNNER.md
- docs/memory/evidence/P0410_CHAT_STAGING_AUDIT.md
- docs/memory/evidence/P0398_FLIGHT_SCALE.md
- docs/memory/evidence/P0397_FLIGHT_WINDOW.md
- docs/memory/evidence/P0396_MERCHANT_PAGE_CHEVRONS.md
- docs/memory/evidence/P0395_MERCHANT_TAB_LABELS.md
- docs/memory/evidence/P0394_MERCHANT_GOODBYE.md
- docs/memory/evidence/P0393_TRAINER_STYLE_MERCHANT.md
- docs/memory/evidence/P0392_MERCHANT_CATALOGUE.md
- docs/memory/evidence/P0391_FOREVER_SESSION_45.md
- docs/memory/evidence/P0390_FOREVER_SESSION_44.md
- docs/memory/evidence/P0389_SESSION_41_REGRESSIONS.md
- `docs/memory/PRE_HANDOFF_AUDIT.md`
- `docs/memory/evidence/P0380_INTEGRATED_GAMEPLAY_REPAIR.md`
- `docs/memory/evidence/P0379_COMPLETION_INPUT_PROVENANCE.md`
- `docs/memory/evidence/P0375_QUEST_PRESENTATION_PROVENANCE.md`
- `docs/memory/investigations/ISSUE_LEDGER.md` (first bug lookup)
- `docs/memory/evidence/P0377_LIVE_REWARD_SELECTION.md`
- `docs/memory/evidence/P0372_PASSIVE_JOURNAL_BUG_MARKER.md`
- `docs/memory/evidence/P0371_NPC_DIAGNOSTIC_BATCH.md` and `docs/memory/patches/P0371_NPC_DIAGNOSTIC_BATCH.md`
- `docs/memory/evidence/P0370_PET_HOTKEY_PRESENTATION_GATE.md` and `docs/memory/patches/P0370_PET_HOTKEY_PRESENTATION_GATE.md`
- `docs/memory/evidence/P0369_LIVE_DIAGNOSTIC_EXPORT_RECOVERY.md` and `docs/memory/patches/P0369_LIVE_DIAGNOSTIC_EXPORT_RECOVERY.md`
- `docs/memory/evidence/P0368_NOV04_FREEZE_GATE.md` and `docs/memory/patches/P0368_NOV04_FREEZE_GATE.md`
- `docs/memory/evidence/P0367_WORLD_TARGET_PROBE_DIAGNOSTIC_SEAM.md` and `docs/memory/patches/P0367_WORLD_TARGET_PROBE_DIAGNOSTIC_SEAM.md`
- `docs/memory/evidence/P0366_QUEST_INTERACTION_PROBE_DIAGNOSTIC_SEAM.md` and `docs/memory/patches/P0366_QUEST_INTERACTION_PROBE_DIAGNOSTIC_SEAM.md`
- `docs/memory/evidence/P0365_AURA_STATUS_PROBE_DIAGNOSTIC_SEAM.md` and `docs/memory/patches/P0365_AURA_STATUS_PROBE_DIAGNOSTIC_SEAM.md`
- `docs/memory/evidence/P0364_PLAYER_HELPFUL_AURA_DIAGNOSTIC_SEAM.md` and `docs/memory/patches/P0364_PLAYER_HELPFUL_AURA_DIAGNOSTIC_SEAM.md`
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
