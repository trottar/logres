---
memory_schema: 1
as_of: 2026-10-22
project: logres
---

# Current State

## Active Objective
Finalize consistent Logres trainer presentation with source-backed profession context and recoverable Blizzard native fallback. Then implement gossip, merchants and flight masters.

## Current Work Item
**P0312 — profession skill context / empty-source event recovery and P0311 regression repair; PREPARED, WSL and WoW UNVERIFIED.** Verified P0311 GitHub main `8987489`. New user screenshot shows native Enchanting with five services while Logres incorrectly displays the zero-source state: **OPEN RUNTIME FAIL**. P0311 profession Goodbye closing both panels is user-rejected while stock remains required. P0312 restores profession Logres-only Goodbye, retains class native-close Goodbye, and adds a guarded copied player-professions section below search and categories. On a native TRAINER_UPDATE with Logres empty, a once-per-event guarded service reread may rebuild the existing trainer panel if real services become available; not proven effective until WoW test.

## Verified State
- P0310 P — Previews → Trainer Empty Preview and live Grimnur Fishing empty Logres panel user screenshot PASS for shared visual geometry, with Blizzard fallback. Fishing Blizzard showed Journeyman rank, absent from Logres model; no general skill ownership inference from service count.
- P0309 Enchanting one-skill purchase USER PASS, class single and bulk purchase previously tested. P0308 class native parking and native-close Goodbye user PASS. P0311 new Enchanting zero-service presentation despite Blizzard five services is FAIL; native profession Goodbye close rejected, not accepted final policy.
- Runtime profession skill-line API results and P0312 recovery are UNVERIFIED. Unknown/unowned profession detection and profession native-window removal remain DEFERRED.

## Next Action
Apply guarded P0312 on exact clean P0311 commit, require 183/183 PREWRITE/POSTWRITE suite PASS and diff/manifest. User commits/pushes; verify main. Deploy and `/reload`. Check P — Previews → Trainer Empty Preview for synthetic context. Open Enchanting and confirm Logres services reappear instead of stale zero rows; if not, use H — Trainer Family Check at the same session to capture actual native service count. At Fishing verify skill/rank context where ordinary profession APIs return it and native fallback stays available. Confirm profession Goodbye closes Logres only, class Goodbye closes native. No purchase needed.

## Success Criteria
One consistent approved parchment renderer for empty and nonempty source; source-backed known profession name, level, skill cap and derived tier label in left sidebar when ordinary. Never fabricate a Learn Profession offer. No polling, forced native filter writes, protected/secret inspection, native profession parking or new transactions. P0311 regression preserved as evidence. No new preview action needed; existing P empty fixture renders the new shared context component.

## Do Not Reopen Without New Evidence
A native zero service count is not proof a profession is already learned or unknown. Do not suppress Blizzard profession UI until adequate source coverage and separately validated native transactions exist. Do not enforce the user-rejected P0311 profession native-close behavior. Keep past failures and their corrective checkpoints discoverable.

## Relevant References
- `docs/memory/evidence/P0312_PROFESSION_CONTEXT_RECOVERY.md`, `docs/memory/patches/P0312_PROFESSION_CONTEXT_RECOVERY.md`
- `docs/memory/evidence/P0311_PROFESSION_CLOSE_FILTER_CONTEXT.md`, `docs/memory/evidence/P0310_TRAINER_EMPTY_CATALOGUE.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`, `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/ROADMAP.md`, `docs/memory/patches/PATCH_INDEX.md`
