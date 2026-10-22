# Current Handoff — P0294 addon-owned trainer selection

Authority: `docs/memory/CURRENT.md`, D-046/D-047, `docs/memory/evidence/P0294_TRAINER_LOCAL_SELECTION.md`.

P0293 `5e50fd2` verified pushed. User confirmed local All sampled / Available only filters and seven visible rows with native-selected skill detail correspondence. The screenshots do not conclusively prove scrolling beyond seven; do not upgrade that result to PASS. Blizzard still owns transaction, native selection, native filter state and stock trainer.

P0294 PREPARED / WSL AND WOW UNVERIFIED: reuses existing seven-row widgets and adds live-only row mouse regions, dynamic detail bindings and catalogue-native-index local selection, keeping the P fixture inert. Filter and scroll changes preserve selection identity and detail; empty rows have no clickable region. No native mutation APIs or native trainer UI changes. Source filtered by Blizzard remains filtered in Logres.

Next: exact clean P0293 baseline, guarded P0294 apply with complete PREWRITE/POSTWRITE checker suites and whitespace gate; user push and verify new main. Deploy `/reload`; use `/logres panel` → H — Integration and Polish → Live Trainer ON (TEST) at an ordinary trainer. Click different Logres entries; compare detail icon/title/description/requirements, highlight and Blizzard native selected row. Check filters, wheel/rail beyond seven, selection continuity across hidden rows, empty state, OFF and trainer close. No forced training purchases or contrived combat. Any Lua/taint/protected error is FAIL; untested transitions are DEFERRED.
