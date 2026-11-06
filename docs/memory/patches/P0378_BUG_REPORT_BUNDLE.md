# P0378 — single-file bug evidence bundle (2026-11-05)

**Baseline:** verified P0377 `c77b3c54b8293fed2300e08430ba046d46bce087` on GitHub `main`; version remains `0.0.263-dev` (no addon runtime modifications).

**Changed:** `tools/export_panel_diagnostics.py`, issue-first `ISSUE_LEDGER.md` for L-020/L-002/L-005, relevant current/handoff/investigation/roadmap references and patch index. **Added:** `tools/check_p0378_bug_report_bundle_contract.py` plus evidence and patch notes.

**Workflow:** `/reload` to flush SavedVariables, `python3 tools/export_panel_diagnostics.py`, upload `LOGRES_BUG_REPORT_LATEST.zip`. ZIP contains the original diagnostic Lua, a JSON incident/screenshot manifest, and matched screenshot binaries; matching is mtime-inferred, not exact. Existing Lua export remains available. Missing screenshot matches are warnings, never forged.

**Validation:** local synthetic image/ZIP fixture PASS; full repository 248 PREWRITE/POSTWRITE STATIC checker suite must PASS in the one-time applier. WoW screenshot matching and quest completion UNVERIFIED. No WoW redeploy is required (tooling/doc-only).
