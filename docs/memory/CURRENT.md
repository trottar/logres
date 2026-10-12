---
memory_schema: 1
as_of: 2026-10-11
project: logres
---

# Current State

## Active Objective
**Phase H: the Blizzard PetActionBar combat reappearance remains OPEN / REPRODUCED IN COMBAT.** P0204 accepts observed P0197 **post-combat deferred recovery** only; neither the in-combat duplicate nor protected visibility ownership is solved. NPC green name text crossing the Logres quest parchment remains observed with source owner unconfirmed. H.3 compass and empty-slot contrast are lower priority; ObjectiveTracker flash remains OPEN / INTERMITTENT.

## Current Work Item
P0203 evidence checkpoint **PUSHED and verified** at GitHub `main` `5c28c2dfd28667926c30499f99c53097a1ba0e57`. P0204 is a **DOCS-ONLY bounded acceptance** of the new `0.0.109-dev` loadCount 260 diagnostic trace. Canonical record: `docs/memory/evidence/P0204_P0197_COMBAT_RECOVERY_2026-10-11.md`. The diagnostic pair directly exercises the pending combat callback and P0197 post-combat recovery; no further reproduction is needed before a focused, source-backed combat-safe control presentation capability audit. No code, artwork or D-045 coordinate changes in P0204.

## Verified State
- **P0197 in-combat duplicate remains FAIL / OPEN / REPRODUCED:** user-identified stock Blizzard PetActionBar overlaps Logres controls during combat (P0203 screenshot). New `0.0.109-dev` loadCount 260 `/logres nativeuicheck` logged `onShow=2 combatDeferred=1 immediateRefolds=1 recovered=0 awaiting=true` and `native-surfaces pending=true`; follow-up `/logres checkall` logged the same onShow/deferral/immediate counters but `recovered=1 awaiting=false`, native pending=false and no errors. **Recovery PASS within one exercised cycle; combat presentation FAIL.** The diagnostic label `lastReconcile=PLAYER_TARGET_CHANGED` is not proof of the precise Blizzard show event.
- Later Phase 0 Run All complete; Layout 19 anchors / 29 binds / 0 failures, v4 13/13 measured; UI Ownership 17 PASS / 18 STOCK / 0 FAIL; no reported Lua/taint/protected error in this tested scope. STOCK is policy not native visibility proof.
- NPC `Jern Hornhelm` green world/NPC overhead label overlaps `Ironband's Excavation` quest dialogue text; owner still UNATTRIBUTED. Combat target-status icons visible but native/ordinary source and 2-column packing unproven.
- P0200 H.3 player-helpful artwork, v4 anchors, quest and native dock remain unchanged. Earlier P0197 ordinary refolds, P0200/P0201 prewrite delivery failures, intermittent ObjectiveTracker flash and special-mode/native click deferrals retain their original records.

## Next Action
Conduct one narrow **source/API capability audit** for a secure, combat-safe presentation ownership transition for native Blizzard PetActionBar and Logres pet actions. The goal is no overlapping dual pet-control rows in supported combat, while ensuring controls/fallback remain usable. Do not attempt protected Hide/Show during combat, infer native visibility from stored snapshots, add hooks/polling/reassertion, or move D-045 geometry. If no proven safe path exists, document an explicit limitation and defer source modification. NPC label/quest occlusion and aura ownership remain separate investigations; no artificial gameplay to re-prove the pet combat failure.

## Success Criteria
No redundant stock PetActionBar observed in supported ordinary Immersion ON, with functional native PET access and secure Logres pet controls; safe return to stock for unsupported modes. H.3 polish improves readability/layout while respecting source, interaction and state rules. Unobserved combat/special modes remain deferred, not PASS.

## Do Not Reopen Without New Evidence
No exact player HP, conventional health bar, enemy exact level/class/difficulty, secret inspection, unqualified Blizzard surface removal, broad hooks, polling or combat-unsafe mutation. PvP is a modifier, not Immersion OFF. Preserve party/class/pet/special/native/aura fallbacks until deliberately replaced.

## Relevant References

