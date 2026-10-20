# P0276 R3 — R2 checker/source self-mismatch

Date: 2026-10-20. Verified pushed baseline: P0275 `75e8024`.

**Observed R2 result — PREWRITE FAIL / NO TRACKED WRITE:** User WSL log shows existing local P0276 R0 candidate EXACT-MATCH and PREWRITE hygiene PASS, then checker 109/144 `check_p0276_r1_native_trainer_skin_contract.py` FAILED on the obsolete token `region ~= nil and ordinary(region)`. Lua already uses `if ordinary(region) and region ~= nil and not assetPieces[region] then`; the SAME static checker also separately required that corrected expression. This is an **assistant-created self-contradictory checker**, not a client-proven runtime defect, not a skin visual PASS and not an R2 installation. R1 dirty-baseline refusal and P0274/P0275 rejected visuals remain historical evidence.

Correction: replace the obsolete checklist token with the exact ordinary-first source branch. Preserve the independent safety condition, D-046/D-047 ownership, R2 exact-R0/clean baseline logic, transactional rollback and no remote Git writes. Add a self-consistency gate before full static checks, and report ALL checker failures at once. No Lua semantics altered by this correction.

**Acceptance:** R3 WSL shadow/prewrite, postwrite and WoW runtime/visual are UNVERIFIED until user actually runs them. Protected/secret-value errors, native UI regression, restoration errors, taint, or missing controls are FAIL. Successful art activation alone is not visual acceptance. No native training transaction ownership, no camera change, and no automatic landscape reflow.
