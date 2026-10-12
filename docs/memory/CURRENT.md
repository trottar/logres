---
memory_schema: 1
as_of: 2026-10-11
project: logres
---

# Current State

## Active Objective
**Phase H integration: newly reproduced Blizzard PetActionBar combat reappearance is the priority defect.** P0200 `0.0.109-dev` normal-session diagnostic checks passed in their measured scope; the current user combat screenshot and explicit report identify a second, smaller Blizzard pet button row overlapping Logres pet controls when combat begins. P0197 symptom is **OPEN / REPRODUCED IN COMBAT**, not unreproduced. A separate NPC dialogue screenshot shows world/name-label text visibly occluding the parchment; owner unknown. H.3 compass brightness/action empty-chrome refinements remain secondary.

## Current Work Item
P0202 docs-only ordinary screenshot review is **PUSHED and verified** at GitHub `main` `3aa21829f0b25b8069bac07089766d3ded7d44e9`. P0203 is **DOCS-ONLY new screenshot/explicit-user-observation evidence**, recording P0197 combat recurrence and NPC dialogue occlusion, with target aura visual attribution unresolved. Canonical record: `docs/memory/evidence/P0203_COMBAT_PET_DIALOGUE_EVIDENCE.md`. Runtime still `0.0.109-dev`; no proposed source change until focused in-combat native surface counters are captured.

## Verified State
- **NEW reproduced negative observation:** one user combat screenshot shows a smaller row overlapping Logres pet controls; user explicitly confirms it is the Blizzard PetActionBar and says it returns **in combat**. This supersedes earlier UNREPRODUCED classification but does not establish exact native `OnShow` trigger. P0197 guarded hook defers Hide under combat lockdown; post-combat recovery logic cannot prevent combat overlap. **OPEN / REPRODUCED IN COMBAT.**
- **NEW visible NPC narrative defect:** `Ironband's Excavation` parchment title/body/objective and page 1/2 show, but green `Jern Hornhelm` overhead label crosses body and objective text, reducing readability; rendering owner and causality remain UNATTRIBUTED.
- **NEW target status population seen:** several small target effect icons adjacent to `Forest Lurker` target indicator in combat. Owner (`NativeDebuffs` vs ordinary/status lane) and native 2-column fit NOT established by still image. Pet secure interaction, native tooltip and special/combat protected behavior remain unproven.
- P0201 loadCount 256: Phase 0 Run All completed; Layout Check 19/29/0, H.2 13/13 measured; aura preview ON/OFF native ready/active restored; Native Access Check PASS; ownership 17 PASS / 18 STOCK / 0 FAIL for observed diagnostics. The P0202 ordinary screenshot showed no duplicate; both original bounded observations stay recorded.
- Previous P0197 ordinary loadCount 253 had four immediate OnShow refolds and no combat deferrals; P0201 loadCount 256 had zero OnShow events. Neither sampled the newly reported combat recurrence. The previously intermittent ObjectiveTracker flash remains OPEN. Preserve P0200/P0201 delivery failures and earlier negatives in historical records.

## Next Action
During naturally occurring combat **with the stock pet row visible**, run Phase H **Native Access Check** (`/logres nativeuicheck`) and record the addon-owned `petbar-reshow` audit counters. Without reloading, run the same action directly after combat and note whether stock disappears. If not possible in combat, capture immediately after and label timing. This establishes whether `OnShow`/`combatDeferred` are implicated and whether `recovered` is exercised before any implementation patch. Independently scope the green NPC world-label-over-quest occlusion and target status icon ownership; do not alter protected Blizzard surfaces, native auras, D-045 geometry or approved player-helpful artwork from a screenshot alone.

## Success Criteria
No redundant stock PetActionBar observed in supported ordinary Immersion ON, with functional native PET access and secure Logres pet controls; safe return to stock for unsupported modes. H.3 polish improves readability/layout while respecting source, interaction and state rules. Unobserved combat/special modes remain deferred, not PASS.

## Do Not Reopen Without New Evidence
No exact player HP, conventional health bar, enemy exact level/class/difficulty, secret inspection, unqualified Blizzard surface removal, broad hooks, polling or combat-unsafe mutation. PvP is a modifier, not Immersion OFF. Preserve party/class/pet/special/native/aura fallbacks until deliberately replaced.

## Relevant References

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
