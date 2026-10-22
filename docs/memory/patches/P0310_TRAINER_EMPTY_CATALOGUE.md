# P0310 R2 — Shared NPC empty-catalogue model

Status: R2 PREPARED on verified P0309 `5d27a06`; full WSL/WoW UNVERIFIED.

- Add UI/NPCServiceEmptyState.lua as pure bounded descriptive model builder.
- Keep existing landscape art; add identical synthetic empty fixture and **P — Previews → Trainer Empty Preview** (also `/logres nativetraineremptypreview`) alternate synthetic preview; all 35 existing P panel actions retained, one additional reviewed P action registered.
- Route guarded native profession trainer `total==0` through same live renderer; disabled placeholder row and detail; retain empty underlying source catalogue.
- Keep Blizzard stock visible, no invented profession ownership or purchase, no class or nonempty profession transaction changes.
- Sync CURRENT, handoff, investigation/roadmaps, patch index, checker, evidence, manifest.

R0 PREWRITE stopped on nine candidate compatibility failures (seven fixed P action inventory, two source/TOC adjacency), no tracked writes. R2 deliberately migrates seven historical gallery inventory checkers; existing 35 action IDs and their behavior remain unchanged.

Next after static + in-client verification: pursue evidence-backed acquisition/offscreen profession behavior only when existing information and controls can be replaced safely. Then gossip, merchant, flight master.

R2 corrects R1 preview access: dedicated P-tab Trainer Empty Preview, seven historical count contracts migrated to 36; P0310 R0 nine-checker prewrite failure remains preserved.
