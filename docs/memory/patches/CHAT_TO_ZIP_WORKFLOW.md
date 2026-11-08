# Chat-to-ZIP in WSL

Use this for routine text changes. Ask Chat for a Git unified diff against the full SHA of the verified main commit. The handoff must name the patch ID, title and every changed path. Review the diff before running the builder. Changed Python checkers execute during candidate validation.

From the Logres checkout, build with the exact command from the Chat handoff. Replace the example values with the supplied ones.

```bash
python3 tools/build_patch_zip.py ~/Downloads/P0406.patch \
  --id P0406 --baseline "$baseline_sha" --title "Routine change" \
  --path docs/ROADMAP.md --output P0406.zip
```

Repeat `--path` for each file. The builder refuses stale or malformed input and checks the exact shadow candidate before it writes the ZIP. It prints its SHA-256. The same reviewed diff, baseline, metadata and builder generate the same ZIP bytes. The local tracked tree is never the builder's staging area.

Verify the SHA-256, extract the ZIP at the checkout root and run its one-time applier. Inspect its manifest and the diff. Commit and push only when ready. Apply-time checks verify a clean tracked baseline, exact hashes, full checker names and rollback on failure. Runtime patches still need the existing deployment and Forever checks.

The first pilot is a tools and memory update. For the next routine change, ask Chat to produce the diff and exact build command. Use Work for a persistent bug or a change that needs deeper investigation. Version one accepts UTF-8 LF edits and additions within existing directories. Use the existing manually guarded workflow for renames, removals, new directories, binary assets or mode changes.
