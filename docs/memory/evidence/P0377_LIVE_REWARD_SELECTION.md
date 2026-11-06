## P0377 R4 — historical ledger retention repair (2026-11-05)

- **R3 REFUSED at 211/247 PREWRITE STATIC:** `check_p0375_quest_presentation_provenance_contract.py` requires `P0375` in each of L-002, L-005 and L-034 rows. The P0377 applier's `issue()` helper rewrote L-005 attempt, verification and evidence fields, discarding its previous `P0375` provenance. No tracked files were modified. The 210 preceding checks passed only as run; 36 subsequent checks were NOT run.
- **Root cause:** destructive row replacement violated the canonical ledger's cumulative evidence rules, not a runtime quest failure.
- **R4 resolution candidate:** append all previous attempt/verification/evidence text to each revised row and reject any generated candidate that loses any previous ledger field. Explicitly check the three P0375 historical row markers before running the 247-checker shadow suite. Retain scoped timer check and native fail-open transaction gates; do not weaken the P0375 checker.
- **Failure history:** R0 arity TypeError; R1 missing live-choice cleanup method; R2 broad preview-timer false positive; R3 missing historic P0375 issue marker. All PREWRITE refused; no runtime PASS. L-005 remains PARTIAL and L-002 OPEN. The 247 PRE/POST checks and WoW validation are still contingent.

## P0377 R3 — scoped reward timer contract repair (2026-11-05)

- **R0 REFUSED / applier error:** generated `once()` call omitted its path argument; `TypeError` before any tracked write.
- **R1 REFUSED / candidate-contract mismatch:** the generated `RewardVisual.lua` omitted `function Visual:ClearLiveChoiceHandler()`; the shadow P0377 checker rejected the candidate before any tracked write.
- **R2 REFUSED / false-positive contract:** P0377's new checker prohibited `C_Timer.After(` across *all* of `Quest/Dialogue.lua` despite the existing `PresentText()` preview-only conditional auto-hide timer at P0376 line 1303. This was neither reward polling nor a new transaction. Shadow static checks stopped before tracked writes; previous historical checkers passed only for those actually run.
- **R3 correction:** narrow the timer/polling prohibition to the new reward-selection coordinator methods between `HandleCompletionAction()` and `HidePresentation()`. Keep global prohibition of direct reward transactions in the dialogue. Add a scoped timer regression fixture and candidate preflight. Do not remove or alter existing preview auto-hide behavior.
- **Disposition:** all R0–R2 negative outcomes are preserved. R3 is still a *candidate*, WoW UNVERIFIED; L-005 PARTIAL/FAIL, L-002 OPEN. Only the user's full 247 PREWRITE/POSTWRITE checks and later WoW evidence can establish a PASS.

## P0377 R2 — generated patch refusal correction (2026-11-05)

R0 refused before tracked writes because `once()` omitted its `p` argument. R1 passed unique anchors and legacy preflight but refused before tracked writes at the P0377 contract: missing `function Visual:ClearLiveChoiceHandler()`. R2 adds the missing method to the existing RewardVisual module and verifies all authored new-contract literal tokens against the complete candidate before shadow checks. Neither R0 nor R1 is a runtime result. WoW UNVERIFIED; L-005 remains PARTIAL and L-002 OPEN.

# P0377 — L-005 live quest reward selection and fail-open completion

**Date:** 2026-11-05. **Authoritative repository baseline:** P0376 `44d9269d78a0c16e8beee3404191dd47dc8649dd`, `0.0.262-dev`, 246 static checkers. **Candidate:** `0.0.263-dev`, 247 static checkers. **WoW client outcome: UNVERIFIED.**

## User report and latest diagnostic

User reports that P0376 improved reward hover/tooltips and compass presentation but **cannot select a reward in the Logres UI and has no Complete Quest action**. Uploaded `LOGRES_DIAGNOSTICS_LATEST.lua` captures session 14, quest 21: `completion-observed` #1411, `completion-presentation` #1414 (`shown`), and `completion-stock-fallback` #1415 (`choices-or-unknown`). Incident #1416 and #1418 screenshots succeeded. The journal also contains earlier P0375/0.0.261-dev sessions and a P0376/0.0.262-dev login (#1323). This evidence confirms the fallback decision; it does **not** prove whether a quest reward was later claimed or the screenshot's contents. L-005 remains PARTIAL / user-observed failure; L-002 native popup remains OPEN.

## Narrow source cause

- `Quest/RewardVisual.lua`: production cards were hover-only and live clicks were disabled. `previewChoiceHandler` was intentionally limited to authored deterministic previews.
- `Quest/CompletionControl.lua`: `Gate` rejects any `GetNumQuestChoices()` result other than zero; therefore a live multi-choice quest cannot receive completion ownership or its Complete Quest button.
- `Quest/Dialogue.lua`: the original Accept/Complete action root is hidden before attempting ownership, but no visible fallback action is configured if the gate rejects the quest. A player can therefore see Logres rewards without any actionable Logres button.

## P0377 candidate and module boundaries

1. **Data adapter (`QuestDialogue`)** preserves original native choice indices supplied by the guarded `GetQuestItemInfo("choice", index)` reader. No row-position remapping to native index. The data model stays plain and preview-only fixtures unchanged.
2. **View (`QuestRewardVisual`)** renders selectable live choice rows and highlight via an owner callback only after the controller has acquired ownership; retains item hover and Shift comparison. View performs no Blizzard reward action or native choice state mutation.
3. **Controller (`QuestCompletionControl`)** validates the ordinary bounded native choice count, current quest ID, non-combat, zero cost, shown/enabled native frame, complete one-to-one choice-card coverage, and an explicit selected choice. It restores captured stock **before** writing the user-selected native choice ordinal and calls the existing native quest completion handler. It never directly calls `GetQuestReward`, forces a protected interaction, polls, or auto-claims.
4. **Coordinator (`QuestDialogue`)** keeps the original shared Accept/Complete button and existing narrative-page painter. If capability is incomplete or changes at click time, it shows **Finish in Blizzard** on the final page with a stock handoff, rather than a dead-end reward screen. Claim and selection state are cleared on lifecycle exit.

## Evidence and test disposition

- Source review confirms the above preexisting limitation. Blizzard Forever UI source (`Gethe/wow-ui-source`, branch `forever`, `Blizzard_UIPanels_Game/Mainline/QuestFrame.lua`) uses the selected `QuestInfoFrame.itemChoice` in `QuestRewardCompleteButton_OnClick`, including native confirmation and error behavior. P0377 reuses that handler rather than bypassing it.
- The repository static suite and the P0377 checker must both run in the WSL checkout before commit; an archive build alone is **not** a static PASS.
- **Required in-game checks:** ordinary multi-choice quest (hover, select, highlight, switch, Complete Quest, observe `QUEST_TURNED_IN` and received item), zero-choice quest (unchanged), unsupported choice overflow/secret/cost (visible stock fallback and no orphaned controls), narrative next/previous page, Immersion OFF stock restore, /reload, and protected/taint/error journal. Environmental inability to reproduce is DEFERRED, not PASS.
- P0377 does not fix L-002 native Continue-frame visuals, L-027 Blizzard XP/recipe toasts, camera rotation, HUD overlap or quest tracker cycling. Those issues remain OPEN/PARTIAL as recorded.

P0377 R0 APPLIER REFUSAL (2026-11-05): the generated Dialogue insertion called once() with three arguments, omitting the old/new boundary. TypeError before tracked writes. R1 restores the original function as exact-match anchor, inserts new helpers after it, and audits arity for all once/section/issue calls. Full repository checkers still require WSL.
