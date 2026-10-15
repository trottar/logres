---
memory_schema: 1
as_of: 2026-10-13
project: logres
---

# Current State

## Active Objective
**P0210 WORKTREE RECONCILIATION (2026-10-14; LOCAL, DOCS/IGNORE ONLY):** GitHub main is P0208 `f6b9a3a`; P0209 R8 `0.0.120-dev` remains uncommitted. User confirms Blizzard PetFrame/PetActionBar absent after initial Immersion-ON `/reload` and again after Immersion OFF -> ON: ordinary visible behavior observed. Combat, PET STOCK, Edit Mode, native secure interaction and taint remain UNVERIFIED by this report. Preserve prior pet failures and candidate source/checkers/evidence. P0210 ignores temporary patch extraction/Windows sidecars without deletion or staging. See `docs/memory/evidence/P0210_WORKTREE_RECONCILIATION.md`.

**P0209 R8 LOCAL CORRECT-DIRECTION CANDIDATE (2026-10-14):** User loadCount 276 demonstrated R7 first-ON native relocation and second-ON removal of Logres pet controls, but this was the OPPOSITE of required Immersion ownership; R7 IS NOT ACCEPTED. R8 0.0.120-dev keeps Logres secure pet-action buttons visible during Immersion ON and attempts secure constant-hidden visibility on Blizzard PetFrame and PetActionBar, with PET STOCK access and Immersion OFF native release. No direct native Hide/Show, reparent, combat Lua mutation, polling, or protected presentation inspection. Native PetFrame driver registration is CLIENT-UNVERIFIED; static success is not acceptance. Require WoW ON, OFF, combat, pet clicks, Edit Mode, PET STOCK and taint tests. P0197/P0206/P0209 negatives preserved. Evidence `docs/memory/evidence/P0209_R8_IMMERSIVE_PET_OWNERSHIP_EVIDENCE.md`.

**P0209 R7 LOCAL TWO-STEP PET HANDOFF (2026-10-14):** R6 `0.0.118-dev` loadCount 275 **SCOPED IN-GAME STAGING PASS**: with a pet active, ON staged the native pet bar at the class/pet anchor while Logres buttons remained; OFF restored the previous arrangement. Logres reported `activations=1 restores=1 failures=0`, and user confirmed the two screenshots worked as expected. This does NOT establish native clicks, combat or Edit Mode safety. R5 hide-on-first-ON remains a preserved runtime visual failure. R7 `0.0.119-dev`, default OFF, keeps the R6 first ON as a fail-open visibility stage and requires a SECOND explicit ON after user visual confirmation before calling the existing addon-owned `Probe:HideProbe` to remove duplicates. OFF restores the native anchor first and re-arms Logres. No automatic suppression, native reparent, combat swap, native state inspection or combat-time protected mutation. All prior R0–R6/P0206/P0197 negatives preserved. NO PUSH until Phase H runtime proof. See `docs/memory/evidence/P0209_R7_TWO_STEP_HANDOFF_EVIDENCE.md`.

**Phase H: pet-action native ownership unresolved.** P0208 stock fail-open is last PUSHED baseline `f6b9a3a`. P0209 R2 was runtime-tested and failed combat continuity by deliberately swapping Logres away during combat. R3 now tests one Blizzard-native pet bar at Logres's established class/pet anchor. Keep P0206/P0209 failures and P0197 duplicate OPEN; do not conflate static PASS with WoW acceptance.

## Current Work Item
**P0209 R8 LOCAL CORRECT-DIRECTION CANDIDATE (2026-10-14):** User loadCount 276 demonstrated R7 first-ON native relocation and second-ON removal of Logres pet controls, but this was the OPPOSITE of required Immersion ownership; R7 IS NOT ACCEPTED. R8 0.0.120-dev keeps Logres secure pet-action buttons visible during Immersion ON and attempts secure constant-hidden visibility on Blizzard PetFrame and PetActionBar, with PET STOCK access and Immersion OFF native release. No direct native Hide/Show, reparent, combat Lua mutation, polling, or protected presentation inspection. Native PetFrame driver registration is CLIENT-UNVERIFIED; static success is not acceptance. Require WoW ON, OFF, combat, pet clicks, Edit Mode, PET STOCK and taint tests. P0197/P0206/P0209 negatives preserved. Evidence `docs/memory/evidence/P0209_R8_IMMERSIVE_PET_OWNERSHIP_EVIDENCE.md`.

