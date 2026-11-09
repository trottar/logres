# Logres changes from ordinary Chat

The user runs ordinary Chat and gives it a bug report or feature goal. Chat reads current Logres instructions and affected source from GitHub, verifies the exact main commit and forms the change. Use GitHub read-only. For an investigation or source audit, return findings and evidence. Generate a change package only when the user asks to implement a change.

For a fresh local checkout receipt, run this from the Logres root in WSL and attach the resulting JSON to Chat if it needs local context.

```bash
python3 tools/chat_change.py context > LOGRES_CONTEXT.json
```

The receipt covers the Logres checkout. It records HEAD, HEAD tree, branch, tracked status, patchable untracked names, source version and checker inventory. It includes no source contents. GitHub supplies the tracked source for a clean matching checkout. When GitHub and the local checkout differ, Chat should identify the mismatch before preparing a change. The runner requires the exact clean tracked baseline. For a runtime bug, attach Report Bug evidence separately when it matters.

## Chat output for an implementation request

Produce one downloadable `P00XX.logres.json` file and explain what changed and why. The user supplies the goal. Chat identifies files and builds the entire package from baseline source. Give the exact command for that file. Keep the interaction in ordinary Chat. Treat local checks as pending until the local runner reports results. When changing a control or owner, search existing `tools/check_*.py` files for both the source paths and moved action names before drafting. Preserve the original behavior and safety checks while updating any presentation-specific assertions. For runtime changes, compare TOC and Bootstrap versions dynamically in checkers. A literal version in a checker will fail the version policy. When adding a ledger issue, use the next consecutive ID and canonical row columns.

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

## Run in WSL

Save the returned JSON in the Logres checkout root and review the change before applying it. The optional review command prints the exact derived diff and names existing checkers that mention changed runtime paths literally. These are search leads. Review leaves pure version bumps out of that list and warns about pinned versions in proposed checker files. The full suite still covers indirect dependencies. The check command runs the full checker suite on a temporary copy and reports every failing checker. The apply command builds the ZIP, checks and applies with rollback. It writes the ZIP beside the JSON and a manifest in the checkout.

```bash
python3 tools/chat_change.py review P0413.logres.json
python3 tools/chat_change.py check P0413.logres.json
python3 tools/chat_change.py apply P0413.logres.json
```

For a change you intend to apply, only the apply command is required. Packages that change files under `Logres/` require explicit `--allow-runtime` on the apply command. Use it when you requested and reviewed a runtime change. The runner derives paths and hashes. It refuses ambiguous or absent anchors, an unexpected HEAD, tracked edits and file collisions. Review any changed Python checker before apply because the checker suite executes it. After apply, use the staging command printed by the runner. It stages the complete package and then runs `verify-staged`, which checks the index paths, exact file bytes and manifest against the same JSON. Once that passes, commit and push. The runner itself reads Git only. For runtime changes, the Chat handoff should include the existing deployment block and in-client validation. Use Work for persistent issues requiring deeper investigation.
