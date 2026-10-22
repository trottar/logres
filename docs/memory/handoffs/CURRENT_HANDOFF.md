# Current Handoff — P0304 automatic trainer entry via shared NPC session

Authority: `docs/memory/CURRENT.md`, `docs/memory/evidence/P0304_NPC_SESSION_AUTO_TRAINER.md`, D-046/D-047. Verified P0303 GitHub `main` `4f7f9b5`. User reports P0303 trainer regression PASS; earlier single/bulk training and hover are user-confirmed within tested cases.

P0304 PREPARED, WSL full checker suite and client behavior UNVERIFIED. `UI/NPCServiceSession.lua` manages event-driven NPC service registration, guarded source-root OnShow subscription, `GetState()` interaction matching, one automatic presentation per live visit, and explicit per-visit Goodbye/OFF dismissal. Trainer opt-in default is ON. All source data, search, filter, scroll, details, hover, fixture, transactions, camera and approved visuals remain in their current specialized modules.

Crucial boundary: Blizzard ClassTrainerFrame stays visibly shown and fully usable in P0304. Trainer purchase guards require native `IsShown()==true`; actual safe suppression/restoration has NOT been established. P0304 validates automatic lifecycle separately before a native-presentation trial. If auto entry fails, stock remains available; capture diagnostics and do not add periodic retry/polling.

Next: guarded WSL apply, 175 expected checkers PREWRITE+POSTWRITE, manifest, user commit/push, verify main, deploy/reload. Open trainer normally without H ON, check automatic Logres. Click Goodbye, confirm no immediate re-open during same interaction; close/reopen trainer to confirm new session opens. Check H OFF/ON and native stock. After PASS: narrowly test protected-safe Blizzard presentation restoration; then native gossip, merchant, flight master. No needless purchases.
