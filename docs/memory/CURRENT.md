---
memory_schema: 1
as_of: 2026-10-22
project: logres
---

# Current State

## Active Objective
Advance guarded live NPC gossip presentation through the accepted preview-first shared option model and renderer, after successful P0314 profession trainer single-window feedback.

## Current Work Item
**P0315 — one-shot read-only live gossip source-to-inert-option-model adapter; PREPARED / full WSL static and WoW UNVERIFIED.** Verified pushed GitHub main P0314 `f40a8e0`. User reports the latest pushed profession trainer patch successful with no noticed issues; individual restoration and postpurchase edge cases have not been independently enumerated. P0315 collects only ordinary, bounded C_GossipInfo text/options/quest counts during an explicit H-panel action. Complete nonquest gossip can enter the existing NPCOptionModel.FromValidated envelope, with every option disabled and without live presentation or native click.

## Verified State
- P0314 is pushed to main `f40a8e0`; the user reports successful runtime behavior with no noticed issues. This is a scoped positive report, not a claim of complete profession-purchase/restoration/combat test coverage.
- P0313 class/profession services, the complete owned-professions sidebar, and current-trainer focus were user accepted; previously observed Enchanting purchase and class Goodbye remain historical evidence.
- Existing P — NPC Choices Branching / Services / Overflow / Locked previews and Quest narrative renderer are accepted; native gossip source-to-model behavior remains UNVERIFIED.
- P0311 Enchanting zero-service and premature profession-close FAIL, P0313 R0 checker failures and P0314 R0 artifact EOF failure remain preserved in historical evidence.

## Next Action
Apply P0315 against exact clean pushed P0314 main; require **186/186** prewrite and postwrite static checkers, `git diff --check`, manifest, then user push and verify. Deploy via `tools/deploy_logres.sh` and `/reload`. During ordinary NPC gossip, open `/logres panel` > H — Integration and Polish > **Gossip Source Check (READ-ONLY)**, inspect status/options/quests/text/modelReady, export diagnostics. An NPC with quest entries should defer mixed-source model conversion. No visible gossip change or native action is expected. After runtime evidence, gate a separate read-only shared-renderer presentation checkpoint.

## Success Criteria
A bounded source-to-model adapter produces only independently ordinary nonquest NPC gossip with known text and source-backed labels. Mixed quest paths, missing/secret/invalid/truncated sources fail open to Blizzard. No live choice, quest claim, trainer mutation, native frame changes, timer, polling or camera change. Existing 36 P actions and trainer functionality remain unchanged.

## Do Not Reopen Without New Evidence
Do not suppress Blizzard gossip or enable live selections from a data-model/static PASS. Do not infer that absent option/quest APIs are empty lists, do not synthesize NPC dialogue or quest actions, and do not use secret/protected Blizzard presentation values. Quest 237 remains reserved. P0314 postpurchase/recovery edge cases stay UNVERIFIED outside user-tested scope.

## Relevant References
- `docs/memory/evidence/P0315_GOSSIP_SOURCE_MODEL.md`, `docs/memory/patches/P0315_GOSSIP_SOURCE_MODEL.md`
- `docs/memory/evidence/P0314_PROFESSION_SINGLE_WINDOW.md`, `docs/memory/evidence/P0311_PROFESSION_CLOSE_FILTER_CONTEXT.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`, `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/ROADMAP.md`
