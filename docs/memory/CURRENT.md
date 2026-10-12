---
memory_schema: 1
as_of: 2026-10-11
project: logres
---

# Current State

## Active Objective
**Phase H.3 whole-screen visual fidelity remains OPEN; P0200 R1 source is pushed and P0201 diagnostics are accepted in their tested scope.** One P0202 ordinary screenshot has now been visually reviewed: no blocking overlap apparent, but faint compass labels on bright sky and heavy empty action-slot chrome are grounded presentation concerns. P0197 duplicate stock PetActionBar and ObjectiveTracker flash remain OPEN / INTERMITTENT / UNREPRODUCED.

## Current Work Item
P0201 R1 is **PUSHED and verified** at GitHub `main` `826ff576567036a4e5d5c5a7c3c13dc1a299d0ca` (docs-only bounded P0200 `0.0.109-dev` evidence). **P0202 is a DOCS-ONLY screenshot visual review candidate**, not a runtime fix or full visual-fidelity PASS. Canonical new record: `docs/memory/evidence/P0202_H3_SCREENSHOT_VISUAL_EVIDENCE.md` (user image 1907x1192, 16:10; original file remains in conversation). Preserve D-045 v4 positions and approved player helpful artwork.

## Verified State
- P0200 R1 `0.0.109-dev` Phase 0 Run All completed; Layout Check 19 anchors / 29 binds / 0 failures, H.2 13/13 measured; Status Aura Preview ON/OFF and native ready/active restoration passed; native access check PASS; Main normal candidate active; UI Ownership 17 PASS / 18 STOCK / 0 FAIL within those diagnostic scopes. Source: P0201 canonical evidence.
- The P0202 screenshot visibly shows active quest and native dock **separated without obvious overlap**, top-center compass, readable slim percentage/name bars, one retained authored player helpful frame, and lower action/pet controls. No obvious clipped action button or duplicate stock PetActionBar is visible in this single frame.
- **Concerns, not functional FAIL:** compass text/ticks faint against a bright sky; empty bronze action frames dominate lower-left density. At 16:10, screenshot does not grant pixel-perfect D-045 16:9 placement acceptance.
- **DEFERRED:** actual populated harmful icons/two-column fit, native/aura tooltips, button clicks, combat/special modes and Immersion OFF/ON visual restoration. P0197 pet reappearance and ObjectiveTracker flash remain OPEN / INTERMITTENT / UNREPRODUCED; do not implement polling or broad hooks.
- Historical negative results (P0201 R0 truncated SHA; P0200 R0 checker failure; earlier P0196 issues) remain in P0201/P0200 and investigations. P0202 adds no Lua, TGA or version change.

## Next Action
Apply/commit/push this docs-only P0202 observation checkpoint with no WoW redeploy. For any further H.3 polish, first narrow a safe contrast/empty-frame styling hypothesis grounded in the screenshot, respecting existing source/secure/native accessibility and D-045 positions; no automatic feature suppression or speculative layout rewrite. Naturally populated harmful aura art remains environmentally DEFERRED. Whole-screen and cross-state visual acceptance stay OPEN pending appropriate evidence.

## Success Criteria
No redundant stock PetActionBar observed in supported ordinary Immersion ON, with functional native PET access and secure Logres pet controls; safe return to stock for unsupported modes. H.3 polish improves readability/layout while respecting source, interaction and state rules. Unobserved combat/special modes remain deferred, not PASS.

## Do Not Reopen Without New Evidence
No exact player HP, conventional health bar, enemy exact level/class/difficulty, secret inspection, unqualified Blizzard surface removal, broad hooks, polling or combat-unsafe mutation. PvP is a modifier, not Immersion OFF. Preserve party/class/pet/special/native/aura fallbacks until deliberately replaced.

## Relevant References

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
