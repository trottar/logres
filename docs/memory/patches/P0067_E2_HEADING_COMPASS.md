# P0067 — E.2 Heading-Only World Compass

Date: 2026-10-01
Result: PREPARED — RUNTIME PROOF PENDING

## Baseline

P0066 verified pushed:

`586d188d`

Runtime:

`0.0.27-dev`

## Runtime

Version:

`0.0.27-dev -> 0.0.28-dev`

## Purpose

Implement the first D-029 Phase E runtime slice.

## Changes

- adds `Navigation/Compass.lua`;
- top-center cardinal/intercardinal heading tape;
- Immersion + existing State context gating;
- secret-safe `GetPlayerFacing()` sampling;
- no stale/fabricated heading fallback;
- throttled world-only facing refresh;
- addon-owned Compass diagnostics;
- `/logres compasscheck`;
- `Compass Check` developer-panel action;
- Compass Check in Run All;
- new D-029/E.2 static checker;
- version-neutral repair to the older D.6 restoration checker;
- synchronized Phase E durable memory.

## Delivery tooling note

The first local generator attempt failed before artifact creation because the
generator source used conflicting nested triple-quoted strings.

No failed artifact was delivered.

The generator was corrected before the P0067 ZIP was produced.

## Explicit non-scope

No:
- C_Map position dependency;
- waypoint markers;
- quest presentation;
- distance;
- route/path guidance;
- minimap suppression.

## Runtime proof

Required before E.2 can close.

See:
`docs/memory/investigations/E2_HEADING_COMPASS_RUNTIME_VALIDATION.md`

## First apply failure

The first local P0067 apply aborted during static checks.

`tools/check_restoration_contract.py` selected the early already-disabled
`DisableInteraction()` cleanup call in both Player and Target replacement
functions instead of the later active-branch call after stock restoration.

Corrected P0067 fixes the checker only. Player/Target runtime code is unchanged.

Evidence:
`docs/memory/evidence/E2_P0067_STATIC_CHECKER_FAILURE_2026-10-01.md`

## Completion delivery

A second local apply failed because the applier used a brittle exact-text anchor
against `tools/check_restoration_contract.py`. The completion artifact removes
anchor replacement entirely and writes the final checker/memory files
deterministically.

## Stock checker correction

The completion apply exposed a latent false positive in
`check_stock_replacement_contract.py`.

The checker expected a contiguous source substring even though the existing
runtime message is split across two concatenated Lua literals.

P0067 corrects the checker and leaves the runtime stock-replacement command path
unchanged.

## Target checker scope correction

The final contract checker exposed another latent static-check false positive:
Target-only forbidden fields were searched across all of `Commands.lua`, which
incorrectly matched legitimate PlayerFrame diagnostic fields.

P0067 corrects the checker to isolate `runTargetFrameCheck()` before applying
Target-only forbidden-field assertions. Runtime Player/Target code is unchanged.