**P0209 R7 LOCAL TWO-STEP PET HANDOFF (2026-10-14):** R6 `0.0.118-dev` loadCount 275 **SCOPED IN-GAME STAGING PASS**: with a pet active, ON staged the native pet bar at the class/pet anchor while Logres buttons remained; OFF restored the previous arrangement. Logres reported `activations=1 restores=1 failures=0`, and user confirmed the two screenshots worked as expected. This does NOT establish native clicks, combat or Edit Mode safety. R5 hide-on-first-ON remains a preserved runtime visual failure. R7 `0.0.119-dev`, default OFF, keeps the R6 first ON as a fail-open visibility stage and requires a SECOND explicit ON after user visual confirmation before calling the existing addon-owned `Probe:HideProbe` to remove duplicates. OFF restores the native anchor first and re-arms Logres. No automatic suppression, native reparent, combat swap, native state inspection or combat-time protected mutation. All prior R0–R6/P0206/P0197 negatives preserved. NO PUSH until Phase H runtime proof. See `docs/memory/evidence/P0209_R7_TWO_STEP_HANDOFF_EVIDENCE.md`.

R3 (0.0.115-dev) is an **opt-in / default-OFF / runtime-UNVERIFIED** source-based native-button reuse trial. In the manner of Dominos, use Blizzard's own secure pet buttons, but unlike Dominos do **not** reparent secure children or hide their native ancestor. Instead move the intact stock `PetActionBar` to the existing Logres classPet layout anchor only out of combat, and hide the duplicate Logres pet-action probe. The native bar and buttons remain active through combat; no reciprocal driver and no stock Show/Hide. OFF, Immersion OFF, PET STOCK and Edit Mode enter attempt restoration of the original native anchor (captured and passed as opaque GetPoint(1) token). PetFrame remains fully Blizzard-owned. Existing 18 Phase H actions preserved. If a protected operation fails, retain native controls and mark RUNTIME FAIL; do not commit.

## Verified State
**P0209 R8 LOCAL CORRECT-DIRECTION CANDIDATE (2026-10-14):** User loadCount 276 demonstrated R7 first-ON native relocation and second-ON removal of Logres pet controls, but this was the OPPOSITE of required Immersion ownership; R7 IS NOT ACCEPTED. R8 0.0.120-dev keeps Logres secure pet-action buttons visible during Immersion ON and attempts secure constant-hidden visibility on Blizzard PetFrame and PetActionBar, with PET STOCK access and Immersion OFF native release. No direct native Hide/Show, reparent, combat Lua mutation, polling, or protected presentation inspection. Native PetFrame driver registration is CLIENT-UNVERIFIED; static success is not acceptance. Require WoW ON, OFF, combat, pet clicks, Edit Mode, PET STOCK and taint tests. P0197/P0206/P0209 negatives preserved. Evidence `docs/memory/evidence/P0209_R8_IMMERSIVE_PET_OWNERSHIP_EVIDENCE.md`.

**P0209 R7 LOCAL TWO-STEP PET HANDOFF (2026-10-14):** R6 `0.0.118-dev` loadCount 275 **SCOPED IN-GAME STAGING PASS**: with a pet active, ON staged the native pet bar at the class/pet anchor while Logres buttons remained; OFF restored the previous arrangement. Logres reported `activations=1 restores=1 failures=0`, and user confirmed the two screenshots worked as expected. This does NOT establish native clicks, combat or Edit Mode safety. R5 hide-on-first-ON remains a preserved runtime visual failure. R7 `0.0.119-dev`, default OFF, keeps the R6 first ON as a fail-open visibility stage and requires a SECOND explicit ON after user visual confirmation before calling the existing addon-owned `Probe:HideProbe` to remove duplicates. OFF restores the native anchor first and re-arms Logres. No automatic suppression, native reparent, combat swap, native state inspection or combat-time protected mutation. All prior R0–R6/P0206/P0197 negatives preserved. NO PUSH until Phase H runtime proof. See `docs/memory/evidence/P0209_R7_TWO_STEP_HANDOFF_EVIDENCE.md`.

P0209 R0 memory-health PREWRITE FAIL; R1 61/60 Lua upvalue PREWRITE FAIL; R2 applied and ran in WoW (`0.0.114-dev`, loadCount 269) but **RUNTIME FAIL for intended combat behavior**: pressing trial ON removed the Blizzard pet bar out of combat, then the `[combat] show; hide` native / `[combat] hide; show` Logres state drivers removed Logres pet actions and showed Blizzard's bar during combat. This was the authored reciprocal policy and contrary to user intent. No push. P0208 `f6b9a3a` remains the verified HEAD. P0197 combat duplicate remains OPEN. See `docs/memory/evidence/P0209_R3_NATIVE_REUSE_EVIDENCE.md`.

**Existing-addon evidence:** Dominos `Dominos/bars/petBar.lua` reuses native secure pet buttons; Bartender4 `PetBar.lua` and `HideBlizzard.lua` use a stable pet bar rather than swapping it out in combat. Neither codebase authorizes transplanting their hidden-parent setup into Logres. R3 reversible reanchoring remains a new runtime hypothesis.

