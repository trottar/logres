# P0273 — Native gossip continuity within existing opt-in service placement

Baseline: verified `main` `c5ef384530fc452e37102cc11e395c63c37bb3e9` (partially recorded P0272 runtime). No Git commit/push by applier.

Changes: extend existing stock-native gated controller to gossip type 3; keep merchant type 5 / trainer type 7 and same center, anchors and restoration. Surface gossipStarts/gossipRestores in existing H-panel diagnostics. Historical P0271/P0272 static contracts migrated, missing P0272 checker and docs reconstructed without claiming its original WSL gate. Add P0273 contract; synchronize CURRENT, handoff, investigation, roadmap, evidence, patch index. Set version 0.0.171-dev. Camera, quest ownership, native children/actions, bank, auction, flight remain byte-identical.

Validation: guarded applier requires exact baseline, clean tracked index, frozen file hashes; prewrite entire checker suite in candidate and postwrite suite; `git diff --check`, hashes and manifest. WoW runtime UNVERIFIED until the user's actual gossip->trainer/merchant, OnHide and auto OFF checks. Any failure requires corrective patch, not silent promotion.

## R0 shadow static gate failure — OPEN then corrected by R1

- **Attempt:** original P0273 R0 ZIP at verified main `c5ef384`, user ran the guarded WSL applier on 2026-10-19. It completed baseline and 18-path candidate preparation, then stopped at prewrite checker 1/140.
- **Observed error:** `check_checker_version_policy.py` rejected `tools/check_p0273_native_gossip_continuity_contract.py` for freezing the literal `0.0.171-dev` (two occurrences in a hard-coded TOC/Bootstrap parity assertion). This was an assistant-authored checker regression, **not** a Blizzard runtime failure.
- **State/result:** no tracked source writes by R0 because shadow validation blocked them. The genuine untracked `P0272_MANIFEST.txt` remained untouched. **R0 FAIL; R1 corrective archive prepared.**
- **Correction and gate:** R1 replaces the fixed-version comparison with dynamic TOC/Bootstrap version parity and validates a development-version pattern, with no runtime-version literal in feature checkers. Full 140-checker WSL shadow/postwrite suite and in-client gossip tests remain required; do not mark PASS from package/syntax-only verification.
