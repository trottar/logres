# Current Handoff — P0296 trainer scroll control and single purchase trial

Authority: `docs/memory/CURRENT.md`, `docs/memory/evidence/P0296_TRAINER_SCROLL_TRAIN_TEST.md`, D-046/D-047.

P0295 `7b1a459` independently verified on main; user screenshot/report show local selection and matching details PASS, wheel scrolling and local filtering PASS. **Scrollbar FAIL:** displayed thumb is frozen artwork with no click/drag. The inert `Visible services` placeholder is still OPEN; no real category taxonomy. No prior native transaction trial has been validated.

P0296 PREPARED / STATIC AND WOW UNVERIFIED. In live mode only, remove static thumb and add an owned vertical Slider with offset/thumb synchronization, while retaining inert P preview and arrow controls. A separate guarded one-skill transaction controller operates only from a physical **Train selected (TEST)** click after explicit local row selection, and checks live Forever identity/status, price, funds, count, trainer NPC and lockdown. One `BuyTrainerService(index)` request may be issued only on fully ordinary verified data. No Train All, automatic repeat, native selection setter or stock hiding. A successful call is NOT proof of purchase. A failed gate leaves Blizzard usable; accepted request hides the stale Logres snapshot.

Next: pinned clean P0295 apply → complete static/whitespace checks → commit/push → independently verify → deploy and `/reload`. At trainer use `/logres panel` → H → Live Trainer ON (TEST). Drag/click rail and wheel, filter and select; if user chooses, attempt one affordable Available skill and verify cost/spell in stock UI. Record any taint, protected or secret exception as FAIL; no forced purchase needed for basic scrollbar proof. OFF/close; check no invisible click regions.
