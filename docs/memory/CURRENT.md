---
memory_schema: 1
as_of: 2026-10-22
project: logres
---

# Current State

## Active Objective
Advance universal NPC gossip stages using the existing preview-first Quest narrative/option renderer, safely handing off to separately owned NPC services.

## Current Work Item
**P0316 — forward correction of P0315 read-only gossip source coverage; PREPARED / full WSL static and WoW UNVERIFIED.** Verified pushed P0315 main `878235b`. The previously supplied P0315 R1 applier was pinned to already-superseded P0314 and rejected with `unexpected commit baseline; no writes`. P0315 itself is pushed and must not be rewritten. P0316 replaces its erroneous mixed-quest blanket source rejection with a bounded stage-aware data model: gossip-only, mixed quest/gossip, quest-only and empty, for any NPC with a supported current gossip stage (guards, trainer preludes, service NPCs). Native options remain inert, quest rows count-only, Blizzard remains available.

## Verified State
- GitHub main P0315 pushed `878235b`; predecessor P0314 `f40a8e0` was user-reported successful within observed interactions. Individual profession postpurchase/lockdown restoration cases are not separately proved.
- P0315 universal-scope defect identified in committed source and checker: quest presence caused `mixed-quest-gossip-stock-retained` regardless of ordinary gossip options. **DESIGN FAIL**, not a demonstrated WoW runtime error.
- P0315 R1 archive SHA-256 was verified by the user but baseline refused before writes after P0315 was already pushed. **ARTIFACT BASELINE FAIL / NO TRACKED WRITES**.
- P — NPC Choices Branching, Services, Overflow and Locked fixtures, source-independent option model/rendering, and class/profession trainer implementations remain the working architectural baseline. Earlier P0311/P0313/P0314 failures remain recorded.

## Next Action
Run P0316 applier only on exact clean P0315 `878235b`: demand **187/187** static checkers PREWRITE/POSTWRITE, manifest and `git diff --check`. User commits/pushes; verify new `main`. Deploy and `/reload`, then sample naturally encountered guard, pre-service trainer, and mixed quest/gossip when available using **H — Gossip Source Check (READ-ONLY)**. Check status/kind/options/quests/text/modelReady, nativeActions/nativeWrites both zero, and export diagnostics. No live replacement or native selections are expected. Afterwards design separately gated shared-renderer read-only presentation.

## Success Criteria
Any supported gossip stage can yield a validated inert source model independent of future NPC service identity; quest entries remain counted, not copied as selectable gossip. Missing, invalid, truncated or secret source fails open to Blizzard. No native action, stock suppression, protected UI mutation, polling, timer or camera change. P previews, trained service flows and quest 237 unchanged.

## Do Not Reopen Without New Evidence
Do not narrow gossip by NPC service family or require quest absence to consider readable gossip. Do not conflate source sampling with production UI capability. Do not infer missing APIs are empty, invent quest options, enable live selection or hide Blizzard controls. Preserve failed applier evidence and prior negative results; no speculative client guarantees.

## Relevant References
- `docs/memory/evidence/P0316_UNIVERSAL_GOSSIP_SCOPE.md`, `docs/memory/patches/P0316_UNIVERSAL_GOSSIP_SCOPE.md`
- `docs/memory/evidence/P0315_GOSSIP_SOURCE_MODEL.md`, `docs/memory/evidence/P0314_PROFESSION_SINGLE_WINDOW.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`, `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/ROADMAP.md`
