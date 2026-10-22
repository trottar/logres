# Current Handoff — P0305 trainer readiness event repair

Authority: `docs/memory/CURRENT.md`, `docs/memory/evidence/P0305_TRAINER_READY_EVENT_REPAIR.md`, D-046/D-047.

Verified GitHub main P0304 `a493b9f7208898103146d5f4605c0debdb6fa71f`. User runtime: **automatic entry FAIL**, but H Live Trainer ON works. Preserve that negative evidence, no further generic trainer workup needed. P0303 shared catalogue, approved trainer visuals, single/Train All purchase, local search, filter, selection, hover and Goodbye remain user-verified within their tested scope.

P0304 subscribed to normalized state and native OnShow; a lazy native trainer may be loaded/displayed after those early callbacks, so the first visit can miss registration/ready state. Source-backed Forever events `TRAINER_SHOW` and `TRAINER_UPDATE` provide narrow trainer readiness signals. P0305 adds a service-neutral Reconcile on these signals, an addon-owned readiness audit, and no native writes or polls. This is a targeted hypothesis; actual event sequence and fix remain WoW UNVERIFIED. Stock trainer remains shown because the purchase guards require it.

Next: exact clean P0304 baseline ZIP application, full prewrite/postwrite static suite, git diff --check; user commit/push, independently verify main, deploy/reload. Open Briarthorn normally without H ON. Verify Logres appears, Goodbye suppresses same-visit re-opening, closing/reopening creates a fresh presentation, manual H ON/OFF still functions. Do not repurchase spells. If failed, collect NPCServiceSession audit for readiness counters/last event; no timer or broad hooks. After auto-pass, separate native suppression/restoration gate; then native gossip, merchant, flight master.
