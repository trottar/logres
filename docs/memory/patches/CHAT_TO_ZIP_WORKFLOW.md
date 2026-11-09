# Logres changes from ordinary Chat

The user runs ordinary Chat and gives it a bug report or feature goal. Chat reads current Logres instructions and affected source from GitHub, verifies the exact main commit and forms the change. Use GitHub read-only.

For a fresh local checkout receipt, run this from the Logres root in WSL and attach the resulting JSON to Chat if it needs local context.

```bash
python3 tools/chat_change.py context > LOGRES_CONTEXT.json
```

The receipt covers the Logres checkout. It records HEAD, HEAD tree, branch, tracked status, patchable untracked names, source version and checker inventory. It includes no source contents. GitHub supplies the tracked source for a clean matching checkout. When GitHub and the local checkout differ, Chat should identify the mismatch before preparing a change. The runner requires the exact clean tracked baseline. For a runtime bug, attach Report Bug evidence separately when it matters.

## Chat output

Produce one downloadable `P00XX.logres.json` file and explain what changed and why. The user supplies the goal. Chat identifies files and builds the entire package from baseline source. Give the exact command for that file. Keep the interaction in ordinary Chat.

Use this JSON structure. The example is illustrative.

```json
{
  "schema": "logres-change/v1",
  "id": "P0407",
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

Use the actual full GitHub SHA and next patch ID. Each edit uses exact, complete LF-terminated lines. Include enough existing context to identify one occurrence. Apply edits in array order within each file. A blank `after` removes the matched lines. A `create` entry adds a text file in an existing directory. Only `Logres/`, `docs/`, `tools/`, and `README.md` are eligible. Version one covers UTF-8 text edits and additions. Use the existing guarded patch workflow for deletes, renames, binary assets, mode changes and new directories.

## Run in WSL

Save the returned JSON in the Logres checkout root and review the change before applying it. The optional review command prints the exact derived diff and writes nothing. The apply command validates the package, builds the ZIP, runs the checks and applies with rollback. It writes the ZIP beside the JSON and a manifest in the checkout.

```bash
python3 tools/chat_change.py review P0407.logres.json
python3 tools/chat_change.py apply P0407.logres.json
```

Only the apply command is required. The runner derives paths and hashes. It refuses ambiguous or absent anchors, an unexpected HEAD, tracked edits and file collisions. Review any changed Python checker before apply because the checker suite executes it. Commit and push when ready. For runtime changes, the Chat handoff should include the existing deployment block and in-client validation. Use Work for persistent issues requiring deeper investigation.
