# P0084 Delivery Failures — Recovery Record — 2026-10-02

Status: RECOVERY APPLIER PREPARED
Date: 2026-10-02

## Attempt 1

Observed:

```text
P0084: Target debug count anchor mismatch
```

Cause:
the applier renamed only the expression
`self.preservedOverrideCount` before looking for a debug-table anchor whose key
was still named `preservedOverrideCount`.

The failure occurred before TargetFrameReplacement, Commands, or D-027 were
written and before repository checks or manifest creation.

## Attempt 2

Observed:

```text
P0084-REPAIR: CURRENT.md does not match the partial P0084 state
```

Cause:
the repair expected the literal marker `P0084 prepares:` even though the exact
P0084 payload written by attempt 1 contains different wording:
`P0084 corrects that defect.`

The second repair failed before copying its repair payload or modifying tracked
runtime files.

## Durable lesson

Do not use prose marker strings as authority for recovery from a partial patch.

The recovery applier instead:
1. treats verified P0083 HEAD `484323bb...` as the only source baseline;
2. classifies every P0084-owned local file by exact bytes against:
   - P0083 HEAD;
   - the exact known attempt-1 partial payload;
   - the intended final P0084 content;
3. refuses unknown patch-owned edits before mutation;
4. reconstructs runtime source from `git show HEAD:path`;
5. builds the complete intended P0084 tree in a temporary `git archive`;
6. runs all applicable static checks there before touching the working tree;
7. only after preflight PASS writes the real working tree;
8. reruns checks and `git diff --check`;
9. creates the manifest.

## Classification

Both failures are:
**STATIC PATCH-DELIVERY FAILURES / CHECKER FALSE POSITIVE.**

They do not add runtime evidence and do not invalidate the P0083 runtime
root-cause finding.

## Attempt 3

Observed during the deterministic recovery's temporary-tree validation:

```text
Logres restoration failure diagnostic contract
=============================================
ERROR: Commands.lua still uses obsolete target diagnostic: overrides=%s
```

Cause:
the replacement-generated `Commands.lua` was not the problem.

The checker searched the entire file for `overrides=%s`, but that label is also
legitimately used by unrelated action-binding diagnostics:

- `Logres actionbindings: keyRouting=%s overrides=%s pending=%s`;
- `Logres %s bindings: keyRouting=%s overrides=%s boundButtons=%s pending=%s`.

The obsolete TargetFrame label exists only in
`restorationMismatchSummary`.

Correction:
scope the obsolete-label assertion to `restorationMismatchSummary` instead of
the entire Commands file.

The recovery preflight stopped in the temporary `git archive` before writing
the intended final P0084 working-tree files.

## Recovery v2 hardening

Recovery v2 additionally requires the exact restoration-summary label
replacement to occur exactly once and validates the resulting summary region
before the temporary-tree checker suite runs.

