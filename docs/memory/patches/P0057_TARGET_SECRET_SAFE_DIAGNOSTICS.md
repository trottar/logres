# P0057 — Target secret-safe diagnostics

Date: 2026-10-01
Result: PREPARED — runtime proof pending

## Baseline

P0056 pushed:
`4d7b6b1`

Version:
`0.0.24-dev`

## Failure

`/logres targetframecheck` raised:

```text
attempt to perform boolean test on a secret boolean value
```

at the P0056 diagnostic branch over `IsIgnoringParentAlpha()`.

## Fix

Version:
`0.0.25-dev`

- capture IgnoreParentAlpha value as an opaque restoration token;
- never branch/compare/format that value;
- remove secure visibility/mouse readback from Target diagnostics;
- track Logres-owned mutation state:
  - preserved override count;
  - stock presentation suppression;
  - stock mouse suppression;
  - interaction configuration;
  - interaction mouse ownership;
  - unit-watch registration;
- update Target Frame Check;
- add static secret-safety guards.

## Runtime status

Target runtime proof remains open until P0057 diagnostics and the normal target
visual/interaction/restoration checks pass.
