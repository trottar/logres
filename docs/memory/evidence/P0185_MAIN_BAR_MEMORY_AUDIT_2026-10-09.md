# P0185 — Memory audit: MainActionBar remaining visual work (2026-10-09)

## Verified facts and inconsistencies

Remote `trottar/logres` `main` SHA `4e999b1445d784378f8a6030f8f9dc737cb9e985`, commit `docs: accept P0183 native Logres debuff runtime`, contains P0184 manifest, patch and acceptance evidence. `CURRENT.md` and `CURRENT_HANDOFF.md` nevertheless said P0184 was **PENDING USER PUSH** and `STATUS.md` still identified P0181/P0182/P0183 as active. The Phase H status table pointed at P0168 pending quest-offer gating, and ACTIVE opened with an old P0168 next step. These are current-index contradictions, not proof the historical attempts never happened.

Latest provided Logres diagnostics at `0.0.98-dev`, loadCount 234: native debuffs `ready=true active=true`, Phase 0 Run All complete, 35 ownership rows = **17 PASS, 18 STOCK, 0 FAIL, 0 DEFERRED** in Immersion ON. The user visually confirmed Logres debuffs appear; P0184 acceptance is durable. No extra aura observation is needed to continue Main work.

The user now states: **"We only have main action bar left to remove."** Earlier P0172 evidence also recorded a clean normal screen except Main. Interpret this as a user-observed **persistent ordinary Immersion ON screen** statement. It is **not** a claim that every other Blizzard frame is physically hidden, that the 18 STOCK rows are defects, or that special UI may be suppressed. Stock ownership means the corresponding Blizzard information/control is intentionally retained, and many such rows say `not inspected`; 17/18 is not a visual-disappearance score.

`Logres/Core/UIOwnershipAudit.lua` registers `main_action` as STOCK (`secure special/edit fallback incomplete`) and `special_actions` STOCK (`special actions deliberately stock`). `Logres/Actions/Primary.lua` reports `stockSuppressionAuthorized=false`, `specialPagingCoverage=normal-pages-only`, `stockPreserved=true`. D-023 requires atomic secure path/routing/feedback and exact restoration before normal Main suppression. D-044 reserves vehicle/override/possess/extra and separate pet/class/stance controls. The main-action bar can be the **last redundant visible normal-mode bar** and still require safe fallbacks for these other cases.

## Classification and next action

**Current H.1 visual delivery gate:** remove the remaining redundant **normal MainActionBar presentation** with a complete normal-mode secure action/control path, no hidden click region, and exact recovery, while failing open to stock for unsupported/special/protected conditions. This is **OPEN**, not runtime PASS; P0185 changes memory only. The wider visual polish stage (including debuff ornament) remains deferred. Preserve as historical negative evidence P0182 filter-only failure, original P0183 prewrite missing cache-manifest entry fixed in R1, P0178 60-upvalue Lua startup error, P0175 R2 nil-rows failure, and open intermittent post-loot ObjectiveTracker flash. Do not conflate absence of environment for special states with a PASS.

## P0185 R0 packaging/baseline failure; R1 correction (2026-10-09)

The first P0185 ZIP passed its own synthetic transform/integrity tests but failed on the user's clean pinned P0184 checkout **before any tracked writes**: `P0185 APPLY FAIL — unexpected source blob docs/memory/investigations/ACTIVE.md: 29b3e0b4d347395c5e06214f23cb7df66c4aae97`. Re-query of the **same** GitHub `main` commit `4e999b1` established that P0185 R0 had pinned stale blob IDs for seven memory files changed by P0184. R0's `ACTIVE.md` expectation `1896d955...` was wrong; the committed blob is `29b3e0b4...`. The original pre-write check rejected this, correctly preventing partial edits. **R0 is INVALID / SUPERSEDED, not a runtime FAIL.** No Git reset, WoW change, or repeat acceptance test is justified.

P0185 R1 corrects all seven blob IDs, additionally verifies each expected blob against both `HEAD:path` and the worktree, preserves the existing exact-head/clean-tree and candidate-shadow full-checker gates, and retains the same documentation-only scope. This is a source-locking/delivery correction; no addon behavior changed.
