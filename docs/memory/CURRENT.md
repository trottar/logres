---
memory_schema: 1
as_of: 2026-10-20
project: logres
---

# Current State

## Active Objective
Close the P-only landscape trainer utility completeness gap after accepted P0283 visual hierarchy, without expanding Blizzard transaction ownership. Preserve the portrait-free 896×712 parchment composition and native H stock surfaces. Filter, funds and Train All are mock *presentation* fields pending separate guarded native source/capability work.

## Current Work Item
**P0284 — TRAINER UTILITY PREVIEW / PREPARED, WSL AND WOW UNVERIFIED.** Verified GitHub `main` P0283 `b6d818b`. User's latest client screenshot: P-only trainer preview **VISUAL PASS** for tested layout and selected/ordinary contrast; user says "Looks good" and identifies missing filter, gold/funds, and native Train All-like utilities. User explicitly says no portrait: this remains the intended Logres design. P0284 adds bounded synthetic Filters/Categorize, denominated Funds and disabled Train All to the existing `Landscape.Fixture/Build/Render`, preserving the approved geometry and interaction split. Native Blizzard trainer transaction/source logic is unchanged; no actual money or trainer cost is inferred.

## Verified State
- **P0283 pushed `b6d818b` / P-only user visual PASS within tested composition:** user screenshot shows gold selected spell, ordinary ivory names, muted disabled row and coherent parchment. User says "Looks good" and explicitly rejects a portrait. Remaining filter, money and Train All presentation is OPEN, not a native UI capability PASS. P0284 is an untested preview-only candidate.
- **P0282 pushed `39acd57` / user WoW VISUAL NEAR-PASS, ROW EMPHASIS FAIL:** Screenshot shows continuous warm parchment, readable categories, integrated skill list/detail and reagent count. User says "Very close" but notes every spell is yellowish; only selected/highlighted spells should be. This is a specific negative acceptance criterion; P0283 color fix is untested. Static PASS does not establish visual PASS.
- **P0281 R2 pushed `6b0501f` / client STRUCTURAL PASS, VISUAL FIDELITY FAIL:** Screenshot confirms a complete landscape composition. Black sidebar/catalogue slabs and near-invisible categories differ from warm parchment reference; bright-brown selected detail box also rejected. User expressly corrects assistant's inaccurate opacity diagnosis. No documented H native regression test and none requested. P0282 is an inert fixture styling candidate only, not client PASS.
- **P0281 R1 PREWRITE FAIL (user WSL):** candidate ran 152 static checkers; 151 passed, 1 failed. New `check_p0281_landscape_trainer_preview_contract.py` required literal `frame:EnableMouse(false)` but valid fixture helper creates local `f` and calls `f:EnableMouse(false)`. Static contract/source mismatch is an assistant artifact-generation failure. PREWRITE refused before tracked writes; no WoW validation occurred. R2 validates the helper's created frame has mouse interaction disabled, without freezing a variable name; results still pending.
- **P0281 R0 artifact PREWRITE REFUSAL:** user applied ZIP with valid SHA-256 on clean pushed P0280 HEAD; the generated Python applier incorrectly pinned a 38-character Bootstrap Git blob instead of verified 40-character `bc11dc309960e26a0a6d6827ea1ea03da81a37f6`. It refused at `Baseline blob mismatch: Logres/Core/Bootstrap.lua` before tracked writes. User confirmed clean status, matching HEAD/index/raw/filtered blob; no repo defect. R1 fixes exactly the pin and adds a hash-length gate; full WSL suite and WoW pending.
- **P0280 pushed `38cf5fc` / WoW VISUAL FAIL:** user screenshot unchanged from three steps before: narrow native trainer next to a synthetic scattered fixture. Diagnostic 4/0 component attachments is only a decorative success counter. Root cause is shared paint without shared landscape composition. Preserve negative result.
- **P0281 PREPARED / WoW UNVERIFIED:** one fully composed inert P landscape model/renderer; no native reflow or gameplay adapter.
- **P0279 R3 R1 pushed `30e6af3` / scoped user WoW PASS:** `trainer.portrait` HIGHLIGHTED with `highlight-visible-mapped-owner`; user confirms visible outline works. Auto-hide on trainer close is not explicitly measured. P0279 R3 R0 checker PREWRITE failure remains preserved.
- **P0280 prepared:** one shared component painter and model shape for P fixture/H native filter, selected skill, status bar, Train. Source-backed native mappings are client-highlighted, but new styling and P/H parity remain UNVERIFIED in WoW. Fail-open and rollback are required; no native action or geometry mutation.
- **P0279 R3 R0 PREWRITE FAIL (user WSL):** 1/150 `check_checker_version_policy.py` refused a literal historical `0.0.179-dev` in the new R3 checker (27/150). PREWRITE stopped before tracked writes; no R3 code committed, deployed or tested. R3 R1 retains the same runtime candidate and corrects only this contract; see R3 R1 failure evidence.
- **P0279 R2 pushed `90198c5` / new `0.0.179-dev` in-client evidence:** The portrait selection first returned expected pre-open `native-root-unavailable`; two open-trainer selections returned DEFERRED `native-owner-outside-size-gate`. This is the EXACT observed gate. The parent identity and size are not recorded and must not be guessed. Title, icon and Hide Highlight previously PASS from `0.0.178-dev`.
- **P0279 R3 R1 prepared:** Add `overlayOwnerPath = ClassTrainerFrame` to `trainer.portrait` only. In the inspector, use an alternate owner ONLY on the observed size-gate refusal, after independent ordinary/unprotected/visible/bounded Frame eligibility. Texture remains anchor; addon overlay is the only reparented object. Native frame-close and portrait visual fit still need WoW proof.
- **P0279 R1 pushed `e7c4430` / scoped WoW proof:** `trainer.title` and `trainer.detailIcon` now HIGHLIGHTED; `mapping hide` PASS. Portrait after opening trainer remains DEFERRED (`native-owner-unverified-or-protected`); initial closed trainer `native-root-unavailable` was environmental. No portrait gate cause established; visual bounds and trainer-close restoration remain unverified.
- **P0279 R2 prepared:** refuse-first diagnostic only. The existing guarded `eligible(owner)` gate is unchanged; one static refusal reason code identifies whether parent lookup, protection, visibility or dimensions caused rejection. No protected/secret native data are formatted, no new polling or native writes.
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
Apply guarded P0284 from verified main `b6d818b`, require full shadow PREWRITE and POSTWRITE static suite and whitespace PASS, then user commit/push and remote verification. Deploy and `/reload`; in the developer panel choose **P — Previews → Trainer Skin Art Preview** and inspect Filters/Categorize, currency denominations, disabled Train All, row emphasis and absence of portrait. Toggle preview OFF and capture screenshot. No real NPC visit or native training for this P-only fixture.

