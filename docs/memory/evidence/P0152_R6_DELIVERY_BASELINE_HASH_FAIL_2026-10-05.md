# P0152 R6 Delivery Failure — Wrong R5 Working-Baseline Hashes — 2026-10-05

Status: RESOLVED BY P0152 R6B DELIVERY REPAIR
Date: 2026-10-05

## Failure

The first P0152 R6 applier refused before candidate construction with:

```text
P0152 R6: FAIL: R5 working baseline mismatch: Logres/HUD/PetActionExecutionProbe.lua
```

## Cause

The R6 applier was pinned to the *pre-R5* hashes carried forward from the R5 applier instead of the actual post-R5 payload hashes. The mistake affected all five R5 replacement files, not only the probe file.

The correct post-R5 SHA-256 values are derived directly from the delivered R5 payload.

## Classification

**PRE-WRITE DELIVERY / BASELINE-PINNING FAILURE.**

R6 wrote no tracked files. The runtime evidence from R5 remains authoritative: direct `type1="pet"` produced a protected-action block and the guessed `y=-120` placement overlapped the resource bar.

## Repair

R6B keeps the R6 runtime candidate unchanged and corrects only delivery baseline verification to the exact post-R5 payload hashes. It still performs full prepared-candidate validation before writes.
