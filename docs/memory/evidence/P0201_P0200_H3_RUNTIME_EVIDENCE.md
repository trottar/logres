# P0201 — P0200 R1 runtime diagnostics checkpoint

Date: 2026-10-11. Type: **documentation and evidence only**. GitHub `main` verified at `9776cf936224f772be581d2378bcbc91403c71dc`, commit `P0200: coordinated H.3 visual implementation`, runtime version `0.0.109-dev`. Source: user-uploaded `LOGRES_DIAGNOSTICS_LATEST.lua`, last loadCount **256**, on Forever `1.60.1` build `70338` / interface `16001`. Source file is supplied in the conversation; raw SavedVariables are **not** tracked in the repository.

## Observed, bounded results

- Phase H Layout Check: after setup `19 anchors / 26 binds / 0 failures`, and after Phase 0 Run All `19 anchors / 29 binds / 0 failures`; `H2 v4 placement: APPLIED`, `13/13` named regions measured. **These are addon-owned geometry and bind checks, not measured collision-free visual acceptance or perfect adherence to planning-envelope dimensions.**
- Phase H Status Aura Preview ON: source/preview check PASS; preview player 2, target 4 (harmful 2 / helpful 2). Native secure HARMFUL containers intentionally `ready=true active=false` during preview. Preview OFF and subsequent Status Aura Check: PASS; native containers `ready=true active=true`. Live player HARMFUL ordinary reader remained empty, target absent. Native restricted aura membership and art/texture behavior are not inspected by this diagnostic.
- Native Access Check: PASS, desired=true, dock=true, five native domains folded, zero failures; separate native-surface candidate has four folded, `petInteraction=true`, `pending=false`, `error=nil`. This is addon-owned reconciliation evidence, not a click-through test of native access or visual visibility proof.
- Phase 0 Run All at loadCount 256 completed, with HUD, action, stock, camera, state, lifecycle, restore, and ownership diagnostics reporting PASS where exercised. Main normal secure replacement: CANDIDATE `armed=true applied=true route=true`, `activations=4 restores=3 error=nil`. UI Ownership: 35 total, 17 PASS, 18 STOCK, zero FAIL/DEFERRED; STOCK remains policy classification, **not** direct stock presentation inspection.
- No Lua, taint, protected-action or secret-value exception appears in the latest diagnostic command results. **This absence does not certify untested controls/modes.**
- PetActionBar re-show counters at loadCount 256: `onShow=0 combatDeferred=0 immediateRefolds=0 recovered=0 awaiting=false`. The prior intermittent duplicate stock pet bar is still OPEN / INTERMITTENT / UNREPRODUCED, and no combat recovery was exercised. Prior ObjectiveTracker flash remains OPEN / INTERMITTENT / UNREPRODUCED.

## Unproven visual and interaction gates

No new in-game screenshot accompanied this P0200 result; user said **"pushed"**, not that final H.3 appearance was visually accepted. Consequently **do not mark visual fidelity PASS** for the sheet-04 harmful frame, multi-icon target 2x3 fit, percentage contrast against the world, title/name typography, action/native-dock density, or v4 collision-free full screen. Also not demonstrated in this upload: real simultaneous player/hostile-target harmful effects; native PET/BUFFS/TARGET or STOCK/MAP/QUESTS/XP/MENU/CAST clicks; pet ability/autocast; manual primary click feedback; special/vehicle/combat paths; direct immersion OFF/ON user confirmation at this checkpoint. Tests completed by the automated Run All are PASS only for its internal tested scope; do not substitute them for the manual visual/click observations.

## Next evidence gate

Keep P0200 code and D-045 v4 coordinates unchanged. Evaluate one **uncropped ordinary 16:9 game screenshot** (overlay OFF), optionally H.2 overlay ON as comparison, plus the user's visual feedback on harmful icon sizing, typography and dock hierarchy. Prefer existing Phase H panel checks over slash commands. Observe real multiple harmful auras when naturally available; if none occur, keep that subtest DEFERRED without contrived travel/gameplay. Perform on-demand native controls and Immersion OFF/ON confirmation when practicable. Do not start speculative polling, broad native hooks, aura payload inspection, source/control ownership expansion or further art rewrites before evidence of an actual deficiency.

## Delivery history

P0200 R0 failed before tracked writes: obsolete H.2 checker pinned the old 18px native harmful declaration. P0200 R1 updated that checker; GitHub `9776cf9` verifies its push. The R0 delivery failure remains a separate recorded negative result and is not a WoW runtime failure.

## P0201 R0 delivery failure and R1 correction (2026-10-11)

**R0 PREWRITE FAIL — no tracked changes.** User verified the R0 ZIP SHA-256 `0e853792488a205c69d399facc73ad7a67b46c4e98b136936acd9057a75eb937` and ran `P0201_APPLY.py` on the verified P0200 `9776cf9` baseline. The applier halted at `invalid expected git blob SHA for docs/ROADMAP.md` before preparing or writing tracked files. The generated PINNED value `9287609a3ab7123f34fd869a02a97f6fc5c05c9` contained **39** hexadecimal characters. The authoritative GitHub `main` blob is `9287609a3ab7123f34fd869a02a97f6fc5c05c9c` (**40** characters). The user `git status --short` after failure showed only unrelated and patch-extraction untracked files; no tracked modifications. This is an assistant artifact-generation/delivery validation failure, not a WoW runtime failure.

**R1 repair:** correct this single pin to the verified full blob hash; retain the `9776cf936224f772be581d2378bcbc91403c71dc` baseline and unchanged P0200 runtime evidence; record R0 negative evidence in memory, index and manifest. All pinned SHA strings are checked for exactly 40 hexadecimal characters and match GitHub `main`. R1 still performs complete prewrite shadow `check_*.py` validation and postwrite diff/memory checks. **R1 runtime scope remains DOCS ONLY; no redeploy.**
