# P0251 — Single ordinary quest completion control and safe stock fallback

- Baseline: verified `main` c17ef529ee12f611e02df0fcc76a41dbf2570dda.
- Evidence: user preserved real quest 237 and provided matching Blizzard/Logres guaranteed reward portrait, item x3, XP 1050, 7s.
- Add: Logres-styled Complete Quest button built from existing Offer button primitives; guarded P0251 completion control, reversible full stock presentation suppression, guarded native handler dispatch with restoration BEFORE click.
- Eligibility: only live ordinary matching QUEST_COMPLETE with 0 selectable choices and 0 quest payment, out of combat, visible enabled native reward button, no protected/unknown stock descendants; otherwise stock fallback unchanged.
- Never press Complete Quest in developer panel; no automatic claim or synthetic quest state mutation.
- Source contract + all repo static checks run by guarded applier; runtime still UNVERIFIED. Claim click is deliberately deferred because quest 237 is a standing test fixture.
- Earlier P0248 R0/R1 static and R2 runtime errors remain in their historical records; intermittent item-name cache OPEN and live choice claiming DEFERRED.

## P0251 R0 static-checker prewrite failure; R1 correction

The user applied the original P0251 ZIP to verified `main` `c17ef52`
with clean tracked files. The applier reported exact baseline PASS and 15 prepared
source/memory files PASS, then REFUSED in shadow validation:
`check_checker_version_policy.py` found the new durable
`tools/check_p0251_completion_control_contract.py` embedding a literal runtime
version. `git status --short` showed only the three unrelated untracked preview
PNGs, and no manifest was generated. No tracked source was changed. This is a
patch-checker authoring failure, **not** a WoW runtime failure.

R1 removes the literal runtime version from the new contract checker. Instead,
it tests that the *current* TOC and Bootstrap version declarations both exist,
agree, and have the expected development-version shape. The repository's
historical-version policy remains unchanged. The applier continues to run the
complete static checker suite in shadow before any tracked writes. No other
Lua/runtime logic or quest-claim behavior changes in R1. No quest claim is to
be exercised on preserved quest 237; runtime remains UNVERIFIED.

## P0251 R1 static prewrite failure; R2 correction

The user verified R1 SHA-256 `9eb38afac630bdd42798e5ecd674df21b19890e7263ecf465bb9e57d20ef4897`, and the R1 applier again passed exact main baseline and unique transforms (15 prepared files) before **REFUSING without tracked writes**. The shadow suite reported `check_p0248_reward_visual_contract.py: ERROR: reward visual must load before dialogue`. Source diagnosis: P0251's TOC transform inserted `Quest\CompletionControl.lua` **between** `Quest\RewardVisual.lua` and `Quest\Dialogue.lua`, violating P0248's required literal adjacency even though both dependencies still loaded first. `git status --short` again contained only the three previously untracked P0214/P0215/P0219 PNGs; no manifest or tracked changes.

R2 corrects the TOC transform to `Quest\CompletionControl.lua` **before** the existing `Quest\RewardVisual.lua` / `Quest\Dialogue.lua` pair. R2 adds that P0248 adjacency and controller-before-visual relationship to the new P0251 contract, plus an explicit applier prewrite assertion. No Lua runtime, handler, reward, suppression, or quest-claim logic is altered in R2. Full local shadow/postwrite checker and WoW validation remain UNVERIFIED; user must keep quest 237 uncompleted. R0's version pin failure and R1's TOC adjacency failure remain recorded; they are tool authoring failures, not in-game failures.

## P0251 R3 — quest completion Immersion OFF/ON recovery (2026-10-18)

User-provided screenshots and exported SavedVariables for `0.0.150-dev`/load332: natural quest 237, `questdialogue completioncontrol` reports `applied=true shown=true snapshot=true reason=applied clicks=0 claimCalls=0`. Blizzard was suppressed with Logres Complete Quest shown; after Immersion OFF, native Blizzard QuestFrame and Complete Quest control visibly returned. After Immersion ON, Logres panel did not return despite the same native completion being open. **RUNTIME FAIL (scope: toggling ON)**. Source cause: P0251 `HidePresentation()` clears `completionActive`; `ApplyPreferences()` re-presents only `activeDetail` quest offers, not completions, and ON does not emit another `QUEST_COMPLETE`. R3 caches an ordinary completion identity, requires native reward frame shown and a matching current ordinary quest identity before re-presenting, discards stale cache on lifecycle exit, preserves real event count, and promotes the existing button/underline layer. This is a proposed code correction, **runtime UNVERIFIED**. Claim clicks remain zero; the user explicitly retains quest 237. Remote GitHub main was P0250 `c17ef52` during R3 preparation, not a verified pushed P0251.

