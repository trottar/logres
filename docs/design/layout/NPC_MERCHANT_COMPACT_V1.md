# P0424 — Merchant compact profile V1

Source authority: user-approved visual-polish request after accepting the P0423
V8 HUD layout (November 9, 2026). The photographed vendor Brog Hamfist
occupied an approximately 896×712 Logres trainer-style shell; two item columns
used much less than the available interior and the bottom footer was distant
from the last item row. This is a presentation refinement, not a purchase bug.

## Selected profile

| Service | Width × height (UI units) | Position | Policy |
|---|---:|---|---|
| Merchant (stock, buyback, repair) | **800 × 625** | TOP, Y −86 | compact native-backed shell |
| Trainer (7-row list, detail/train controls) | 896 × 712 | TOP, Y −86 | retain proven large profile |

Merchant and trainer share the **same** PanelSurface painter, palette,
sidebar/list vocabulary, title, dividers and reversible native presentation
contract. Each service declares its *own content-fit geometry* in the central
`Logres.PanelConfigs.trainer` configuration. Avoid shrinking trainer's
seven-row catalogue, details, costs or native training hit areas based only on
the merchant screenshot.

The merchant catalogue wash moves to X268/W500 and retains the two-column
stock placement (first item X290, second-column relative gap unchanged), while
its vertical wash ends at Y454. The lower divider moves from Y525 to Y468,
footer title/note to Y484/Y514 and pager center to Y583 (42 above bottom).
Native item buttons, quantity dialogs, stock/buyback tabs, pagination scripts,
repair controls, extended costs, native bags and gold display remain Blizzard
owned and remain fully accessible through the existing capability gate and
restoration plan. Preview labels use narrower widths so synthetic rows fit
inside their catalogue wash. The original native controls retain their own
widths, tooltips and transaction logic.

The compact merchant root is approximately 10.7% narrower and 12.2% shorter.
All static fixture bounds are inside the compact root, including six nominal
item-row pitches; this does NOT prove every Forever merchant variant fits.
Unknown native geometry, restricted environments, missing native controls and
combat restoration still fail open to stock according to the existing gates.

## Client acceptance

In WoW Forever, open an ordinary vendor with Immersion ON and verify list,
page navigation, Merchant/Buyback, Goodbye, currency, bags and real stock
controls at the new size; Shift-click an item and cancel the native quantity
popup. Test a trainer to ensure its independent 896×712 catalogue, scroll,
training costs and buttons are unchanged. Test Immersion OFF/ON, close/reopen,
small viewport or scale if naturally available. Lua/protected/secret errors are
failures. Do not buy items only to prove the layout.

Status: P0424 static candidate; **runtime UNVERIFIED**.
