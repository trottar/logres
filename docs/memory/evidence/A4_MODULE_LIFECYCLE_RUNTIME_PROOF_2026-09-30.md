# A.4 Module Lifecycle Runtime Proof — 2026-09-30

Status: VERIFIED  
Final tested baseline: `f5a12d4fc4b644dd5eac8aac02ef195d0b0e9104`

## Background

P0014 introduced the module lifecycle and `/logres lifecyclecheck`.

The first runtime execution reported FAIL, but its detailed values showed the lifecycle itself behaved correctly. The failure was traced to an incorrect diagnostic expectation for the explicit cleanup counter.

Canonical negative evidence:

`A4_LIFECYCLECHECK_FAILURE_2026-09-30.md`

P0015 corrected only that diagnostic assertion:

```text
cleanupBefore + 2
```

became:

```text
cleanupBefore + 1
```

and bumped the runtime version to `0.0.6-dev`.

## Corrected runtime result

After P0015 deployment, the user reported:

> all pass

The requested proof required:
- `/logres status` on the corrected build;
- `/logres lifecyclecheck`.

No new issue was reported.

## Contract behaviors covered

The corrected lifecycle check exercises:

1. **One-time initialization**
   - probe initialized at startup;
   - repeat initialization is a no-op.

2. **Enable idempotence**
   - first enable succeeds;
   - second enable is a no-op.

3. **Disable idempotence**
   - first disable succeeds;
   - second disable is a no-op.

4. **Owned cleanup**
   - explicit counted cleanup runs once;
   - cleanup stack is empty after disable.

5. **Owned preference subscription**
   - receives preference changes while enabled;
   - receives no changes after disable.

6. **Preference restoration**
   - the diagnostic restores the user's original `immersionEnabled` value before returning.

## Errors

No Lua error or lifecycle discrepancy was reported after the corrected P0015 diagnostic.

The P0014 false negative remains durable evidence as a diagnostic defect, not a lifecycle failure.

## Conclusion

A.4 success criteria are satisfied.

**A.4 — Module Lifecycle Contract: COMPLETE.**
