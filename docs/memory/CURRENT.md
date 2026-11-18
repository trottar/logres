---
memory_schema: 1
as_of: 2026-11-18
project: logres
---

# Current State

## Active Objective
Alpha blocked. D-046/D-047/D-048.

## Current Work Item

**P0486** quest35 PASS; **P0487** docs PASS.
**P0489** side/pet OOC0, primary1; combat roles retained;
auto-death targeting BLOCKED protected; client UNVERIFIED.
**P0488** L-054 OPEN; L-030 NPC261/q37 PASS scoped.
**P0485** FAIL retained.
**P0484** FAIL; **P0483** turn PARTIAL; **P0482** est2/3/native3/4.
P0476 floor, P0477 hide, P0478 VISUAL FAIL,
P0479 FAIL retained.
L-002 OPEN.
P0473 FAIL; P0474 scoped PASS; L-037 PARTIAL.
Preserve world HP/aura/50-50, chat SHOW, quest/stock fallback.
P0460 HP PASS; P0461 aura FAIL; P0457 selected PASS;
P0454/P0455 secondary 50/50 VISUAL FAIL; P0456 suspended.
P0458/P0459 FAIL.
P0425 visual PASS; P0442/P0443 overlap FAIL; P0449 aura PASS;
P0450 duplicate FAIL; P0463 GetPoint FAIL; P0464 style FAIL.
L-011 PARTIAL; L-028/L-048 OPEN; L-019 BLOCKED; P0471 unverified.

## Verified State

- P0440 main `bec4038`: #11161 nameplate target12/secondary17/
  combat29/targeting4; 0 failures/secret. P0439 OOC DEFERRED,
  P0437 visual PASS; no qualified threat/production attachment.

- P0422 pet-bar move FAIL; P0423 restored; V8 visual PASS.

- P0420 `bd55e34` H.2 outline observed; P0421 V6 translated 15 owned
  regions from `LOGRES_SCREEN_MAP_REFINEMENTS_P0421.json`. P0416/P0418/P0419
  semantic-anchor/layout contracts retained; no Blizzard controls moved.
- P0417 `bc91448`: pet actions work; L-008 OPEN for combat/Edit Mode/fallback.
- P0418 V5 archive; V6 retains native fallback.

- P0381 OPEN; P0383 quest18 TURNED_IN; L-005 PARTIAL,
  L-001/L-002 OPEN; P0384 aligned; P0385 observed; P0386 UNVERIFIED.

- P0379 `285be528` 249 STATIC; 0.0.264-dev no claim. L-002 native, L-005 FAIL. R0/R1 refused; P0378 screenshots inferred.

- P0370 240 STATIC no-pet PASS; P0367, P0357 P0358 P0359; historic checks remain. L-001/L-002/L-005 FAIL.
- P0352 223, P0351 222, P0350 221 STATIC; client UNVERIFIED.
- P0349 R1 220 STATIC; R0 REFUSED, WoW UNVERIFIED.
- P0348 219 STATIC; D-048 model OFFLINE ONLY.
- P0347 R1 `b94beb47` 218 STATIC; R0 REFUSED, WoW UNVERIFIED.
- P0346 `26370095` 217 STATIC; WoW UNVERIFIED.
- P0345 `626b220` 216/216 STATIC; target aura client UNVERIFIED.
- P0344 `e44f66ba` 215/215 STATIC; L-027 owner UNVERIFIED.
- P0343 R1 `ef4d9604` 214/214 STATIC; R0 REFUSED before writes, L-022 OPEN.
- P0342 R2 213 STATIC; R0/R1 PREWRITE REFUSED; L-028 OPEN.
- P0341 R1 `fb3b2658` 212/212 STATIC; R0 historical-version checker REFUSED before writes; WoW UNVERIFIED.
- P0338 R1 `342cab97` 209/209; P0337 R1 `cfdc07af` 208/208. PREWRITE failures recorded; L-031 remains deferred.
- P0340 prefreeze; P0336/P0335/P0334 R3/P0333/P0332/P0331/P0330/P0329: 207–200 STATIC. See PATCH_INDEX.
- P0328 alpha runbook; P0317/P0318/P0319/P0320 gossip observations; P0321 `9a180c8` parking UNVERIFIED. P0322/P0323/P0324/P0325 D-048 inert models; P0326/P0327 merchant/flight models only. Stock UI/quest 237 kept.
- D-048 independent live domain selectors and saved migration do not exist: schema 3 still stores `immersionEnabled` and `activeQuestEnabled`. D-046 preview-first and D-047 frozen Camera/DynamicCam remain required. Native UI and protected/secret fallbacks stay usable.
- L-020–L-032 are tracked user reports; runtime gates apply. L-028 duplicated/missing target debuffs remains OPEN; L-022 focused quest artifact requires screenshot, L-027 Blizzard transient popup requires `/fstack` owner evidence. L-019 license unresolved, release blocked.

- History retained in PATCH_INDEX/ISSUE_LEDGER: P0368, P0369, P0426, P0427, L-004, L-021, L-025, L-029, L-033, L-034, L-035, L-037, L-038, L-039, L-040, P0241, P0373, P0374, P0376, P0380, P0382, P0387, P0388, P0389, P0390, P0391–P0397, P0402, P0405–P0408, P0410, P0411, P0413–P0415.

## Next Action

