# P0325 — Migration dry-run evidence

**Source baseline:** pushed P0324 `bc56185`. **P0325 WSL suite and WoW runtime UNVERIFIED** until user executes the full guarded applier. No new in-game reproduction was possible or claimed.

- Read `Logres/Core/Database.lua`, `Preferences.lua`, `Immersion/Controller.lua`, `Navigation/Compass.lua`, `Quest/Dialogue.lua`, and Camera module, plus D-046/D-047/D-048. Old schema-3 preferences cannot safely describe complete CAM/native ownership.
- Offline draft `tools/p0325_migration_dry_run.py` deep-copies schema-3 legacy values, makes no native calls and produces optional explicitly selected domain draft overrides only. It is excluded from `Logres/Logres.toc`.
- New checker covers four legacy boolean combinations, 32 fully explicit domain selections per legacy combination, independent one-domain opt-ins, source immutability and invalid input refusal. Those checks are static tests, not an addon behavioral pass.
- No claimed new defect. Risk of silent save/ownership change is a design concern, not reproduced failure. Mass migration and camera inference remain **DEFERRED** pending independent actual Forever restoration proof.
- P0321 native gossip offscreen parking, merchant/flight service handoffs, special pet/security cases and all earlier evidence remain **UNVERIFIED** or in their recorded scoped states. November 4 continues as the proposed client-return gate.
