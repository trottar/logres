# P0274 — Native service accent (merchant/trainer only)

Status: PREPARED; CLIENT UNVERIFIED. Pinned source: main 591ed52. Follow D-047.

- Integrate one mouse-disabled, UIParent-owned gold accent module; unchanged Blizzard children and inputs.
- Show only during successful opt-in native merchant/trainer placement; hide before Restore, including deferred restoration; cosmetic errors fail open.
- Keep native gossip positioned as already tested but visually stock; next milestone uses **existing D-046 Logres quest/NPC renderer** through a guarded live gossip adapter rather than another UI.
- No new H buttons, game transactions, timer, camera, bank, auction or flight changes.
- Record P0273 user-accepted 0.0.171-dev live diagnostics and maintain historical P0272 WSL evidence limitation.
- Guard exact GitHub-pushed baseline; shadow 141 static checkers and postwrite checker suite; transactional rollback; generate manifest; no commits or pushes.
