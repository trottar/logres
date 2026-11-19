# P0493 — L-055 secure action hotkey feedback alpha (2026-11-19)

## Baseline and live evidence

P0492 GitHub main `478cac8a945fb09b66e1fc903aef433fff0a30dd` (tree
`cfdf7ee7eb5fdfee3e2e9cef38d3b09b1c15de2d`) verified read-only.
Forever 0.0.358-dev session177 screenshots #18360 (00:12:04 EST),
#18363 (00:12:18), #18365 (00:12:22) attached in a user bug bundle.
Screenshot correlation is mtime-inferred rather than client encoded.
#18360 reports combat=false and six requested/ordinary actual root alphas
0; image shows button icons but no binding text. #18363 and #18365
report combat=true, requested primary/Bar4=1, secondary/pet=.85,
utility/Bar5=.75 and show key labels. Combat actual roots cannot be read
with this ordinary diagnostic, so do not call requested values measured.
User reports occasional key labels absent when returning to combat.
The exact missing-label *in-combat* state was not captured: issue
OPEN/INTERMITTENT/UNREPRODUCED in that narrower scenario, and screenshot
#18360 may involve a distinct native/icon visual owner. Do not assert
stock leak without separate owner evidence. User reports fade now mostly
works; P0492 scoped opacity improvement retained. No protected-action
warning is attributed from this export.

## Source hypothesis and constrained patch

The six action roots are children of protected action clusters whose
combat alpha is restored by secure `logrescombat`. The 70 keybind/press
feedback frames, including keybind text and plates, are separately parented
to UIParent and are only alpha-updated by an ordinary state callback.
An absent/stale callback at combat entry could reveal button icons while
leaving sibling labels at out-of-combat alpha0. Source-supported gap;
not a proven reconstruction of every screenshot.

P0493 registers 70 **existing addon-owned** feedback frames as refs on
that same one-shot secure driver and mirrors respective combat alphas in
`_onstate-logrescombat`. Lua callbacks in lockdown normalize to combat
alpha so a stale noncombat publication cannot undo the secure reveal.
Out-of-combat rest is still owned by ordinary state/hover/one-shot regen.
No new frames, keybind assignment, hotkey text edit, action routing,
protected attributes, native Blizzard reads, polling or timers. All rest0,
hover primary/Bar4=1, secondary/pet=.85, utility/Bar5=.75 retained.
Driver unavailable continues to favor visible usable controls; existing
fallback, pet and native source behavior unchanged.

## Testing and unresolved cases

A new isolated actual-source fixture must cover missed ordinary combat
callback, secure feedback refs on all 70 siblings, stale locked policy,
postcombat zero recovery, pet/side percentages and no insecure protected
root SetAlpha. Existing historical P0491/P0492/source-policy checkers remain.
Full static check results, final package transactional refusal/rollback and
SHA recorded in PRE_HANDOFF_AUDIT. **Static PASS is not client PASS.**
WoW must validate binding text independently on entry to combat, normal
execution, hovered bar alpha, postcombat zero, pet spell clicks and no
Lua/taint/protected warnings. If labels remain missing, capture Report Bug
*while combat=true*; `secureFeedbackRefs` diagnoses registration while
requested alpha remains policy, not combat measured opacity.
