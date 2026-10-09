---
memory_schema: 1
as_of: 2026-10-09
project: logres
---

# Current State

## Active Objective

**Phase H.1 OPEN — working Logres player and hostile-target debuffs are the active delivery gate.** GitHub `main` `2adce36688ee1d3fdddd75e373598a0e9d6f04e8` contains P0181 docs-only P0180 acceptance at `0.0.96-dev`, Phase 0 Run All complete and 35-row UI ownership 17 PASS/18 STOCK/0 FAIL on Immersion ON. Stock is policy, not inspected native-frame visibility. Naturally populated harmful icon rendering in Logres is not proven; the user reports Blizzard debuffs only.

## Current Work Item

**P0183 R1 `0.0.98-dev` — native secure-rendered Logres harmful aura rows, NOT PUSHED / NOT RUNTIME VERIFIED.** First P0183 ZIP failed before tracked writes due to an unshipped `__pycache__` hash-manifest entry. R1 repairs only patch delivery; it does not constitute runtime validation. Source-backed `CustomAuraContainerTemplate` with addon-owned placement and native HARMFUL AuraButton rendering for player and target. Replaces harmful icon presentation when enabled while leaving Logres player buffs, target helpful, deterministic preview, and all stock aura fallback unchanged. No new scanner or unsafe restricted-payload queries. P0182 nameplate-only filters did not solve the observed issue; preserve negative evidence.

## Verified State

- P0181 verified on `main` `2adce36`; latest uploaded P0180 loadCount 232 Phase 0 Run All completed with no recorded Lua errors and UI Ownership ON 17/18 PASS/STOCK, zero FAIL/DEFERRED. P0180 event-history, preview/Immersion guards accepted for observed scope only.
- Previous player harmful samples ordinary-empty; target harmful 9 events, six restricted, no ordinary positives; target helpful one ordinary positive on friendly target. Secret skips are not number of invisible auras. User reports Blizzard debuffs shown but no Logres debuffs even after P0182 filtering trial.
- Source audit `Gethe/wow-ui-source@e3ecc27` and Forever-compatible Musca-Auras native UI confirms `CustomAuraContainerTemplate`/native AuraButton interface. This is API/source evidence, not proof of P0183 in-client behavior.
- P0178 original >60-upvalue startup FAIL, P0175 R2 nil-rows, P0177 incomplete push, P0182 unproven filter correction, and intermittent loot ObjectiveTracker flash remain preserved in history.

## Next Action

Apply and deploy P0183; test visually whether actual **Logres** player and hostile-target debuffs appear through the native rows while Blizzard aura fallback remains available. Use Phase H **Status Aura Preview ON/OFF**, **Status Aura Check** and Phase 0 **Run All**, **UI Ownership Check** panel buttons. Classify restricted/empty conditions as deferral, and native setup/taint/Lua failures as FAIL. Do not repeat previous passing panel tests merely because persisted SavedVariables are stale. After clean tested scope user commits/pushes; verify GitHub main before advancing. Do not divert to Main/special action ownership before resolving debuffs.

## Success Criteria

Actual player and enemy debuff icons are visible in Logres when harmful effects occur, native container setup/target updates/previews/OFF/ON/fallback are safe, mana/cast/other HUD remains intact, no secret/taint/protected errors, and Run All/ownership remain clean. Source contracts or a green native-setup flag alone are insufficient. Do not suppress Blizzard aura/private/group/target-of-target surfaces.

## Do Not Reopen Without New Evidence

No exact player HP or enemy difficulty, secret payload inspection, blanket native suppression, periodic polling or protected mutation in combat. Pet/class, party, special Main/Override/vehicle, minimap, quest, native aura fallbacks remain where replacements incomplete; PvP is a modifier. Loot ObjectiveTracker flash OPEN/INTERMITTENT/UNREPRODUCED.

## Relevant References

- `docs/memory/patches/P0183_NATIVE_DEBUFF_CONTAINERS.md`
- `docs/memory/evidence/P0183_NATIVE_DEBUFF_CONTAINERS_2026-10-09.md`
- `docs/memory/decisions/D-041_AURA_STATUS_SOURCE_AND_PRIORITY_POLICY.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/memory/evidence/P0181_ACCEPT_P0180_RUNTIME_2026-10-09.md`
- `docs/ROADMAP.md`
