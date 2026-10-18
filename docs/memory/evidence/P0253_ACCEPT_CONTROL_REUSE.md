# P0253 — Completion button must reuse the actual Accept control

Date: 2026-10-18. Verified GitHub main `34274dc` (P0252). User screenshot of
quest 237 shows correct Lesser Healing Potion x3, 1,050 XP and 7s, native
Blizzard suppressed, and redundant "Complete Quest below" text absent. The
standalone Complete Quest button nevertheless remains visually indistinguishable
from the pre-P0252 floating-text presentation. **P0252 visual acceptance FAIL.**
Do not erase the P0251 R3 OFF/ON restoration PASS or prior failures.

Diagnosis: P0252 only moved a second, independently constructed completion
button's parent by ten units and raised its existing decorative rule. The
Accept/Decline buttons are made by the same factory but live under the original
`offerActionRoot`, whereas Complete Quest uses its own action root/frame/layers.
The visual patch did not eliminate that duplication, so it cannot guarantee
true parity. No need to design another art surface or asset.

P0253 reuses the **identical Accept button instance** and `offerActionRoot`.
When a supported native completion is safely suppressed, the existing Accept
button alone changes label to Complete Quest, moves to center within the same
root, and its normal existing click route is redirected to the guarded native
completion controller. Decline is hidden. When a quest offer owns the panel,
Accept is restored to its original left position/label/click path and Decline is
shown. Page navigation preserves a guarded active completion without hiding its
shared root. A refused completion claim gate remains stock-visible. There is no
new texture, independent frame, or alternative presentation design.

`Quest/CompletionControl.lua`, quest reward reads and actual native claim routing
are UNCHANGED. Offer-control diagnostics report both actually shown Accept and Decline, not
just the shared frame; completion shown diagnostics are gated by completion
ownership. The source's P0251/P0252 static contracts are amended to reflect
intentional single-instance ownership, and a new P0253 checker asserts the same
factory object, restored offer controls, and no duplicate creation. P0252 runtime
FAIL is preserved in evidence and the patch index. **Runtime visual and offer
regression tests remain UNVERIFIED.** Quest 237 remains unclaimed (no permission
to exercise a Complete Quest action); final claim and choices remain DEFERRED.

## P0253 R0 — exact checker-anchor prewrite refusal; R1 repair

User verified SHA-256 `eecf4321edcd761d367d2f2708ddab59d11b39709c16b3c5d50c025a6e9fbc4d` and ran the original P0253 applier against verified, clean P0252 main (`34274dc`). The applier passed exact baseline validation, but REFUSED **before any tracked write** while transforming `tools/check_p0251_completion_control_contract.py`: `anchor count 0; expected 1` for the old checker token containing `"complete", "Complete Quest"`. The applier required whitespace not present around the checker literals (including before the quoted token and after the comma). A second transform for the prior completion frame-level check also required non-existent trailing whitespace and would have refused next. `git status --short` showed only three pre-existing, unrelated untracked preview PNGs; there was no P0253 manifest. This is a patch-authoring failure, not an in-client runtime error or proof of visual behavior.

**R1 repair:** Correct both old checker anchor strings to match the pushed P0252 checker. No Lua code, quest claim routing, visual design, or protected/native restoration logic changes from P0253 R0. R1 keeps the full transactional shadow static-checker suite, followed by `git diff --check`, before presenting a durable checkpoint. WoW visual comparison and final claim execution remain UNVERIFIED; preserve quest 237.
