# P0287 — Read-only numeric category observation

Baseline verified on GitHub: `cb8b7567f843a4250d92f19ec74d62291f23a0c3` (P0286). Latest user WoW diagnostics established a numeric `GetTrainerServiceInfo` third result and numeric fourth result with ordinary name `Enchant Chest - Minor Absorption`. P0286's `categoryValue=unavailable` reflected a formatting placeholder, not the actual raw number.

Patch purpose: record an ordinary bounded numeric category and expansion number, retain safe money/icon/name reads, and mark such rows explicitly `numeric-category-unclassified`. Continue marking sampled source as `service-row-shape-deferred` until independently established meaning. No guessed available/known/unavailable mapping and no live fixture connection. Existing Classic string categories continue as before.

All changes are limited to the on-demand read-only service probe, H diagnostic formatting, version, tests and durable memory. No Blizzard transaction/control/layout writes, no native renderer updates, no portrait, no polling and no new external dependency. WSL static suite and client confirmation required; until then status PREPARED/UNVERIFIED.

## P0287 R0 checker-policy refusal and R1 corrective handoff

User WSL R0 SHA-256 PASS and pinned P0286 baseline PASS. PREWRITE ran 158 checkers; `check_checker_version_policy.py` alone failed because the new P0287 feature checker included a historical `0.0.NNN-dev` literal inside an evidence expectation. The applier stopped before tracked writes. This is a P0287 R0 artifact defect (not a WoW runtime failure). R1 removes the exact runtime-version pin from the checker; its runtime code and generated source transforms are unchanged. R1 WSL PREWRITE/POSTWRITE and WoW remain UNVERIFIED.
