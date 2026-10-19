# P0266 — NPC Option Session Runtime Repair

Status: PREPARED / CLIENT UNVERIFIED (2026-10-19). Baseline: verified P0265 commit `99c7294`.

One patch for three observed runtime defects: Service row/footer overlap, branch Back hidden during long narratives, and universal shared-dialogue Goodbye missing. See `docs/memory/evidence/P0266_NPC_SESSION_RUNTIME_REPAIR.md`. Static checks do not imply runtime PASS; no native transactions, camera, or guarded completion controller modifications. P0265 remains PUSHED / SCOPED RUNTIME FAIL on these features until this fix is tested in WoW.

R0 was refused before tracked writes due to local `ACTIVE.md` blob divergence from verified committed main. R1 preserves divergent local documentation in user home, recovers candidate docs from verified HEAD, and refuses source-code drift; see evidence. In-client runtime result remains PENDING.

R1 also detects and clears local skip-worktree/assume-unchanged bits on backed-up documentation paths if present, without remote or branch-ref changes; failure restores flags.

### R2 baseline correction
R1 rejected ACTIVE.md despite user diagnostic proving committed/index/worktree blobs equal GitHub main. Underlying subprocess discrepancy remains UNREPRODUCED; remove redundant per-file object-ID pin while preserving exact immutable commit gate and raw committed-bytes/local-bytes comparison for all guarded paths. Run full shadow/postwrite static suite; runtime acceptance remains pending.
