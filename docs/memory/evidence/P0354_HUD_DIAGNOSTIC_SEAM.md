# P0354 — HUD structural diagnostic ownership seam

**Baseline:** verified GitHub `main` P0353 R1 `bac01ad18554157265e292fbf0c8982e3c3473d8` (224/224 PREWRITE/POSTWRITE STATIC; `0.0.242-dev`). Earlier P0353 R0 refused at 57/224 `check_native_access_contract.py`, with no tracked writes; R1 passed. WoW UNVERIFIED. P0321 native GossipFrame restoration remains the FIRST contingent client gate. L-022/L-027/L-028 OPEN; L-019 public release BLOCKED.

## Targeted source observation

`Core/Commands.lua` owns the one 3KB `runHUDCheck` report. It samples `Logres:GetModuleStatus("HUD")`, the already-owned HUD `GetDebugStatus()` and ordinary addon-owned structural/boolean fields (bands, textures, events, ally rows, resource and target cues, immersion presentation). It does not read live secret-capable health/power, protected Blizzard presentation or mutate any frame. This is a diagnostic of `HUD/HUD.lua`, not command routing. The HUD module already loads before Commands.

## Coherent narrow change

Move the exact original report body to `function HUD:RunDevHUDCheck(emit, boolText)` in `HUD/HUD.lua` without changing its PASS/FAIL text, branch conditions, formatting or sample sequence. Commands retains `local function runHUDCheck()` forwarding its existing output sink and boolean formatter through `Logres:GetModule("HUD"):RunDevHUDCheck(emit, boolText)`. Run All ordering, slash routing, panel actions and help remain. There is no new event, timer, native/protected read, secret inspection, saved schema change, D-048 live selector, camera behavior or Lua load entry. Version bumps to `0.0.243-dev`; count remains 94 Lua/120 panel actions (38 P previews).

## Acceptance and evidence limits

New checker #225 guards exact wrapper, original structural comparisons/emit signatures, single report owner, Run All ordering, module load precedence, original secret-safe HUD checker and memory continuity. Guarded exact baseline/11 Git blob applier builds full shadow candidate and requires **225/225 PREWRITE and POSTWRITE STATIC PASS** before manifest. A static PASS does not establish WoW behavior, UI rendering, FPS or client acceptance. Runtime is UNVERIFIED / DEFERRED while client unavailable; P0321 first contingent in-client safety gate.

Negative-result discipline: P0353 R0 PREWRITE failure remains separately recorded and unchanged. A P0354 PREWRITE refusal must be retained as an OPEN failed candidate and corrected narrowly, not conflated with an in-client failure.

## P0354 R0 PREWRITE guard refusal (2026-10-26)

**Outcome: REFUSED before the PREWRITE shadow run; zero tracked writes.** The user ran the initial P0354 archive against the expected clean P0353 R1 baseline. ZIP SHA verification succeeded, but `P0354_APPLY.py` rejected `Logres/Core/Bootstrap.lua`: actual Git blob `38dc4f574b8fd40a929dd287b3ec2798732cf4b4` (40 hex digits) versus packaged expected `38dc4f574b8fd40a929dd287b3ec2798732cf4b` (39 digits). This was an applier packaging typo, not a source divergence or an in-game observation; no candidate was constructed and no STATIC checker ran. P0354 R1 corrects only this guard plus durable refusal documentation and reissues the same HUD source extraction on the same verified pushed baseline. The R1 guard table also validates that every expected SHA has exactly 40 lowercase hex digits before checking files. All 225 checks remain mandatory PREWRITE and POSTWRITE; WoW remains UNVERIFIED. Preserve R0 as historical negative evidence.

## P0354 R1 PREWRITE checker-policy refusal (2026-10-26)

**Outcome: REFUSED 27/225 PREWRITE, zero tracked writes.** The user verified the R1 archive checksum and applied it on the expected clean P0353 R1 baseline. All 11 40-character blob guards passed. During shadow validation, `tools/check_checker_version_policy.py` rejected `tools/check_p0354_hud_diagnostic_seam_contract.py` because the new historical checker contained the literal `0.0.243-dev` in two TOC/Bootstrap version comparisons. This violated the pre-existing durable rule against exact version pins in feature checkers. No original runtime code, saved settings, or native UI was modified. This is a patch-author preflight omission, not a HUD runtime result or a change in source baseline. The R1 archive is rejected; retain its negative evidence alongside R0.

## P0354 R2 correction and preventive validation

R2 replaces the two fixed version comparisons with regex-extracted TOC/Bootstrap parity and a structural `0\.0\.\d+-dev` format assertion (no literal runtime release pin). It also changes the historical checker-inventory equality into a minimum of 225 so future checkers can be added without weakening P0354 invariants. The applier adds an explicit check of its new checker against the same `check_checker_version_policy.py` regex *before* building the shadow candidate, alongside the existing 40-character Git SHA guard. The intended Lua extraction and version `0.0.243-dev` remain unchanged. Full 225/225 PREWRITE and POSTWRITE STATIC plus diff hygiene are still acceptance gates; runtime remains UNVERIFIED. R0 and R1 failures must remain durably recorded after success.

## P0354 R2 PREWRITE memory ceiling refusal (2026-10-26)

**Outcome: REFUSED 55/225 PREWRITE, zero tracked writes.** The R2 ZIP integrity and 11 baseline blob guards passed, and its new checker cleared the dynamic-version policy preflight. The shadow candidate then failed `tools/check_memory_health.py`: `CURRENT_HANDOFF.md` exceeds the repository's 15 KB hard maintenance threshold. The pushed P0353 handoff already contained **14,440 UTF-8 bytes**, leaving only 594 bytes for the next appended checkpoint. Appending another roughly 1 KB section was predictably unsafe. The source, addon, user settings and GitHub main were unchanged. This was a third avoidable patch-author packaging failure, not an in-client result.

## P0354 R3 bounded handoff and preventative checks

R3 treats CURRENT_HANDOFF as an active short handoff, not an append-only historical log: the exact original P0353 handoff bytes are preserved in `docs/memory/handoffs/P0353_FULL_HANDOFF_ARCHIVE.md`; the active handoff is condensed to a current checkpoint, all three P0354 refusals, safety gates, and continuity marker index (P0317–P0353) with links to the archive and evidence. Long-form negative evidence stays in this evidence record, P0353 evidence, and the appended roadmap/patch index history. R3 guards a stricter 8 KB active handoff size, the existing 9,800-byte CURRENT budget, the exact archive baseline, the 11 SHA guards, and the durable version-policy preflight before running all 225 STATIC checks PREWRITE and POSTWRITE. The HUD report extraction itself is identical to R0/R1/R2. All runtime behavior remains UNVERIFIED.
