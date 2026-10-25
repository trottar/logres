# P0333 — guarded pet hotkey/active-outline presentation

- Exact baseline: pushed `cbc2015a87a91035b25e6ea65585164ef495f470` (P0332 R1), 14 validated blob SHA/path pairs, branch `main`, clean tracked state.
- `PetActionExecutionProbe`: guarded ordinary `BONUSACTIONBUTTONn` label source and `UPDATE_BINDINGS` refresh; no new routing or secure attr changes.
- `Actions/Button`: generic checked visual gated off only when custom pet decoration owns the outline; undecorated fallback retained. Pet active cached flag remains ordinary-safe.
- `PetActionPresentation`: ordinary active outline no longer depends on both autocast booleans, which remain separate.
- Historical P0152 checker intentionally migrated; P0333 checker adds six binding and four active/autocast policy fixtures; 204 total checks PREWRITE/POSTWRITE; Bootstrap/TOC parity 0.0.227-dev, 94 Lua source entries unchanged.
- Durable records: CURRENT, handoff, issues, ACTIVE, STATUS, Phase H, patch index, roadmap, evidence, this patch record. No camera, native Blizzard UI, secure action routing, QuestieDB, saves, D-048 live preferences or aura modifications.
- WSL static tests and client visual/control acceptance UNVERIFIED until run. WoW Forever unavailable until November 4, 2026; no immediate deployment request. User alone commits/pushes, then GitHub main verified before advancing.
