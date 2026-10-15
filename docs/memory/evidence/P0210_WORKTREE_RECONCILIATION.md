# P0210 — Local worktree reconciliation and P0209 R8 bounded runtime evidence

Date: 2026-10-14. Authority: GitHub `main` at `f6b9a3a58bfc9081043455038df33b706c6e9e6f` (P0208), independently verified. **P0209 R0–R8 and their source/memory/checker revisions remain LOCAL/UNCOMMITTED and are NOT durable upstream.** P0210 is a docs/ignore reconciliation checkpoint, not an additional runtime fix.

## User-observed P0209 R8 result

The user reports the latest R8 candidate **worked**: with Immersion ON the Blizzard pet frame/bar is **already absent after `/reload`**; after Immersion OFF followed by ON it disappears again. This is **USER-CONFIRMED ordinary visibility behavior for the tested reload and mode transition**, not a blanket full pet-surface acceptance. The exact initial/reload/cycle test was described in prose, not logged as a screenshot/driver action series. Do not infer untested combat behavior, native secure interaction in Immersion OFF, Edit Mode recovery, or taint-free execution from this result. P0197 in-combat duplication and previous P0206/P0209 failures remain historical evidence pending a distinct verified closure.

The supplied `LOGRES_DIAGNOSTICS_LATEST.lua` records `0.0.120-dev` loadCount 277, Immersion OFF/ON transitions, and a later ordinary `checkall` with `nativeuicheck: PASS`. It does **not** include a new R8 `/logres petbardriver check` trace (the driver entries refer to older modes), so it cannot independently prove initial driver registration or combat behavior. The file also records an earlier `statecheck: FAIL` (revision changed during check) and `stockreplacecheck: FAIL` while combat-pending; preserve these observations and do not relabel them PASS because a later ordinary check passes. The user's direct visual report establishes the bounded reload/transition behavior.

## Worktree classification from user's `git status --short`

**Preserve and reconcile:** modified tracked Logres source (Bootstrap, Commands, PetActionExecutionProbe, NativeSurfaceReplacement, TOC); untracked `Logres/Immersion/PetBarVisibilityTrial.lua`; modified `tools/check_pet_combat_candidate_contract.py` and untracked `tools/check_petbar_visibility_trial_contract.py`; modified phase/memory docs; untracked P0209 R0–R8 evidence and patch records; `P0209_R8_MANIFEST.txt`. These are not disposable simply because they are uncommitted.

**Generated and local-only; ignore rather than delete:** `P0..._APPLY.py`, `P0..._README.txt`, `P0..._PAYLOAD/`, `*.zip:Zone.Identifier`, transient diagnostics and root screen-map staging. `*.zip` is already ignored in `.gitignore`, but sidecars are not. New patterns do **not** ignore `Logres/` Lua, `tools/` contracts, `docs/` evidence, or patch manifests.

**Unrelated/unclassified:** `KaonLT_E8_4_Canonical_Five_F2_Staging_Predecessor_Repair_Task_Contract.md` belongs to a different workstream and is deliberately untouched and unignored. Older untracked `P0209_*_MANIFEST.txt` entries remain visible for deliberate historical archiving instead of being deleted/hidden indiscriminately.

## Scope and next action

P0210 makes **no runtime Lua changes**, pet-frame policy changes, protected/native visibility queries, Git staging/commits/pushes, or deletions. It adds root-only ignore rules, records the verified bounded R8 visual outcome, and synchronizes current memory without marking full combat/interaction validation complete. Before a further pet runtime change, reconcile and checkpoint the candidate code and negative evidence, then conduct the remaining capability-gated pet click/autocast, PET STOCK, Edit Mode, combat and BugCatcher validation as practical. Do not revisit a now-unreproduced reload problem without new evidence.
