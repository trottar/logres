# Current Handoff — P0234 source-qualified nearby services

Authority: `docs/memory/CURRENT.md` and `docs/memory/evidence/P0234_NEARBY_POI_SOURCE_AND_PRIORITY_AUDIT.md`. GitHub main P0233 `27e9e36` verified. P0233 user-observed automatic QuestieDB startup (`provider=ready candidates=4 shown=2` before manual retry) and following one marker to a physical quest giver remains PASS locally. Earlier P0230 initial zero-index failure is retained.

P0234 audits source/presentation only: native positioned POIs/vignettes and the accepted focused quest are distinct from historical QuestieDB 50-yard candidate NPC spawns. Native tracking metadata lacks live per-result coordinates. Upstream QuestieDB v1.0.6 contract 4 exposes flavor-specific NPC role flags (`NpcDB.npcFlags`, `LibQuestieDB.Enum.npcFlags`) in addition to spawn coordinates. Existing P0230 consumer gate requires only contract 1, so do not assume loaded runtime contract 4 without checking it.

Next work: P0235 add bounded possible flight master/innkeeper/repair service candidates using v4 capability gate and the existing finite zone index; never infer live service availability or drop lower-priority native/quest coverage. No hard dependency, no native pin scraping, no radius change. P0234 docs-only: no WoW redeploy.
