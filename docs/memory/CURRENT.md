---
memory_schema: 1
as_of: 2026-10-09
project: logres
---

# Current State

## Active Objective

**Phase H.1 OPEN — ownership/coexistence and incomplete Blizzard replacement coverage.** GitHub `main` verified at `fd0dc88` (`0.0.95-dev`, P0178 R1). The expandable 35-surface Blizzard ↔ Logres UI ownership audit is installed and accepted for **observed Immersion ON/OFF, slash registration and Run All**. It is a policy/diagnostic matrix, not a claim that every retained stock frame was visually inspected or can be removed. The original P0178 `0.0.94-dev` client startup failure (Lua `handleCommand` more than 60 upvalues) remains recorded and corrected, not erased.

## Current Work Item

**P0179 — docs-only runtime evidence acceptance, awaiting user commit/push.** Synchronize P0178 R1 verified remote commit and observed 0.0.95-dev loadCount 229 diagnostics, without any addon-runtime or checker changes. Maintain the 35-surface registry and Phase 0 UI Ownership Check as the *ongoing* ownership regression gate whenever Logres adds a replacement or changes an ownership policy. Keep existing specialized checks and Phase 0 Run All.

## Verified State

- Remote `main` at `fd0dc882f2a3bf81faab3bb23e5e47923145b438` contains `Logres/Core/UIOwnershipAudit.lua`, `tools/check_ui_ownership_audit_contract.py`, P0178/R1 manifests and the fix records. No unpushed-code claim remains.
- Uploaded `LOGRES_DIAGNOSTICS_LATEST.lua`, `0.0.95-dev`, loadCount 229: `/logres status`, `/logres uiownershipcheck`, Phase 0 Run All, `/logres lifecyclecheck` and `/logres preferencecheck` executed; Run All completed in Immersion ON and OFF, with no command/Lua error recorded in these runs. Individual lifecycle and preference checks PASS.
- Immersion ON: ownership `total=35 pass=17 stock=18 deferred=0 fail=0`; HUD `immersion=true visible=true`; five native domains folded, cast gate armed and `gateEscapes=0`. Immersion OFF: `total=35 pass=16 stock=19 deferred=0 fail=0`; Logres player/target/chat/bar replacement released, HUD hidden, five native domains restored, cast gate unarmed, and Run All complete. A subsequent Immersion ON Run All again returned 17/18/0/0.
- **STOCK is policy-only**, not a proof of native frame visibility; entries often report `observed=not inspected`. A PASS can prove coherent observed addon-owned state without proving every gameplay/context transition or every Blizzard visual.
- P0177 comparator previously observed one general target HELPFUL candidate missed by narrower priority filters; live player/target harmful data remains unproven, target hostility of buff observation unknown. The loadCount 229 scan had empty player harmful/absent target. Keep no harmful-coverage PASS claim.

## Next Action

Apply P0179 docs-only source-locked patch, run full repository static suite and `git diff --check`, commit/push only by user, then verify new main before advancing. No WoW redeploy or new in-game validation required for P0179. Thereafter use `/logres uiownershipcheck` and Run All as recurring Phase H audit gates. Next runtime capability investigation remains **naturally encountered live harmful-aura source/presentation vs retained Blizzard auras**; investigate source restrictions and priority-filter differences only on real ordinary evidence. Separately, the occasional post-loot ObjectiveTracker flash is OPEN/INTERMITTENT/UNREPRODUCED, and primary/special/pet/party/minimap/full-quest ownership remains capability-gated STOCK. Do not create a broad hider/polling workaround.

## Success Criteria

P0179 changes documentation/evidence only and leaves `0.0.95-dev` runtime untouched; static checks and whitespace check PASS; P0178 R1 acceptance is precise, negative history intact; registration guidance for future Logres surfaces remains explicit. Future UI-ownership changes extend the registry, provide a corresponding static contract, and are checked alongside existing Run All; STOCK/DEFERRED never auto-promote to PASS or suppression authorization.

## Do Not Reopen Without New Evidence

No conventional exact player HP bar, enemy exact level/class/difficulty, secret-capable value inspection, global frame suppression or generic reassertion. Preserve native group/party, class/pet, Main/Override/special actions, minimap, target auras/ToT/Focus/boss, full quest/XP, and unsupported interactions until secure and information/control replacements with restoration/fail-open are established. PvP modifies Immersion rather than turning it OFF. Historical failures include P0175 R2 nil-row, original P0176 prewrite regression, P0177 omitted-file push, and original P0178 upvalue failure.

## Relevant References

- `docs/memory/patches/P0179_ACCEPT_P0178_R1_RUNTIME.md`
- `docs/memory/evidence/P0179_ACCEPT_P0178_R1_RUNTIME_2026-10-09.md`
- `docs/memory/patches/P0178_R1_SLASH_UPVALUE_FIX.md`
- `docs/memory/evidence/P0178_R1_SLASH_UPVALUE_FIX_2026-10-09.md`
- `docs/memory/patches/P0178_UI_OWNERSHIP_MATRIX.md`
- `docs/memory/evidence/P0178_UI_OWNERSHIP_MATRIX_2026-10-09.md`
- `docs/memory/evidence/P0177_R1_DURABILITY_REPAIR_2026-10-09.md`
- `docs/memory/evidence/P0164_BLIZZARD_SURFACE_OWNERSHIP_AUDIT_2026-10-07.md`
- `docs/memory/decisions/D-041_AURA_STATUS_SOURCE_AND_PRIORITY_POLICY.md`
- `docs/memory/decisions/D-042_WORLD_TARGET_ANCHOR_AND_FALLBACK_POLICY.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/ROADMAP.md`
