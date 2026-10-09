# P0174 R2 — tracker/cast re-show correction

Date 2026-10-08. Baseline: P0174 `0.0.90-dev` applied but not committed; remote main P0173 `f9c99685f72fa8aacd3cb40b69548a7450ad516f`. No version bump; corrective revision. **RUNTIME PENDING.**

R1 delivery failure (preserved): the user ran the P0174 R1 applier and its shadow checker failed in `tools/check_memory_health.py` because R1 generated `CURRENT.md` lacked the mandatory `## Success Criteria` and `## Relevant References` headings. There were no R1 tracked writes. R2 fixes that delivery defect, preserves the same runtime repair design, and remains pending full static shadow checks and in-game validation.

Negative result: first P0174 screenshot shows full `All Objectives / Quests` native tracker overlaying Logres dock despite a captured native-access snapshot. User reports intermittent hide/re-show, native cast bars reappearing during combat, stock aura/buff surfaces and absent enemy aura display. P0174's event-targeted re-fold does not necessarily execute after Blizzard's final Show() call. Combat intentionally refuses protected stock mutations. Do not write that P0174 fixed either behavior.

Change: `NativeAccess:InstallRefoldHooks()` targets only ObjectiveTrackerFrame, PlayerCastingBarFrame, OverlayPlayerCastingBarFrame and TargetFrameSpellBar. Hooks do not inspect visibility; after an actual Show outside lockdown, they Hide only when Immersion desires the domain folded, user has not opened it, and the original restoration snapshot exists. During explicit Restore, `restoring[key]` prevents immediate hook re-hide. OnShow in combat leaves stock visible, marks pending, and relies on PLAYER_REGEN_ENABLED reconciliation. `nativeuicheck` shows native show/refold/deferral/pending counts and cannot PASS while a pending re-fold remains. Frame creation/addon load is handled without polling. All native information is accessible on demand.

Do not infer cast-in-combat suppression or aura ownership. D-041 requires preservation of all unproven harmful/private/group auras, target status and enemy special effects. P0174 R2 intentionally does not suppress BuffFrame/DebuffFrame/target auras or pretend they are replaced.

One-time applier verifies full locally-applied P0174 manifest hashes and still-unchanged Git HEAD before writes; prepares exact candidate in a shadow clone including the existing uncommitted P0174 modifications; runs all static checkers and `git diff --check` before writes and after writes; transactional rollback for R2-owned changes. Generates P0174_R2_MANIFEST.txt; no Git commits/pushes.
