# P0206 R3 — Quarantine unsafe PetActionBar hidden-parent trial

Baseline remains **verified pushed P0205** Logres `main` `79a8e2308a37135b61db8ad8a0433cae5ec8b4bd`, with **local uncommitted P0206 R2** applied. This is an in-place corrective patch, not another push or automatic acceptance.

## Runtime result (P0206 R2)

WoW Forever 1.60.1.70338, Logres `0.0.110-dev`, loadCount 261. User explicitly observed the smaller Blizzard PetActionBar **no longer appearing in and out of combat**, then reported **Immersion OFF failed to restore Blizzard pet controls** and a BugCatcher protected-function error. Attached BugCatcher image contains localized `ADDON_ACTION_PROTECTED` text but **does not identify the addon, protected function or stack**. Attribution to the SetParent trial is a risk-based source hypothesis, not a proven callsite.

Addon-owned `petcombat` counters report two arm/disarm cycles `activations=2 restores=2 failures=0`, but no after-Immersion OFF test of native parent or interaction was recorded. The user-visible restoration failure overrides these narrow self-reported PASS-like counts. No Lua, taint or protection event may be marked PASS. **P0206 R2 runtime FAIL; DO NOT COMMIT/PUSH.** The R2 native hidden-parent strategy is **REJECTED/QUARANTINED** pending a new protected-state-safe approach; no speculative in-combat reassertion or native introspection.

## Correction

R3 restores `NativeSurfaceReplacement.lua` to exact P0205 native-fold code, removes all addon-driven PetActionBar `GetParent/SetParent` behavior, keeps `PetCombatCandidate` loaded only as a zero-mutation diagnostic quarantine, and makes Phase H **Pet Combat Trial ON (BLOCKED)** explicitly reject activation. OFF and Check remain callable. Retains the 18-button Phase H grid; no UI object from the trial can be armed. Version becomes `0.0.111-dev` for clear separation. The original P0197 in-combat duplicate may reappear and remains OPEN; it must not be disguised as resolved.

## Validation gates

After R3 guarded shadow checker PASS and deployment, `/reload` recreates native frames and clears R2 session-only reparenting. From Phase H run Trial Check (QUARANTINED), try ON (must reject, no native mutation), test PET manual open/close and Immersion OFF (stock bar visible **when pet controls are normally available**), then Immersion ON, and try ordinary pet button interactions. Check BugCatcher for new errors. Report any missing native bar or protected-action message as FAIL, preserve evidence, and **do not commit**. Do not manufacture combat; if it happens, previous stock overlap is a known OPEN regression relative to the trial, not a new reason to suppress unsafe controls.

## Delivery result / supersession

**R3 did not apply.** Its shadow suite stopped at `check_checker_version_policy.py` because the newly added `check_pet_combat_candidate_contract.py` hard-coded `0.0.111-dev`. All 26 previously printed checker passes apply only to the subset reached; no postcandidate runtime proof occurred. The user's `git status --short` continued to show the already-uncommitted R2 working tree. **P0206 R4 supersedes the R3 delivery**, removes the prohibited fixed-version literal while continuing to require Bootstrap/TOC version parity, and otherwise retains this exact corrective quarantine intent. See `docs/memory/patches/P0206_R4_CHECKER_POLICY_REPAIR.md`.
