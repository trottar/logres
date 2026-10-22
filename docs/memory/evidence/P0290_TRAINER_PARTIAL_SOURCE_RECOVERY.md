# P0290 — Partial trainer-service information into accepted live landscape

Date: 2026-10-21. **PREPARED / WSL AND WOW UNVERIFIED.**
Baseline: verified pushed GitHub main P0289 R1 `aee3f9dba0be575bf35789904b1e17a85993caa6`.

## Observed negative result — runtime FAIL

User screenshot of Logres development `0.0.190-dev` confirms **H developer panel PASS**: Live Trainer ON (TEST), Live Trainer OFF, Trainer Skin controls appear on first H page. But repeated Live Trainer ON yields `DEFERRED (result=unsafe-or-incomplete-service-row shown=false displays=0)`. The screenshot shows deferrals increasing, with **purchases=0, filterWrites=0, selectionWrites=0, nativeGeometryWrites=0**. This is **LIVE PRESENTATION FAIL / OPEN**. The screenshot does not identify which particular row gate failed, or prove an actual secret/protected field; do not invent a cause.

Source inspection establishes two concrete over-restrictions independent of the unknown individual runtime field: (1) P0288's `FromSnapshot()` rejects *every* live presentation when any row is not simultaneously named, indexed and in one of two fully accepted states. (2) P0287's probe returns no independently safe name when another tuple field is unavailable, even if `ordinary(name)` succeeds. Both can be corrected without probing further or interpreting unverified numeric category semantics.

## P0290 R0 static PREWRITE failure — durable negative result

User WSL output on 2026-10-21: R0 ZIP SHA-256 and pinned P0289 R1 baseline both PASS, then PREWRITE ran **161 checkers, 1 failure**, `check_memory_health.py`: `CURRENT.md exceeds 20 KB hard maintenance threshold`. Applier returned REFUSED/FAILED before tracked writes. **This is an assistant-generated patch-memory maintenance failure**, unrelated to live trainer API or runtime safety. P0290 R1 corrects it by replacing CURRENT's sprawling historical Verified State and References with a concise authoritative state, while retaining past failures and context in this evidence document, the investigations, roadmap, and patch index. An explicit candidate guard requires `CURRENT.md` under 10,000 bytes before running PREWRITE. R1 preserves identical runtime source changes to R0. WSL and WoW R1 results UNVERIFIED.

## P0290 R1 POSTWRITE whitespace failure — durable negative result

User WSL output on 2026-10-21: P0290 R1 ZIP checksum and pinned P0289 R1 baseline PASS, PREWRITE **161 checkers / 0 failures**, POSTWRITE **161 checkers / 0 failures**, but final `git diff --check` failed with `docs/memory/CURRENT.md:38: new blank line at EOF`. The applier is designed to roll back its tracked writes on this exception; no runtime result or pushed patch is implied. **Assistant-generated patch failure / OPEN until R2 re-test**: the `section()` builder appended two newlines at the document's final section; the shadow PREWRITE ran Python checkers but not diff whitespace. P0290 R2 fixes the final-section writer and gates all 14 proposed files with `git diff --no-index --check` before writing. It retains the same guarded Lua source changes, below-10 KB CURRENT limit, historical negative results, and postwrite `git diff --check`. WSL and WoW R2 results UNVERIFIED.

## P0290 correction

`NativeTrainerServiceProbe.snapshotRow()` retains `safeText(name,100)` **only when its own `ordinary(name)` gate succeeds**, even when unrelated fields are secret or unusable. It never inspects or interprets those unrelated fields. The existing four-value ordinary gate and its deferred state stay intact. No raw secret value is copied, compared, logged, or formatted.

`TrainerLiveTrial.FromSnapshot()` continues to require an existing permitted trainer-source report with a bounded row sample and validated source-derived index. It recognizes exactly the four states emitted by the existing probe: `source-observed`, `numeric-category-unclassified`, `unexpected-service-shape`, and `deferred-secret-or-call`. An ordinary name becomes a visible label; a missing name becomes `Service N (details withheld)` using only the addon-owned bounded index. Unproven costs display `Cost unknown`. All availability is labeled *not classified*. The screenshot/panel may now present a partial read-only landscape rather than silently discarding the entire trial. A partially withheld model reports `live-partial-visible`.

**Still deferred:** invalid trainer/root/combat status, invalid sample/index or unrecognized source states, numeric availability enum, protected/secret fields, genuine interactive filtering/selection, transaction-safe Train All, underlying native UI replacement. No purchase, filter, selection, native geometry mutations, polling, replacement interaction or hidden Blizzard click surface. The shared P0284 landscape renderer and synthetic fixture remain unchanged; stock Blizzard controls and fail-open fallback remain authoritative.

## Validation and stop conditions

Static gates: exact remote baseline SHA, all required tracked blob hashes, clean tracked state, complete repository `check_*.py` suite on shadow candidate before writing, full suite after writing, `git diff --check`, generated manifest. New P0290 checker guards source/adapter/state and H entrypoints; historical P0288/P0289 checkers stay enforced. No claim of full WSL PASS until applied by the user.

WoW: deploy, `/reload`, open ordinary trainer, `/logres panel` → H → Live Trainer ON (TEST), inspect names/explicitly withheld rows, currency, disabled Logres buttons, and Blizzard usability. Then Live Trainer OFF and optionally close trainer. A screenshot and panel result suffice; no repeated general source audit or purchase. If P0290 still defers, preserve exact negative result rather than bypassing session/secret gates. WoW status **UNVERIFIED**.

Authority: D-046 preview/model/renderer/live adapter; D-047 selective NPC ownership and Blizzard transaction fallback.