## Success Criteria
The inert landscape retains its accepted P0283 material, text contrast, row states, bounds and no-portrait design while visually presenting filter affordance, categorized state, mock funds and a distinct mock Train All beside Train. All new values are declared synthetic, bounded model fields and use addon-owned mouse-disabled frames, not secure controls. No new native read/write, purchases, training, Quest, camera or protected operations. P-client screenshot decides visual acceptance; multi-reagent overflow and native adapters remain DEFERRED.

## Do Not Reopen Without New Evidence
Do not infer addon installation from one guessed filesystem path or the presence/absence of a Lua global alone. No hard QuestieDB dependency, package bundling, unknown CurseForge project ID, global quest ID scans on updates, guessed quest availability, invented coordinates or native pin scraping. Do not hide the Blizzard minimap, alter user-accepted waypoint/focused-quest bearings, or treat missing locations as PASS. Baked flavor must not be guessed from a Source-only indicator. Keep negative and deferred evidence explicit.

## Relevant References
- `docs/memory/evidence/P0284_TRAINER_UTILITY_PREVIEW.md`
- `docs/memory/patches/P0284_TRAINER_UTILITY_PREVIEW.md`
- `docs/memory/evidence/P0283_TRAINER_SELECTION_EMPHASIS.md`
- `docs/memory/patches/P0283_TRAINER_SELECTION_EMPHASIS.md`
- `docs/memory/evidence/P0282_TRAINER_PARCHMENT_VISUAL_FAILURE.md`
- `docs/memory/patches/P0282_TRAINER_PARCHMENT_VISUAL_REPAIR.md`
- `docs/memory/evidence/P0281_LANDSCAPE_TRAINER_PREVIEW.md`
- `docs/memory/patches/P0281_LANDSCAPE_TRAINER_PREVIEW.md`
- `docs/memory/evidence/P0280_SHARED_TRAINER_COMPONENT_TRANCHE.md`
- `docs/memory/patches/P0280_SHARED_TRAINER_COMPONENT_TRANCHE.md`
- `docs/memory/evidence/P0279_R3_R1_PREWRITE_VERSION_POLICY_FAILURE.md`
- `docs/memory/patches/P0279_R3_R1_VERSION_POLICY_REPAIR.md`
- `docs/memory/evidence/P0279_R3_EXPLICIT_PORTRAIT_OWNER.md`
- `docs/memory/patches/P0279_R3_EXPLICIT_PORTRAIT_OWNER.md`
- `docs/memory/evidence/P0279_R2_PORTRAIT_OWNER_GATE.md`
- `docs/memory/patches/P0279_R2_PORTRAIT_OWNER_GATE.md`
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