P0489 L-055 bar fade live test; L-056 protected targeting deferred.
P0488 L-054 observe; L-030 false positives open. L-035/L-002 OPEN.

## Success Criteria

P0409 R1 user PASS. P0404 layout PASS; P0403 unverified.

## Do Not Reopen Without New Evidence
Preserve P0321/P0329, camera, secure actions, quest 237. No polling or secret reads.

## Relevant References
- docs/memory/evidence/P0489_ACTION_BAR_ALPHA_POLICY.md
- docs/memory/evidence/P0487_QUEST_MARKER_RUNTIME_PASS.md
- docs/memory/evidence/P0488_PLAYER_BUFF_RESTRICTION_RECOVERY.md
- docs/memory/evidence/P0486_INFORMATIONAL_QUEST_FLAGS.md
- docs/memory/evidence/P0485_SPARSE_QUEST_ELIGIBILITY.md
- docs/memory/evidence/P0484_QUEST_ELIGIBILITY_FALLBACK.md
- docs/memory/roadmap/POST_P0474_WORKSTREAMS.md
- docs/memory/evidence/P0471_TARGET_FACTION_CREST.md
- docs/memory/evidence/P0467_CHAT_WORKFLOW_AUDIT.md
- docs/memory/evidence/P0466_IMMERSIVE_NAME_DEFAULTS.md
- docs/memory/decisions/D-049_IMMERSIVE_NAMES_AND_DEFAULTS.md
- docs/memory/evidence/P0465_WORLD_AURA_STYLE.md
- docs/memory/evidence/P0464_PER_UNIT_NATIVE_WORLD_AURAS.md
- docs/memory/evidence/P0463_AURA_ACTIVATION_TRACKER_REPAIR.md
- docs/memory/evidence/P0453_SECONDARY_THREAT_SOURCE_ISOLATION.md
- docs/memory/evidence/P0451_SECONDARY_THREAT_QUALIFICATION.md
- docs/memory/evidence/P0450_WORLD_AURA_OWNERSHIP_HANDOFF.md
- docs/memory/evidence/P0449_NATIVE_WORLD_AURA_CONTAINER.md
- docs/memory/evidence/P0448_WORLD_AURA_ATTACH_REFRESH.md
- docs/memory/patches/CHAT_TO_ZIP_WORKFLOW.md (P0428/P0434/P0452)
- docs/memory/evidence/P0426_NPC_VISUAL_AND_COMPASS_INTAKE.md
- docs/design/navigation/COMPASS_IDENTITY_AND_PROVIDER_FRESHNESS.md
- docs/DEPENDENCIES.md
- docs/memory/evidence/P0424_COMPACT_MERCHANT_PROFILE.md
- docs/design/layout/NPC_MERCHANT_COMPACT_V1.md
- docs/memory/evidence/P0421_V6_SCREEN_REFINEMENTS.md
- docs/design/layout/SCREEN_MAP_V6.json
- docs/design/layout/SCREEN_MAP_V6.md
- docs/memory/evidence/P0420_H2_INTRINSIC_ANCHOR_PROJECTION.md
- docs/memory/evidence/P0419_H2_ACTION_FOOTPRINT_CALIBRATION.md
- docs/memory/evidence/P0418_APPROVED_SCREEN_MAP_TRANSLATION.md
- docs/design/layout/SCREEN_MAP_V5.md
- docs/design/layout/SCREEN_MAP_V5.json
- docs/memory/evidence/P0417_PET_STOCK_GATE_REPAIR.md
- docs/memory/evidence/P0416_FIVE_BAR_AUTHORED_LAYOUT.md
- docs/design/layout/ACTION_BARS_V1.json
- docs/memory/evidence/P0403_QUEST_STAGE_HANDOFF.md
- docs/memory/evidence/P0408_CHAT_PREFLIGHT.md
- docs/memory/evidence/P0404_CENTERED_FLIGHT_MASTER.md
- docs/memory/evidence/P0406_CHAT_CHANGE_RUNNER.md
- docs/memory/evidence/P0410_CHAT_STAGING_AUDIT.md
- docs/memory/evidence/P0412_CHAT_AUTHOR_PREFLIGHT.md
- docs/memory/evidence/P0413_GUILD_REGISTRAR.md
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
- `docs/memory/roadmap/NOV04_GAMEPLAY_REGRESSION_MATRIX.md` and `docs/memory/evidence/P0339_GAMEPLAY_RUNTIME_MATRIX.md`
- `docs/memory/evidence/P0334_PVP_BADGES.md` and `docs/memory/patches/P0334_PVP_BADGES.md`
- `docs/memory/investigations/ISSUE_REGISTER.md` (L-020–L-032); `docs/memory/evidence/P0329_GAMEPLAY_SNAPSHOT.md`; `docs/memory/patches/P0329_GAMEPLAY_SNAPSHOT.md`
- `docs/memory/roadmap/NOV04_VALIDATION_RUNBOOK.md`; `docs/memory/roadmap/LAUNCH_READINESS.md`
- `docs/memory/architecture/P0328_ALPHA_STAGE_READINESS.md`; `docs/memory/evidence/P0321_GOSSIP_SINGLE_WINDOW.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`; `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`; `docs/memory/decisions/D-048_FIVE_INDEPENDENT_SYSTEMS.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`; `docs/memory/investigations/ACTIVE.md`; `docs/memory/roadmap/STATUS.md`; `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`; `docs/ROADMAP.md`
