---
memory_schema: 1
as_of: 2026-10-22
project: logres
---

# Current State

## Active Objective
Finish source-backed Logres trainer replacement with recoverable stock fallback, shared NPC catalogue/session/renderer and service-specific purchases. After trainer finalization, native gossip, merchants and flight masters in that order.

## Current Work Item
**P0309 — guarded single profession-service purchase / PREPARED; WSL STATIC and WoW UNVERIFIED.** GitHub `main` P0308 `78a0c03` verified. User reports class-only Logres presentation, automatic open and true native-close Goodbye PASS. Cooking/Enchanting render the shared Logres catalogue with stock Blizzard still usable and Logres Goodbye only dismissing Logres; Fishing remains native-only after source-empty diagnostic. This is correct P0308 scoped regression evidence, NOT proof of profession purchase. P0309 adds an independently guarded profession single-service request, while keeping class purchase and class Train All separate. It does not park profession stock or invent source data.

## Verified State
- User P0308 class trainer: only Logres visible, Goodbye closes trainer cleanly without Blizzard flash, and no observed regression. Scoped native-close visual PASS; purchases while class stock parked remain unverified.
- User P0308 Cooking and Enchanting: shared source-backed Logres UI and visible Blizzard controls, no observed error; no Logres profession purchase yet verified. Goodbye dismisses only Logres at professions, by design.
- P0307 Fishing Trainer Grimnur: `type=7`, `profession=yes`, `services=0`, Blizzard-only fallback. This is a single-NPC source-empty observation, not universal fishing absence.
- Earlier class single and Train All purchase, search, filters, selection, hover, scrolling, icons and native parking passed separately within tested scopes.

## Next Action
Apply P0309 guarded ZIP on clean verified P0308. Require complete prewrite/postwrite `tools/check_*.py`, source hashes, diff whitespace and manifest PASS. User commits/pushes, verify main, deploy and `/reload`. At a profession trainer with an available affordable skill, select exactly that known skill and, ONLY if intentionally purchasing, test Logres Train selected (TEST) once. Verify actual learning and funds using visible Blizzard. If unavailable, test disabled actions/read-only selection and defer purchase evidence. Class trainer should still show only Logres, class Train All should remain separate, and Goodbye should close class interaction. Fishing source-empty remains stock. Record any Lua, taint, protected or secret-value errors as FAIL.

## Success Criteria
Separate profession controller revalidates ordinary family, trainer identity, service index/name/icon/rank/level, skill requirement, copper, both extra cost returns and funds before at most one explicit BuyTrainerService request. No automatic purchase, bulk for professions, preview transaction, polling or native parking. Blizzard stays visible/usable for profession clients whether request succeeds or defers. No alteration to Quest, camera, shared renderer or accepted Logres trainer art.

## Do Not Reopen Without New Evidence
Never generalize a class transaction into profession Train All, silently ignore talent/profession cost, treat a pcall as confirmed training, fabricate empty Fishing rows, hide stock before profession purchases are proven, inspect secret/native placement values, or erase historical R0 static failures. D-046/D-047 remain authoritative.

## Relevant References
- `docs/memory/evidence/P0309_PROFESSION_SINGLE_TRANSACTION.md`, `docs/memory/patches/P0309_PROFESSION_SINGLE_TRANSACTION.md`
- `docs/memory/evidence/P0308_TRAINER_NATIVE_GOODBYE.md`, `docs/memory/evidence/P0307_TRAINER_FAMILY_DIAGNOSTIC.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`, `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/ROADMAP.md`, `docs/memory/patches/PATCH_INDEX.md`
