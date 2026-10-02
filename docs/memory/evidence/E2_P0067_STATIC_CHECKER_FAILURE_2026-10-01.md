# E.2 P0067 Static Checker Failure — 2026-10-01

Status: FAILURE PRESERVED — CHECKER DEFECT CORRECTED BEFORE COMMIT
Date: 2026-10-01
Baseline: `586d188d3c624dd64ba05cfb91b8e17db5a57bc9`

## First local apply

The user applied the first P0067 artifact.

The applier ran all repository contract checkers before manifest creation.

All reported checks passed until `tools/check_restoration_contract.py` reported:

```text
ERROR: PlayerFrame replacement must restore stock before disabling interaction
ERROR: TargetFrame replacement must restore stock before disabling interaction
```

The applier aborted.

No P0067 commit or push occurred.

## Narrow diagnosis

P0067 did not modify PlayerFrame or TargetFrame runtime code.

Both `DisableReplacement()` implementations contain two different
`DisableInteraction()` calls:

1. an early cleanup call in the `already-disabled` branch, where no active stock
   suppression is owned;
2. the active-disable call after successful `RestoreStock(snapshot)`.

The completed D.6 checker used an unrestricted first textual
`find("self:DisableInteraction()")`.

That selected the legal already-disabled cleanup call and compared it with the
later active-branch `RestoreStock(snapshot)` call.

The checker therefore reported a false ordering defect even though the actual
active branch still restores stock first.

## Correction

The checker now searches for `DisableInteraction()` beginning after the
verified `RestoreStock(snapshot)` occurrence within the isolated
`DisableReplacement()` function.

This preserves the D.6 invariant:

**active replacement removal restores stock first, then removes the Logres
interaction path.**

The already-disabled cleanup path remains legal.

## Corrected-artifact generation failures

While preparing the corrected P0067 artifact:

1. one local generator attempt failed with a Python quoting `SyntaxError`;
2. a second local generator attempt failed an internal anchor assertion.

Both attempts explicitly produced no valid corrected artifact and were not
handed off.

The final corrected artifact was rebuilt and audited before presentation.

## Scope

No PlayerFrame or TargetFrame runtime code change is required.

The compass implementation is not implicated by the checker failure.

## Classification

**STATIC CHECKER FAILURE — REAL DELIVERY FAILURE, FALSE RUNTIME DEFECT**

The failure remains durable project knowledge after correction.

## Reusable lesson

Static ordering checks for functions with multiple branch-local calls must
search inside the relevant order window/branch rather than treating the first
textual occurrence as the active transition path.

Artifact-generation errors are failures: never hand off an artifact unless the
actual final ZIP was successfully built and audited.

## Second local apply failure — brittle exact anchor

After the checkout was cleaned back to the verified baseline and P0067 was
reapplied, the applier failed before checks with:

```text
P0067: tools/check_restoration_contract.py: expected exact anchor once, found 0
```

Cause:
the applier used brittle `replace_exact` text surgery against the restoration
checker instead of writing the intended final file deterministically.

This is a delivery-tooling failure, not a runtime addon failure.

Correction:
the completion artifact contains a complete final restoration checker and
complete final memory files. Its applier performs no anchor replacement.

## Stock replacement checker false positive

A later P0067 completion apply passed the corrected D.6 restoration checker and
then exposed a second latent static-check defect:

```text
ERROR: Commands.lua missing replacement path:
Turn Stock Bars Replace OFF first.
```

The runtime command path was present on verified `main`, but intentionally split
across two concatenated Lua string literals:

```text
"replacement owns this routing domain. Turn Stock Bars "
"Replace OFF first."
```

The checker incorrectly required the human-readable message as one contiguous
source substring.

Correction:
- preserve the runtime command text unchanged;
- make the static checker verify the two actual source fragments;
- do not rewrite Commands.lua merely to satisfy a brittle checker.

Classification:
**STATIC CHECKER FAILURE — REAL DELIVERY FAILURE, FALSE RUNTIME DEFECT.**

## Target checker scope false positive

After the stock-replacement checker correction, the full contract run reached
the final contract checker and reported:

```text
ERROR: Commands.lua still inspects secret-capable target state:
debugStatus.containerAlpha
ERROR: Commands.lua still inspects secret-capable target state:
debugStatus.contentMainAlpha
```

Source review confirmed both fields are used by `runPlayerFrameCheck()`, where
they are part of the established PlayerFrame diagnostic. They are not used by
`runTargetFrameCheck()`.

The Target checker incorrectly searched the entire `Commands.lua` file for
Target-forbidden fields instead of isolating the Target diagnostic function.

Correction:
- isolate `runTargetFrameCheck()`;
- apply Target-only forbidden-field checks only inside that function;
- leave PlayerFrame diagnostic behavior unchanged.

Classification:
**STATIC CHECKER FAILURE — REAL DELIVERY FAILURE, FALSE RUNTIME DEFECT.**

