# Logres changes from ordinary Chat

The user runs ordinary Chat and gives it a bug report or feature goal. Chat verifies GitHub main, reads the current Logres instructions and affected source at that exact commit, and forms the change. Use the repository's startup order and the issue ledger for a reported bug. Use GitHub read-only. For an investigation or source audit, return findings and evidence. Generate a change package only when the user asks to implement a change.

For a fresh local checkout receipt, run this from the Logres root in WSL and attach the resulting JSON to Chat if it needs local context.

```bash
python3 tools/chat_change.py context > LOGRES_CONTEXT.json
```

The receipt covers the Logres checkout. It records HEAD, HEAD tree, branch, tracked status, patchable untracked names, source version and checker inventory. It includes no source contents. GitHub supplies the tracked source for a clean matching checkout. When GitHub and the local checkout differ, Chat should identify the mismatch before preparing a change. The runner requires the exact clean tracked baseline. For a runtime bug, attach Report Bug evidence separately when it matters.

## Chat output for an implementation request

Use the user's goal, screenshots, Report Bug evidence, and approved design exports as applicable. Identify the precise surface, its owner and the requested change before editing. For a placement request, map the visible widget to its exact layout key and list the expected geometry delta. Distinguish adjacent surfaces such as pet actions and party status. If the evidence leaves the identity ambiguous, resolve it before changing geometry.

For a text change, build the complete `P00XX.logres.json` from baseline source. The user can download the JSON directly or receive it in a ZIP with a thin wrapper that calls the checked-in `tools/chat_change.py apply` and an author receipt. When delivering a ready-to-apply payload ZIP, use the repository's `tools/build_patch_zip.py` workflow and its transactional applier. Avoid patch-specific installers that implement their own guards or transforms. Deliver one apply route with an exact filename, SHA-256, and commands. When changing a control or owner, search existing `tools/check_*.py` files for both the source paths and moved action names before drafting. Preserve the original behavior and safety checks while updating any presentation-specific assertions. For runtime changes, compare TOC and Bootstrap versions dynamically in checkers. A literal version in a checker will fail the version policy. When adding a ledger issue, use the next consecutive ID and canonical row columns.

Use this JSON structure. The example is illustrative.

```json
{
  "schema": "logres-change/v1",
  "id": "P0413",
  "baseline": "1111111111111111111111111111111111111111",
  "title": "Describe the change",
  "files": [
    {
      "path": "docs/ROADMAP.md",
      "edits": [{"before": "Exact existing line.\n", "after": "Replacement line.\n"}]
    },
    {"path": "docs/NEW_NOTE.md", "create": "New file contents.\n"}
  ]
}
```

Use the actual full GitHub SHA and next patch ID. Each before block starts at an existing line boundary and must match exactly once. Use complete lines where convenient. A block can end mid-line when the untouched suffix should remain. Preserve LF endings in the complete output file. Apply edits in array order within each file. A blank `after` removes the matched lines. A `create` entry adds a text file in an existing directory. Only `Logres/`, `docs/`, `tools/`, and `README.md` are eligible. Version one covers UTF-8 text edits and additions. Use the existing guarded patch workflow for deletes, renames, binary assets, mode changes and new directories.

## Author release gate

1. Read the baseline at its full verified SHA, including the affected sources,
   historical checkers, relevant issue rows and current memory. Audit file
   ownership and allowed behavior before editing. Keep one coherent scope.
2. Construct the complete candidate from the exact baseline. For JSON, validate
   every anchor and reconstruct every final file. For a payload ZIP, compare
   archive payload bytes to the checked candidate. Check dynamic TOC/Bootstrap
   parity for runtime changes, CURRENT and handoff byte limits, canonical ledger
   rows, historical memory markers and active roadmap consistency as applicable.
   Keep historical checks focused on the behavior they were written to protect.
3. Run every real repository checker and diff hygiene on the exact final
   candidate. Verify the exact deliverable in a disposable checkout, including
   guard refusal and restoration after a failed post-write check. See
   [PRE_HANDOFF_AUDIT.md](../PRE_HANDOFF_AUDIT.md). Author preflight is a release
   gate. The user's guarded apply is a separate check. Withhold a code ZIP when
   the complete author audit is unavailable and name the actual limitation.
4. Attach or report a compact receipt bound to the delivery. Include the full
   baseline SHA, patch ID/revision, SHA-256 of the delivered file and inner JSON
   when applicable, exact changed paths and their final hashes, checker count
   and result, and which apply/refusal/rollback tests ran. Keep author, user
   apply and WoW results distinct. Recompute and retest after any byte change.
5. Use an exact repo-relative file or a known Downloads path in WSL commands.
   Keep searches scoped to the checkout. Give one apply command plus the
   matching staging verification. Start apply/stage instructions with
   `unsetopt CORRECT CORRECT_ALL 2>/dev/null`. Gate staging on explicit apply
   PASS and an existing current-patch manifest. On refusal, record the command,
   first independent failing check, counts and tracked state before revising.
   Preserve the failed revision, re-verify main and fix the contract or scope
   mismatch on that same baseline when it still matches.
6. Verify the user's push on GitHub main before taking the next baseline.
   Record exactly what the player observed. Visual acceptance and confirmed
   transactions, fallback, combat and recovery each have their own scope.
   For runtime changes put the mandatory `_classic_beta_` deployment block
   from the project handoff instructions immediately before WoW validation,
   and provide the actual `_forever_` target for Forever tests, `/reload`,
   the exact validation action, and the Report Bug export when relevant.

The [P0428 audit](../evidence/P0428_CHAT_WORKFLOW_REPLICATION.md) shows how
these checks relate to the successful multi-update run and its revisions.

## Run in WSL

Save the returned JSON in the Logres checkout root and review the change before applying it. The optional review command prints the exact derived diff and names existing checkers that mention changed runtime paths literally. These are search leads. Review leaves pure version bumps out of that list and warns about pinned versions in proposed checker files. The full suite still covers indirect dependencies. The check command runs the full checker suite on a temporary copy and reports every failing checker. The apply command builds the ZIP, checks and applies with rollback. It writes the ZIP beside the JSON and a manifest in the checkout.

```bash
python3 tools/chat_change.py review P0413.logres.json
python3 tools/chat_change.py check P0413.logres.json
python3 tools/chat_change.py apply P0413.logres.json
```

For a change you intend to apply, only the apply command is required. Packages that change files under `Logres/` require explicit `--allow-runtime` on the apply command. Use it when you requested and reviewed a runtime change. The runner derives paths and hashes. It refuses ambiguous or absent anchors, an unexpected HEAD, tracked edits and file collisions. Review any changed Python checker before apply because the checker suite executes it. After JSON apply, use the staging command printed by the runner. It stages the complete package and then runs `verify-staged`, which checks the index paths, exact file bytes and manifest against the same JSON. For a standalone payload ZIP, stage only its explicit payload paths plus the verified manifest, compare staged bytes with the verified payload or its recorded hashes, and run `git diff --cached --check`. Once that passes, commit and push. The runner itself reads Git only. For runtime changes, the Chat handoff should include the existing deployment block and in-client validation. Use Work for persistent issues requiring deeper investigation.
