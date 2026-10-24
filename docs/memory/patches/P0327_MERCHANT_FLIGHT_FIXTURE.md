# P0327 — Inert merchant and flight presentation models

**Baseline:** verified P0326 main `7949d7cb79a491db6ca0c2264694a31588db05e8`, exact SHA-1 blob guards, clean `main` and full repository PREWRITE + POSTWRITE suite. **Scope:** one Python-only model under `tools/`, one independent checker, three canonical P0327 records, CURRENT/HANDOFF and prepend-only roadmap/memory pointer updates. **No Lua**, no addon TOC, saved schema, camera, player-facing settings, native frame or transaction change.

**D-046 / D-047 / D-048:** pure fixture-to-model preparation only, without in-game renderer or visual PASS. Blizzard retains merchant and flight transactions, fares, route map, travel and close. The two distinct native parking owners remain untouched. No full live NPC service registration. P0321 parking runtime remains **UNVERIFIED** pending November 4.

**Validation required:** 198 static checks PREWRITE and POSTWRITE, exact candidate `git diff --no-index --check`, final `git diff --check`, generated P0327 manifest and GitHub pushed main confirmation. **No WoW redeploy** for P0327.

**Next:** client evidence for P0321 gossip restoration and merchant/flight native handoffs; then candidate P — Previews in-game same-renderer proof, not speculative transaction coding.
