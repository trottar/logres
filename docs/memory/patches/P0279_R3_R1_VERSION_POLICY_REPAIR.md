# P0279 R3 R1 — PREWRITE checker version-policy repair

Baseline `main`: P0279 R2 `90198c5c26ca38e7a642e69e0ae5575c88ad38e4`.

Original R3 applier ran PREWRITE and refused at 1/150: `check_checker_version_policy.py` rejected historical exact version `0.0.179-dev` embedded in the new R3 contract checker. No tracked file writes occurred. Reissue the identical R3 runtime/configuration patch with its R3 checker adjusted to check stable evidence markers instead of an exact historical version, and record refusal in `docs/memory/evidence/P0279_R3_R1_PREWRITE_VERSION_POLICY_FAILURE.md` and active repo memory. No global guard relaxation, Blizzard mutation, or separate scope expansion.

Guarded R3 R1 applier re-checks exact R2 HEAD and blobs, clean tracked state, runs all 150 checkers in shadow PREWRITE and live POSTWRITE, `git diff --check`, writes manifest, and rolls back on failure. No commits/pushes. Visual/lifecycle verification remains pending even when static checks pass.
