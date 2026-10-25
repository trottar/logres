# P0340 — Pre-freeze internal installation/readiness audit

**Baseline:** GitHub `main` P0339 `8a5d3f86c557745de6b2e61bf7a5f0273930c129`, pushed 2026-10-25. P0339 manifest records 210/210 PREWRITE and POSTWRITE static checks; WoW runtime remains UNVERIFIED, and the November 4 client opportunity is contingent.

## Source findings

- `Logres/Logres.toc` loads 94 unique Lua modules; GitHub tree contains every declared path. The repository tree contains 40 staged image/font assets in `Logres/Media` (4,360,512 Git tree bytes), `Logres/Camera/LIBCAMERA_NOTICE.txt`, and the external QuestieDB data addon is not bundled. Existing P0328 `stage_alpha_candidate.py` stages only TOC-loaded Lua, asset media and attribution, plus an internal-only notice; ignored `dist/` is for QA output, not public distribution.
- `README.md` still states that P0226 is *only diagnostic and does not yet add database compass icons*. This was accurate historically but is now demonstrably stale: later P0230–P0231 introduced conditional QuestieDB historical coordinates, and P0337 gates possible historical quest-giver presentation using current native offer corroboration. QuestieDB is **optional**; historical locations never prove quest eligibility. The source-accurate dependency/version/install procedure remains `docs/DEPENDENCIES.md`.
- Root `LICENSE`/`LICENSE.md`/`COPYING` is absent on verified `main`: **L-019 remains an unresolved public-distribution blocker**. Existing `README.md` has no functional five-domain controls; D-048 selectors and migration are not implemented. Actual Forever clean-install, native restoration (P0321), combat, camera, and gameplay P0330–P0338 remain UNVERIFIED. No release is approved.

## Narrow offline remedy

Correct obsolete README install/feature claims; add `tools/alpha_prefreeze_audit.py`, a **read-only** A0/A3 inventory check that calls existing `stage.collect`, reconstructs the same deterministic ZIP entirely in memory (never writes a ZIP), compares every extracted member to the source rows, validates CRC and notice, checks optional QuestieDB exclusion and LibCamera attribution, and emits an internal SHA-256 and conspicuous L-019/runtime/public gate disclosures. Add source contract #211, update launch prefreeze commands and current memory. No change to the existing stage tool, addon code/TOC, game deployment, API, native state or license terms. A local byte-level staging PASS is not real-client or release PASS.

## Failure and deferral ledger

No new negative in-client result exists; the closed Forever beta does not permit one. A stale README feature statement was independently observed as an installation-documentation defect and is corrected. Earlier refused P0337/P0338 ZIPs retain their original failures and evidence. New P0340 guard/checker and WSL full 211-checker PREWRITE shadow/POSTWRITE results must be observed before asserting static PASS. L-019 must be resolved by the project owner before any public release; neither staging nor a future license file alone substitutes for an explicit distribution approval. L-022 screenshot and L-027 transient frame ownership remain OPEN, P0321 GossipFrame runtime remains DEFERRED.

## Next evidence

Run the full 211-checker WSL suite and `python3 tools/alpha_prefreeze_audit.py` / `python3 tools/stage_alpha_candidate.py --check` before an internal Nov 3 freeze if the source is unchanged. On the contingent November 4 client, validate P0321 native GossipFrame restoration first, then inspect other issues using `NOV04_GAMEPLAY_REGRESSION_MATRIX.md`. Do not auto-generate a public ZIP, require forced in-game travel, or modify frozen D-047 camera.
