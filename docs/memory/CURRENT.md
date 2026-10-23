---
memory_schema: 1
as_of: 2026-10-23
project: logres
---

# Current State

## Active Objective
Complete stage-aware NPC conversation through one safe Logres narrative/option system with native quest and service fallback intact.

## Current Work Item
**P0320 — source-backed quest links and native quest-detail handoff; PREPARED / full WSL static and WoW UNVERIFIED.** Verified pushed P0319 main `ee0e4cb`. User visually confirmed P0319 dialogue stages: guard list -> chosen directions text works; Eldrun shaman trainer text-only dialogue renders; Logres gossip choices are clickable. New **runtime failure**: quest offer NPC renders text but has no clickable quest links because P0319 still stores native quests only as counts. This MUST be corrected before parking Blizzard gossip.

## Verified State
- P0319 pushed `ee0e4cb` and screenshots confirm text-only, multi-choice menu, guard follow-up and trainer narrative behavior. Direct quest link missing in Logres is a reported observable failure, not deferred data.
- P0316 source already gives `GetAvailableQuests` and `GetActiveQuests` tables; P0319 displayed only `GetOptions()` entries. Native quest link selection remains untested. P0317 established the shared live renderer, P0318 added guarded ordinary gossip choice dispatch, and P0319 added zero-choice narrative stages. Earlier patch errors remain preserved in evidence.
- Blizzard gossip/quest window stays native and clickable. Merchant and flight transactions remain Blizzard-owned. Quest 237 reserved.

## Next Action
Apply P0320 on clean exact pushed P0319 `ee0e4cb` with **191/191 PREWRITE+POSTWRITE** static contracts and diff hygiene, user commit/push, verify main. Deploy to Forever beta and `/reload`; at naturally encountered quest NPC verify quest title appears among Logres options and user click opens native quest detail, including active quest if available. Confirm Blizzard controls remain usable and no Lua/taint/secret errors; H panel Gossip Live Status shows `questActions`/`questBlocked`. Preserve failures if any, no NPC-by-NPC screenshot demands. Defer inaccessible runtime to November 4.

## Success Criteria
Same accepted renderer displays verified NPC quest title links, alongside ordinary gossip. Explicit click only revalidates current NPC, quest IDs, complete menu and stage and calls `SelectAvailableQuest` or `SelectActiveQuest` once. **No automatic acceptance or reward claims**. Incomplete/secret/unsupported data or combat fail open; stock stays fully usable. Never leave invisible Blizzard click regions.

## Do Not Reopen Without New Evidence
Do not park Blizzard gossip before native quest link proof. Do not invent NPC exceptions, poll, hijack protected actions, or claim single-window completion. Merchant and flight panels stay Blizzard-owned without their own proven replacement/fallback. Preserve P0319 positive screenshots and negative quest-link evidence.

## Relevant References
- `docs/memory/evidence/P0320_QUEST_GOSSIP_LINKS.md`, `docs/memory/patches/P0320_QUEST_GOSSIP_LINKS.md`
- `docs/memory/evidence/P0319_UNIVERSAL_GOSSIP_STAGES.md`, `docs/memory/evidence/P0318_GOSSIP_NATIVE_CHOICES.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`, `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/ROADMAP.md`
