---
memory_schema: 1
as_of: 2026-10-10
project: logres
---

# Current State

## Active Objective

**Phase H.1 OPEN — P0187 R2 (`0.0.100-dev`) accepted for manual/session-only normal Main replacement and exact ON/OFF/ON re-arm; persistent startup/special fallback still gated.** Verified remote `main` is `41c7d972d8bd32537ccd4a956f85617a081d27b7`. The normal Blizzard `MainActionBar` is the user's only reported unwanted persistent normal-screen bar. All other intentionally retained Blizzard information/control fallback surfaces remain policy-owned; 18 STOCK matrix rows do **not** mean 18 unwanted visible bars.

## Current Work Item

**P0188 docs-only acceptance of P0187 R2 normal-mode runtime, followed by P0189 automatic-ownership gate.** Uploaded loadCount 238 diagnostic shows fresh STOCK; ON CANDIDATE → OFF STOCK → ON CANDIDATE → OFF STOCK, plus an idempotent duplicate ON. Integrated Phase 0 Run All reports activations=7/restores=6, error=nil, Primary keys=true/12, and 35 ownership rows 17 PASS/18 STOCK/0 FAIL/0 DEFERRED. User reports it worked as expected. This validates tested normal-mode manual execution, not special-state/combat behavior or persistent default. Existing `main_action` remains STOCK in the read-only policy audit.

## Verified State

- **P0187 R2 pushed/verified `41c7d97`, `0.0.100-dev`, manual normal-mode runtime ACCEPTED for observed scope.** Fresh start STOCK; repeated ON/OFF/ON works, no error in supplied final diagnostics; native secure re-arm R0 failure no longer reproduces. User confirms visual behavior. See P0188 evidence.
- **P0187 R0 FAIL preserved:** first OFF succeeded but repeat ON failed `secure normal mode gate not established`. **P0187 R1 original delivery FAIL preserved:** checker baseline mismatch before writes; R2 packaging corrected it. Do not erase either failure.
- **P0184 pushed/verified `4e999b1`:** P0183 R1 native Logres harmful icons visually accepted; aura completion fallbacks remain stock. Prior stock Bar 2–3 replacement, stock on-demand dock, HUD, Quiet Mode, player/target shell, pet/class/party/special-control policies remain unchanged.
- The 35-row UI Ownership audit is **policy classification**: P0187 candidate Main remains `STOCK` in that audit, not a physical Main visibility check. The final Run All shows 17 PASS/18 STOCK/0 FAIL.
- Native vehicle/override/possess/bonus/form/pet-battle transitions and combat-time recovery are **ENVIRONMENTALLY DEFERRED**, not tested PASS. Edit Mode/mouse-region proof is limited to user-reported normal-screen success; separate instrumented proof is absent. P0187 still manual and OFF after reload.
- Retain P0182 ineffective filter-only attempt, initial P0183 ZIP `__pycache__` failure, P0178 Lua upvalue FAIL, P0175 R2 nil-row FAIL, and intermittent post-loot ObjectiveTracker flash as historical/open evidence.

## Next Action

**P0189 runtime startup/default activation integration gate**, not another manual re-arm investigation: implement deliberate, opt-out-capable normal Immersion ON arming after Primary/stock readiness; preserve native special-mode and protected combat fallback via secure driver, exact restoration before relinquishing Logres input, and explicit OFF/Edit Mode recovery. Avoid blindly arming during unresolved/special startup or relying on forced gameplay for proof. Add a targeted static contract, then bounded WoW validation of fresh reload, OFF/ON, Primary execution, and naturally available special transitions. Leave special unavailable cases DEFERRED and H.1 OPEN until default behavior is proven. H.2 authored placement and H.3 whole-screen polish follow.

## Success Criteria

The visually redundant normal Main presentation is absent when Logres has replacement coverage and present/usable when it does not, including special/override/vehicle/possess requirements. Routing, action execution/feedback, edit access, exact restoration, and interactions remain usable; no hidden clickable stock bar, protected-action, taint, Lua or secret-value failures. No assertion that all STOCK classifications are removed; the whole-screen integration/visual polish stage follows capability-safe H.1 closure.

## Do Not Reopen Without New Evidence

No exact player HP, conventional player health bar, enemy exact level/class/difficulty, secret-capable reads, broad stock UI suppression, polling or periodic forcing, or combat-unsafe protected mutation. PvP remains a modifier, not Immersion OFF. Keep class/pet, party/CompactParty, special actions, quest and on-demand native access, target-of-target, nameplates and private/group aura fallbacks until independently replacement-proven. The intermittent ObjectiveTracker flash remains OPEN / INTERMITTENT / UNREPRODUCED.

## Relevant References

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