## Next Action
**P0209 R8 LOCAL CORRECT-DIRECTION CANDIDATE (2026-10-14):** User loadCount 276 demonstrated R7 first-ON native relocation and second-ON removal of Logres pet controls, but this was the OPPOSITE of required Immersion ownership; R7 IS NOT ACCEPTED. R8 0.0.120-dev keeps Logres secure pet-action buttons visible during Immersion ON and attempts secure constant-hidden visibility on Blizzard PetFrame and PetActionBar, with PET STOCK access and Immersion OFF native release. No direct native Hide/Show, reparent, combat Lua mutation, polling, or protected presentation inspection. Native PetFrame driver registration is CLIENT-UNVERIFIED; static success is not acceptance. Require WoW ON, OFF, combat, pet clicks, Edit Mode, PET STOCK and taint tests. P0197/P0206/P0209 negatives preserved. Evidence `docs/memory/evidence/P0209_R8_IMMERSIVE_PET_OWNERSHIP_EVIDENCE.md`.

**P0209 R7 LOCAL TWO-STEP PET HANDOFF (2026-10-14):** R6 `0.0.118-dev` loadCount 275 **SCOPED IN-GAME STAGING PASS**: with a pet active, ON staged the native pet bar at the class/pet anchor while Logres buttons remained; OFF restored the previous arrangement. Logres reported `activations=1 restores=1 failures=0`, and user confirmed the two screenshots worked as expected. This does NOT establish native clicks, combat or Edit Mode safety. R5 hide-on-first-ON remains a preserved runtime visual failure. R7 `0.0.119-dev`, default OFF, keeps the R6 first ON as a fail-open visibility stage and requires a SECOND explicit ON after user visual confirmation before calling the existing addon-owned `Probe:HideProbe` to remove duplicates. OFF restores the native anchor first and re-arms Logres. No automatic suppression, native reparent, combat swap, native state inspection or combat-time protected mutation. All prior R0–R6/P0206/P0197 negatives preserved. NO PUSH until Phase H runtime proof. See `docs/memory/evidence/P0209_R7_TWO_STEP_HANDOFF_EVIDENCE.md`.

Apply P0209 R3 over exact **uncommitted R2** working tree (P0208 remains Git HEAD); require complete shadow repository checkers. Deploy, `/reload`, check default OFF, enable Native Pet Bar ON only out of combat with pet present. Verify one bar using native buttons, secure clicks, no combat disappearance, OFF anchor restore, Immersion OFF and PET STOCK release, Edit Mode with trial OFF and BugCatcher. Do not push on failure. Do not manufacture combat proof.

## Success Criteria
Only one interactive native secure pet bar in Immersion ON, positioned at Logres classPet anchor, never replaced by a second bar at combat entry, plus usable native PetFrame and reliable out-of-combat anchor restore. No orphan click region, taint/Lua/protected error, stale EditMode state or lost native buttons. Unsupported cases DEFERRED, runtime negative FAIL. Visual proof is required.

## Do Not Reopen Without New Evidence
No native hidden ancestor/reparent, direct combat Hide, broad OnShow reassertion, polling, secret-capable visibility inspection, or removing stock secure fallback. Preserve H.2 v4 anchors/art, target/party/pet auras and all 18 Phase H controls. PetFrame replacement is separate capability work.

## Relevant References
- `docs/memory/evidence/P0209_R8_IMMERSIVE_PET_OWNERSHIP_EVIDENCE.md`
- `docs/memory/patches/P0209_R8_IMMERSIVE_PET_OWNERSHIP.md`
- `docs/memory/evidence/P0209_R7_TWO_STEP_HANDOFF_EVIDENCE.md`
- `docs/memory/patches/P0209_R7_TWO_STEP_HANDOFF.md`
- `docs/memory/evidence/P0209_R6_NATIVE_ANCHOR_VISIBILITY_ISOLATION.md`
- `docs/memory/patches/P0209_R6_NATIVE_ANCHOR_VISIBILITY_ISOLATION.md`
- `docs/memory/evidence/P0209_R5_EDITMODE_INITIAL_NIL_EVIDENCE.md`
- `docs/memory/patches/P0209_R5_EDITMODE_INITIAL_NIL_REPAIR.md`
- `docs/memory/evidence/P0209_R4_EDITMODE_GATE_EVIDENCE.md`
- `docs/memory/patches/P0209_R4_EDITMODE_GATE_REPAIR.md`
- `docs/memory/evidence/P0209_R3_NATIVE_REUSE_EVIDENCE.md`
- `docs/memory/patches/P0209_R3_NATIVE_REUSE.md`
- `docs/memory/evidence/P0209_RECIPROCAL_PETBAR_DRIVER_CANDIDATE.md`
- `docs/memory/patches/P0209_RECIPROCAL_PETBAR_DRIVER_TRIAL.md`

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
