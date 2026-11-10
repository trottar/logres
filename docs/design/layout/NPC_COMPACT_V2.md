# P0425 — NPC Compact V2: merchant Buyback alignment and trainer fit

Source: user feedback + captured WoW Forever incident screenshots 9547, 9549,
9565, client `0.0.301-dev`. Baseline: P0424 main
`80b46f49dd71feb3a499b1885499b82ce744a2dd`.

| Service | V2 size | Policy |
| --- | --- | --- |
| Merchant | 800 × 625 | retain P0424 compact native-backed shell |
| Trainer | 820 × 660 | content-fitted seven-row owned trainer |

Merchant: keep native Merchant/Buyback `OnClick`, secure/stock transactions and
localized labels; move BOTH tab roots from top Y=140 to Y=128. The separate
`MerchantBuyBackItem` root should sit at (592,405) relative to shell top-left,
above footer rule Y468, rather than crossing the divider. The native root is
optional: when present, require a known direct MerchantFrame parent, ordinary
nonprotected mutable geometry, and a reversible snapshot before repositioning.
If unknown, fail open to stock. The native item is distinct from the Buyback
tab and still owns its own icon/click/tooltip, with original points restored.

Trainer: preserve all seven rows and 46-unit pitch, ordinary trainer catalogue,
scroll/thumb, searchable filters, current trainer/character professions,
selection, reagents, funds, Train/Train All fallback. Layout: 820×660 shell;
list rectangle x268/y102/w520/h352; details x33/y483/w480/h137;
reagents x532/y483; funds x533/y569; train actions at y593. The native
trainer UI remains parked/recoverable with no new training calls.

User acceptance requires live Merchant and Buyback tabs, native buyback icon,
real buyback click only if an appropriate item naturally exists, merchant
close/reopen, trainer seven-row visibility and selection, scroll, costs,
Goodbye, stock fallback, Immersion OFF/ON, and no Lua/taint errors. Do not
purchase an item or train a skill solely for proof.
