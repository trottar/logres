# P0273 — Native gossip-to-service continuity: opt-in stock-window positioning

Date: 2026-10-19. Pinned baseline: actual pushed main `c5ef384530fc452e37102cc11e395c63c37bb3e9` (P0272 runtime source, incomplete historical checkout; see P0272 reconciliation evidence). D-047 remains controlling.

## Observed client result / narrow hypothesis

User 0.0.170-dev screenshots show native `GossipFrame` at Blizzard's left stock position for the **Train me** choice, followed by a centered `ClassTrainerFrame`. User confirms P0272 auto TEST worked and reports this spatial jump as the remaining inconsistency. 0.0.170-dev diagnostics show ON, 2 automatic starts, OFF with 2 restorations, `failures=0`, `pending=false`, `nativeTransactions=0`; Run All contains no reported FAIL in performed checks. Blizzard gossip-to-trainer flow remains otherwise usable. The cause is source-specific: P0272 normalized candidates only included 5/merchant and 7/trainer; earlier native metadata established GossipFrame ordinary `protected=no` and anchor methods present, but **never proved live GossipFrame mutation**.

Hypothesis: add normalized type **3 gossip** to the SAME existing P0271/P0272 opt-in placement controller (not another renderer) so both the initial native GossipFrame and subsequent merchant/trainer native frame are centered at identical screen coordinates. Preserve the controller's existing protected/unprotected, visible, combat, full opaque-anchor capture, OnHide, interaction-transition and auto-OFF guarded restoration. Count gossip starts/restores in the existing H output. No extra H actions (105 total / P34 / H18), no polling/timer, no changes to Quest Dialogue, Blizzard selection/transaction behavior, bank, auction, taxi or camera.

## Test boundary and negative result preservation

The first client test is a **real, ordinary gossip frame** with opt-in H `Native Auto Position (TEST)` ON. Verify it centers, Gossip options work; click Train me and verify the native trainer centers, is operable; close and reopen or turn OFF and verify stock restored. Merchant transition if naturally available, otherwise DEFERRED. If gossip is secret/protected or unavailable, the gate must leave it stock and report a deferral; do not coerce. If any Lua/taint/protected error or restoration failure, immediately classify FAIL and correct before expansion. No spending gold or travel is necessary. Only a user report plus saved diagnostics constitutes runtime acceptance.

## Repository-integrity defect repaired with this checkpoint

Verified main `c5ef384` has P0272 runtime (0.0.170-dev) but no P0272 checker, evidence record, patch record or generated manifest; its commit message is P0271. P0273 adds migrated historical checker and historical records; preserves actual P0272 failure/unknown status, **does not manufacture a missing P0272 manifest** or change old Git commits. Static suite result for original P0272 remains UNVERIFIED. This omission is separate from the scoped client PASS and is now explicitly documented.

## R0 shadow static gate failure — OPEN then corrected by R1

- **Attempt:** original P0273 R0 ZIP at verified main `c5ef384`, user ran the guarded WSL applier on 2026-10-19. It completed baseline and 18-path candidate preparation, then stopped at prewrite checker 1/140.
- **Observed error:** `check_checker_version_policy.py` rejected `tools/check_p0273_native_gossip_continuity_contract.py` for freezing the literal `0.0.171-dev` (two occurrences in a hard-coded TOC/Bootstrap parity assertion). This was an assistant-authored checker regression, **not** a Blizzard runtime failure.
- **State/result:** no tracked source writes by R0 because shadow validation blocked them. The genuine untracked `P0272_MANIFEST.txt` remained untouched. **R0 FAIL; R1 corrective archive prepared.**
- **Correction and gate:** R1 replaces the fixed-version comparison with dynamic TOC/Bootstrap version parity and validates a development-version pattern, with no runtime-version literal in feature checkers. Full 140-checker WSL shadow/postwrite suite and in-client gossip tests remain required; do not mark PASS from package/syntax-only verification.

## P0273 subsequent pushed checkpoint and scoped client acceptance (2026-10-19)

Verified remote main `591ed52` (P0273). Real 0.0.171-dev player screenshots show Blizzard `GossipFrame` and `ClassTrainerFrame` centered at the same position; native Train me option, trainer settings and training controls remain visible. Saved diagnostics: starts=3, restores=3, gossipStarts=2, gossipRestores=2, autoDeferred=0, pending=false, failures=0, nativeTransactions=0; auto OFF reports stock restored. 0 → Run All completed without reported FAIL in performed scope. **RESULT: P0273 SCOPED CLIENT PASS** for center continuity, input and restoration. Panel overlaps right side of native windows in screenshots; presentation without panel remains visually unverified. Does not prove unrelated services, protected states or any transaction. Original P0272 WSL gate/manifest absent remains OPEN historical evidence.
