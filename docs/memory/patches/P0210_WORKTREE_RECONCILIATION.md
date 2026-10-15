# P0210 — Non-destructive local working-tree reconciliation

Status: **PREPARED / LOCAL / DOCS AND GITIGNORE ONLY; NOT PUSHED**.

Verified pushed baseline is P0208 `f6b9a3a`; P0209 R8 `0.0.120-dev` remains local. User-confirmed bounded behavior: Blizzard pet frame/bar is absent initially after Immersion-ON `/reload` and again after an Immersion OFF/ON cycle. This is an observed visibility result, **not proof** of combat, protected interaction, Edit Mode, PET STOCK, or error-free operation. Preserve P0197/P0206/P0209 failures and mark untested contexts UNVERIFIED, not PASS.

The root `.gitignore` already includes `*.zip`. P0210 adds root-only exclusions for extracted one-off P0xxx appliers, readmes, payload directories, NTFS Zone.Identifier sidecars, local diagnostics and root map staging. Manifest files, source, contracts, memory evidence and unrelated data remain visible, unmodified and unstaged.

The applier guards `main` at P0208, exact original `.gitignore` Git blob, P0209 R8 manifest and source/checker hashes, and all R8 manifest entries prewrite. It creates a new P0210 checksum manifest, validates candidate whitespace, runs the existing static checker suite prewrite, runs `git diff --check` postwrite and rolls back patch-owned writes on failure. **No WoW redeploy required.** See `docs/memory/evidence/P0210_WORKTREE_RECONCILIATION.md`.
