---
memory_schema: 1
as_of: 2026-10-11
project: logres
---

# Current State

## Active Objective
**Phase H integration remains active; P0197 is pushed and its ordinary no-duplicate pet-bar observation is accepted, while the earlier intermittent reappearance remains OPEN / INTERMITTENT / UNREPRODUCED.** P0196 R4 target buffs/debuffs and H.2 v4 screen composition remain user-accepted for observed ordinary presentation. H.3 polish remains separate.

## Current Work Item
P0199 is a **DOCS-ONLY H.3 approved-art-to-runtime fidelity audit**, grounded in all 12 approved D-039 sheets, current production Theme/TGA source and the latest user screenshot. Canonical matrix: `docs/design/H3_APPROVED_ART_RUNTIME_FIDELITY.md`; checkpoint: `docs/memory/patches/P0199_H3_VISUAL_FIDELITY_CHECKPOINT.md`. **Next after P0199 push:** one cohesive H.3 runtime visual candidate targeting native harmful aura icon fidelity/fit, readable percentage/name typography and action/native-dock hierarchy, without altering v4 positions, authored player buffs, secure/pet/aura fallbacks or combat behavior. No H.3 runtime PASS is implied by this document.

## Verified State
- GitHub `main` P0197 at `0a20eef1de3b77fa26d03d6b1c1ccfd23cde0a7b`, `0.0.108-dev`. Uploaded loadCount 253: `petbar-reshow: AUDIT (onShow=4 combatDeferred=0 immediateRefolds=4 recovered=0 awaiting=false lastReconcile=PET_BAR_UPDATE)` after normal Immersion OFF/ON and diagnostic cycles. All four observed ordinary OnShow events refolded immediately; **combat deferral and recovery were not tested**.
- Phase H Native Access Check passed: desired=true, four new native surfaces folded, pet interaction ready, pending=false, error=nil. Two Phase 0 `checkall` runs completed with no reported failures in their tested scope. Latest Layout Check: 19 anchors / 34 binds / 0 failures. User reports the redundant Blizzard pet bar did not appear during this session.
- Previous P0196 R4 screenshot captured intermittent duplicate native PetActionBar. Trigger remains unknown. This is **not** evidence that P0197 solved all ways it may reappear, nor proof of in-combat behavior. Manual PET secure clicks, pet ability/autocast, special vehicles/combat and complete aura populations are not demonstrated by this upload. Historic negative evidence and deferrals stay open. The Phase 0 stock ownership inventory remains a policy classification, not a visibility observation.
- Earlier P0196 R1 aura art/unsupported hook failure, P0196 R2 prewrite error, and intermittent ObjectiveTracker flash remain recorded.

## Next Action
Apply the guarded docs-only P0199 audit, verify user push to `main`, then prepare one integrated H.3 candidate based on the mapped reference-to-runtime gaps. Use the approved aura sheet and existing `Media/Aura` art, not generic native icons or speculative source changes. Validate multi-icon player/target debuffs, full-screen density, and native access/Immersion restoration. P0197 pet re-show is still intermittent/unreproduced; record recurrence through existing event counters, do not add polling.

## Success Criteria
No redundant stock PetActionBar observed in supported ordinary Immersion ON, with functional native PET access and secure Logres pet controls; safe return to stock for unsupported modes. H.3 polish improves readability/layout while respecting source, interaction and state rules. Unobserved combat/special modes remain deferred, not PASS.

## Do Not Reopen Without New Evidence
No exact player HP, conventional health bar, enemy exact level/class/difficulty, secret inspection, unqualified Blizzard surface removal, broad hooks, polling or combat-unsafe mutation. PvP is a modifier, not Immersion OFF. Preserve party/class/pet/special/native/aura fallbacks until deliberately replaced.

## Relevant References

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
