# P0339 — Source-verified November 4 gameplay regression matrix

**Baseline:** GitHub `main` commit `342cab97a8ad13478495f3247de155b50a5d4a05`, P0338 R1, `0.0.232-dev`, P0338 manifest reports 209/209 PREWRITE and POSTWRITE static checks. WoW client unavailable until contingent November 4 reopening; **no P0330–P0338 new client PASS**.

## Narrow source finding

P0338 is pushed, but `CURRENT.md` and the November 4 runbook retain pre-push checkpoint language. Existing `NOV04_VALIDATION_RUNBOOK.md` details initial P0321 native GossipFrame and merchant/flight gates, but does not enumerate the source-verified panel actions and per-issue PASS/DEFERRED conditions for P0330–P0338. `Logres/Core/Commands.lua` registers specific 0, B, C, E, F, H and P actions. The P0338 focused-marker status fields exist in `Compass:GetDebugStatus`, but the existing `Compass Check` prints only focused **quest** distance; it would be inaccurate to tell the user that this action already prints newer generic focused-marker fields.

## P0339 preparation

Add one docs-only regression matrix linked from the canonical runbook, retain the P0321-first restoration gate, and document each later checkpoint's verified panel actions, natural observations, negative-result/deferred criteria and export policy. Align `CURRENT.md` with the **verified pushed** P0338 commit and prepare P0339 with no runtime code, TOC change, version bump, source API, protected mutation, saved preferences or camera change. New pure static contract checks historical continuity, action strings, safe ordering and non-claims.

## Prepackage synthetic checker negative result

An initial isolated checker fixture falsely required the first `P0321` occurrence to precede the first `P0330` occurrence in the entire matrix, but the matrix title legitimately names P0330–P0338 before the mandatory P0321-first section. The fixture **FAILED** without repository writes. Corrected its order assertion to compare the actual **Mandatory ordering** section against the first P0330 test row. Re-run the checker against its exact generated candidate and preserve this result as a prepackage authoring failure, not a WoW failure. A second isolated fixture then caught the new patch record missing the literal `UNVERIFIED` status; that record was corrected before packaging. Neither fixture failure altered tracked files. The full 210-checker WSL run remains required.

## Limitations and negative results

The R0 failures of P0337 (checker mismatch) and P0338 (seven historical handoff expectations and preview checker scope) remain preserved in their existing evidence; these are not runtime defects. No client screenshot, `/fstack` native popup owner, combat/secure outcome, exact focused-distance performance or visual PASS was newly observed here. Retain L-022 reproduction gate, L-027 unknown native owner, optional QuestieDB and L-019 distribution blocker. Older map/native info remains accessible. Runtime verification is **DEFERRED**, not silently accepted.

## Acceptance gate

Full 210 PREWRITE shadow and 210 POSTWRITE checker run against exact P0338 pushed WSL baseline, candidate diff hygiene, SHA/blob checks, rollback and manifest; checker fixtures alone are not full static PASS. On November 4 first test P0321 native gossip restoration, then source-available bounded per-item observations. No WoW redeploy for this **docs + tools only** checkpoint.
