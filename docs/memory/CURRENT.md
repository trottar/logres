---
memory_schema: 1
as_of: 2026-10-19
project: logres
---

# Current State

## Active Objective
Prove a visually unified, independently configurable Logres trainer using evidence from ElvUI Forever/Aurora while preserving Blizzard training controls, D-046 fixture parity, and D-047 native ownership. Camera frozen.

## Current Work Item
**P0278 — FOREVER TRAINER SCROLLBOX/ROW MOTIF, PREPARED / WoW UNVERIFIED.** Verified pushed main P0277 `f042f311`. User live trainer screenshot shows the previous alpha/root quest panel approach merely blackens the Blizzard trainer; **VISUAL FAIL**. ElvUI Forever source identifies `.ScrollBox`, `ForEachFrame` rows, category/row painting and separate inset handling, whereas Aurora Classic uses incompatible fixed `ClassTrainerSkillN` rows. P0278 adds original addon-owned parchment/gold surface and row accents using shared `Theme.panelSurface` and independent `TrainerPanelConfig`. Existing H ON/OFF and P preview provide tests. Native protected controls/transactions untouched; no dynamic update hook or landscape reshaping.

## Verified State
- **P0278 R0 PREWRITE FAIL (user WSL):** historical P0276 checker asserted direct TOC adjacency and rejected new TrainerMotif inserted between audit and skin (checker 109/146); no tracked writes. R1 migrates the assertion to enforce audit-before-skin order, while new P0278 checker enforces motif placement. Full WSL rerun and WoW acceptance PENDING. See `docs/memory/evidence/P0278_R1_PREWRITE_ORDER_FAILURE.md`.
- **R3 PREWRITE FAIL:** assistant-built CURRENT_HANDOFF.md lacked `CURRENT.md`; checker 55/144 failed. All 144 prewrite checks ran, no tracked files were written. R4 corrects this; WSL and WoW remain unverified.
- **R2 PREWRITE FAIL:** checker 109/144 still required a stale secret-unsafe token although the candidate Lua was fixed. R2 made NO tracked writes. R3 reconciles checker/source, but WSL/WoW unverified.
- **P0275 pushed `75e8024`: VISUAL FAIL** (large empty shell, native frame unchanged inside). **P0274 visually rejected** despite additive counters. Both rejected wrappers retired; preserve evidence.
- D-046 P visual fixture uses EXACT same nine-slice painter as native trial, no synthetic purchases. D-047 retains native skill lists, Train/Train All, filters, money, and all transactions.
- P0276 R1 adds a reversible root texture alpha snapshot and no native SetPoint/SetSize, native child action mutations or camera edits. This is NOT accepted reskin fidelity or landscape reflow until WoW proves it.
- P0273 verified positioning and restoration remain untouched, with the previous original P0272 WSL proof limitation preserved.

## Next Action
Execute full PREWRITE/POSTWRITE 146-checker WSL gate, manifest and diff check; user commits/pushes and remote is verified. Deploy to WoW then P Trainer Skin Art Preview, P Quest Dialogue Preview, with native trainer open H Trainer Skin ON (TEST)/OFF. ON must report `native-scroll-motif-active`; any DEFERRED leaves stock. Confirm actual visual row/scroll appearance, text/icon/filter/Train availability, close/stock restoration and rows after scrolling. Run H Native Service Frame Audit only if needed, then 0 Run All. Report screenshots and diagnostics; no acceptance without in-game evidence.

## Success Criteria
P/live row motifs share one original painter and trainer-specific parameters; the Quest UI remains unchanged. Live ON applies safe decorative ScrollBox/rows, OFF/close restores original native appearance; no native mutations from motif, no invisible click regions, no taint/secret errors or buying. Source finding is NOT Forever runtime proof; failures/deferrals and historic visual failures remain explicit.

## Do Not Reopen Without New Evidence
Do not infer addon installation from one guessed filesystem path or the presence/absence of a Lua global alone. No hard QuestieDB dependency, package bundling, unknown CurseForge project ID, global quest ID scans on updates, guessed quest availability, invented coordinates or native pin scraping. Do not hide the Blizzard minimap, alter user-accepted waypoint/focused-quest bearings, or treat missing locations as PASS. Baked flavor must not be guessed from a Source-only indicator. Keep negative and deferred evidence explicit.

## Relevant References
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
