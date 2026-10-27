# P0355 — P0173 read-only primary stock ownership diagnostic seam

**Baseline:** verified pushed P0354 R3 `4254d0a80f2f8ffd98a708836482a093bed06e62`; committed manifest states 225/225 PREWRITE/POSTWRITE STATIC, version `0.0.243-dev`. WoW runtime UNVERIFIED. P0321 native GossipFrame restoration FIRST contingent in-game gate; L-022/L-027/L-028 OPEN; L-019 public distribution BLOCKED.

## Targeted source observation

`Logres/Core/Commands.lua` still contains a standalone `runPrimaryOwnershipCheck()` body testing the addon-owned `PrimaryActions:GetStockOwnershipGate()` result. The check reports ordinary/special mode, 12-button stock availability, unresolved flags, and candidate routing without authorizing stock suppression. It classifies missing readiness as **DEFERRED**, not runtime failure or permission to suppress. This report belongs to the already-loaded `Logres/Actions/Primary.lua` module, rather than command dispatch.

## Narrow change

Move the original P0173 report body unchanged (except the method declaration) to `Primary:RunDevPrimaryOwnershipCheck(emit)`, leaving the original command-local wrapper in place and forwarding the same output sink. Preserve the Run All order, slash routes, phase-C panel registration, original report text and ordering, normal versus special mode checks, and the `GetStockOwnershipGate` implementation. Migrate only the old `tools/check_primary_ownership_contract.py` assertion that the report implementation/string physically lives in Commands to look at Primary. Retain every stock/native fallback and unsafe-mutation prohibition in that checker.

Version proposal `0.0.244-dev` with matched TOC and Bootstrap; exactly 94 Lua loads and 120 developer panel actions (38 previews). Static checker #226 checks delegation, read-only body continuity, output, ordering, stock-preservation, legacy checker migration, memory, and version parity dynamically. No saved schema migration, native frame mutation, new protected action routing, secret-value inspection, camera, polling, D-048 live selector, or dependency change.

## Failure prevention / validation scope

P0354's earlier R0 malformed SHA guard, R1 historical version-policy pin, and R2 15 KB handoff overflow were patch-author errors refused before tracked writes. P0354 R3 resolved them and preserved exact evidence. This patch validates 12 40-character baseline Git blob hashes, checks no version literal appears in the new checker, enforces <9,800-byte CURRENT and ≤8,000-byte active handoff budgets, and checks Lua/panel/TOC counts **before** running every static contract. The WSL applier uses a complete shadow worktree for 226/226 PREWRITE checks and reruns 226/226 POSTWRITE plus `git diff --check` with rollback. No claim of local full-suite PASS or WoW behavioral PASS is made before WSL execution. A PREWRITE failure is REFUSED, not runtime FAIL and not an accepted patch.

## R0 refusal — PREWRITE candidate construction (2026-10-26)

The P0355 R0 ZIP SHA-256 `20c0597478d05ebeddd6b126443fe552f15bbad2f5670a314bdcbe336b0b68e7` passed integrity and its 12 baseline source guards, then refused inside `candidate_files()` before constructing the shadow checkout: `P0355: REFUSED: REFUSED: handoff authority and refusals missing`. The generated handoff abbreviated the historical refusal as `R2 memory health`, while the applier itself required the exact token `P0354 R2`. This was a contradictory patch-author assertion, not a repository defect or runtime result. Status: REFUSED / zero tracked writes, not PASS and not a WoW failure. R1 renders `P0354 R0`, `P0354 R1`, `P0354 R2` and `P0355 R0` explicitly and verifies the rendered handoff together with both negative evidence records prior to the 226-checker shadow suite. The underlying P0173 diagnostic extraction is unchanged.

## R1 PREWRITE historical checker refusal — corrected by R2 (2026-10-27)

R1 ZIP SHA-256 `c4be42f4873cf42a24b5aa98a202a120a3937542e2bbfe8ff722133f54ab80da` passed 12 Git blob guards, its rendered handoff self-test, version policy, memory budget and Lua/panel/order preflights. PREWRITE then REFUSED 191/226 at `tools/check_p0354_hud_diagnostic_seam_contract.py` because the generated handoff retained `P0354 R2` but omitted the exact token `check_memory_health.py` required by the P0354 historical contract. No tracked files changed. This is a PATCH-AUTHOR CHECKER-COMPATIBILITY FAILURE, not WoW runtime failure or accepted PASS. R2 adds the exact required token to handoff and preflights the original P0354 historical assertion against the generated candidate. Existing P0173 implementation and all stock-preservation rules are unchanged; the full 226 checker suite is still required for acceptance.
