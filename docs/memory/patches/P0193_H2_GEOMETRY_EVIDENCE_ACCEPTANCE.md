# P0193 — Accept P0192 R1 read-only H.2 geometry evidence

Date: 2026-10-11. Expected GitHub `main` baseline `377762049d11baa55904fb5f38d920f775345a1b` (P0192 R1 verified). **Docs, evidence and checker only**: no Lua, TOC, UI anchors, Blizzard surfaces, version bump or deployment needed.

User supplied `LOGRES_DIAGNOSTICS_LATEST.lua` (`0.0.102-dev`, loadCount 242) confirming Layout Check PASS, 13/13 actual Logres named frame bounds measured, 0 missing/deferred, and integrated Run All completed PASS for existing tested scope. Preserve raw normalized data in `../evidence/P0193_H2_GEOMETRY_RUNTIME_2026-10-11.json` and interpretation/limits in the paired Markdown. Do not confuse source geometry observation with collision or runtime v4-placement acceptance. P0192 R0 pre-write delivery failure remains preserved, as do protected native-mode environmental deferrals.

Update active repository memory and patch index in the same checkpoint. Add static evidence checker comparing the exact planned columns against D-045 v4 JSON, checking measurement completeness and bounded numeric values. Applier refuses unexpected commit/blob state, validates candidate and static suite in a shadow checkout before writes, checks whitespace and emits `P0193_MANIFEST.txt`; no Git mutation.

After user push verification, P0194 can implement a bounded, fail-open action/player-reaction placement/reflow slice; quest vs native-access and aura actual-width mismatch must be resolved without silent design changes or protected-frame suppression. No WoW redeploy for P0193.

## P0193 R0 pre-write delivery failure; R1 correction

The original P0193 applier was run on the P0192 R1 main baseline and passed the first 26 shadow static checkers, then **FAILED before tracked writes** in `tools/check_checker_version_policy.py`: the newly introduced `check_h2_geometry_evidence_contract.py` pinned historical runtime version `0.0.102-dev`. No `P0193_MANIFEST.txt` was generated. This is an **artifact delivery failure**, not a WoW runtime failure. Preserve the exact observed addon version in the dated JSON and evidence Markdown, not in a durable `check_*.py` feature contract. R1 checks that the evidence version is a syntactically valid development version without freezing its historical literal; keeps loadCount 242, the 13 measurements and all other checks. No addon runtime changes. The full shadow checker suite must pass prior to any tracked writes.

## P0193 R1 post-write whitespace FAIL; R2 correction

The user ran P0193 R1 on the verified P0192 R1 baseline. All shadow
contract checkers passed, including the checker-version policy, but
`git diff --check` then failed **after the attempted writes** with
`docs/memory/CURRENT.md:79: new blank line at EOF.` R1's exception handler
restores tracked file bytes, deletes new patch files, and removes the
manifest. This is a second **artifact delivery FAIL**, not a WoW runtime
regression or a passing repository checkpoint. User-supplied console output
did not include a subsequent `git status`; R2 independently requires a clean
tracked baseline before proceeding.

Root cause: the R1 `section()` helper could add multiple terminal newlines,
while its whitespace guard rejected only three or more; Git rejects a newly
introduced blank line at EOF. R2 normalizes transformed documents to exactly
one trailing LF and hardens `check_whitespace()` against two trailing LF
characters. Additionally, R2 runs `git diff --no-index --check` on every
shadow candidate document against its baseline **before** any tracked writes;
existing post-write `git diff --check`, static checks, transactional rollback,
manifest and baseline hash gates remain unchanged. No Lua or runtime geometry
changes.
