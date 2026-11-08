## P0392 — Merchant catalogue preview and live trial (2026-11-08)

## Observed and scoped

P0390 main 6e1495913edd7434a8c3134e219f28fa32e61628. P0391 was applied locally at intake. Forever session 46, 0.0.275-dev, captured profession confirmation at sequence 5447 and Logres catalogue refresh at 5448. The user reports learning worked and still sees Blizzard popups, especially on a profession purchase, and asked to defer the broader flash while finishing NPC interactions. L-002 remains OPEN and deferred. Popup identity and current aura placement are unverified.

## Merchant implementation

L-003 has an in-game preview under P — Previews, also reachable with /logres merchantpreview. The four states are sample list, empty, source unavailable and native handoff. At an already open merchant, /logres merchantlive opens the same renderer with ordinary live records. It requires MERCHANT_SHOW, the normalized merchant interaction and Immersion ON. It refreshes on MERCHANT_UPDATE, dismisses when the merchant closes or is replaced, on world entry or Immersion OFF. Prices use copper only when ordinary fields establish coin pricing. Extended cost, missing rows, and unsupported records fall back to Blizzard. The addon panel is non-transactional. Blizzard owns purchases, sales, buyback, repair, costs in alternate currencies and native confirmation.

Source anchors are the pinned client mirror 9dc84f0d3bbae1768ac3405b3716000bd93eda06, Blizzard_UIPanels_Game Mainline and Vanilla MerchantFrame.lua and MerchantFrameDocumentation.lua. These establish event and API shape candidates. Forever live API shape and coexistence remain UNVERIFIED.

## Client validation

After preview acceptance, open a naturally available merchant and run /logres merchantlive. Compare two item names, stack counts and prices to the native window. Check paging if enough items are naturally present. Close the merchant and verify the Logres pane closes. Report Bug collects the last catalogue result, scope, row count and read counter. Native transactions are optional gameplay, with no test purchase required. Keep L-003 deferred pending client evidence; next L-004 flight identity, presentation and handoff.

The existing quest, trainer, camera, and protected ownership policies retain their prior scope.
