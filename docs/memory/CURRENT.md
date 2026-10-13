---
memory_schema: 1
as_of: 2026-10-13
project: logres
---

# Current State

## Active Objective
**Phase H: native pet unit/action fallback reliability remains OPEN / INTERMITTENT.** P0207 source/runtime audit is PUSHED at `f080661b`; R6 `0.0.112-dev` was an unaccepted local candidate with `petFrame:folded petActions:stock` and intermittent stock absence. P0208 R0 PREWRITE FAILED (wrong P0207 PATCH_INDEX blob pin) and R1 PREWRITE FAILED (incorrect uppercase trial-quarantine string predicate despite genuine blocked R6 module); R2 `0.0.113-dev` is a NEW, unvalidated fail-open runtime candidate, excluding both PetFrame and PetActionBar from Logres stock folding. It does not solve the reproduced P0197 in-combat duplicate. Preserve the rejected P0206 R0–R6 approaches and other H.3, quest, and aura findings.

## Current Work Item
P0207 DOCS-ONLY full pet lifecycle audit is **PUSHED / verified** at GitHub `main` `f080661b36bb1a3c3c3d6d0d261c42c0729c8f6a`. P0206 R6 remains **LOCAL / UNCOMMITTED / NOT ACCEPTED**. P0208 is a fail-open code candidate to release Blizzard PetFrame (unit/portrait) in addition to the R6 action-bar stock policy. No native pet parent, state driver, forced Show, combat protected mutation, polling, or protected presentation inspection is introduced. All 18 Phase H panel actions remain; the separate PET dock now reads PET STOCK. Runtime acceptance pending.

## Verified State
- P0207 exact client `1.60.1.70338` audit + loadCount 265: native `petFrame:folded petActions:stock`, trial QUARANTINED/armed=false and inconsistent user-visible Blizzard pet controls; no diagnostic taken while Immersion OFF. PetFrame and PetActionBar are different secure Blizzard frames with distinct source visibility rules. Current snapshot/stock-status strings are **not** direct visibility or click proof. See P0207 evidence.
- P0208 R0 prewrite failed due to author-pin mismatch on PATCH_INDEX (P0207 HEAD `8b2b13f`); R1 repaired pin but failed prewrite due to a mis-specified `QUARANTINED` source literal and nonrepresentative fixture; R2 verifies the exact quarantined R6 Lua SHA-256 and preserves strict HEAD blob checks. SOURCE CHANGE ONLY: `Native:Ready` rejects both stock pet domains; one-shot PET STOCK dock reconcile can restore addon snapshots out of combat. Native Access Check marks `petPolicy=stock/stock`, `petVisual=UNVERIFIED`. A clean `/reload` is required before visual validation.
- R0 panel checker failure, R1 rejected slash-only interface, R2 failed protected hidden-parent trial, R3 pinned checker, R4 ZIP missing payload, R5 incomplete stock release and R6 intermittent missing native pet remain negative results. P0197 combat overlap OPEN / REPRODUCED. Other Phase H concerns unchanged.

## Next Action
Apply P0208 over **P0207 pushed HEAD + uncommitted P0206 R6** only if all shadow static checkers pass; deploy and `/reload`. With an active visible pet, use Phase H Native Access Check for `petFrame:stock petActions:stock petPolicy=stock/stock petVisual=UNVERIFIED`. Use Phase D Immersion OFF and ON; separately inspect portrait/health/context menu and ability buttons/cast/autocast/drag/keybinds, world PET STOCK dock and Edit Mode exit, and BugCatcher. Capture actual user visual outcome; status alone cannot PASS. On missing UI or protected error STOP, retain failure; no forced stock Show/polling.

## Success Criteria
Both Blizzard pet surfaces visibly present and usable with a pet available and Immersion OFF, and safely available under Immersion ON without hidden click regions, Lua/taint/protected failures, or incorrect PET/Edit Mode restoration. Native visibility must be user observed, not inferred from diagnostics; unsupported contexts DEFERRED. Original combat duplication intentionally remains OPEN for a later distinct capability gate.

## Do Not Reopen Without New Evidence
No exact player HP, conventional health bar, enemy exact level/class/difficulty, secret inspection, unqualified Blizzard surface removal, broad hooks, polling or combat-unsafe mutation. PvP is a modifier, not Immersion OFF. Preserve party/class/pet/special/native/aura fallbacks until deliberately replaced.

## Relevant References

- `docs/memory/evidence/P0208_PET_STOCK_FAIL_OPEN_EVIDENCE.md`
- `docs/memory/patches/P0208_PET_STOCK_FAIL_OPEN.md`
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
