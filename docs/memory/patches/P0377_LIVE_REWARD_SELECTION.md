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

# P0377 — Modular live quest reward selection

**Baseline:** P0376 GitHub main `44d9269d78a0c16e8beee3404191dd47dc8649dd`.
**Candidate:** `0.0.263-dev`, checker count 247. **WoW UNVERIFIED.**

Scope: L-005 reward choice and Complete Quest dead-end; L-002 stock fallback remains OPEN.

- `Quest/CompletionControl.lua` owns bounded selection and native claim, retaining quest ID, combat, cost, native button, restorative snapshot and restore-before-native-handler restrictions.
- `Quest/RewardVisual.lua` emits selection ordinal through owner callbacks; live selection/highlight only if acquired by controller. Never claims, polls or inspects protected state.
- `Quest/Dialogue.lua` adapts guarded reward-card indices, installs selected callbacks on final narrative page, owns shared action placement and always provides visible `Finish in Blizzard` when unsupported.
- Existing `Quest/RewardModel.lua` remains unchanged and passive. No new module, button factory, frame shell, global hook or TOC inventory change.
- New static contract, ledger-first evidence and durable documentation. Failure must remain recorded even if subsequent runtime validation succeeds.

Full static and WoW tests remain **UNVERIFIED** until run by the user in the actual checkout/client. No commit or push performed by this patch.
