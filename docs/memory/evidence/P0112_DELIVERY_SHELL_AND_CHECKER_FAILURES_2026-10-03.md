# P0112 Delivery Shell + Static-Checker Failures — 2026-10-03

Status: **DURABLE PROCESS-FAILURE RECORD — CORRECTED IN P0112 R5**
Date: 2026-10-03
Initial P0112 baseline: `bd0a9da3c7abc49ff527e8901bfd5c77846414a5`
Current parent after parallel P0113: `19c0d1ffcdc0cf2df59a2e648cfa9caab1c4d347`

## Why this record exists

P0112 repeated two delivery failures that were already represented in project
history, especially P0064:

1. a static checker stopped after the applier had already written patch-owned
   files, leaving a partial worktree;
2. staging/diagnostic commands referenced `P0112_MANIFEST.txt` before a successful
   applier had created it, so zsh offered to autocorrect the missing P0112
   manifest to the unrelated historical `P0111_MANIFEST.txt`.

The user explicitly identified this as a recurring failure and requested that the
lesson become durable project memory.

## Observed P0112 state

The first P0112 apply:
- verified remote/worktree baseline before writing;
- wrote the intended `0.0.45-dev` runtime/docs changes;
- passed the new camera-distance info checker;
- then failed in the older Taxi target-probe checker only because that checker
  required Bootstrap and TOC to remain exactly `0.0.44-dev`;
- returned nonzero before `P0112_MANIFEST.txt` was created.

The partial worktree therefore contained the intended P0112 files but no manifest.

## Static-checker diagnosis

`tools/check_camera_taxi_target_probe_contract.py` was intended to preserve the
P0109 Taxi capability contract.

It incorrectly also pinned the entire addon forever to the runtime version that
introduced the probe:

- `Logres.VERSION = "0.0.44-dev"`;
- `## Version: 0.0.44-dev`.

P0112 intentionally advances runtime metadata to `0.0.45-dev`.

No Taxi behavioral/safety assertion failed.

Correction:
- historical feature checkers must validate feature invariants, not pin unrelated
  future addon versions;
- the obsolete exact-version assertions are removed from the Taxi checker;
- the new camera-distance checker is also kept version-invariant so the same
  defect does not recur.

## zsh autocorrection diagnosis

When a referenced patch artifact does not exist, zsh filename correction can
offer a similarly named historical artifact.

For this incident:

`P0112_MANIFEST.txt`

did not exist because the applier had failed before manifest creation, while:

`P0111_MANIFEST.txt`

did exist.

zsh therefore offered:

`correct 'P0112_MANIFEST.txt' to 'P0111_MANIFEST.txt'`

This is not evidence that P0111 should be used. It is evidence that the new
artifact is missing.

The same class of failure was already recorded in
`P0064_ASSISTANT_WORKFLOW_FAILURES_2026-10-01.md`.

## Required operating corrections

For every future patch handoff in the user's zsh/WSL environment:

1. begin shell handoff blocks with:

   `unsetopt CORRECT CORRECT_ALL 2>/dev/null`

2. never reference `P00XX_MANIFEST.txt` in staging/commit commands until:
   - the applier has printed its explicit PASS result; and
   - `test -f P00XX_MANIFEST.txt` succeeds;

3. never accept zsh correction from a new patch artifact to an older patch
   artifact;

4. if a checker fails after patch-owned writes, treat the checkout as a partial
   patch state and diagnose it before reset/reapply/staging;

5. patch appliers that start from a verified baseline should be transactional
   over patch-owned files:
   - validate as much as possible before writing;
   - capture exact pre-write content for patch-owned files;
   - on post-write validation failure, restore patch-owned files and remove new
     patch-owned files before returning nonzero when safe to do so;

6. do not use `git diff --name-only` alone to decide whether the checkout changed
   when it conflicts with `git status`; use porcelain status and direct
   `git hash-object` verification for the relevant paths.

## R2 repair parser failure

The first in-place repair (R2) also failed before making repair-owned writes.

Cause:
its helper returned `git status --porcelain=v1` through `.strip()`. Porcelain
records intentionally begin with status-column whitespace. Stripping the whole
output removed the leading space from the first record only:

` M Logres/Camera/Probe.lua`

became:

`M Logres/Camera/Probe.lua`

The parser then sliced `line[3:]`, producing the impossible path:

`ogres/Camera/Probe.lua`

and reported a false tracked-set mismatch.

Correction:
- preserve raw porcelain output exactly;
- never call `.strip()` on machine-readable Git status output;
- parse status columns before path extraction.

This failure occurred before the repair transaction began, so no repair-owned
repository files were changed by R2.

## R4 repair anchor failure

R4 rebased to the separately pushed P0113 parent correctly, but then tried to
synchronize several deferred shared documents in the same recovery pass. That
was unnecessary and reintroduced a brittle text-anchor dependency.

The local `docs/ROADMAP.md` was still the already-written first-attempt P0112
version, not the untouched P0113-parent version R4's anchor expected. The exact
anchor therefore did not exist and R4 rolled back its repair-owned changes.

Correction:
recovery must stay narrow. P0112 R5 repairs the known partial state, updates only
the authoritative CURRENT / handoff identity and patch index needed for
correctness, and leaves the remaining P0113 shared-summary convergence for a
later docs-only checkpoint after P0112 is durable.

## Classification

**DELIVERY / PROCESS FAILURE.**

Not WoW runtime evidence.
Not a failure of the read-only camera-distance diagnostic contract.
