---
memory_schema: 1
as_of: 2026-11-10
project: logres
---

# Current State

## Active Objective
Alpha blocked. D-046/D-047/D-048.

## Current Work Item

**P0440** lifecycle probe; P0439 main `572c558` verified. OOC anchor
unavailable in Forever #11003/#11082; P0432 combat anchor observed.
Read-only nameplate event tokens distinguish target, secondary anchors and
hostile combat player-targeting. Report Bug > H > Nameplate Lifecycle.
No protected changes; fallback preserved. D-042/L-011 DEFERRED; L-047
panel controls scoped PASS. P0427 historical; P0425 visual PASS.

## Verified State

- P0439 `572c558` panel controls PASS scoped; OOC trial DEFERRED, zero failures. P0437 visual PASS, P0432 combat anchor observed, production attachment/aggro unproven.

- P0422 moved the pet-action bar in error; P0423 restored it and V8 was visually accepted.

- P0420 pushed main `bd55e34`; user screenshot shows expected and measured
  H.2 outlines aligned, but requests actual visual refinement. P0421 uses
  `LOGRES_SCREEN_MAP_REFINEMENTS_P0421.json` to move 15 owned regions in V6.
  P0416 action slots/roles, P0418 initial map, P0419 footprints, P0420
  semantic-anchor overlay remain intact; no Blizzard control is moved.
- P0417 main `bc91448`: Blizzard pet bar/frame user-observed suppressed and Logres actions working; L-008 still OPEN for combat/Edit Mode/fallback coverage.
- P0418 V5 initial 19-region map (`LOGRES_SCREEN_MAP_APPROVED.json`) is archived; V6 supersedes only runtime centers, preserving the H.2 audit and native fallbacks.

- P0381 integrated gameplay OPEN; P0383 `cc783a0` 253 STATIC; client 0.0.267-dev quest18 TURNED_IN; hotspot offset and stock greeting OPEN. L-005 PARTIAL, L-001/L-002 OPEN. P0384 quest21 aligned hover in 0.0.268-dev incident 3196; P0385 observed; P0386 UNVERIFIED.

- P0379 `285be528` 249 STATIC; 0.0.264-dev no claim. L-002 native, L-005 FAIL. R0/R1 refused; P0378 screenshots inferred.

- P0370 240 STATIC; no-pet labels user PASS. P0369 P0368 P0367 P0366 R1 P0365 R1 P0364 R1 P0363 P0362 P0361 R1 P0360 P0359 P0358 R1 P0357 P0356: 239–227 STATIC, client checks pending; prior refusals in evidence. L-001/L-002/L-005 FAIL.
- P0352 223, P0351 222, P0350 221 STATIC; client UNVERIFIED.
- P0349 R1 `4e59c8f2f03daf30b630fb15e3e14d5f38cc8da6` 220/220 STATIC; R0 REFUSED, WoW UNVERIFIED.
- P0348 `4b7481d731d5f90e214b285bc7cce16ec826176f` 219/219 STATIC; D-048 model OFFLINE ONLY.
- P0347 R1 `b94beb47` 218 STATIC; R0 REFUSED, WoW UNVERIFIED.
- P0346 `26370095` 217 STATIC; WoW UNVERIFIED.
- P0345 `626b220` 216/216 STATIC; target aura client UNVERIFIED.
- P0344 `e44f66ba` 215/215 STATIC; L-027 owner UNVERIFIED.
- P0343 R1 `ef4d9604` 214/214 STATIC; R0 REFUSED before writes, L-022 OPEN.
- P0342 R2 `be3be5e80cf65cf1bf6d261b84b573f1f1effca2` 213/213 STATIC; R0/R1 PREWRITE REFUSED; L-028 OPEN.
- P0341 R1 `fb3b2658` 212/212 STATIC; R0 historical-version checker REFUSED before writes; WoW UNVERIFIED.
- P0338 R1 `342cab97` 209/209; P0337 R1 `cfdc07af` 208/208. PREWRITE failures recorded; L-031 remains deferred.
- P0340 prefreeze; P0336/P0335/P0334 R3/P0333/P0332/P0331/P0330/P0329: 207–200 STATIC. See PATCH_INDEX.
- P0328 alpha runbook; P0317/P0318/P0319/P0320 gossip observations; P0321 `9a180c8` parking UNVERIFIED. P0322/P0323/P0324/P0325 D-048 inert models; P0326/P0327 merchant/flight models only. Stock UI/quest 237 kept.
- D-048 independent live domain selectors and saved migration do not exist: schema 3 still stores `immersionEnabled` and `activeQuestEnabled`. D-046 preview-first and D-047 frozen Camera/DynamicCam remain required. Native UI and protected/secret fallbacks stay usable.
- L-020–L-032 are tracked user reports; runtime gates apply. L-028 duplicated/missing target debuffs remains OPEN; L-022 focused quest artifact requires screenshot, L-027 Blizzard transient popup requires `/fstack` owner evidence. L-019 license unresolved, release blocked.

- Historical markers retained for continuity; status/evidence in PATCH_INDEX and ISSUE_LEDGER: L-004, L-021, L-025, L-029, L-033, L-034, L-035, L-037, L-038, L-039, L-040, P0241, P0373, P0374, P0376, P0380, P0382, P0387, P0388, P0389, P0390, P0391, P0392, P0393, P0394, P0395, P0396, P0397, P0402, P0405, P0406, P0407, P0408, P0410, P0411, P0413, P0414, P0415.

## Next Action

P0440: during natural two-enemy Forever combat, use Report Bug > H >
Nameplate Lifecycle and left-click Report Bug. Verify target/secondary anchors
and combat targeting separately; threat/attachment remain UNPROVEN.

## Success Criteria

P0409 R1 user PASS. P0404 layout PASS; P0403 unverified.

## Do Not Reopen Without New Evidence
Preserve P0321/P0329, camera, secure actions, quest 237. No polling or secret reads.

## Relevant References
- docs/memory/patches/CHAT_TO_ZIP_WORKFLOW.md (P0428/P0434)
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
- `docs/memory/roadmap/NOV04_GAMEPLAY_REGRESSION_MATRIX.md` and `docs/memory/evidence/P0339_GAMEPLAY_RUNTIME_MATRIX.md`
- `docs/memory/evidence/P0334_PVP_BADGES.md` and `docs/memory/patches/P0334_PVP_BADGES.md`
- `docs/memory/investigations/ISSUE_REGISTER.md` (L-020–L-032); `docs/memory/evidence/P0329_GAMEPLAY_SNAPSHOT.md`; `docs/memory/patches/P0329_GAMEPLAY_SNAPSHOT.md`
- `docs/memory/roadmap/NOV04_VALIDATION_RUNBOOK.md`; `docs/memory/roadmap/LAUNCH_READINESS.md`
- `docs/memory/architecture/P0328_ALPHA_STAGE_READINESS.md`; `docs/memory/evidence/P0321_GOSSIP_SINGLE_WINDOW.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`; `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`; `docs/memory/decisions/D-048_FIVE_INDEPENDENT_SYSTEMS.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`; `docs/memory/investigations/ACTIVE.md`; `docs/memory/roadmap/STATUS.md`; `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`; `docs/ROADMAP.md`
