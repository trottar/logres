# P0279 R3 R1 — original R3 PREWRITE version-policy refusal

Date: 2026-10-20. Baseline: verified pushed `main` `90198c5c26ca38e7a642e69e0ae5575c88ad38e4` (P0279 R2).

## Observed WSL failure

User ran the original `P0279_R3_PORTRAIT_EXPLICIT_OWNER.zip`; archive SHA-256 verified and extraction completed. Its guarded applier reported `P0279 R3: PREWRITE whitespace PASS`, then **REFUSED/FAILED PREWRITE: 1/150 static checkers failed**, checker `27/150 check_checker_version_policy.py`:

```
ERROR: tools/check_p0279_r3_explicit_portrait_owner_contract.py freezes historical runtime version(s): 0.0.179-dev
```

The new P0279 R3 checker required the text `0.0.179-dev` inside the R3 evidence via an exact version string literal in its checker source; the existing repository version-policy checker legitimately rejects ANY exact `0.0.N-dev` in contract checkers, so the rejection is a packaging/static-contract defect, not a WoW failure. **Applier failed before tracked writes; no tracked files were modified, and no R3 runtime or mapping behavior was tested**. Preserve this failure rather than calling R3 passed.

## Narrow correction

R3 R1 removes the runtime-version literal from the new P0279 R3 contract checker's `for marker` assertion while preserving the durable historical version in this evidence and in R3 evidence. The corrected checker still verifies the exact observed size gate (`native-owner-outside-size-gate`), repeated result, `ClassTrainerFrame`, native immutability, and explicit-owner-only mapping. No native behavior, R3 Lua source, eligibility gate, layout, transaction, or visual styling is changed from the original R3 candidate. The original R2 baseline remains the required git HEAD.

## Evidence and acceptance

The checker failure was reproduced as a static source-policy conflict and removed in the replacement candidate. Local syntax/archive/synthetic-candidate and version-policy checker validation are not the complete suite. R3 R1's **full 150 static PREWRITE/POSTWRITE checks and WoW portrait runtime are pending WSL/in-game validation**. Stop on any further refusal and preserve its exact output. On acceptance, verify the user's pushed commit on `main` before advancing.
