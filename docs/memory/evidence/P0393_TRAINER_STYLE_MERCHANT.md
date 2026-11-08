## P0393 — Trainer-style merchant with native controls (2026-11-08)

## Visual evidence and authority

Verified published P0392 e431643adcd640fd1239a771f500b5c3888e813c. The supplied Tailoring Supplies screenshot shows the P0392 synthetic preview at the right, overlapping the Logres control dock, with plain text stock and red Blizzard template buttons. User rejected style and placement and asked for the trainer window analogue with all vendor features including quantity purchases. This is a P0392 visual FAIL; the screenshot does not establish a failed purchase.

## Design and capability

P0393 uses the trainer's 896 x 712 surface, upper center anchor, header, gold divider, list wash, sidebar, and footer. The preview and live window use the same shell. The preview uses inert item examples. Live moves named native controls and fades named decorative regions only. Supported Native MerchantFrame buys using its real item buttons and native quantity selector (normally Shift-click), sells from bags, pages, buys back, filters where available, performs repairs and uses the original confirmation, extended-cost, refund and stock rules. Bulk selling, guild repair, alternate currencies and modified clicks remain available when supplied by the native frame. The addon does not call any merchant transaction API.

Pinned source: [Vanilla merchant XML](https://github.com/Gethe/wow-ui-source/blob/9dc84f0d3bbae1768ac3405b3716000bd93eda06/Interface/AddOns/Blizzard_UIPanels_Game/Vanilla/MerchantFrame.xml), [Vanilla quantity and purchase handling](https://github.com/Gethe/wow-ui-source/blob/9dc84f0d3bbae1768ac3405b3716000bd93eda06/Interface/AddOns/Blizzard_UIPanels_Game/Vanilla/MerchantFrame.lua), [Mainline merchant XML](https://github.com/Gethe/wow-ui-source/blob/9dc84f0d3bbae1768ac3405b3716000bd93eda06/Interface/AddOns/Blizzard_UIPanels_Game/Mainline/MerchantFrame.xml), [Mainline merchant transactions](https://github.com/Gethe/wow-ui-source/blob/9dc84f0d3bbae1768ac3405b3716000bd93eda06/Interface/AddOns/Blizzard_UIPanels_Game/Mainline/MerchantFrame.lua). These establish source design candidates, not observed Forever layout behavior.

Presentation requires the observed merchant visit, normalized context, Immersion, ordinary non-protected targets and complete pre-mutation snapshots of required anchors and native size. The root remains visible. Capability refusal leaves Blizzard available. Restore runs on closing or context exit, Immersion OFF, world transition or manual stock toggle, and defers when combat locks geometry. The older manual placement trial is mutually exclusive. The Report Bug click saves current presentation result, starts, restores and pending state. No polling or transaction scripts replaced.

## Client checks still required

Compare the live vendor with the trainer placement. On an eligible item, open the quantity selector and cancel; optionally exercise a normal intended purchase. Verify the buyback tab, paging, tooltips and bag access. Repairs, alternate currency and optional services are deferred when absent. Use /logres merchantlive to show stock for this visit and confirm the original window is usable. Client layout, merchant interaction parity and L-003 remain UNVERIFIED. L-002 stays OPEN and deferred.
