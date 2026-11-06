# P0380 — integrated gameplay repair memory checkpoint

**Baseline:** verified main P0379 `285be5281638ecfa9317c615aa2711d1a649556a`, manifest `249 PREWRITE+249 POSTWRITE STATIC PASS`, runtime `0.0.264-dev`. WoW failure remains observed and OPEN/PARTIAL.

**Scope (documentation / test tooling only):** Reconcile CURRENT/handoff with pushed P0379; add new L-039 tracker-internal collision while keeping L-025 general menu overlap; record P0379 session-25 Enter/Leave with no Down/Up/dispatch; establish P0381 coordinated fix and acceptance plan for L-001/L-002/L-005/L-025/L-029/L-033/L-034/L-038/L-039. Preserve old issues/negative results. Add new checker #250 and narrowly extend historic P0374 issue-row check from L-001..L-038 to L-001..L-039; all previous statuses remain enforced.

**Guarding (R1):** exact HEAD and modified documentation/checker blobs; clean tracked working tree; strict anchor transforms; CURRENT <9800 bytes, handoff <8000 bytes; unchanged `0.0.264-dev` runtime; 250-check suite in shadow *before any write* and 250-check suite after write; whitespace and manifest; rollback on failure. No Git operations beyond read and `git diff --check`.

**Non-goals:** runtime Lua mutation, WoW deployment, native suppression, claiming quest completion, closing ledger issues, changing camera/D-048, rewriting all historical memory. P0381 is the next code implementation package, not assumed present or passed.

## P0380 R1 applier correction

P0380 R0 refused PREWRITE on `Logres/Quest/ActiveQuest.lua`, an unchanged runtime
source file, despite a clean P0379 tracked worktree. The reason for the raw
blob discrepancy is UNKNOWN. This guard was unnecessary for a docs-only patch.
R1 no longer gates on Bootstrap, TOC, Dialogue, or ActiveQuest raw file bytes;
it still checks HEAD, clean tracked status, all modified existing file blobs,
all new-file absence, full 250-checker shadow PREWRITE and POSTWRITE,
whitespace and rollback. No tracked writes occurred in R0 and no gameplay
code is changed by R1.

## P0380 R2 second PREWRITE refusal

P0380 R1 **REFUSED at 27/250 PREWRITE**: `tools/check_checker_version_policy.py` detected the new P0380 checker pinning the historical client version. No tracked writes occurred. R2 replaces literal build matching in the new checker with dynamic TOC/Bootstrap parity and adds preflight scanning of the exact historical-version checker policy to the applier's shadow suite. All other memory and issue scope remains unchanged. No runtime Lua changes; actual WSL 250/250 validation is required before commit.
