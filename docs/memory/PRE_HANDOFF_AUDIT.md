# Mandatory assistant-side pre-handoff audit

Authority: `AGENTS.md`. Effective starting with the P0380 R4 documentation checkpoint (2026-11-06). This is a **hard release gate for every future code ZIP**, not a task delegated to the user's patch applier. It applies to a repaired ZIP as fully as to a first attempt. A passing in-user PREWRITE guard is defense in depth; it is **not** a replacement for the audit described here.

## 1. Establish authority and scope

1. Read the actual current `main` commit and the project startup chain: `AGENTS.md`, `CURRENT.md`, its references, `handoffs/CURRENT_HANDOFF.md`, `investigations/ACTIVE.md`, `roadmap/STATUS.md`, active phase roadmap, and `docs/ROADMAP.md`. Consult `investigations/ISSUE_LEDGER.md` first for every bug.
2. Name the exact intended behavior, affected L-ID(s), touched source owners, API/protected/secret constraints, fallback, regression risks, and runtime proof required. Do not assume an intended behavior is a permitted implementation.
3. Inventory **all** planned changes: Lua, TOC, Python, contract checkers, commands, memory, and generated applier behavior. Verify that unchanged files are not incorrectly subjected to raw-byte mutation guards.

## 2. Audit historical invariants *before writing implementation*

1. Examine the exact source and applicable historical `tools/check_*.py` contracts. A new checker does **not** supersede older ones. Search every touched file and API/action for historical prohibitions, expected call paths, owners, sequence requirements, and source-location assertions. Review the full checker inventory, not just the newest test.
2. Make an explicit **constraint matrix**: proposed action -> existing source/API and protected-state rules -> historical checker requirements -> compatible implementation or unresolved conflict. Document conflicts before generation.
3. Do not bypass a checker by moving a prohibited action into another function, weakening/removing the assertion, or obscuring source text. If a historical contract is obsolete, justify the revision with source/runtime evidence, record the accepted change, and check every dependent contract. Otherwise preserve the invariant and choose a supported native handler/fail-open route or defer the behavior.
4. Preserve existing Blizzard information, interaction, and recovery surfaces until Logres has a capability-gated replacement. Avoid polling, secret-value inspection, speculative protected mutation, and unproven runtime claims.

## 3. Validate the **exact prepared candidate** before the handoff

1. Build the final candidate in a complete local **read-only baseline mirror / shadow tree** matching the GitHub commit that the ZIP will require. Include the actual candidate contents of new contract checkers, changed source, memory, and all generated files. Verify source anchors, expected Git blobs, LF text, newlines, and current/handoff memory budgets.
2. Run `python3 tools/check_checker_version_policy.py`, `python3 tools/check_memory_health.py`, and **every** `tools/check_*.py` against that prepared candidate, not just the changed/new checkers. Check each exit code and preserve any failure output. A new checker must pass against the same candidate as all historical checkers.
3. Validate syntax and applicable compilation/tests for changed Lua/Python/tooling when available. Run whitespace/conflict-marker checks equivalent to `git diff --check` on the full candidate. Inspect the diff for unintended removals, version changes, dependency drift, native/protected safety regressions, or erased negative history.
4. Validate the **actual distributable ZIP**, not only the script used to make it: archive listing, path safety, payload hashes, one-time applier syntax, expected baseline/branch, prewrite refusal before tracked writes, rollback on postwrite failure, manifest and cleanup behavior. Verify its SHA-256.
5. Record the complete pre-handoff result: baseline SHA, touched files, checker inventory count and PASS count, candidate syntax/diff/ZIP results, known uncertainties, and WoW cases requiring actual client validation. **Never claim tests were executed unless they were actually run.**

## 4. Hard stop and handoff

- **Any failure, unverified essential gate, or missing complete candidate environment blocks a code ZIP handoff.** Resolve and re-run the full suite before delivery. Do not expect the user to discover an assistant-authored contract conflict or perform the assistant's initial static verification.
- The eventual user-side applier **still** verifies exact baseline/clean state and runs the full static suite PREWRITE and POSTWRITE, then `git diff --check` and emits the one-time manifest. It must not write tracked files on a PREWRITE refusal and must restore patch-owned writes after POSTWRITE failure.
- A code ZIP handoff includes actual evidence of the pre-handoff audit, a sandbox ZIP, SHA-256, exact WSL apply and Git stage/commit/push commands, and—in a runtime-code patch—the required Forever deployment and client validation steps. The user alone commits/pushes; verify new remote `main` before advancement. Static PASS is not WoW PASS.
- **Documentation-only checkpoints** are not code ZIPs. Audit their exact documentation changes and applicable memory/source-contract invariants, and explicitly report any unavailable full-suite testing; do not state that the full suite passed without its execution. No WoW redeployment is required for a docs-only checkpoint.

## P0381 R0 negative precedent (2026-11-06)

An assistant-authored candidate added `pcall(CompleteQuest)` to `Logres/Quest/Dialogue.lua`, while historical `tools/check_p0241_quest_progress_contract.py` forbids that direct mutation. The candidate's *new* P0381 checker demanded the prohibited call. The user ran the ZIP; the applier **REFUSED PREWRITE at 77/251** on P0241, with **no tracked writes**. This was a failure of the assistant's historical-contract and cross-checker audit, not a WoW or WSL error. The P0381 implementation remains uncommitted, gameplay issues L-002 and L-005 remain open/partial, and the existing native-action safety contract remains authoritative. P0381 correction must resolve the semantic conflict and pass every historical checker **before** another code handoff.

## P0380 R3 docs applier refusal (2026-11-06)

The original R3 gate ZIP verified and extracted, but its applier REFUSED before
static tests with `audit policy absent not a replacement`. The policy used the
Markdown text `not **a** replacement`; the literal assertion did not strip
Markdown emphasis. No tracked writes or manifest were produced. R4 validates
normalized policy text and independently exercises the packaged assertion.
This is an assistant-side patch validation failure; preserve it as negative
evidence and do not describe R3 as applied or verified.
