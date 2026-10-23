---
memory_schema: 1
as_of: 2026-10-23
project: logres
---

# Current State

## Active Objective
Complete usable NPC gossip interaction using the accepted Quest narrative and shared option renderer, without sacrificing safe Blizzard fallback or service transitions.

## Current Work Item
**P0318 — implement real native gossip option clicks through a separately gated controller; PREPARED / static+WoW UNVERIFIED.** GitHub pushed main P0317 `f56c2cd` verified. User-uploaded diagnostics from runtime `0.0.218-dev` load 415 confirm P0317 deployed but contain only the earlier quest-only Gerrig Bonegrip source check, not a live-choice display/selection test. P0317 offers automatic additive source-backed dialogue, but intentionally inert choices; the user explicitly directed completing implementation instead of more read-only probes. P0318 connects real user clicks to `C_GossipInfo.SelectOption` after ordinary source, client capability, combat and fresh full-menu identity gates. Stock gossip remains available.

## Verified State
- P0317 pushed `f56c2cd`, runtime `0.0.218-dev` confirmed present by uploaded diagnostics. No claim of live gossip visual success or actual native click acceptance.
- P0316 `ae770b4` quest-only model source PASS on Gerrig Bonegrip (options=0, quests=1, no writes); prior P0315 design and P0315/P0317 R0/R1 applier failures remain preserved in evidence.
- P branching/services/overflow/locked previews are accepted; existing quest, profession, camera and native fallback architecture remains authoritative.

## Next Action
Apply P0318 on exact clean pushed P0317 `f56c2cd`, run **189/189 PREWRITE+POSTWRITE** static contracts, `git diff --check`, manifest. User commits and pushes; verify main. Deploy to beta and `/reload`; use H — Gossip Live Status (READ-ONLY) while naturally selecting an ordinary gossip option in Logres. Confirm native branch/service works and Blizzard controls remain functional. Any error is FAIL; if unavailable before beta closure October 23 10:00 PDT, record runtime DEFERRED for November 4. After actual safe click evidence, separately gate single-window stock parking/restoration.

## Success Criteria
One direct Logres click on a source-confirmed available choice revalidates the entire live NPC option menu, calls the documented native option-ID API once, and yields normal native dialogue/service transition. Unknown/locked/secret/unavailable cases retain Blizzard control; no addon-owned quest acceptance, transaction, camera change, stock hide, timer or polling. Quest 237 remains reserved.

## Do Not Reopen Without New Evidence
No further repeated gossip source sampling as an implementation prerequisite; no automatic native selections or speculative polling. Do not conflate P0317 deployment with actual live-choice behavior. Never suppress usable Blizzard choices before safe replacement. Preserve all historical assistant patch failures and runtime deferrals.

## Relevant References
- `docs/memory/evidence/P0318_GOSSIP_NATIVE_CHOICES.md`, `docs/memory/patches/P0318_GOSSIP_NATIVE_CHOICES.md`
- `docs/memory/evidence/P0317_LIVE_GOSSIP_PRESENTATION.md`, `docs/memory/evidence/P0316_UNIVERSAL_GOSSIP_SCOPE.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`, `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/ROADMAP.md`
