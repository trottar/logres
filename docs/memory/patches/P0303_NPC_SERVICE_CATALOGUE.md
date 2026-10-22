# P0303 — NPC service catalogue data extraction

- Baseline: verified pushed P0302 `05f8afc`.
- Status: PREPARED / WSL and WoW pending.
- Runtime: source-neutral data-only `UI/NPCServiceCatalogue.lua` now powers the trainer's source-order filter window/clamp; trainer's single-skill purchase resolves stable ID from original catalogue. Visual layout, hover, native purchase logic and Blizzard stock preserved.
- Evidence: `docs/memory/evidence/P0303_NPC_SERVICE_CATALOGUE.md`; historical P0294 selection, P0295 slider, P0296 icon and P0297 blackout failures are preserved.
- Next: validate extraction in WoW, then automatic/default trainer + safe native stock fallback. After trainer production validation: native gossip, merchant, flight master, in that order. Shared lifecycle/hover/scroll input should be extracted only through tested adapters and not via an unproven generic wrapper.

## R0 failure / R1 correction
R0 PREWRITE FAIL 2/174: preserved P0288 TOC adjacency was broken and new evidence marker missing. No tracked writes. R1 restores the contiguous trainer chain and requires explicit UNVERIFIED evidence; WSL suites and WoW remain pending.
