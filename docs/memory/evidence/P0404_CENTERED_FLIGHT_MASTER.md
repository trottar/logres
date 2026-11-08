# P0404 — Centered flight master with native pins

## Observations

Verified GitHub main P0403 50ba114482ab90d3beff355317fdf5cc6f77d8a9. P0401 session 59 incident 6641 showed the readable map and Ironforge at 50c, with the header cropped at the top left. P0402 Forever 0.0.286-dev session 60 incident 7173 retained a complete inventory of 20 direct children from the earlier flight visit. TaxiRouteMap was an inert leaf. The native CloseButton and TaxiButton1 through TaxiButton18 were click- and motion-enabled leaves. P0400 refused capture at its eight-child limit. Raising only the limit would still refuse interactive children.

The [pinned Blizzard taxi code](https://github.com/Gethe/wow-ui-source/blob/9dc84f0d3bbae1768ac3405b3716000bd93eda06/Interface/AddOns/Blizzard_UIPanels_Game/Shared/TaxiFrame.lua) anchors each pin to InsetBg and draws route lines on TaxiRouteMap. The pinned XML and Lua describe different pin parents. The observed direct TaxiFrame shape would also fail the P0399 sidebar's route-map-only parent test. A priced row proves catalogue data, while its use for live purchase remained unverified. The [Blizzard panel manager](https://github.com/Gethe/wow-ui-source/blob/9dc84f0d3bbae1768ac3405b3716000bd93eda06/Interface/AddOns/Blizzard_UIParentPanelManager/Shared/UIParentPanelManager.lua) owns TaxiFrame's left-panel position. P0399's attempt to override that position failed live.

## Candidate

The shared service shell uses the trainer's top-center geometry. TaxiFrame remains in the native manager. The native host adapter validates the exact native map, close and globally named pin identities, ordinary inputs and known parent shapes before capturing a reversible plan. The plan moves InsetBg, route lines and all recognized pins as one group. Existing pin anchors and click scripts stay intact. Only after moving the known map inputs does the plan disable the original root and close click/motion and fade the native root. The centered shell Goodbye uses the native close. The existing sidebar dispatch revalidates native pin identity, visibility, availability, fare and funds at the user's click. Unknown shapes or failed application restore the prior state and use the P0401 layout when supported. Closing the native frame hides the independent host immediately, including when combat delays restoration. Report Bug retains the historical P0400 capture reason and records the new host result separately.

No global placement hook, per-frame work, direct taxi API transaction, new camera path or automated spending. A naturally occurring P0403 quest handoff remains unobserved since P0403 was prepared. L-001 stays open independently.

## Validation

Replay the 20-child Forever inventory and the pinned-source nested-pin alternative. Verify the independent top-center geometry against a simulated native top-left reset. Exercise fare revalidation, map and sidebar clicks, Goodbye, close in combat, rejection of unknown input, rollback of a partial parent failure, scale mismatch and manual stock restoration. Client position and actual flight purchase remain UNVERIFIED. On the next ordinary flight-master visit check the entire window, fare and native pin hover, then use the route list for a flight already intended. If it looks wrong or the action fails, capture one Report Bug incident while visible.
