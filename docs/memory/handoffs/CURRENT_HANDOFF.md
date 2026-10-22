# Current Handoff — P0291 Forever trainer data fidelity

Authority: `docs/memory/CURRENT.md`, D-046/D-047 and `docs/memory/evidence/P0291_FOREVER_TRAINER_DATA.md`.

Verified pushed P0290 R2 `61838ba`. User WoW screenshot proves five real service names displayed in the approved portrait-free shared landscape: **LIVE PRESENTATION PARTIAL PASS**, not functional/native trainer replacement. Costs unknown, icons placeholders, ranks and level requirements unclassified. Blizzard trainer remains operative; no purchase tests requested.

**Narrow source finding:** Blizzard Forever's own `Blizzard_TrainerUI/Mainline/Blizzard_TrainerUI.lua` reads `GetTrainerServiceInfo(index)` as `name, serviceType, texture, requiredLevel, subText, category`. P0285–P0287 misread numeric field 3 as a category and field 4 as expansion: SOURCE SCHEMA ASSUMPTION FAILED. Six-field in-client test remains pending. P0291 independently branches on the safely observed Forever shape, retains Classic fallback, collects bounded texture/level/rank/cost/skill/description, and shares P0284 landscape. No action routing, category-to-train permission, Blizzard control replacement or geometry mutation.

P0290 R0 memory-health PREWRITE failure, R1 EOF-diff failure and earlier H slash-only/registry contract failures remain recorded in historical evidence. P0291 does not reopen those issues.

Next: guarded P0291 ZIP on P0290 R2 baseline, PREWRITE/POSTWRITE full check suite and diff PASS, user push/verify. Deploy `/reload`; open trainer, `/logres panel` → H → Live Trainer ON (TEST). Inspect skill textures, ranks/levels, costs and stock coexistence; Live Trainer OFF. A screenshot and panel result suffice. No generic audit or purchased skill necessary.
