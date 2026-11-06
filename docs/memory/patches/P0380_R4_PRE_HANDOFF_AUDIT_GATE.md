# P0380 R4 — Assistant pre-handoff audit gate (docs-only)

Date: 2026-11-06. Baseline: verified main `fe1d2aac616e562fdaaa7bb10f2b3e58eadb7318` (P0380 R2). This checkpoint changes **repository memory only**. No Lua, TOC, addon version, saved schema, gameplay behavior, or static checker is changed. No WoW redeploy.

## Negative result preserved

P0381 R0 was delivered without an assistant-side exhaustive historical contract check. Its progress implementation contained forbidden `pcall(CompleteQuest)` and its new contract checker required it. User's applier reported **P0381 PREWRITE REFUSED 77/251** at `check_p0241_quest_progress_contract.py`; tracked files remained unchanged. This is an assistant handoff defect, not a gameplay API observation or a successful code patch. Source evidence and failure provenance are retained in `docs/memory/evidence/P0380_INTEGRATED_GAMEPLAY_REPAIR.md`.

## Policy change

`docs/memory/AGENTS.md` makes assistant-side full candidate auditing a hard precondition to **any code ZIP handoff**. New `docs/memory/PRE_HANDOFF_AUDIT.md` specifies authority, historical checker/invariant cross-audit, exact-candidate 100% static suite and artifact/rollback verification, proof in the handoff, and a stop gate. `docs/memory/LEARNINGS.md` preserves the generalized lesson. `CURRENT.md`, handoff, P0381 plan, L-002/L-005 `ISSUE_LEDGER.md` attempt history, and relevant roadmap/index pointers are synchronized.

## Validation status

This is a *memory-only* policy checkpoint. The future P0381 code candidate is neither included nor certified. The P0380 R4 applier gates the expected baseline, exact modified blobs, memory limits and historical content, checks the complete candidate shadow tree PREWRITE, and rechecks POSTWRITE. Its manifest is evidence only for checks actually run. The documented assistant-side code-audit rule becomes authoritative after this patch is committed/pushed and verified on remote `main`.

## Next action

User applies/commits/pushes P0380 R4. Verify `main`. Then rebuild P0381 R1 from verified source: audit P0241 and *all* historical contracts first, resolve progress routing without direct unsafe mutation, and run every static checker against the exact prepared candidate before delivering any new code ZIP. L-001/L-002/L-005/L-025/L-029/L-033/L-034/L-038/L-039 retain their existing unresolved evidence gates.

## R3 refusal superseded by R4

R3 user-side applier refused `audit policy absent not a replacement` before the
250-checker shadow stage: the prewrite assertion did not normalize Markdown
`not **a** replacement`. No tracked writes; not a runtime result. R4 fixes
that specific false-negative guard and preserves the original history.

## R4 pre-delivery validation scope

Assistant independently verified GitHub `main` remained `fe1d2aac`, all twelve
existing-file blob identifiers, every exact replacement anchor, CURRENT and
HANDOFF byte budgets, Python applier syntax, ZIP payload text hygiene, and
positive/negative tests of the R3 Markdown-policy regression against R4's
`check_contracts()`. The full 250-checker shadow suite could not be run in
the assistant's isolated environment; it remains an explicit PREWRITE and
POSTWRITE requirement in the one-time applier. Do **not** label those
unexecuted checks PASS. This is a documentation-only correction under the
scoped audit exception, not a code-handoff certification.
