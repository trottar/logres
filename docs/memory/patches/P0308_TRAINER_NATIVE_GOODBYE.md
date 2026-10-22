# P0308 — class native-close Goodbye and source-empty profession evidence

Baseline: verified P0307 `dad4c97f71496cdd374bb542e8999ab4087cd8e3`. Candidate version `0.0.209-dev`.

Adds `Quest/TrainerCloseTrial.lua` as a class-only, guarded native CloseTrainer request adapter loaded after existing NPC trainer family diagnostic. Class Goodbye now preflights and requests native close only after existing Parking.Restore succeeds through `Trial.Disable("goodbye")`; on capability/failure Blizzard restores as before. Explicitly excludes profession trainers, combat, protected and secret states; no retry, no timer, no existing training source/transactions/visual changes. Includes full WSL static/manifest/whitespace gates, dedicated checker, current/handoff/roadmap/evidence synchronization. No assistant Git commits or pushes. Runtime **UNVERIFIED** until client test.

Negative evidence retained: P0307 R0 hard-coded checker threshold failed before writes; P0304 auto first-entry failed before P0305; P0307 Fishing source returned zero services, so cross-family Logres fallback is DEFERRED rather than hidden/fabricated. P0306 Goodbye restoring stock was expected and visually PASS, but was not native-close behavior.

Profession native parking now explicitly deferred when IsTradeskillTrainer is not ordinary false: this prevents the P0306 discovered loss of Blizzard training buttons with read-only Logres profession UI. Visual/source support in Enchanting/Cooking observed, Fishing source empty.
