# P0167 R1 — delivery failure: malformed evidence write call

Date: 2026-10-07
Baseline: `a67e0cce85e054eddfdd8f75cd17c9f450d66b3b`
Classification: **DELIVERY FAILURE — CLOSED BY P0167 R2**

## Attempt

P0167 R1 corrected the R0 stale `ACTIVE.md` assumption and synchronized the older P0131 panel-phase checker with the intended quest TEST-probe move to Phase F.

## Observed result

The applier verified the exact pushed baseline and entered candidate construction, then stopped before the checker suite and before any tracked write with:

`write() takes 3 positional arguments but 4 were given`

The user's post-failure status showed only the normal diagnostics file and extracted `P0167_PAYLOAD/` untracked. The R1 ZIP also incorrectly contained generated `__pycache__/P0167_R1_APPLY.cpython-313.pyc` delivery trash.

## Cause

The generated applier attempted to emit two evidence paths through one call to its local helper `write(path, content, root)`, producing a four-positional-argument call. The bytecode directory came from compiling the applier inside the build directory before packaging without excluding generated artifacts.

## R2 correction

P0167 R2:
- splits the malformed evidence emission into separate three-argument `write()` calls;
- statically validates every local `write()` call in the generated applier has exactly three positional arguments before packaging;
- excludes all `__pycache__` / `.pyc` files from the archive;
- removes only the exact known R1 bytecode artifact from the user worktree when present and untracked;
- preserves the same `0.0.84-dev` runtime candidate and panel-only scope.

No runtime candidate code, layout geometry, suppression policy, secure routing, or camera behavior was reached by the failed R1 delivery.
