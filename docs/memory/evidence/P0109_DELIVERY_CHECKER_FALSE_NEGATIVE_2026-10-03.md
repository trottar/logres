# P0109 Delivery Checker False Negative — 2026-10-03

Status: **DELIVERY FAILURE — PARTIAL TRACKED WORKTREE MUTATION; RUNTIME NOT DEPLOYED**
Date: 2026-10-03
Remote baseline: P0108 `19efaad6`
Intended runtime: `0.0.44-dev`

## Failure

The first P0109 apply wrote the intended tracked runtime/docs changes and then
stopped during the new Taxi target-probe static checker.

The observed checker output was:

```text
Logres G.5 Taxi target-50 capability probe contract
====================================================
ERROR: Camera/Probe.lua missing Taxi probe contract: math.abs(finalFactor - self.lastCameraDistanceFactor) <= 0.000001
ERROR: Commands.lua missing Taxi probe contract: camerataxitargetprobe: PASS

FAILED: 2 error(s)
```

The original interactive apply wrapper also used `set -e` directly in the user's
interactive zsh. When the applier returned nonzero, that shell exited. This was a
delivery-procedure defect; future handoffs must not enable errexit in the caller's
interactive shell.

## Diagnosis

Both reported contract failures were checker false negatives.

### Multiline Lua expression

The runtime correctly checks the final camera-distance factor against the initial
factor, but formats the expression across multiple lines:

```lua
self.lastCameraDistanceUnchanged =
    math.abs(
        finalFactor - self.lastCameraDistanceFactor
    ) <= 0.000001
```

The first checker incorrectly required that expression as one exact single-line
substring.

### Dynamic PASS/FAIL format

The runtime result line uses one format string plus the dynamic status argument:

```lua
"Logres camerataxitargetprobe: %s (...)"
passed and "PASS" or "FAIL"
```

The first checker incorrectly required the literal combined substring
`camerataxitargetprobe: PASS`, which cannot occur in the source.

This is the same class of delivery-checker mistake previously recorded for
P0095: checker expectations must match semantic source fragments rather than an
imagined rendered runtime string.

## Repository effect

Unlike the earlier P0095 incident, the first P0109 applier wrote tracked files
before running the repository checker suite.

Observed state after failure:
- remote `main` remained P0108 `19efaad6`;
- intended P0109 tracked source/docs were present only in the local worktree;
- the new P0109 checker and patch record were present as untracked files;
- `P0109_MANIFEST.txt` had not been created;
- no commit or push occurred;
- no WoW deployment occurred.

The local worktree hashes were captured before repair and used as the P0109 R2
repair precondition.

## Correction

P0109 R2 changes checker/evidence only:
- accept the actual multiline final-factor comparison through semantic fragments;
- accept the actual `%s` result format plus the separate PASS/FAIL expression;
- preserve the already-written P0109 runtime implementation unchanged;
- run the complete maintained checker suite;
- create the P0109 manifest only after checks pass.

No runtime camera behavior changes between the first P0109 write and P0109 R2.

## Result classification

The first P0109 delivery is **FAILED / SUPERSEDED BY R2**.

This is not runtime evidence for or against target-50 capability.
