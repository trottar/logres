---
memory_schema: 1
as_of: 2026-10-23
project: logres
---

# Current State

## Active Objective
Integrate ordinary and mixed NPC gossip through the approved Logres Quest narrative and option renderer without breaking native service transitions.

## Current Work Item
**P0317 R2 — event-driven live additive read-only gossip presentation; PREPARED / full WSL and WoW UNVERIFIED.** Pushed GitHub main P0316 `ae770b4` verified. P0316 quest-only source-model PASS on Gerrig Bonegrip (`0.0.217-dev`, no actions or writes); Check All completed with no explicit FAIL. P0317 R0 applier refused before writes: ambiguous Visual:Paint anchor (2 occurrences). R1 scoped the anchor and migrated the P0265 checker but its generated handoff lost the required `CURRENT.md` authority pointer, causing 16 dependent PREWRITE static failures with no tracked writes. R2 repairs that handoff dependency. Both are assistant artifact failures, not runtime evidence. User rejects further repetitive source probing; accepted P previews and the guarded source are enough to proceed to a presentation trial. P0317 routes real choices into the SAME NPC option list and Quest narrative presentation, with every live choice inert and Blizzard UI retained.

## Verified State
- P0316 `ae770b4` pushed, quest-only source model confirmed by user-uploaded runtime diagnostics: NPC Gerrig Bonegrip, interaction 3, options 0, quests 1, text source C_GossipInfo.GetText, modelReady=true, nativeActions=0/nativeWrites=0. Does not prove gossip-option source or live visual.
- P0315 mixed-source blanket-rejection design FAIL corrected by P0316; earlier P0315 R1 unexpected-baseline artifact refusal recorded. P0314 profession presentation user-reported successful; historic edge failures retained.
- P — branching/services/overflow/locked NPC choices preview and shared narrative/list renderer accepted. User explicitly directed implementation instead of repeated NPC source checks.

## Next Action
Apply P0317 only on exact clean pushed P0316 main. Require **188/188 PREWRITE and POSTWRITE** static checkers, `git diff --check`, manifest and user push/verified main. Deploy via `tools/deploy_logres.sh`, `/reload`, observe naturally encountered live gossip and panel **H — Gossip Live Status (READ-ONLY)**; **Gossip Live Toggle** disables/restores the live additive layer. Confirm Logres UI and fully usable stock choices, Quest transitions, no Lua/secret/taint; record nonreproductions as DEFERRED, not PASS. No special travel required. Next separate native selection/one-window ownership gate only after live presentation behavior verified.

## Success Criteria
Event-driven real gossip text and ordinary choice labels display using approved shared renderer, inert and paginated. Mixed quest and gossip stages eligible; quest-only/empty remain Quest/Blizzard-owned. Failure leaves Blizzard usable. No native gossip selection, quest acceptance, trainer transaction, UI suppression, camera change, timer or polling.

## Do Not Reopen Without New Evidence
Do not require redundant random NPC samples before implementing accepted presentation. Do not claim a fully replaced gossip interaction from a static/read-only trial. Quest 237 reserved; target auras, pet, party and native action fallbacks unchanged. Preserve P0315 baseline FAIL and P0316 runtime scope.

## Relevant References
- `docs/memory/evidence/P0317_LIVE_GOSSIP_PRESENTATION.md`, `docs/memory/patches/P0317_LIVE_GOSSIP_PRESENTATION.md`
- `docs/memory/evidence/P0316_UNIVERSAL_GOSSIP_SCOPE.md`, `docs/memory/evidence/P0315_GOSSIP_SOURCE_MODEL.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`, `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/ROADMAP.md`
