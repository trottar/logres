---
memory_schema: 1
as_of: 2026-10-23
project: logres
---

# Current State

## Active Objective
Complete stage-aware, usable NPC dialogue through the accepted shared Quest narrative and NPC option renderer, while retaining functional Blizzard quest/service fallback.

## Current Work Item
**P0319 — text-only and quest-only NPC gossip stages through the existing renderer; PREPARED, WSL static and WoW UNVERIFIED.** Verified pushed main P0318 `de325e6`. The user's screenshots and `0.0.219-dev` diagnostics show Grimnur Stonebrand (fishing) options=1, quest=0 and live Logres presentation, plus the Ironforge Guard first menu with paginated Logres options. Subsequent guard directions text (after selecting a destination) is Blizzard-only; Gerrig Bonegrip quest-only greeting is Blizzard-only (source options=0 quests=1); Eldrun Stormbreaker shaman trainer greeting is Blizzard-only. Those are real negative presentation observations, not reasons to demand more screenshots. No proof yet of direct Logres native choice dispatch.

## Verified State
- GitHub P0318 main `de325e6` verified pushed, runtime `0.0.219-dev` in user diagnostics load 416/417; Gerrig source `model-ready` options=0 quests=1; Grimnur source `model-ready` options=1 quests=0.
- P0318 native choice controller is present, but no recorded H click-action result proving native execution. Guard first-stage multi-page options visually render. Guard follow-up text fails to render in Logres. Shaman trainer introductory text likewise stock-only. Exact follow-up GOSSIP_SHOW delivery is unverified.
- P previews are accepted; P0315/P0317/P0318 assistant artifact failures and all recorded runtime deferrals remain part of repo evidence. Quest 237 reserved.

## Next Action
Apply P0319 from clean exact pushed P0318 main `de325e6`, run **190/190 PREWRITE and POSTWRITE** static contracts and `git diff --check`, generate manifest, then user commit and push/verify main. Deploy via `tools/deploy_logres.sh`, `/reload`; recheck naturally accessible Ironforge Guard direction response, text-only shaman trainer, Gerrig quest-only greeting; validate Blizzard quests, services, safe close and no Lua/taint/protection failures. Use H — Gossip Live Status (READ-ONLY) for evidence, not redundant Gossip Source Check. If follow-up stays Blizzard-only, investigate authoritative event delivery separately; do not add polling without evidence. Beta deferrals go to November 4.

## Success Criteria
A validated nonempty source narrative renders through the SAME Logres narrative window regardless of whether gossip choices are present. Real options still use existing paginated Logres controller; quest entries remain native and unmodified, absent options create no fake actions. Text-only follow-up transitions display when authoritative gossip event arrives. All failures fail-open to working Blizzard. No polling, timer, protected/secret-value misuse, native-frame suppression, native quest click, transaction, or camera change.

## Do Not Reopen Without New Evidence
Do not implement exceptions for NPC names/families, assume all service NPCs have gossip options, demand repetitive screenshots, or claim full single-window replacement. Native choices and stock fallback stay usable; no removal of Blizzard quest controls before safe replacement. Preserve the user's observed missing stages and any unverified event pathways.

## Relevant References
- `docs/memory/evidence/P0319_UNIVERSAL_GOSSIP_STAGES.md`, `docs/memory/patches/P0319_UNIVERSAL_GOSSIP_STAGES.md`
- `docs/memory/evidence/P0318_GOSSIP_NATIVE_CHOICES.md`, `docs/memory/evidence/P0317_LIVE_GOSSIP_PRESENTATION.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`, `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/ROADMAP.md`
