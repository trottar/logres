---
memory_schema: 1
as_of: 2026-10-11
project: logres
---

# Current State

## Active Objective

**Phase H.2 ACTIVE — P0193 R2 verified pushed on `main` `213c526`.** P0194 R0 bottom-center-only placement was visually rejected. User requires one unified in-game screen map then one whole-screen placement pass, not isolated widget trials. P0194 R3 integrates the viewport map as a **dedicated Phase H developer-panel view** without removing the 15 Phase H actions; full-screen overlays are optional. H.1 ordinary Main remains accepted; special native/protected modes deferred.

## Current Work Item

**P0194 R3 — in-panel H.2 map candidate.** Phase H gets a dedicated H.2 Map button/view showing 13 D-045 approved regions and current secret-safe Logres-owned frame bounds, with Overlay ON/OFF, Refresh Map, and Layout Check controls. The original R2 offered slash-only controls, rejected as workflow; retain slash shortcut but make panel primary. R0 failed user visual intent; R1 delivery checker failed pre-write; R2 panel omission was rejected before runtime acceptance. No gameplay frame moves in R3.

## Verified State

- **P0193 R2 pushed/verified `213c526`**: approved 13 planning zones and 13/13 actual addon proxy measurements durable; no whole-screen geometry applied.
- **P0194 R0 visually rejected**: cropped screenshot still showed resource text near former action clusters. Deployment/Lua root cause not independently proved; do not claim runtime PASS. User rejected piecemeal positioning.
- **P0194 R1 pre-write checker failure**: static checker demanded incorrect viewport field expressions; no tracked writes. R2 corrected it but relied on slash commands instead of developer-panel UX. R3 corrects interaction policy; its runtime validation is PENDING.
- Existing Main ordinary user/runtime PASS and native/special environmental deferrals remain. Native harmful container bounds, Quest/native-access overlap and action Bar 4–5 geometry not collision-proven.

## Next Action

**Apply/deploy P0194 R3.** Open developer panel → Phase H → H.2 Map. Validate 13 approved blue and safe actual gold rectangles; test Overlay ON/OFF, Refresh Map, Layout Check and Back to H. Capture uncropped in-game full-screen overlay screenshot, then Phase H Layout Check / Phase 0 Run All and export diagnostics. Only after runtime acceptance and verified user push, prepare **one coherent P0195 whole-screen anchor/reflow implementation**, preserving native, secure, party, class/pet and special-mode fallback. Do not fragment into one-widget trials.

## Success Criteria

The visually redundant normal Main presentation is absent when Logres has replacement coverage and present/usable when it does not, including special/override/vehicle/possess requirements. Routing, action execution/feedback, edit access, exact restoration, and interactions remain usable; no hidden clickable stock bar, protected-action, taint, Lua or secret-value failures. No assertion that all STOCK classifications are removed; the whole-screen integration/visual polish stage follows capability-safe H.1 closure.

## Do Not Reopen Without New Evidence

No exact player HP, conventional player health bar, enemy exact level/class/difficulty, secret-capable reads, broad stock UI suppression, polling or periodic forcing, or combat-unsafe protected mutation. PvP remains a modifier, not Immersion OFF. Keep class/pet, party/CompactParty, special actions, quest and on-demand native access, target-of-target, nameplates and private/group aura fallbacks until independently replacement-proven. The intermittent ObjectiveTracker flash remains OPEN / INTERMITTENT / UNREPRODUCED.

## Relevant References

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
