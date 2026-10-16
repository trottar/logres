# P0218 — H.3 approved compact aura metadata and urgency

Baseline: verified GitHub main `b841afa39ca15edfad12ac8f675efcb80acd0df6` (P0217). Runtime version `0.0.127-dev`. Static and WoW evidence boundaries in `../evidence/P0218_H3_AURA_STATE_PLATES.md`.

- Reuse P0137 sheet-04 Aura count-plate asset (unchanged), register shared status aura metadata dimensions, a warm urgent rail and source path in Theme.
- In addon-owned `StatusAuras.lua` only, place a small plate beneath a source-approved 2+ count and show an existing-classification urgent-only 11px rail. Hide both on empty/inactive rows.
- Keep all source guards, filter priority, preview, tooltip callbacks, frame click boundaries, Blizzard native restricted HARMFUL and PlayerHelpfulAuras untouched.
- Add `tools/check_h3_status_aura_visual_contract.py` to guard these bounds, bump Bootstrap/TOC, and update durable CURRENT/handoff/roadmap/evidence/index in one checkpoint.
- Applier guards baseline and git worktree, shadow checks all statics, checks exact prepared-file whitespace, applies transactionally, writes SHA manifest, never commits/pushes. Runtime unverified until developer panel and direct inspection.

## R1 delivery correction

R0 stopped **prewrite** at `check_memory_health.py`: prepared handoff lacked a `CURRENT.md` pointer. R1 updates only the generated handoff/contract guard and records the negative result. Approved assets, Lua rendering changes, layout and secure paths remain unchanged. See evidence record.
