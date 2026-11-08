## P0394 — Merchant Goodbye and control styling (2026-11-08)

## Observed client evidence

Verified published P0393 eb940936ec1edee237da023da2c967bc02b85d19. The supplied Forever screenshot shows Alexandra Bolero's live merchant in the trainer shell, Page 1 of 2, the bag visible, and the stock quantity picker displaying 2. The user accepts the basic concept and identifies the native X as inconsistent with the trainer Goodbye. Screenshot evidence establishes the live layout and quantity picker visibility. A completed purchase, sale, buyback, repair and bag click are unverified.

## Change and gates

Live and preview Goodbye use the trainer's 78 x 24 hit area, upper-right inset, small gold font and underline. The original button handles the click. Styling stages the stock texture snapshots as opaque alpha tokens and leaves an actual X usable when appearance cannot be safely replaced. The original Merchant/Buyback buttons receive Logres active-row artwork where their decorative regions and localized labels are supported. The active marker follows the ordinary native selected tab. The native page buttons and page text are grouped under the item area and retain their handlers. The quantity picker, its confirmation and all purchase logic remain native. Merchant HUD overlap and bag clickability need separate runtime evidence.

Primary pinned source is SharedUIPanelTemplates.xml (UIPanelCloseButton, PanelTabButtonTemplate), CharacterFrameTemplates.xml (CharacterFrameTabButtonTemplate), and Mainline/Vanilla MerchantFrame.xml. Report Bug captures Goodbye mode and whether tabs were styled. In Forever open a vendor and click Goodbye. Reopen, switch both tabs and navigate pages when available. Check that the quantity picker still opens on a stackable item. Test stock fallback with /logres merchantlive. P0394 Forever UNVERIFIED; NPC flash remains separately deferred.
