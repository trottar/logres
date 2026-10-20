# P0276 R2 — local R0 candidate baseline reconciliation

Status: PREPARED / WSL and WoW UNVERIFIED (2026-10-20). Baseline remote `main` verified `75e8024`.

## Failure observed
The user attempted R1 after an earlier P0276 archive and received `refusing modified, staged or deleted tracked files` for thirteen tracked paths. R1 was limited to a pristine P0275 worktree and therefore refused before patch writing. The exact cause of those changes is not inferred from filenames alone. Do not erase existing worktree changes, stage blindly or override an unexpected tree.

## Correction and gates
R2 supports either (A) clean tracked P0275 HEAD or (B) a **byte-for-byte exact** local R0 candidate independently generated from the pinned HEAD and the bundled original R0 transforms. All staged edits and any mismatching/unrelated tracked state refuse. In mode B, every R0-new path must match the expected bytes as well. Unknown R1-owned paths also refuse. User's unrelated untracked PNG and P0272 manifest remain untouched. After classification R2 prepares the entire R1 functional candidate in a shadow, runs the full prewrite checker suite, performs prewrite whitespace validation, writes patch-owned files transactionally, checks postwrite suite/diff, and creates a new R2 manifest. On postwrite failure all original patch-owned bytes are restored.

No claim is made that R0 was successfully validated in WSL. R1 was REFUSED, not tested, and neither trial is accepted in WoW. This is a workflow correction, not permission to skip native-protection, restoration, D-046/D-047, or screenshot evidence. Camera and unrelated NPC surfaces are frozen.
