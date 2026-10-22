# P0302 — Live trainer hover feedback

Date: 2026-10-22. Verified GitHub baseline main P0301 `07bc02829132feab15a2f7703ffb42e93bccc655`, version `0.0.202-dev`. **P0302 PREPARED / WSL FULL SUITE AND WOW UNVERIFIED**.

## User observation
User screenshot displays P0301 class trainer at Briarthorn with Logres `Train all (4, 39s)` and Blizzard `Train all (4, 39s)`, consistent catalogue costs, valid textures and Goodbye. **BULK QUOTE VISUAL PASS** only; no bulk click, server-confirmed learning or funds deduction is shown. User requests hover indication like the existing Quest Accept/Decline controls. Current Logres selectable rows, filter and Train actions have owned mouse regions but no `OnEnter` visual (except Goodbye). This is a usability omission, not a transaction fault.

## Narrow reference and design
`Logres/UI/DecisionVisual.lua` creates Quest decision visuals and brightens text plus underline on `OnEnter`, resetting on `OnLeave`. P0302 independently applies its visual vocabulary (warm translucent hover wash, gold bottom rule and action text brightening) to the live trainer's existing addon-owned interaction regions. The `TrainerLandscape.lua` painter owns row hover wash to avoid an input layer hiding icon/name art. `TrainerLiveTrial.lua` owns event handlers and capability gating. Hidden/disabled rows stay inert. Hover hides whenever a row is recycled, filter or scroll changes, pointer leaves or Goodbye/OFF hides the parent. The accepted synthetic P fixture does not receive an interactive hover.

## Safety and tests
Exact clean P0301 Git/blob baseline, unique transforms, candidate heading/version/EOF/whitespace validation, full `tools/check_*.py` PREWRITE and POSTWRITE, rollback and manifest are required. No native data/transaction mutation; P0301 `QuoteAll`/`AttemptAll` and P0296 single-skill PurchaseTrial remain byte-identical. No `BuyTrainerService`, native setters, C_Timer, `OnUpdate` or protected-frame modification added to visual/controller files. Stock trainer remains available.

WoW: `/reload`, open trainer, `/logres panel` → H — Integration and Polish → Live Trainer ON (TEST). Hover a selectable row, filter, scroll arrow and enabled Train selected/Train All; highlight should appear and disappear on pointer exit. Hide chosen row via search and verify no ghost highlight. Ineligible Train controls must not glow; Goodbye/OFF must remove all hit regions. No purchase required. Any Lua/taint/secret error is FAIL. This cosmetic test does NOT authorize Train All as runtime-validated or native stock suppression.
