## P0396 — Shared Logres merchant page chevrons (2026-11-08)

Verified published P0395 fabc155f09b30e4d790214b8cab217e2a2f5d807. User reports one label per tab, confirmed visually by the screenshot of Alexandra Bolero. The screenshot shows native page arrows and labels, native Page 1 of 2, and an open quantity dialog with 2 entered. The earlier reported P0394 sale and buyback pass remains scoped. There is no new transaction evidence.

P0396 extracts the original quest chevron construction into NPCNarrativePages.CreateChevron and uses the same art, direction and enabled colors for the original merchant page buttons. OnEnable and OnDisable refresh only Logres art. The native page counter remains the single localized count. Named stock page buttons retain their handlers. The two-button appearance is an atomic optional part of the existing native merchant layout plan. Only bounded ordinary decorative regions of the original buttons are faded, with opaque alpha restoration. An unexpected shape or unsupported event hook keeps stock art and paging. The merchant preview has two inert pages using the same arrow art.

The quantity popup is lower priority per the user and remains stock. Test naturally available multi-page merchant stock. Click Next and Previous and verify the list and count update and the end chevron is dim. WoW P0396 UNVERIFIED.
