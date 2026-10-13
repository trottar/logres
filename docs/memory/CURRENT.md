---
memory_schema: 1
as_of: 2026-10-13
project: logres
---

# Current State

## Active Objective
**Phase H: full PetFrame/PetActionBar ownership and restoration remains OPEN / INTERMITTENT.** P0206 R6 `0.0.112-dev` released `petActions` from Logres folding but `petFrame` remains folded; stock visibility after Immersion OFF is not reliable by user report. P0206 R2 protected-function error and R0/R3/R4 packaging failures remain negative results. P0197 combat duplication remains REPRODUCED. See P0207 full lifecycle audit; other H.3, quest and aura findings remain open.

## Current Work Item
P0205 is last verified **PUSHED** GitHub main `79a8e2308a37135b61db8ad8a0433cae5ec8b4bd`. P0206 R6 is an **UNCOMMITTED local runtime candidate**, not an accepted fix. P0207 is **DOCS-ONLY**, exact Forever 70338 PetFrame/PetActionBar + Edit Mode/Logres source and user `0.0.112-dev` loadCount 265 audit. Next runtime work: stop folding **PetFrame** while also retaining R6 PetActionBar stock fail-open, then test both separately. No combat-safe replacement suppressor authorized.

## Verified State
- Latest uploaded loadCount 265: native surfaces `petFrame:folded petActions:stock`, candidate `QUARANTINED`, `armed=false`; `uiownershipcheck` marks both pet domains STOCK with `observed=not inspected`. A snapshot/owner label is **not** actual stock visibility proof; user reports intermittent missing native controls after Immersion OFF and transient Edit Mode/PET restoration. No OFF-state native check was captured. **FAIL/OPEN**, not PASS.
- Exact Forever XML/source: `PetFrame` is a secure child of `PlayerFrame`, with independent `UpdateShownState()` conditions (visible pet, `PetUsesPetFrame`, vehicle, Edit Mode). `PetActionBar` is Edit Mode-owned `UIParent` root with 10 secure buttons and pet-event Show/Hide. Edit Mode may temporarily force native appearance; cause of reported transitions is unverified.
- Native:Fold saves opaque `IsShown` token; Restore passes it to SetShown unchanged. This can restore historical visibility instead of native current policy. Do **not** inspect protected presentation to prove it. `PlayerFrameReplacement` suppresses player content containers, **not whole PlayerFrame parent**; no attribution of PetFrame absence to alpha by itself.
- P0206 R0 15-action panel overflow; R1 slash-only panel design rejected; R2 protected error and restoration failure; R3 checker runtime pin; R4 missing payload; R5 still-folded pet actions and failed stock access; R6 PetFrame still folded and intermittent absence. Preserve failures exactly. Full matrix: `docs/memory/evidence/P0207_PET_UI_FULL_LIFECYCLE_AUDIT.md`.

## Next Action
Build one narrow **capability-gated fail-open runtime checkpoint**: keep native PetActionBar stock-owned and **release native PetFrame** because the HUD pet row/secure target overlay does not replace all its information and interaction. Restore existing snapshots only out of combat, and verify from a clean `/reload`. Keep all 18 Phase H panel actions. Independently validate portrait/health/menu and pet abilities/binds/autocast/drag through Immersion OFF/ON, PET dock and Edit Mode, plus incidental combat. Native visibility is **user-visual unverified** unless actually observed; no secret/protected visibility inspection, direct combat mutation, polling, blanket hooks or further hidden-parent trial.

## Success Criteria
With pet available, **both** native PetFrame and PetActionBar are independently visible/clickable with Immersion OFF and remain accessible in any unsupported Immersion ON state; no Lua/taint/protected-action errors and PET/Edit Mode restoration works. A diagnostics policy PASS alone is insufficient. P0197 duplicate remains OPEN until a later distinct combat-safe handoff is proved. Unreproduced special cases remain DEFERRED.

## Do Not Reopen Without New Evidence
No exact player HP, conventional health bar, enemy exact level/class/difficulty, secret inspection, unqualified Blizzard surface removal, broad hooks, polling or combat-unsafe mutation. PvP is a modifier, not Immersion OFF. Preserve party/class/pet/special/native/aura fallbacks until deliberately replaced.

## Relevant References

- `docs/memory/evidence/P0207_PET_UI_FULL_LIFECYCLE_AUDIT.md`
- `docs/memory/patches/P0207_PET_UI_FULL_LIFECYCLE_AUDIT.md`

- `docs/memory/patches/P0206_R6_STOCK_PET_FAIL_OPEN.md`
- `docs/memory/evidence/P0206_R5_STOCK_PET_RESTORE_FAILURE.md`
- `docs/memory/patches/P0206_R5_PAYLOAD_DEPENDENCY_REPAIR.md`
- `docs/memory/patches/P0206_R4_CHECKER_POLICY_REPAIR.md`
- `docs/memory/patches/P0206_R3_CORRECTIVE_QUARANTINE.md`
- `docs/memory/evidence/P0206_R2_RUNTIME_FAILURE.md`
- `docs/memory/patches/P0206_PET_COMBAT_CANDIDATE.md`
- `docs/memory/evidence/P0206_RUNTIME_CANDIDATE_EVIDENCE.md`
- `docs/memory/patches/P0205_PET_COMBAT_SOURCE_AUDIT.md`
- `docs/memory/evidence/P0205_FOREVER_PET_COMBAT_SOURCE_AUDIT.md`
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
