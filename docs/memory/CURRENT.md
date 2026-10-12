---
memory_schema: 1
as_of: 2026-10-11
project: logres
---

# Current State

## Active Objective
**Phase H.3 visual-fidelity review remains OPEN; P0200 R1 is pushed and its observed normal-session diagnostics passed.** P0196 R4 accepted target aura behavior and H.2 v4 ordinary composition remain established within their tested scope. Intermittent duplicate stock PetActionBar and ObjectiveTracker flash remain OPEN / INTERMITTENT / UNREPRODUCED; no new suppression is authorized.

## Current Work Item
P0200 R1 `0.0.109-dev` is **PUSHED on GitHub `main` `9776cf936224f772be581d2378bcbc91403c71dc`**. P0201 is a DOCS-ONLY acceptance of P0200's bounded diagnostic results from user `LOGRES_DIAGNOSTICS_LATEST.lua` loadCount 256. Its canonical record is `docs/memory/evidence/P0201_P0200_H3_RUNTIME_EVIDENCE.md`. H.3 *visual/interaction* acceptance is not yet established: no new full-screen screenshot or explicit visual assessment was submitted. No code/art/position changes in P0201.

## Verified State
- Latest `0.0.109-dev` Phase 0 Run All **completed** without reported Lua/protected/secret errors in the tested scope. Latest Layout Check: **19 anchors / 29 binds / 0 failures**; H.2 v4 placement APPLIED, **13/13** addon proxy regions measured. Earlier standalone Layout Check at loadCount 256 was 19/26/0.
- Phase H Status Aura Preview ON: 2 player and 4 target illustrative effects, native secure HARMFUL intentionally inactive. Preview OFF and Status Aura Check: PASS, native secure HARMFUL `ready=true active=true`. Real player harmful ordinary reads empty; target absent. Multi-icon native rendering and frame fit remain **DEFERRED**, not visually accepted.
- Native Access Check PASS with five folded domains, zero failures. Four candidate native surface folds, pet interaction ready, no pending/errors. Main secure normal candidate applied and routed, activations=4/restores=3/error=nil. UI Ownership 35 total: 17 PASS / 18 STOCK / 0 FAIL. STOCK is policy classification, not proof of native visibility.
- Latest `petbar-reshow` counters **onShow=0**, no combat-deferral/recovery exercised; the previous P0197 session observed four immediate refolds. The duplicate pet bar is still intermittent/unreproduced, not closed. Native control clicks, manual PET/BUFFS/TARGET fallback, combat/special modes, and an uncropped H.3 screen comparison are unobserved in the new upload.
- Historical P0200 R0 obsolete H.2 checker shadow FAIL happened before tracked writes; P0200 R1 pushed its correction. Earlier P0196 failures and ObjectiveTracker flash remain historical negative evidence.
- P0201 R0 docs-only delivery PREWRITE FAIL: generated `docs/ROADMAP.md` pinned Git blob SHA was 39 hex characters, so the guarded applier rejected it before tracked writes; R1 corrects to the verified 40-character blob. This is a packaging error, not a runtime result.

## Next Action
Record P0201 diagnostic acceptance without modifying runtime, then visually review **one uncropped, ordinary-screen screenshot** of deployed P0200 (`H.2 Map` overlay OFF). Compare approved harmful aura sheet-04 frame/2-column fit, percentage/name typography, action and dock hierarchy, and existing player buffs against D-039, maintaining D-045 v4 positions. When naturally available inspect populated harmful auras; missing source remains DEFERRED. Test native on-demand controls/Immersion OFF-ON if practicable. Correct only an observed defect; no blind art rewrite, forced gameplay or polling.

## Success Criteria
No redundant stock PetActionBar observed in supported ordinary Immersion ON, with functional native PET access and secure Logres pet controls; safe return to stock for unsupported modes. H.3 polish improves readability/layout while respecting source, interaction and state rules. Unobserved combat/special modes remain deferred, not PASS.

## Do Not Reopen Without New Evidence
No exact player HP, conventional health bar, enemy exact level/class/difficulty, secret inspection, unqualified Blizzard surface removal, broad hooks, polling or combat-unsafe mutation. PvP is a modifier, not Immersion OFF. Preserve party/class/pet/special/native/aura fallbacks until deliberately replaced.

## Relevant References

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
