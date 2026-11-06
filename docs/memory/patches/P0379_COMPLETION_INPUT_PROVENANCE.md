# P0379 — read-only quest completion input diagnostic

Baseline: verified GitHub main P0378 `4ffbe3ba44749243a90acc49051377cd9fd3e242` (248 static checks, 0.0.263-dev).

Code: `Logres/Quest/Dialogue.lua` adds additive hooks on existing shared Accept/Complete button, guarded read-only addon-owned geometry/status, `GetDebugStatus()` input summary. `Logres/Dev/Panel.lua` includes it in Report Bug. TOC/Bootstrap version becomes 0.0.264-dev. Controller reward routing and native Continue unchanged.

Records: issue-ledger rows L-002/L-005/L-020, CURRENT, handoff, ACTIVE, Phase H, status, roadmap, patch index, dedicated evidence and new checker. No new saved schema or addon module.

Testing: applier preflight must PASS 249/249 full shadow tests, version-policy checker, candidate whitespace checks and postwrite 249/249; actual client remains UNVERIFIED. L-005 runtime failure still OPEN/PARTIAL; L-002 OPEN. User owns Git commit/push. Runtime deployment required before WoW test.

## P0379 R1 correction (2026-11-06)

P0379 R0 was refused at 129/249 PREWRITE by `check_p0292_trainer_information_contract.py`: `CURRENT over 10KB soft target`. The proposed R0 `CURRENT.md` reached approximately 10,521 bytes (9,780-byte baseline). Its transactional shadow validation correctly produced **zero tracked writes**. The refusal is real repository knowledge, not PASS or a client outcome.

R1 replaces the verbose new CURRENT status with concise current work/action/verification and folds two redundant historical summary lines into the already-linked patch index/evidence trail, preserving referenced IDs and outstanding statuses. An explicit UTF-8 `CURRENT.md` <10000-byte guard runs before the shadow checker suite. No quest control logic changes from R0. R1 requires the full 249 PREWRITE/POSTWRITE checkers in WSL, and WoW evidence remains UNVERIFIED until actual play.

## P0379 R2 correction — second failed candidate and comprehensive guard (2026-11-06)

R1 was **REFUSED at 191/249 PREWRITE** by `check_p0354_hud_diagnostic_seam_contract.py`: `CURRENT_HANDOFF.md` exceeded the historical 8,000-byte constraint. Baseline handoff is 7,991 **UTF-8 bytes** (7,975 codepoints); R1 prepended 410 bytes, reaching approximately 8,401 bytes. No tracked files were written. R0 (129/249, `CURRENT.md` over 10 KB) also remains REFUSED; neither is a gameplay PASS or a quest-code defect.

R2 preserves the same Logres-only input probes and native claim path as R0/R1. Corrective scope: compact historical repeated `CURRENT.md` summaries and three repeated `CURRENT_HANDOFF.md` sections; **archive their exact original text** in `docs/memory/handoffs/P0379_ACTIVE_MEMORY_COMPACTION_ARCHIVE.md`. All historical milestone markers and failure signals remain in the live handoff, with original evidence in the issue ledger and archive. `CURRENT.md` must stay **<9800 UTF-8 bytes** and handoff **<8000 UTF-8 bytes**, enforced explicitly before the first checker and again by the P0379 checker. Candidate must still pass all 249 PREWRITE and all 249 POSTWRITE static checkers in WSL, followed by `git diff --check`, before any commit. WoW input validation and quest action success remain **UNVERIFIED**; L-005 PARTIAL/FAIL and L-002 OPEN.
