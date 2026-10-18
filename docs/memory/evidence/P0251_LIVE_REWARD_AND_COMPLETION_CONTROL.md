# P0251 — Live quest reward portrait and completion-control capability

Date: 2026-10-18. GitHub baseline `main` `c17ef52` P0250. User-provided screenshot and `LOGRES_DIAGNOSTICS_LATEST.lua`, 0.0.149-dev, load330, from an actual `QUEST_COMPLETE` interaction for quest 237, **In Defense of the King's Lands**. The quest is deliberately reserved for ongoing tests; **do not complete it during P0251 validation**.

## Observed

The native Blizzard completion UI displays Lesser Healing Potion x3, 1,050 XP, 7 silver, and a native Complete Quest button. Logres' reward portrait card shows the same item/icon/count, and the same XP/7s. Quest Dialogue Check recorded completion event=1 shown=1, source=`guaranteed-item-ordinary`, money=700 copper, item cache requests=0, gate=`name-ordinary` and `rewardvisual cards=1` in the screenshot. This is a **live ordinary guaranteed-item portrait presentation PASS (read-only), scoped to quest 237**. It does not prove the intermittent cache-event branch or multi-choice behavior. The uploaded SavedVariables run history was collected before the on-screen live event for the latest attempt (the screenshot proves the post-event state).

User explicitly requested a Logres-styled **Complete Quest** action and suppression of the overlapping Blizzard quest completion UI, matching established Accept/Decline styling. The user will **not click a completion button** because quest 237 is a standing test quest. Therefore the claim execution path must remain RUNTIME UNVERIFIED, even if visual/suppression/restoration tests pass.

## Design and safety bounds

`CompleteQuest()` advances a progress dialogue; it is **not** the final reward claim. The native `QuestRewardCompleteButton_OnClick()` performs Blizzard's completion choice, payment confirmation, and `GetQuestReward` path. P0251 only uses that native handler after verifying its availability, an ordinary matching active quest ID, zero reward choices, zero money-to-pay, a shown/enabled native complete button, a shown reward panel and QuestFrame, and out-of-combat state. The fallback retains Blizzard for choice rewards, unknown/secret results, protected stock children, payments, missing handler, or any capture/suppression failure. Actual claim is invoked only from a deliberate user click on the Logres control. Native quest mouse subtree/alpha are captured before suppression and restored **before** the click dispatch; combat/protection are gated, no polling or blanket lifecycle suppression. QuestFrame itself remains shown. Failure must keep Blizzard usable; log the gating reason through addon-owned state only.

**Runtime status:** P0251 control and suppression path UNVERIFIED until the user reloads and checks control presence, stock visibility, and restoration by Immersion OFF while leaving quest 237 unclaimed. Claim mutation explicitly DEFERRED by user choice. Multiple-choice UI stays Blizzard-owned. Historical intermittent reward-name cache issue remains OPEN.

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

