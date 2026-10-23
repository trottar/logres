---
memory_schema: 1
as_of: 2026-10-23
project: logres
---

# Current State

## Active Objective
Complete the accepted single-window NPC gossip narrative and choice system while preserving Blizzard-native quest details and dense NPC services.

## Current Work Item
**P0321 R3 — repaired PREWRITE evidence/record terminal blank lines; PREPARED / WSL full static UNVERIFIED, WoW runtime DEFERRED until November 4.** Verified pushed P0320 `bcc3cfa` on GitHub main. User screenshot shows Logres quest link “A Donation of Wool” on Mistina Steelshield and reports dialogue/quest options working. Prior P0317 live renderer, P0318 native gossip selections, P0319 no-choice text, and P0320 quest links are existing accepted capabilities. P0321 first introduces an optional narrow offscreen native-root parking trial; it does not remove gameplay native logic.

## Verified State
- P0320 `bcc3cfa` pushed; screenshot shows quest offer rendered in the same Logres option view; user reports everything working. This is user visual/interaction evidence, not proof that all quest categories, services or restoration conditions passed.
- Guard directions first menu and follow-up narrative, Eldrun shaman trainer text-only, and Grimnur fishing trainer gossip have user visual positive evidence; P0317–P0319 previous negative observations and assistant artifact failures remain recorded.
- Blizzard GossipFrame remains visible, usable and duplicated in P0320; merchant/flight/trainer dense native transaction UIs remain Blizzard-owned. Quest 237 reserved.
- P0321 R0/R1 both stopped safely before any tracked writes: malformed 41-hex-character `docs/ROADMAP.md` expected blob ID. Prior assistant checkout-normalization diagnosis was incorrect. R2 corrected the SHA but PREWRITE whitespace rejected an extra blank line at the end of generated evidence; no writes. R3 corrects evidence and record payload EOFs and adds generator-side checks; full suite and WoW remain unverified.

## Next Action
R0 and R1 both incorrectly rejected `docs/ROADMAP.md` before writes due to a 41-character SHA-1 literal. R2 corrected the expected 40-character Git object ID but failed the PREWRITE diff hygiene check on a newly added blank line at evidence EOF; no writes. R3 fixes both new Markdown payload EOFs and adds a terminal-blank-line preflight, retaining exact HEAD and clean-tree checks. The user reports that the beta window ended before single-window P0321 could be validated; WoW testing is DEFERRED to November 4, not PASS. Apply P0321 only on exact clean pushed P0320 `bcc3cfa`; require 192/192 PREWRITE and POSTWRITE static checkers, diff hygiene and manifest. User commits/pushes and main must be verified before runtime. Deploy, `/reload`, speak to natural ordinary or quest NPC and confirm only the Logres gossip view is onscreen while choices/quest links work. Check **H — Gossip Stock Status (READ-ONLY)** and H Toggle for stock fallback. Verify Gossip Close, quest handoff, immersion OFF, and native restore; treat any Lua/taint/protected/secret failure as FAIL and correct before expanding. If beta unavailable, runtime DEFERRED to Nov 4.

## Success Criteria
Only for a fully mapped, actionable source-backed gossip stage with safe unprotected native GossipFrame and usable native CloseGossip does Logres move the WHOLE SHOWN stock root offscreen, preserving opaque anchor tokens and native service APIs. Restore BEFORE native gossip or quest selection and on any exit, toggle, combat deferral, native hide, handoff or immersion OFF. No invisible Blizzard click regions; no alpha/mouse suppression, polling, quests acceptance/claims or merchant/flight replacement. Fail open to Blizzard whenever capability insufficient.

## Do Not Reopen Without New Evidence
Do not claim static verification proves parking or UI layout in WoW, remove quest detail/turn-in fallback, invent NPC-specific exclusions or broad native hooks. Do not move protected frames during combat. Keep P0317/P0318/P0319/P0320 contracts and runtime evidence intact.

## Relevant References
- `docs/memory/evidence/P0321_GOSSIP_SINGLE_WINDOW.md`, `docs/memory/patches/P0321_GOSSIP_SINGLE_WINDOW.md`
- `docs/memory/evidence/P0320_QUEST_GOSSIP_LINKS.md`, `docs/memory/evidence/P0319_UNIVERSAL_GOSSIP_STAGES.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`, `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/ROADMAP.md`
