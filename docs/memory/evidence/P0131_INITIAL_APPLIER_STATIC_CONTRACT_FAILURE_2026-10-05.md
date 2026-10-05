# P0131 Initial Applier Static-Contract Failure — 2026-10-05

Status: **CLOSED — TOOLING CONTRACT DEFECT; RUNTIME DESIGN UNCHANGED**
Baseline: `ab6473b25944f6d8e17318235b370a6cb5a74cc5`
Candidate runtime: `0.0.62-dev`

## Attempt

The initial P0131 applier was run against the expected P0130 durable baseline.
All pre-existing repository static contract checkers passed after the candidate
files were written.

The new P0131 checker then failed with one error:

```text
ERROR: OfferActionProbe.lua missing contract fragment: action.reported = true
```

The transactional applier reported rollback of patch-owned files.
The resulting repository status contained only untracked diagnostic / patch
payload artifacts; no tracked P0131 changes remained applied.

## Cause

The runtime implementation's reporting method intentionally marks the stored
resolved action through:

```lua
self.lastAction.reported = true
```

inside `Probe:MarkReported(kind)`.

The static checker incorrectly required the nonexistent local-variable spelling:

```lua
action.reported = true
```

This was a checker-literal mismatch, not a runtime behavior defect.

## Correction

P0131 R1 changes only the checker contract to require the actual
`self.lastAction.reported = true` implementation.

The Accept / Decline probe design, mutation boundaries, event outcome rules, and
runtime code are unchanged.

## Classification

**CLOSED — STATIC CHECKER CORRECTED.**

Runtime mutation evidence remains pending after successful R1 application and
in-client validation.
