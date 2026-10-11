---
memory_schema: 1
as_of: 2026-10-11
project: logres
---

# Current State

## Active Objective

**Phase H.2 ACTIVE — P0194 R3 pushed/verified `f7a67bc`, `0.0.103-dev`.** In-game user screenshot shows approved blue 13-region map and old gold frame positions simultaneously. H.2 panel map is accepted for observed function, not geometry acceptance. P0195 applies one coordinated percent-based v4 frame layout/reflow with capability-safe native fallbacks; H.1 ordinary Main accepted, special modes deferred.

## Current Work Item

**P0195 unified v4 layout candidate (`0.0.104-dev`) — runtime validation OPEN.** Apply all approved 13 territories together via centralized UIParent-percent anchors, with 2×6 Main/Secondary, 6×2 Utility, separated target/player harmful and target helpful lanes, and non-overlapping retained Bar4/5 and native access. This is one screen-wide patch, not 13 independent acceptance trials. Frame-sized envelopes are not forced to match planned rectangles. No new stock UI suppression.

## Verified State

- **P0194 R3 pushed/verified `f7a67bc`**: user confirms H.2 developer panel additions work and provides a full-screen overlay screenshot. Latest `0.0.103-dev`, loadCount 245 diagnostics: Layout Check 16 anchors / 23 bindings / 0 failures; H.2 13/13 measured; Run All complete with existing checks PASS within observed ordinary scope. **No v4 placement was applied in this checkpoint.**
- Screenshot: blue quest rectangle overlaps existing top-right native-access dock, while original action clusters and player reaction frames occupy middle/lower-center. Native dock must be preserved and moved separately. Extra Bar4/5 stay accessible as satellite controls; no full-screen layout collision PASS yet.
- Historical P0194 R0 visual mismatch, R1 prewrite checker failure and R2 rejected slash-only UX preserved in P0194 patch memory. P0195 has not been deployed or proven at runtime. Special protected, vehicle, override, possess, form and petbattle remain environmentally deferred.

## Next Action

Apply/deploy P0195 and `/reload`. In Phase H → H.2 Map select Overlay ON, capture one uncropped full-screen blue/gold screenshot after the move; use Overlay OFF and Layout Check, then Phase 0 Run All. Confirm all action inputs including Bar4/5 remain clickable and native access remains available. If any Lua/taint/protected/secret error or visual collision occurs, preserve failure and correct before commit. **After user runtime approval and push verification**, finish H.2 visual assessment; H.3 is later.

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
