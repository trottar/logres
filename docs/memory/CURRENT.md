---
memory_schema: 1
as_of: 2026-10-11
project: logres
---

# Current State

## Active Objective

**Phase H.2 ACTIVE — user-approved Layout Draft v4 is the authored design target, not an implemented in-game placement.** Verified remote `main` `c67527e` contains P0190's accepted ordinary H.1 auto Main checkpoint (`0.0.101-dev`). Special combat/vehicle/override/possess/form/petbattle states remain ENVIRONMENTALLY DEFERRED. P0191 is a docs-only v4 positioning checkpoint awaiting user push; `Integration/Layout.lua` retains P0166's existing runtime anchors.

## Current Work Item

**P0191 docs-only publish the exact approved 13-rectangle screen map**: `docs/design/layout/SCREEN_MAP_V4.json` and `.md`, decision D-045 and layout contract checker. User's final correction aligns Main Bar Y to Secondary at **60.4%**. Enemy aura bands are symmetric about the right-offset target, and Player Debuffs are directly above bottom-center Player Resource, not over the left actions. No Lua/TOC, stock UI or anchor mutation.

## Verified State

- **P0189 pushed/verified at `bd0c36a`**, `0.0.101-dev`; user states all worked as expected. Latest `LOGRES_DIAGNOSTICS_LATEST.lua` loadCount 239: fresh startup Main `CANDIDATE auto=true optOut=false armed=true applied=true driver=true route=true` (1 activation / 0 restores); manual OFF `STOCK optOut=true` (1/1); manual ON `CANDIDATE optOut=false` (2/1); integrated Run All final `CANDIDATE activations=7 restores=6 pending=false error=nil`, Primary keys/feedback 12/12, `checkall: complete`.
- UI Ownership policy remains **35 / 17 PASS / 18 STOCK / 0 FAIL / 0 DEFERRED**. Main STOCK row is a policy classification and never a physical visibility read.
- User confirms tested ordinary visual/control behavior. Export does not independently measure mouse hit regions or capture a dedicated Edit Mode result. Opt-out continuity across Immersion toggles was included in user-accepted sequence; no intervening maincheck independently measures that state.
- Protected special native transitions in combat, vehicle, override, possess, bonus/form and petbattle are **ENVIRONMENTALLY DEFERRED**; do not force gameplay. Stock fallback stays available wherever capability is incomplete.
- Retain P0187 R0 repeat-ON FAIL, P0187 R1 delivery FAIL, P0188 R0 whitespace FAIL, earlier P0182/P0178/P0175 errors, and intermittent post-loot ObjectiveTracker flash. P0183 harmful aura visual acceptance and other deliberate stock information/control fallbacks unchanged.

## Next Action

**Apply, commit and push P0191, then verify remote main.** Next proposed P0192: bounded H.2 live geometry translation/collision audit of the approved v4 boxes using existing P0166 semantic anchors, full action density and required native fallbacks. Actual geometry remains runtime-UNTESTED; H.3 styling waits for accepted H.2 composition. No generic drag-anything editor or automatic pixel conversion.

## Success Criteria

The visually redundant normal Main presentation is absent when Logres has replacement coverage and present/usable when it does not, including special/override/vehicle/possess requirements. Routing, action execution/feedback, edit access, exact restoration, and interactions remain usable; no hidden clickable stock bar, protected-action, taint, Lua or secret-value failures. No assertion that all STOCK classifications are removed; the whole-screen integration/visual polish stage follows capability-safe H.1 closure.

## Do Not Reopen Without New Evidence

No exact player HP, conventional player health bar, enemy exact level/class/difficulty, secret-capable reads, broad stock UI suppression, polling or periodic forcing, or combat-unsafe protected mutation. PvP remains a modifier, not Immersion OFF. Keep class/pet, party/CompactParty, special actions, quest and on-demand native access, target-of-target, nameplates and private/group aura fallbacks until independently replacement-proven. The intermittent ObjectiveTracker flash remains OPEN / INTERMITTENT / UNREPRODUCED.

## Relevant References

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