- `docs/memory/patches/P0204_ACCEPT_P0197_COMBAT_EVIDENCE.md`
- `docs/memory/evidence/P0204_P0197_COMBAT_RECOVERY_2026-10-11.md`
- `docs/memory/patches/P0203_REPRODUCED_COMBAT_PET_BAR_AND_DIALOGUE.md`
- `docs/memory/evidence/P0203_COMBAT_PET_DIALOGUE_EVIDENCE.md`
- `docs/memory/patches/P0202_H3_SCREENSHOT_VISUAL_REVIEW.md`
- `docs/memory/evidence/P0202_H3_SCREENSHOT_VISUAL_EVIDENCE.md`
- `docs/memory/patches/P0201_RECORD_P0200_RUNTIME.md`
- `docs/memory/evidence/P0201_P0200_H3_RUNTIME_EVIDENCE.md`
- `docs/memory/patches/P0200_H3_VISUAL_IMPLEMENTATION.md`
- `tools/check_h3_visual_fidelity_contract.py`

- `docs/design/H3_APPROVED_ART_RUNTIME_FIDELITY.md`
- `docs/memory/patches/P0199_H3_VISUAL_FIDELITY_CHECKPOINT.md`
- `docs/design/approved/README.md`
- `docs/memory/decisions/D-039_APPROVED_VISUAL_BASELINE.md`

- `docs/memory/patches/P0198_P0197_RUNTIME_OBSERVATION.md`
- `docs/memory/evidence/P0197_PET_BAR_RESHOW_EVIDENCE.md`
- `docs/memory/patches/P0197_PET_BAR_DEFERRED_RESHOW_RECOVERY.md`

- `docs/memory/patches/P0196_R4_TARGET_AURA_NATIVE_CONFIG.md`
- `docs/memory/evidence/P0196_R4_TARGET_AURA_RUNTIME_EVIDENCE.md`

- `docs/memory/patches/P0194_R3_H2_PANEL_SCREEN_MAP.md`
- `docs/memory/evidence/P0193_H2_GEOMETRY_RUNTIME_2026-10-11.md`
- `docs/memory/evidence/P0193_H2_GEOMETRY_RUNTIME_2026-10-11.json`
- `docs/memory/patches/P0193_H2_GEOMETRY_EVIDENCE_ACCEPTANCE.md`

- `docs/memory/patches/P0192_H2_READONLY_GEOMETRY_CHECKPOINT.md`
- `docs/memory/evidence/P0192_H2_GEOMETRY_AUDIT_2026-10-11.md`

- `docs/design/layout/SCREEN_MAP_V4.md`
- `docs/design/layout/SCREEN_MAP_V4.json`
- `docs/memory/decisions/D-045_H2_SCREEN_MAP_V4.md`
- `docs/memory/patches/P0191_H2_SCREEN_MAP_V4_DESIGN_BASELINE.md`

- `docs/memory/patches/P0190_ACCEPT_P0189_AUTO_MAIN_RUNTIME.md`
- `docs/memory/evidence/P0190_P0189_AUTO_MAIN_RUNTIME_2026-10-11.md`

- `docs/memory/patches/P0189_MAIN_AUTO_IMMERSION_GATE.md`
- `docs/memory/evidence/P0189_MAIN_AUTO_GATE_CANDIDATE_2026-10-11.md`

- `docs/memory/patches/P0188_ACCEPT_P0187_NORMAL_RUNTIME.md`
- `docs/memory/evidence/P0188_P0187_R2_NORMAL_RUNTIME_2026-10-10.md`
- `docs/memory/patches/P0187_MAIN_SECURE_REPLACEMENT_CANDIDATE.md`
- `docs/memory/evidence/P0187_MAIN_SECURE_CANDIDATE_2026-10-09.md`
- `docs/memory/patches/P0186_MAIN_SECURE_TRANSITION_SOURCE_GATE.md`
- `docs/memory/evidence/P0186_MAIN_TRANSITION_SOURCE_GATE_2026-10-09.md`
- `docs/memory/patches/P0185_MAIN_BAR_MEMORY_RECONCILIATION.md`
- `docs/memory/evidence/P0185_MAIN_BAR_MEMORY_AUDIT_2026-10-09.md`
- `docs/memory/patches/P0184_ACCEPT_P0183_RUNTIME.md`
- `docs/memory/evidence/P0184_ACCEPT_P0183_RUNTIME_2026-10-09.md`
- `docs/memory/decisions/D-023_SELECTIVE_STOCK_ACTION_REPLACEMENT.md`
- `docs/memory/decisions/D-044_CLASS_PET_SPECIAL_CONTROL_SOURCE_AND_FALLBACK_POLICY.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/memory/investigations/ACTIVE.md`
- `docs/ROADMAP.md`
