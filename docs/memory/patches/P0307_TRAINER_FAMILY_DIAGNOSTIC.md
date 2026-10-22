# P0307 — one-shot trainer family compatibility diagnostic

- P0306 class trainer parking user-visible PASS; fishing profession stock-only observation remains OPEN for targeted classification.
- Exact baseline `5acc447da13252fc651945033f4bb4c7b33b6add`. Candidate `0.0.208-dev`.
- Add one read-only family adapter probe and H-panel command/action without touching trainer UI, class train purchases, native parking, camera or quest.
- Guarded applier requires clean baseline + expected blobs, prewrites and postwrites all static checks and git diff --check, records manifest and rolls back on failure; never commits or pushes.
- Expected in-client result is diagnostics text, not a changed trainer surface. WSL and WoW runtime UNVERIFIED until tested.
- Positive/negative evidence stays canonical in `docs/memory/evidence/P0307_TRAINER_FAMILY_DIAGNOSTIC.md`.

## R0 failure / R1 repair

R0 PREWRITE FAIL (unexpected checker count 178), no tracked writes. Verified baseline has 177 checkers; candidate adds one. R1 removes erroneous 179 minimum and requires exact baseline-plus-P0307 checker set, executing each PREWRITE/POSTWRITE. Full tests UNVERIFIED.
