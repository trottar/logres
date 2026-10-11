---
memory_schema: 1
as_of: 2026-10-11
project: logres
---

# Current State

## Active Objective

**Phase H.1 OPEN — P0189 `0.0.101-dev` default Immersion ON secure Main ownership is a runtime candidate, not a PASS.** GitHub `main` baseline `a1e85e79a89917fa2c3b84b0cb738f1f13e68d37` verified with P0188 R1. P0187 R2 previously passed manual ON/OFF/ON/restoration in tested normal mode. P0189 uses that gate automatically at module enable only after conservative ordinary source readiness; explicit Main Replace OFF opts out until reload. User reports normal Main was the remaining unwanted persistent bar; 18 STOCK UI-ownership rows represent deliberate fallbacks, not 18 unwanted visible elements.

## Current Work Item

**P0189 automatic startup/runtime validation.** Install `0.0.101-dev`, deploy and `/reload` with Immersion ON. Without pressing ON, Phase D Main Replace Check must be CANDIDATE (`auto=true optOut=false`, applied/route true). Inspect Main visual and empty mouse region and use Logres Primary keys. Explicit OFF must restore native Main and persist through Immersion OFF/ON and developer lifecycle; explicit ON re-arms, Immersion OFF restores and ON re-engages. Edit Mode recovery and normal integrated Phase 0 Run All/UI Ownership should pass. On missing/unclassified/special startup source, fail open to stock with bounded native-event retry. Combat/vehicle/possess/pet-battle absent from environment remain DEFERRED, not PASS. Stop at any Lua/taint/protected/secret error.

## Verified State

- **P0188 R1 pushed and verified on `main` `a1e85e7` (docs-only).** The P0187 R2 `0.0.100-dev` manual normal secure Main gate is runtime accepted for tested scope: loadCount 238, repeat ON/OFF/ON succeeds, final Run All Main 7/6, `error=nil`, routing true/12, and UI Ownership 17 PASS/18 STOCK/0 FAIL. The UI Ownership `main_action` STOCK line is a policy/fallback designation, not physical presentation inspection.
- **P0189 candidate, not client-validated.** Startup automatic normal gate shares existing P0187 secure driver; OFF is a session opt-out and resets on reload. Initial unready/special source is stock-visible pending native events, not a hard diagnostic error; actual secure failure is still FAIL. No auto-default proof is claimed yet.
- **Preserved failures:** P0187 R0 ON/OFF/ON state reset bug; R1 delivery hash rejection; P0188 R0 prewrite whitespace failure. P0182 target-debuff filter miss, P0183 initial package error, P0178 Lua upvalues, P0175 nil rows, and intermittent post-loot ObjectiveTracker flash remain in history.
- Preserve special-mode native secure fallback, Blizzard pet/class/party/quest/aura/target-of-target, navigation dock, and other deliberate stock controls. Native override/vehicle/possess/bonus/form/petbattle transitions and combat recovery remain environmentally untested.

## Next Action

**P0189 runtime verification first.** Check fresh startup auto ON, OFF session opt-out, re-ON, Immersion and Edit Mode restoration, normal Primary actions and no hidden click surface, then Phase 0 integrated checks. Only checks actually run may be marked PASS. Naturally inaccessible special-state checks remain DEFERRED without contrived travel. If any error appears, preserve it and prepare narrow correction before H.1 advancement. H.2 layout and H.3 polish remain later.

## Success Criteria

The visually redundant normal Main presentation is absent when Logres has replacement coverage and present/usable when it does not, including special/override/vehicle/possess requirements. Routing, action execution/feedback, edit access, exact restoration, and interactions remain usable; no hidden clickable stock bar, protected-action, taint, Lua or secret-value failures. No assertion that all STOCK classifications are removed; the whole-screen integration/visual polish stage follows capability-safe H.1 closure.

## Do Not Reopen Without New Evidence

No exact player HP, conventional player health bar, enemy exact level/class/difficulty, secret-capable reads, broad stock UI suppression, polling or periodic forcing, or combat-unsafe protected mutation. PvP remains a modifier, not Immersion OFF. Keep class/pet, party/CompactParty, special actions, quest and on-demand native access, target-of-target, nameplates and private/group aura fallbacks until independently replacement-proven. The intermittent ObjectiveTracker flash remains OPEN / INTERMITTENT / UNREPRODUCED.

## Relevant References

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
