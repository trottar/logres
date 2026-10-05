# P0127 — P0126 Acceptance / Next Objective Synchronization

Date: 2026-10-05
Result: **INSTALLED / PUSHED — DOCS-ONLY** (`ef56075d`)
Baseline: `89b0c563d1ff5e12c61baa3e407725a90d9cefd4`
Runtime: unchanged at `0.0.58-dev`

## Purpose

Synchronize authoritative project state after P0126 was committed/pushed and the
final Active Quest R3 runtime/visual result passed.

P0127 also opens the exact next work item:
the D-035 NPC quest-interaction source/capability audit.

## Changes

P0127:
- records P0126 as durable at `89b0c563` / `0.0.58-dev`;
- preserves the initial `0.0.55-dev` hover failure and R1 correction history;
- records final R3 runtime + visual PASS evidence;
- marks Active Quest as an accepted production baseline with whole-screen polish
  deferred;
- updates CURRENT, handoff, roadmap status, Phase G pause text, Phase H parallel
  translation state, visual audit, questing architecture, and durable MEMORY;
- closes Active Quest as an active investigation item;
- opens `NPC_QUEST_INTERACTION_CAPABILITY.md` as the exact next objective;
- updates the patch index and dated memory.

## Next objective

**D-035 NPC quest interaction source/capability audit.**

The audit starts with information/control/fallback inventory. It does not suppress
Blizzard quest/gossip surfaces and does not implement quest actions.

## Boundary

Docs/evidence only. No Lua/runtime files change.

No WoW redeploy or `/reload` is required.
