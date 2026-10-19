# P0263 N3 — shared decision-button visual factory extraction

Date: 2026-10-18. Baseline: verified pushed `main` `36d43f6d748241d94cdb33d57b765a9391f8f7e8` (P0262 R1).

## Evidence received and classification

User reports **all five narrative/reward P-tab previews and pagination worked and looked as expected** after applying P0262 R1. `LOGRES_DIAGNOSTICS_LATEST.lua` on `0.0.160-dev`, loadCount 350 records each long/short/generic narrative, Single/Multi reward fixture command `PASS (state=shown)`. Read-only `questdialoguecheck`, `questoffercontrolscheck` and `checkall` report PASS. `questoffercontrolscheck` has `preview=true`, `clicks=4`, `lastResult=preview-only`, `probeCallOK=false`, no production call. This accepts P0262 only for scoped visuals and registered diagnostics; it does not prove every camera context, a real quest Accept/Decline action, generic gossip, native reward choice or claim. P0262 R0 static failure remains part of history.

## N3 question and implementation

Can the accepted original Accept/Decline/Complete **button artwork and cosmetic state callbacks** be used by a reusable N3 component while leaving all original action handlers and fail-open Blizzard controls unmodified?

`UI/DecisionVisual.lua` receives the original source-equivalent `setOfferVisual` painter, `CreateFrame("Button")` factory, original size, font/shadow, rule texture, visual normal/hover/pressed colors, and four cosmetic mouse callbacks. The theme-backed style/color functions and asset table are passed by the original quest owner; this preserves all exact fallback values without duplicating theme constants. `Quest/Dialogue.lua` retains its *sole* `createOfferButton` wrapper with exactly the original `OnClick` closure. The callback still intercepts preview clicks **before** guarded real completion action routing. Accept and Decline remain the original two physical button instances; Complete Quest continues to repurpose the actual Accept button, not create a third one. No new preview buttons or visual states are introduced in this extraction; existing inert offer and reward previews already exercise both appearances.

The original owner-owned `UpdateOfferControls`, `PositionCompletionActionVisual`, completion page gating, timer behavior, stock suppression, guarded claim and quest offer probes remain untouched. P0262 `NPCNarrativePages` remains unchanged, as do preview models, reward visuals, commands and the developer panel. Only one new visual module is loaded just after `UI/NarrativePages.lua`, before `Quest/Dialogue.lua`. Version advances to next development build for in-client distinction.

## Frozen and open boundaries

All five `Logres/Camera/*.lua`, DynamicCam coexistence/profiles, `Quest/OfferActionProbe.lua`, `OfferStockSuppression.lua`, `CompletionControl.lua`, `NarrativeModel.lua`, `RewardModel.lua`, `RewardVisual.lua`, `UI/NarrativePages.lua`, `Core/Commands.lua`, and `Dev/Panel.lua` remain byte-identical to P0262 baseline. No new event, polling, native quest mutation, protected/secret inspection, global source or bank/auction implementation. `QuestFrame` controls remain available under the same original capability gate and restore-before-claim policy. The reported transient Blizzard frame flash on real claim remains OPEN; quest237 must stay uncompleted.

## Static and runtime gate

One-time applier verifies pushed baseline and file blob IDs, transforms the exact original source factory once, tests complete prepared checkout through every `tools/check_*.py` checker in a shadow tree (minimum expected 129), runs whitespace checks **before tracked writes**, then repeats all checkers and records manifest after writing. The dedicated P0263 contract requires the view's original cosmetics and strictly forbids action handlers/native operations. The full suite is performed in WSL, not claimed by artifact creation alone.

WoW proof requires `/reload`, P — Previews page 1/2: long quest narrative first/final page, Short, Generic, Single/Multi rewards, visual hover and press of in-panel Accept/Decline and Complete Quest sample. Synthetic clicks remain preview-only; use H — Integration and Polish → Quest Offer Controls Check to inspect `lastResult=preview-only`, `probeCallOK=false`. F — Quest Experience → Quest Dialogue Check is read-only. No external NPC or claim is needed. Visual success is still **UNVERIFIED** for P0263 before user report; static PASS does not imply parity. Next: explicit generic inert decision-state fixtures and then N4 option lists only after this view proves parity and second-use need.

## P0263 R0 delivery failure / R1 correction (2026-10-18)

The user's WSL application of original `P0263_N3_DECISION_VISUAL.zip` verified its published SHA-256 `de9575d5e7873e590bf85a7edfc56220def1a5d5d79f603427d0dc199567afbf` and extracted the archive. The applier stopped at its **prewrite payload gate** with `P0263: ERROR REFUSE payload missing DecisionVisual.lua`. The original archive contained `P0263_APPLY.py`, README, evidence, patch record, and checker but **omitted `P0263_PAYLOAD/DecisionVisual.lua`**. The applier incorrectly required that file while also generating its bytes from the authoritative original factory. This is a **PACKAGE DELIVERY FAILURE, NOT A STATIC CHECKER PASS, NOT A WOW RUNTIME FAILURE**, and the refusal occurred before any tracked mutation or manifest creation. The user did not report a new WoW test.

R1 includes the missing real `DecisionVisual.lua` in the archive, and compares it byte-for-byte with the generated result before any tracked write. It retains exact baseline SHA/blob gates, complete shadow/postwrite suite, manifest, transactional rollback and frozen camera/native/controllers. No source behavior, runtime version, UI/art, quest action routing or camera intent changes from R0. R1 remains WSL/RUNTIME UNVERIFIED until applied and tested; R0's failure stays historical.
