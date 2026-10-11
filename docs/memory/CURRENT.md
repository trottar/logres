---
memory_schema: 1
as_of: 2026-10-11
project: logres
---

# Current State

## Active Objective
**Phase H.2 ACTIVE — P0196 R4 verified pushed as `c89692b`, version `0.0.107-dev`; P0197 intermittent pet-bar deferred-reshow recovery is the next runtime candidate.** Approved v4 geometry and restored Logres player/target buff artwork remain accepted; target debuff icon size is deferred to H.3 polish.

## Current Work Item
P0197 is an **UNPUSHED RUNTIME CANDIDATE** with narrow hypothesis: stock PetActionBar can be shown by Blizzard during combat; NativeSurfaceReplacement OnShow defers Hide, yet post-combat Reconcile sees an existing snapshot and skips refold. Record addon-owned OnShow/deferred/recovered counters and retry Hide only once in an out-of-combat event-driven reconciliation when that precise deferred OnShow was observed. No protected visibility inspection, periodic forcing or user-facing artwork changes. Details: `docs/memory/patches/P0197_PET_BAR_DEFERRED_RESHOW_RECOVERY.md` and `docs/memory/evidence/P0197_PET_BAR_RESHOW_EVIDENCE.md`.

## Verified State
- GitHub `main` `c89692b0dec19c6dc03779a1eb57a1536da2124e` verified as P0196 R4 user push. User screenshot and testimony: target helpful/harmful presentation correct; smaller Logres debuff icon is polish, not this work item.
- User screenshot: a duplicate Blizzard PetActionBar is intermittently visible alongside Logres 5x2 pet controls, exact onset unknown. Uploaded `0.0.107-dev` loadCount 251 diagnostics: `native-surfaces CANDIDATE` reports petFrame/petActions/playerBuffs/targetAuras folded, pending=false, error=nil. This is snapshot state, **not proof that Blizzard remained hidden continuously**. Original OnShow and combat deferral code has a specific event-driven recovery gap; combat trigger remains **INFERRED, NOT OBSERVED**.
- Prior P0196 R1 unsupported target OnShow hook/art regression and R2 prewrite checker failure remain preserved. Unobserved protected/combat/special pet states are not PASS.

## Next Action
Apply and deploy P0197; observe the pet bar naturally, including when entering/leaving ordinary combat if available; run Phase H Native Access Check when duplicate visible and again after leaving combat. Observe `petbar-reshow` counters, PET open/close stock restoration, Immersion OFF/ON, Pet Action Probe Check and Run All. Do not claim source-only repair complete until in-game evidence. Any Lua/taint/protected-action error or lost pet interaction blocks acceptance. User alone commits/pushes after PASS.

## Success Criteria
Blizzard PetActionBar is not redundantly exposed alongside Logres's complete pet cluster during supported ordinary gameplay; intentional PET access/Edit Mode and fallback remain usable. If protected state prevents in-combat folding, defer and retry once at safe post-combat reconciliation without querying Blizzard protected visibility. Preserve the main/special, party, aura and native fallback boundaries of Phase H.

## Do Not Reopen Without New Evidence
No player exact HP or conventional health bar, enemy exact level/classification, secret-capable reads, broad native suppression, polling, periodic reassertion or combat-unsafe protected mutation. PvP remains a modifier, not Immersion OFF. Preserve Blizzard controls where capability is incomplete. ObjectiveTracker flash remains OPEN / INTERMITTENT / UNREPRODUCED.

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
