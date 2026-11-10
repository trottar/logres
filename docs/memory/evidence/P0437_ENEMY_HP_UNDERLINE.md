# P0437 — Remove gold underline beneath enemy HP bars (2026-11-10)

## Observed / accepted

P0436 main `2982b30745828267f54a3ecaf3ba06800bc72f10` verified. The
user's Forever screenshot accepts the corrected combat-row 50% aggro visual,
full-size target, aura lane spacing and normal player-health vignette.
The remaining requested aesthetic change is removal of the thin horizontal
gold underline beneath each enemy percentage bar. This is an explicit user
visual requirement, not a runtime or combat classifier defect.

## Scoped implementation

`Logres/HUD/HUD.lua` builds the gold underline twice: once in
`buildEnemyDisplayFixture` for synthetic 100/50 previews, and once below
`LogresHUDTargetHealthBar` for the canonical screen-space target fallback.
Remove both standalone 46x1 accent textures, retaining the health bar,
percentage text, shared target font, cast cue, enemy name, and independent
harmful/helpful icon lanes with relative ±25px offsets. Keep the 50% scale
and opacity and unscaled combat-row alignment from P0436. Do not remove
unrelated player/pet/ally decorations or the historical theme token.

## Safety and outstanding gates

No nameplate creation, Blizzard frame child mutation, combat lockdown action,
secret-value inspection, aggro routing, change to the saved screen-space
preference, or removal of native/Logres fallback. The screenshot does not
prove real nameplate attachment or confirmed secondary aggro. D-042/L-011
remain DEFERRED. L-046 stays OPEN until an in-game screenshot demonstrates
the missing rule in both the preview and ordinary target fallback, with aura
spacing and percentage information intact. Static PASS alone cannot close it.
