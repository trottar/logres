# P0206 R4 — Fix checker version policy; preserve pet fallback quarantine

Baseline: verified `main` `79a8e2308a37135b61db8ad8a0433cae5ec8b4bd` (P0205); local working tree contains uncommitted **P0206 R2**. Do not commit R2 or attempt to run its native-parent trial again.

## R3 failed prewrite (static; observed)

R3 verified the exact R2 baseline, prepared 15 candidate files, and passed the static checkers printed through `check_cast_visual_contract.py`. The next checker, `tools/check_checker_version_policy.py`, failed because the R3-authored `tools/check_pet_combat_candidate_contract.py` contained an **exact `0.0.111-dev` version pin**. R3 printed `APPLY FAIL: SHADOW CHECK FAILED check_checker_version_policy.py`. No corrected tracked contents were written; R2 remains uncommitted and unsafe. This is a patch-generation/contract authoring error, not evidence of a new WoW runtime problem.

## R4 correction and limits

The R4 contract verifies Bootstrap/TOC versions both parse and **match one another**; it must not require a hard-coded historical version. The prepared candidate runtime remains `0.0.111-dev` as authored by R3. All existing R3 quarantine behaviors are retained: no native parent mutation, Trial ON rejected, all 18 developer-panel Phase H controls retained, stock NativeSurfaceReplacement restored to exact pushed P0205, and P0197 combat duplication still OPEN. R2 failed stock restoration and coincided with the generic BugCatcher protection error; no precise protected call site has been identified. R3 was a static delivery failure and produced no runtime evidence. R4 is likewise **NOT YET RUNTIME TESTED**.

The R4 applier requires the pinned P0205 HEAD and exact **uncommitted R2 candidate** bytes, runs all repository checkers in a candidate shadow before tracked writes, validates whitespace and emits `P0206_MANIFEST.txt`. The full static checker suite is only accepted after it actually completes on the user checkout. After R4 succeeds, deploy and `/reload`, then use the **Phase H developer panel** (Trial Check / Trial ON BLOCKED / Trial OFF / Native Access Check), native PET dock, Phase D Immersion OFF/ON and BugCatcher to verify stock pet-control restoration. Any protected-action error, missing stock pet controls, or unusable controls = FAIL and no commit.

## R4 delivery result — PREWRITE FAIL (observed)

The user applied the distributed R4 ZIP on the uncommitted R2 candidate. It stopped with `P0206 R4 APPLY FAIL: [Errno 2] No such file or directory: .../P0206_R4_PAYLOAD/check_pet_combat_candidate_contract.py`. The R4 builder deliberately excluded this original checker although its applier's R2 baseline reconstruction iterates `r2.NEW` and requires the file. The corrected R4 checker under the separate `_R4.py` name cannot substitute for the original R2 checker because the latter is required to establish exact expected R2 bytes. **No R4 tracked-file writes occurred; the uncommitted R2 candidate remains in place.** This is a package-dependency validation failure, not a new WoW runtime result. See `docs/memory/patches/P0206_R5_PAYLOAD_DEPENDENCY_REPAIR.md`.
