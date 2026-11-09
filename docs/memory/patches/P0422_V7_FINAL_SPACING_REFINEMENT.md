# P0422 — final V7 pet/party spacing refinement

Date: 2026-11-09. Baseline pinned to verified GitHub `main`
`ac373444999aabc8309b212e746f213de9fb6384` (P0421).

## User-approved scope

After deploying P0421, the user reported the layout looked effectively done
but that the party/allies frame and pet-action cluster sat slightly too close
to the pet bar. The requested fix is explicit and narrow: **shift both regions
1% to the right**.

## Runtime change

- `allies`: center X 23 → 24, Y unchanged at 50
- `petActions`: center X 9 → 10, Y unchanged at 50

All other V6/V7 centers remain unchanged. No widget sizes, action-bar roles,
grids, secure buttons, bindings, key ownership, contextual alpha, pet driver,
or Blizzard fallback behavior change. The P0420 H.2 overlay remains read-only.

## Static validation intent

P0422 should preserve the exact P0421 runtime except for those two center
translations, keep the historical V5/V6 maps intact, and retain out-of-combat
fit/recovery safeguards. WoW Forever validation remains **PENDING** until the
user tests the shifted spacing in-game.
