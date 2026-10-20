---
memory_schema: 1
as_of: 2026-10-20
project: logres
---

# Current State

## Active Objective
Complete source-backed mapping verification and correct its runtime failures without native UI mutation. Preserve indexed service roles, D-046 fixture parity, D-047 Blizzard-owned controls and transactions. Keep global Logres/native overlap in future shared refinement.

## Current Work Item
**P0279 R1 — M MAPPING RUNTIME RECONCILIATION / PREPARED; WoW UNVERIFIED.** P0279 pushed `7660395`. In-client M results establish nine trainer highlights; a few returned DEFERRED. Portrait failed because overlay parenting targeted a native Texture; title and detail-icon global candidates were unavailable; dynamic row deliberately deferred, five design-only slots unmapped. R1 repairs addon overlay owner choice, upgrades source-backed title/detail-icon candidate paths, and logs HIGHLIGHTED/UNMAPPED/DEFERRED with reasons. No live skinning or landscape reflow; no native writes. See R1 evidence.

## Verified State
- **P0279 pushed `7660395` / WoW scoped evidence:** 9 trainer highlights drew overlays; title and detail-icon root paths unavailable; portrait anchoring failed, five design-only roles UNMAPPED and dynamic row DEFERRED. Early four `native-root-unavailable` events occurred before trainer load. User reports most outlines looked correct but cannot identify the few missing; log provides exact technical deferrals. Explicit Hide and automatic close restoration not independently recorded. See R1 evidence.
- **R1 fixes:** guarded addon-owned portrait/FontString owner-vs-anchor distinction; source-backed alternative title/detail-icon candidates (client unverified); M logs exact statuses without changing any native interaction controls.
- **P0278 R1 pushed `41826a9` / user visual evidence:** new trainer scroll area is closer to Logres visual language; **PARTIAL / not accepted final**. User reports other tests working; no claim of landscape reflow or fully verified native control mapping. Approved landscape Enchanting screenshot is a DESIGN TARGET, not deployed runtime.
- **P0279 mapping scope:** Trainer, merchant, flight and additional gossip/bank/auction/stable/tabard service roots indexed with SOURCE_CANDIDATE vs UNMAPPED provenance. Unverified dynamic ScrollBox row identity deferred. No Blizzard-native hiding permitted in read-only M inspector. Full WSL and WoW testing PENDING.
- **P0278 R0 PREWRITE FAIL (user WSL):** historical P0276 checker asserted direct TOC adjacency and rejected new TrainerMotif inserted between audit and skin (checker 109/146); no tracked writes. R1 migrates the assertion to enforce audit-before-skin order, while new P0278 checker enforces motif placement. Full WSL rerun and WoW acceptance PENDING. See `docs/memory/evidence/P0278_R1_PREWRITE_ORDER_FAILURE.md`.
- **R3 PREWRITE FAIL:** assistant-built CURRENT_HANDOFF.md lacked `CURRENT.md`; checker 55/144 failed. All 144 prewrite checks ran, no tracked files were written. R4 corrects this; WSL and WoW remain unverified.
- **R2 PREWRITE FAIL:** checker 109/144 still required a stale secret-unsafe token although the candidate Lua was fixed. R2 made NO tracked writes. R3 reconciles checker/source, but WSL/WoW unverified.
- **P0275 pushed `75e8024`: VISUAL FAIL** (large empty shell, native frame unchanged inside). **P0274 visually rejected** despite additive counters. Both rejected wrappers retired; preserve evidence.
- D-046 P visual fixture uses EXACT same nine-slice painter as native trial, no synthetic purchases. D-047 retains native skill lists, Train/Train All, filters, money, and all transactions.
- P0276 R1 adds a reversible root texture alpha snapshot and no native SetPoint/SetSize, native child action mutations or camera edits. This is NOT accepted reskin fidelity or landscape reflow until WoW proves it.
- P0273 verified positioning and restoration remain untouched, with the previous original P0272 WSL proof limitation preserved.

## Next Action
Run guarded P0279 R1 shadow 148-checker PREWRITE and POSTWRITE gates and manifest; user commit/push, verify remote `main`. Deploy runtime files, `/reload` and when naturally at a trainer use `/logres` -> M to verify only previously deferred `trainer.portrait`, `trainer.title`, `trainer.detailIcon`, then `Hide Highlight` and close trainer. Inspect matching outline, HIGHLIGHTED/DEFERRED and Lua/taint errors. No need to repeat nine successful probes or contrive gameplay/travel. Record negatives and then proceed to separately scoped P0280 component styling only on verified native mappings.

