---
memory_schema: 1
as_of: 2026-10-11
project: logres
---

# Current State

## Active Objective
**Phase H: PetActionBar combat duplication remains OPEN / REPRODUCED.** P0204's post-combat recovery PASS is bounded to one observed cycle. P0205 traced the exact Forever 1.60.1.70338 Blizzard PetActionBar, XML Edit Mode root and secure state-driver source: a safe production combat-time ownership handoff is **NOT YET PROVEN**. NPC world-label dialogue overlap, ObjectiveTracker flash and H.3 contrast remain separate open items.

## Current Work Item
P0204 is **PUSHED and verified** at GitHub `main` `566bb8b569b1fd53f869ac051ab62cbd9fa380a2`, documents only. P0205 is the **DOCS-ONLY exact-build source/API capability audit** at `Gethe/wow-ui-source@943764493e6b16d63ded3ab304150d1f05e58b57`, recorded in `docs/memory/evidence/P0205_FOREVER_PET_COMBAT_SOURCE_AUDIT.md`. Runtime stays `0.0.109-dev`. Neither new parent gating nor direct state-driver takeover is enabled/accepted by static reasoning.

## Verified State
- Exact Forever build 70338 Blizzard PetActionBar source explicitly calls `self:Show()` on supported pet-related events. XML root is `parent=UIParent`, inherits `EditModeActionBarTemplate`, and contains ten secure pet controls. SecureStateDriver can make secure visibility transitions, but its presence does not establish safe coexistence with Blizzard's native Show, Edit Mode reparenting or all fallback modes. Source analysis only.
- P0204 loadCount 260: Blizzard PetActionBar combat overlap **FAIL / REPRODUCED**; `onShow=2 combatDeferred=1 immediateRefolds=1`, then `recovered=0→1 awaiting=true→false` proves one post-combat recovery PASS. No native visibility read was performed.
- **REJECTED** insecure combat-time hide/reassertion. **DEFERRED** unqualified visibility driver takeover and hidden-ancestor reparent because restoration and secure/stock control coverage are not runtime-established. See the canonical P0205 audit for precise source citations and candidate criteria.
- Prior P0200 `0.0.109-dev` normal Run All scope PASS (Layout 19/29/0; UI Ownership 17/18/0); harmful native 2-column attribution, NPC overhead text over quest, ObjectiveTracker flash, pet special modes/interaction and H.3 full acceptance remain open/deferred. No runtime/art/coordinate edits in P0205.

## Next Action
Prepare one **explicitly opt-in, default-OFF, reversible runtime candidate** for secure combat pet presentation ownership. Favor a capability-gated native/Logres visibility handoff that preserves functional stock controls on every unsupported path, arms/restores strictly out of combat, and never reads protected Blizzard presentation to decide behavior. Test native PET manual access, actual combat transition, Edit Mode and Immersion OFF/ON before production enablement; record failures. Do **not** register a blanket stock visibility driver, reparent Edit Mode roots unconditionally, add polling/hooks or mutate protected controls during combat on source reasoning alone. No further contrived combat reproduction is required to establish P0197's failure.

## Success Criteria
No redundant stock PetActionBar observed in supported ordinary Immersion ON, with functional native PET access and secure Logres pet controls; safe return to stock for unsupported modes. H.3 polish improves readability/layout while respecting source, interaction and state rules. Unobserved combat/special modes remain deferred, not PASS.

## Do Not Reopen Without New Evidence
No exact player HP, conventional health bar, enemy exact level/class/difficulty, secret inspection, unqualified Blizzard surface removal, broad hooks, polling or combat-unsafe mutation. PvP is a modifier, not Immersion OFF. Preserve party/class/pet/special/native/aura fallbacks until deliberately replaced.

## Relevant References

- `docs/memory/patches/P0205_PET_COMBAT_SOURCE_AUDIT.md`
- `docs/memory/evidence/P0205_FOREVER_PET_COMBAT_SOURCE_AUDIT.md`
- `docs/memory/patches/P0204_ACCEPT_P0197_COMBAT_EVIDENCE.md`
- `docs/memory/evidence/P0204_P0197_COMBAT_RECOVERY_2026-10-11.md`
- `docs/memory/patches/P0203_REPRODUCED_COMBAT_PET_BAR_AND_DIALOGUE.md`
- `docs/memory/evidence/P0203_COMBAT_PET_DIALOGUE_EVIDENCE.md`
- `docs/memory/patches/P0202_H3_SCREENSHOT_VISUAL_REVIEW.md`
- `docs/memory/evidence/P0202_H3_SCREENSHOT_VISUAL_EVIDENCE.md`
- `docs/memory/patches/P0201_RECORD_P0200_RUNTIME.md`
- `docs/memory/evidence/P0201_P0200_H3_RUNTIME_EVIDENCE.md`
- `docs/memory/patches/P0200_H3_VISUAL_IMPLEMENTATION.md`
- `tools/check_h3_visual_fidelity_contract.py`

