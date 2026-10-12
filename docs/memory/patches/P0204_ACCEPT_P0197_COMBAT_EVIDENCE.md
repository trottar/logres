# P0204 — Accept bounded P0197 combat-deferral runtime evidence

Date: 2026-10-11. Baseline: pushed GitHub `main` `5c28c2dfd28667926c30499f99c53097a1ba0e57` (`P0203`); deployed version `0.0.109-dev`. **DOCS ONLY — no runtime change or WoW redeploy**.

Source: user-uploaded `LOGRES_DIAGNOSTICS_LATEST.lua`, loadCount 260, Native Access Check followed by Phase 0 Run All (~30 seconds apart). New canonical record: `docs/memory/evidence/P0204_P0197_COMBAT_RECOVERY_2026-10-11.md`. User screenshot/owner confirmation from P0203 remains direct combat-overlap evidence.

P0204 accepts that P0197 **post-combat recovery executed successfully in one observed cycle** (`onShow=2`, `combatDeferred=1`, `immediateRefolds=1`, `recovered=0→1`, `awaiting=true→false`). The earlier Native Access Check was appropriately `DEFERRED` during native combat reconciliation; the later check was PASS with no errors. **Do not equate recovery PASS with combat-presentation PASS.** Duplicate Blizzard PetActionBar during combat stays **OPEN / REPRODUCED IN COMBAT**. No exact original Blizzard show event or protected stock visibility inspection was captured. Old P0197 observations and all negative evidence remain recorded.

**Next:** source/API capability audit for a combat-safe pet control presentation transition; no speculative new hide hooks, protected combat mutations, broad polling, secret-value reads or D-045 anchor movement. Separate NPC world-label dialogue occlusion and target icon ownership are unchanged open investigations.