## Success Criteria
All indexed roles and existing actions preserved. Non-frame Texture/FontString can be highlighted using verified ordinary unprotected Frame owner while anchoring to its own bounds; none of the native frame, protected interactions, state, geometry or transactions change. M reports HIGHLIGHTED/UNMAPPED/DEFERRED reasons; all unverified source candidate paths and recycling remain explicitly open until Forever client proof. User-visible restoration and genuine bounds are not inferred from static checks.

## Do Not Reopen Without New Evidence
Do not infer addon installation from one guessed filesystem path or the presence/absence of a Lua global alone. No hard QuestieDB dependency, package bundling, unknown CurseForge project ID, global quest ID scans on updates, guessed quest availability, invented coordinates or native pin scraping. Do not hide the Blizzard minimap, alter user-accepted waypoint/focused-quest bearings, or treat missing locations as PASS. Baked flavor must not be guessed from a Source-only indicator. Keep negative and deferred evidence explicit.

## Relevant References
- `docs/memory/evidence/P0279_R1_MAPPING_RUNTIME_RECONCILIATION.md`
- `docs/memory/patches/P0279_R1_MAPPING_RUNTIME_RECONCILIATION.md`
- `docs/memory/evidence/P0279_SERVICE_MAPPING_INDEX_AND_INSPECTOR.md`
- `docs/ui/SERVICE_ELEMENT_MAPPING_INDEX.md`
- `docs/memory/evidence/P0278_R1_PREWRITE_ORDER_FAILURE.md`
- `docs/memory/evidence/P0278_FOREVER_TRAINER_MOTIF.md`
- `docs/memory/evidence/P0277_PARAMETERIZED_PANEL_SURFACE.md`
- `docs/memory/evidence/P0276_NATIVE_TRAINER_FEASIBILITY.md`
- `docs/memory/evidence/P0275_NATIVE_QUEST_ART_SHELL.md`
- `docs/memory/evidence/P0274_NATIVE_SERVICE_ACCENT.md`
- `docs/memory/evidence/P0273_NATIVE_GOSSIP_CONTINUITY.md`
- `docs/memory/evidence/P0272_NATIVE_AUTO_HANDOFF.md`
- `docs/memory/evidence/P0271_NATIVE_SERVICE_PLACEMENT_TRIAL.md`
- `docs/memory/evidence/P0270_NATIVE_FRAME_CAPABILITY_AUDIT.md`
- `docs/memory/evidence/P0269_D047_NATIVE_SERVICE_RESET.md`
- `docs/memory/evidence/P0268_MULTI_SERVICE_CATALOGUE.md`
- `docs/memory/evidence/P0267_NPC_NAVIGATION_AND_EXIT.md`
- `docs/memory/evidence/P0266_NPC_SESSION_RUNTIME_REPAIR.md`
- `docs/memory/evidence/P0265_NPC_OPTION_SESSION.md`
- `docs/memory/evidence/P0264_PREVIEW_REWARD_CHOICE.md`
- `docs/memory/evidence/P0263_N3_DECISION_VISUAL_EXTRACTION.md`
- `docs/memory/evidence/P0262_N2_NARRATIVE_PAGE_EXTRACTION.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`
- `docs/memory/evidence/P0257_PREVIEW_LIVE_REWARD_MODEL.md`
- `docs/memory/evidence/P0256_UNIVERSAL_PREVIEW_GALLERY.md`
- `docs/memory/evidence/P0251_LIVE_REWARD_AND_COMPLETION_CONTROL.md`
- `docs/memory/evidence/P0250_REWARD_PREVIEW_RUNTIME_ACCEPTANCE.md`
- `docs/memory/evidence/P0249_REWARD_VISUAL_INSTANCE_FAILURE.md`
- `docs/memory/evidence/P0248_REWARD_CARD_PRESENTATION.md`
- `docs/memory/evidence/P0247_REWARD_SOURCE_GATE_DIAGNOSTIC.md`
- `docs/memory/evidence/P0246_QUEST_ITEM_EVENT_CACHE_RESULT.md`
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
