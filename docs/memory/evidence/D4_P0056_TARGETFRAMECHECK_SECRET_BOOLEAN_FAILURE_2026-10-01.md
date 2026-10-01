# D.4 P0056 TargetFrameCheck Secret Boolean Failure — 2026-10-01

Status: VERIFIED FAILURE
Date: 2026-10-01
Baseline: `4d7b6b1`

## User result

Runtime version:
`0.0.24-dev`

`/logres status` succeeded.

`/logres targetframecheck` failed with:

```text
Logres command error: .../TargetFrameReplacement.lua:511:
attempt to perform boolean test on a secret boolean value
(execution tainted by `Logres`)
```

## Root cause

P0056 `GetDebugStatus()` did:

```lua
if region:IsIgnoringParentAlpha() then
```

The return value is secret-capable in this protected TargetFrame path.

The diagnostic attempted a Lua boolean branch on that value.

This violates the established secret-safe rule:
native protected/secret values may sometimes be transported back to native UI
APIs, but must not be branched on, compared for policy, formatted, or otherwise
inspected in Lua.

## Additional hardening

The same diagnostic also queried secure unit-watch frame visibility/mouse state.
Even though the first failure occurred earlier, P0057 removes those diagnostic
readbacks proactively.

P0057 diagnostics use only:
- module-owned non-secret state;
- structural frame existence;
- counts of successful Logres mutations;
- secure configuration state owned by Logres.

Exact prior secret-capable values remain opaque restoration tokens.

## Runtime feature status

The failure is diagnostic.

It does not constitute a PASS for Target replacement.

Do not close D.4 Target runtime proof until P0057 is deployed and the runtime
checks pass.

## Lesson

See L-013.

Secret-safe transport and secret-safe diagnostics are separate requirements.

A diagnostic must never inspect protected/secret state merely to prove that a
native mutation happened.
