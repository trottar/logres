# P0312 — Profession context and source reconciliation

Baseline verified P0311 GitHub main `8987489861c025374c0d26a779e48d84b737ca77`; candidate `0.0.213-dev`.
Status **PREPARED / full WSL and WoW UNVERIFIED**.
- Add data-only guarded `Quest/TrainerProfessionContext.lua` for owned skill values/caps; no transactions.
- Place source-backed profession context under search/categories in approved shared trainer renderer; P empty fixture exercises same render path.
- On event `TRAINER_UPDATE`, recover genuinely later-readable native service snapshots from a displayed empty view (not polling).
- Revert P0311 profession Goodbye native close: restore Logres-only dismissal with usable Blizzard; class behavior unchanged.
- Correct P0311 checker to record supersession rather than assert a known rejected profession close as a required capability.
- Preserve original 36 P preview actions, existing TOC trainer chain, all purchase gates and native fallback.
