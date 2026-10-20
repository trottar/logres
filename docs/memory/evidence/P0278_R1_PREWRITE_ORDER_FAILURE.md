# P0278 R1 — Prewrite contract-order failure and corrective handoff

Date: 2026-10-20. Verified baseline GitHub main P0277 `f042f311ba01e9b498c9abb2e0295d60e3e3a3b6`.

## Observed failure

User's WSL output for P0278 R0: checksum OK; archive extraction succeeded; baseline/shadow architecture/memory/whitespace PASS; PREWRITE candidate suite executed all 146 checkers and failed only checker 109: `tools/check_p0276_r1_native_trainer_skin_contract.py` reported `ERROR: trainer module ordering`. Applier refused before writing tracked files. No runtime evidence or deployment from P0278 R0.

## Narrow cause

The P0276 historical checker required literal adjacency of `Quest\NativeTrainerRegionAudit.lua` and `Quest\NativeTrainerSkin.lua`. P0278 correctly inserted `Quest\TrainerMotif.lua` between them in the TOC; P0278's own checker verifies `TrainerMotif.lua` precedes `NativeTrainerSkin.lua`. The previous assistant inspected source anchors but did not reconcile this old checker before packaging: **assistant PREWRITE integration validation FAILURE**, not a user/environment error.

## Correction and status

P0278 R1 changes historical check to require the audit load before the trainer skin, not immediately adjacent. New P0278 checker retains the required row-motif module ordering. No change to P0278's source, painter, capabilities, native manipulation or camera. R1 adds the historical checker to exact pinned blobs, preserves all previously untracked packaging, and runs all 146 checkers PREWRITE and POSTWRITE. Static WSL and WoW visual/native restoration remain **UNVERIFIED** until user actually executes R1. Record outcome OPEN pending tests; never claim PASS without evidence. P0277 black Blizzard shell remains VISUAL FAIL; no native transaction UI replacement.
