---
memory_schema: 1
as_of: 2026-10-11
project: logres
---

# Current State

## Active Objective
**Phase H.2 ACTIVE — P0195 `9097f43` on `main`; P0196 R4 correcting uncommitted native target aura duplication.** The approved v4 screen composition and restored Logres player/target buff artwork remain authoritative. Source-backed target native aura configuration is a candidate, not runtime acceptance.

## Current Work Item
P0196 R4 is an **UNPUSHED RUNTIME CANDIDATE** addressing the R3 verified visual residual: the small Blizzard contextual target aura icon remains despite correct Logres player/target buffs. R3 `0.0.106-dev` loadCount 250 native-surfaces reported targetAuras:stock; Logres helpful and secure harmful lanes remain. Forever 1.60.1.70338 TargetFrameMixin:ConfigureAuraContainer source supports native 0/0 aura limits and restores, without the R1 forbidden OnShow hook. Existing pet/player buff replacement is untouched. TARGET opens the native aura container; Damage Meter and beta reporter unchanged. R1 visual/hook failure and R2 delivery failure remain recorded. Details: `docs/memory/patches/P0196_R4_TARGET_AURA_NATIVE_CONFIG.md` and `docs/memory/evidence/P0196_R4_TARGET_AURA_RUNTIME_EVIDENCE.md`. No R4 runtime PASS yet.

## Verified State
- P0195 remains the last durable commit on `main` (`9097f43`); P0196 R1/R2/R3/R4 are unpushed. R1 failed player buff visuals and unsupported target aura OnShow hook; R2 failed prewrite memory-health validation. R3 user screenshot accepts original Logres player and target buff presentation, but shows one duplicate Blizzard target icon left of target; diagnostics report `targetAuras:stock`, with secure harmful renderer ready.
- R4 native owner method is supported by inspected Forever source. Gameplay outcome, secure interactions, retarget stability and restoration are untested.

## Next Action
Apply P0196 R4 against exact uncommitted R3 worktree; deploy and `/reload`; test native target aura disappearance with target present, TARGET native open/close, Immersion OFF/ON, pet action/control regression, Phase H Native Access, Target Frame, Status Aura, Layout, Phase 0 Run All. A Lua, protected-action, taint, secret, lost aura or visual failure blocks commit. Only after runtime PASS may user commit and push.

## Success Criteria

The visually redundant normal Main presentation is absent when Logres has replacement coverage and present/usable when it does not, including special/override/vehicle/possess requirements. Routing, action execution/feedback, edit access, exact restoration, and interactions remain usable; no hidden clickable stock bar, protected-action, taint, Lua or secret-value failures. No assertion that all STOCK classifications are removed; the whole-screen integration/visual polish stage follows capability-safe H.1 closure.

## Do Not Reopen Without New Evidence

No exact player HP, conventional player health bar, enemy exact level/class/difficulty, secret-capable reads, broad stock UI suppression, polling or periodic forcing, or combat-unsafe protected mutation. PvP remains a modifier, not Immersion OFF. Keep class/pet, party/CompactParty, special actions, quest and on-demand native access, target-of-target, nameplates and private/group aura fallbacks until independently replacement-proven. The intermittent ObjectiveTracker flash remains OPEN / INTERMITTENT / UNREPRODUCED.

## Relevant References

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
