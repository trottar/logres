# Current Handoff — P0303 source-neutral NPC catalogue

Authority: `docs/memory/CURRENT.md`, `docs/memory/evidence/P0303_NPC_SERVICE_CATALOGUE.md`, D-046/D-047. Verified main P0302 `05f8afc1970a8383f34c1b1dfdc01fc24696a2a2`.

Latest user report: Logres P0302 trainer hover controls work; they clicked Train All and **all offered spells were learned**. This upgrades P0301 from quote-only to scoped purchase PASS. Do not invent detailed accounting or full edge-case coverage. Goodbye, icons, search/filter, selection and scrolling had prior user-confirmed PASS. Keep native stock visible until a safe suppression/recovery protocol is implemented and tested.

P0303 PREPARED: new `UI/NPCServiceCatalogue.lua` supplies Filter/Window/Find over copied addon-owned records. `Quest/TrainerLiveTrial.lua` delegates filter-page calculations and clicked training identity lookup, but retains existing acceptance predicates, seven-row paint, native purchase guard and explicit H workflow. Preserve synthetic P, current trainer visual language, and all historical negative evidence. No extra images, new designs or native ownership changes.

Next: apply guarded exact-baseline P0303, full PREWRITE/POSTWRITE static suite and manifest, commit/push by user, independently verify main; deploy/reload; `/logres panel` -> H - Integration and Polish -> Live Trainer ON (TEST). Test old features without buying again. Then implement automatic/default trainer and safely recoverable Blizzard presentation. After trainer validation: native gossip, merchant, flight master.

P0303 R0 PREWRITE FAIL 2/174; no tracked writes. P0288 TOC skin/live adjacency and new-checker evidence marker are repaired by R1. The shared module is loaded before the contiguous existing trainer chain. R1 still requires full PREWRITE/POSTWRITE and WoW regression validation.
