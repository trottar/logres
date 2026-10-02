# P0064 Assistant Delivery Workflow Failures — 2026-10-01

Status: DURABLE PROCESS-FAILURE RECORD

## Baseline

GitHub `main` remained at:

`20b1bf55`

P0063 runtime:

`0.0.27-dev`

The user had already completed the requested P0063 runtime validation and
reported it successful.

## Failure chain

The assistant then caused a sequence of avoidable delivery/process failures.

### 1. Repeated an already completed validation request

The user reported that P0063 had been pushed and the requested validation had
been checked successfully.

The assistant incorrectly interpreted the report as only a developer-panel
layout observation and asked the user to repeat the runtime validation.

This violated the project rule not to ask for context or work that the user had
already supplied.

### 2. Handed off an artifact after generation had failed

During the first P0064 artifact-generation attempt, the generation environment
explicitly reported that execution had reset and had not successfully
completed.

The assistant nevertheless presented P0064 as if a valid artifact and manifest
flow had been produced.

A failed/reset generation result must never be treated as a successful patch
build.

### 3. Used an ambiguous applier anchor

The first P0064 applier attempted to replace the generic text:

`Status: ACTIVE`

inside the Phase D roadmap.

That text occurred more than once.

The applier correctly refused the ambiguous mutation, but this exposed that the
patch had not been sufficiently audited before handoff.

### 4. Referenced a manifest that did not exist

Because the failed P0064 applier aborted before manifest creation,
`P0064_MANIFEST.txt` did not exist.

The assistant had nevertheless already supplied a `git add` command that named
that file.

zsh therefore offered to autocorrect the nonexistent P0064 manifest to the
unrelated historical `P0046_MANIFEST.txt`.

Patch handoff must never reference a manifest until the applier has created it
successfully.

### 5. Added an over-broad working-tree cleanliness rule

The first repair applier rejected every unrelated tracked modification.

The user's checkout already contained an independent modification to:

`docs/memory/LEARNINGS.md`

That unrelated local state was not a P0064 dependency and should have been
preserved rather than treated as a patch failure.

Patch appliers should verify the exact baseline plus the files they own. They
must not impose broader cleanliness requirements unless the patch genuinely
depends on them.

### 6. Repeated the invalid handoff pattern

After the repair applier aborted, the assistant again provided a staging command
that included `P0064_MANIFEST.txt` even though that manifest still had not been
created in the user's checkout.

This repeated the same avoidable shell-autocorrection failure.

### 7. Deviated from the already-proven patch procedure

Instead of discarding the failed approach and returning immediately to the
established patch workflow, the assistant introduced additional
"recovery-mode" logic.

That added complexity was unnecessary and created new failure modes.

The project already had a proven delivery pattern and there was no repository
requirement forcing the deviation.

## Impact

- No assistant commit or push occurred.
- GitHub `main` remained at `20b1bf55`.
- No runtime code was changed by the failed P0064 attempts.
- The user's checkout accumulated temporary/untracked patch artifacts.
- The user's unrelated `docs/memory/LEARNINGS.md` change remained outside the
  intended P0064 checkpoint.
- The user lost time repeating patch-application and staging attempts.

## Required operating corrections

Future Logres patch delivery must use the established procedure:

1. verify current GitHub `main`;
2. prepare one coherent patch artifact against that exact baseline;
3. verify only the patch-owned baseline files unless broader cleanliness is
   technically required;
4. preserve unrelated local modifications and unrelated historical untracked
   artifacts;
5. use exact/unambiguous mutation anchors or deterministic payload replacement;
6. run applicable repository checks;
7. run `git diff --check`;
8. create `P00XX_MANIFEST.txt`;
9. audit the actual ZIP before handoff;
10. provide the normal apply commands;
11. reference the manifest in `git add` only after the applier has successfully
    created it;
12. stop for `pushed` or a reported problem.

Additional evidence-handling correction:

- when the user reports a requested runtime validation was completed
  successfully, record that result at the precision actually supplied;
- do not invent missing console output;
- do not ask the user to repeat the validation unless new evidence creates a
  concrete reason to retest.

## Local-state rule reinforced

Unrelated local edits are not patch-owned.

In particular, the user's existing `docs/memory/LEARNINGS.md` modification must
not be overwritten, staged, or used as a reason to reject this memory
checkpoint.

This record exists so these failures remain project knowledge rather than being
lost in chat history.
