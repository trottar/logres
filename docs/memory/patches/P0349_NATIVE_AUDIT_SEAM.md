# P0349 — Extract read-only native UI diagnostics to ownership audit

**Baseline:** verified pushed P0348 `4b7481d731d5f90e214b285bc7cce16ec826176f`, 219/219 PRE/POST STATIC, version `0.0.237-dev`; client UNVERIFIED.

Changes:
- `Logres/Core/UIOwnershipAudit.lua`: `Audit.RunNativeAccessCheck(emit)` owns unchanged read-only report body.
- `Logres/Core/Commands.lua`: retains `/logres nativeuicheck`, Run All, 120 existing panel actions and the original `runNativeAccessCheck()` symbol; its body is a one-call delegation.
- `Logres/Core/Bootstrap.lua` / `Logres/Logres.toc`: version parity `0.0.238-dev` only, 94 Lua load entries.
- Four historical diagnostics checkers: relocate report-presence assertions to the new owner **without removing** their native fallback, quarantine or cast-gate requirements.
- `tools/check_p0349_native_audit_seam_contract.py`: static #220 source/owner/route/report constraints; memory and roadmap synchronized.

Never assert native visibility or protected action state from this report. No visual renderer, event, API, camera, D-048 selector, saved-data migration, native setter or secure presentation changed. No new controls. P0321 client validation first on contingent client return; L-022/L-027/L-028 OPEN, L-019 public alpha BLOCKED. WoW **UNVERIFIED**. P0347 R0 historical 1/218 PREWRITE refusal preserved.

## P0349 R0 refused candidate and R1 source-contract correction

On 2026-10-26 (EDT), the user verified R0 ZIP SHA-256 and ran guarded `P0349_APPLY.py` on verified P0348 `4b7481d731d5f90e214b285bc7cce16ec826176f`. PREWRITE shadow **REFUSED 2/220** before tracked writes: `tools/check_interaction_native_contract.py` (index 50/220) still required `expected and 5 or 0` and `castStockOnDemand=true` physically within `Commands.lua`, and `tools/check_native_reshow_contract.py` (index 62/220) still required `result.pendingRefolds == 0` and `nativeShows=%s/%s combatDeferred=%s pending=%s` there. These tokens correctly moved with the untouched four-line native diagnostic body into `UIOwnershipAudit.lua`; R0 migrated four other historical checker owners but **missed these two**. This was an assistant integration-test omission, NOT a WoW failure or user error. **R0 CLOSED / PREWRITE REFUSED; no tracked writes.**

R1 adds both P0174 checker files to the exact Git-blob guard and redirects ONLY their historical diagnostic-token lookups to `Core/UIOwnershipAudit.lua`; native source behavioral, interaction, protected/cast, re-show and fallback assertions are unchanged. It adds both migrations to P0349 checker #220, retains the original four checkers' migrations, and requires 220/220 PREWRITE and POSTWRITE PASS before acceptance. Do not weaken or delete historical native safeguards to obtain a passing suite. The error demonstrates why a pure synthetic checker subset cannot establish complete historical checker compatibility.
