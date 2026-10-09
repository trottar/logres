# P0181 — accept P0180 runtime and correct validation handoff

Date: 2026-10-09. Type: **docs-only runtime-evidence/memory checkpoint**. Source-locked baseline: GitHub `main` `d45097cabf7b6384780550641562c08503e14b72`. Runtime under review: P0180 `0.0.96-dev` / loadCount 230–232. No Lua/TOC/runtime/checker source or version change.

## Objective

Promote P0180 from pending to **accepted for observed scope**, preserve unverified harmful-auras and intentional Blizzard fallbacks, and correct the panel-first testing handoff. Do not claim a new source/filter count demonstrates native visual replacement. Keep the pre-push candidate descriptions as historical records and append outcome paragraphs rather than rewriting evidence history.

## Observed result

Canonical `docs/memory/evidence/P0181_ACCEPT_P0180_RUNTIME_2026-10-09.md`: GitHub `main` `d45097c` contains the P0180 source and contracts. The user's `LOGRES_DIAGNOSTICS_LATEST.lua` loadCount **232** contains an actual Phase 0 **Run All** completed with the 35-row UI Ownership **17 PASS / 18 STOCK / 0 FAIL / 0 DEFERRED**, clean observed guard conditions and no reported Lua/command errors. Earlier event samples include **one friendly target ordinary HELPFUL positive** but no ordinary hostile helpful or player/target harmful positive. Secret-restricted events are not proof of a hidden aura or visual discrepancy.

## Scope and implementation

Rewrite `docs/memory/CURRENT.md` and compact handoff, update live roadmap status heading and append P0181 checkpoint to Phase H, ACTIVE, dated memory and root roadmap. Append observed acceptance to P0180 patch/evidence. Add P0181 patch/evidence and manifest. No modification of code, checker source, addon package, or Git refs.

One-time applier: require exact `main` HEAD and blob hashes, clean tracked worktree, validate payload hashes, construct full shadow checkout, run **all** `tools/check_*.py` with prewrite diff hygiene, install documentation transactionally, run `git diff --check`, leave all Git operations to user.

## Negative results / next gate

Preserve P0178 over-60-upvalue slash failure and P0175 R2 nil-rows history. Record a **process failure**: assistant repeatedly supplied slash commands and interpreted unpersisted panel output as an unperformed test, causing needless retest. All future applicable WoW validation must name exact panel button(s), never request duplicate tests from stale SavedVariables alone. Harmful-aura completeness and visual ownership remain DEFERRED. H.1 next product gate: source-backed secure Main/Override/special action replacement and restoration, with stock fallback until proven; intermittent loot ObjectiveTracker flash remains open. **No WoW redeploy is required for P0181.**
