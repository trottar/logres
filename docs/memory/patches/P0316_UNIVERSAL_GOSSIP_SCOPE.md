# P0316 — roll-forward universal NPC gossip source correction

Baseline: verified pushed GitHub main P0315 `878235b`; candidate runtime `0.0.217-dev`.

Correct pushed P0315 nonquest-only source gate by classifying ordinary gossip, mixed quest/gossip, quest-only and empty source stages without excluding guards, trainer preludes or NPCs with other services. Preserve option labels as disabled and quests as counts only; native Blizzard control remains. Migrate P0315 checker; add P0316 contract. No native selection, render activation, UI suppression, camera or trainer change.

R1 of P0315 was rejected before writes with `unexpected commit baseline` because the old applier pinned P0314 while P0315 was already pushed. Preserve original P0315 evidence/history. P0316 applier pins exact clean P0315 main, verifies owned blob SHAs, runs 187 checker PREWRITE/POSTWRITE, diff hygiene and manifest. Full static and WoW **UNVERIFIED** until user applies/tests. All Git writes remain user-owned.
