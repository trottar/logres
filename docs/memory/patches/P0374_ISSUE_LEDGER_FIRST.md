# P0374 — Canonical issue ledger and resolution discipline

**Baseline:** P0373 `2a97a774564077a22e3fd640be63199c1387a7b7`. **Type:** docs and static contract only. No WoW redeployment.

- Establish `docs/memory/investigations/ISSUE_LEDGER.md` as the **mandatory first lookup** for all bug work, current state, fix attempts, resolution and tested-scope closure.
- Retain separate historical issue register and exact P/L/D evidence; do not rewrite old failures or claim a patch is an in-client fix.
- Index L-001 through L-034; new L-034 is unsolicited quest GUI, distinct from claim-popup L-002 and completion-branch L-005.
- Add first-reference instructions to AGENTS, CURRENT, handoff, and prior register; link this record in patch index.
- Add static checker for completeness, statuses, resolution columns, evidence fields, first-reference links, and memory sizes. Execute all checker contracts against a shadow candidate before any tracked file changes, then postwrite.
- Preserve historical P0373 R0/R1 refusals and unresolved L-001/L-002/L-005/L-033/L-034; P0370 L-021 PASS limited to the no-pet test.

**Validation:** docs-only P0374 requires the applier to report 244/244 STATIC PREWRITE and POSTWRITE, `git diff --check`, and manifest PASS. In-client behavior remains unchanged/unverified by this patch. Commit/push is user-owned; verify remote main before treating checkpoint as durable.