- `docs/design/H3_APPROVED_ART_RUNTIME_FIDELITY.md`
- `docs/memory/patches/P0199_H3_VISUAL_FIDELITY_CHECKPOINT.md`
- `docs/design/approved/README.md`
- `docs/memory/decisions/D-039_APPROVED_VISUAL_BASELINE.md`

- `docs/memory/patches/P0198_P0197_RUNTIME_OBSERVATION.md`
- `docs/memory/evidence/P0197_PET_BAR_RESHOW_EVIDENCE.md`
- `docs/memory/patches/P0197_PET_BAR_DEFERRED_RESHOW_RECOVERY.md`

- `docs/memory/patches/P0196_R4_TARGET_AURA_NATIVE_CONFIG.md`
- `docs/memory/evidence/P0196_R4_TARGET_AURA_RUNTIME_EVIDENCE.md`

- `docs/memory/patches/P0194_R3_H2_PANEL_SCREEN_MAP.md`
- `docs/memory/evidence/P0193_H2_GEOMETRY_RUNTIME_2026-10-11.md`
- `docs/memory/evidence/P0193_H2_GEOMETRY_RUNTIME_2026-10-11.json`
- `docs/memory/patches/P0193_H2_GEOMETRY_EVIDENCE_ACCEPTANCE.md`

- `docs/memory/patches/P0192_H2_READONLY_GEOMETRY_CHECKPOINT.md`
- `docs/memory/evidence/P0192_H2_GEOMETRY_AUDIT_2026-10-11.md`

- `docs/design/layout/SCREEN_MAP_V4.md`
- `docs/design/layout/SCREEN_MAP_V4.json`
- `docs/memory/decisions/D-045_H2_SCREEN_MAP_V4.md`
- `docs/memory/patches/P0191_H2_SCREEN_MAP_V4_DESIGN_BASELINE.md`

- `docs/memory/patches/P0190_ACCEPT_P0189_AUTO_MAIN_RUNTIME.md`
- `docs/memory/evidence/P0190_P0189_AUTO_MAIN_RUNTIME_2026-10-11.md`

- `docs/memory/patches/P0189_MAIN_AUTO_IMMERSION_GATE.md`
- `docs/memory/evidence/P0189_MAIN_AUTO_GATE_CANDIDATE_2026-10-11.md`

- `docs/memory/patches/P0188_ACCEPT_P0187_NORMAL_RUNTIME.md`
- `docs/memory/evidence/P0188_P0187_R2_NORMAL_RUNTIME_2026-10-10.md`
- `docs/memory/patches/P0187_MAIN_SECURE_REPLACEMENT_CANDIDATE.md`
- `docs/memory/evidence/P0187_MAIN_SECURE_CANDIDATE_2026-10-09.md`
- `docs/memory/patches/P0186_MAIN_SECURE_TRANSITION_SOURCE_GATE.md`
- `docs/memory/evidence/P0186_MAIN_TRANSITION_SOURCE_GATE_2026-10-09.md`
- `docs/memory/patches/P0185_MAIN_BAR_MEMORY_RECONCILIATION.md`
- `docs/memory/evidence/P0185_MAIN_BAR_MEMORY_AUDIT_2026-10-09.md`
- `docs/memory/patches/P0184_ACCEPT_P0183_RUNTIME.md`
- `docs/memory/evidence/P0184_ACCEPT_P0183_RUNTIME_2026-10-09.md`
- `docs/memory/decisions/D-023_SELECTIVE_STOCK_ACTION_REPLACEMENT.md`
- `docs/memory/decisions/D-044_CLASS_PET_SPECIAL_CONTROL_SOURCE_AND_FALLBACK_POLICY.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/memory/investigations/ACTIVE.md`
- `docs/ROADMAP.md`
