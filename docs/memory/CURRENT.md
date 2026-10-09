---
memory_schema: 1
as_of: 2026-10-09
project: logres
---

# Current State

## Active Objective

**Phase H.1 OPEN — remove the last user-reported redundant persistent stock action-bar presentation: the normal Blizzard `MainActionBar`.** GitHub `main` **`4e999b1445d784378f8a6030f8f9dc737cb9e985`** has P0184 docs-only acceptance of P0183 R1. Runtime remains **`0.0.98-dev`**. The user reports that **only the Main action bar remains to remove** from the intended ordinary Immersion ON screen. Treat this as user visual scope, **not** as a claim that all other Blizzard-owned fallback/information/control surfaces have disappeared or can be suppressed.

## Current Work Item

**Next implementation: normal-mode MainActionBar visual/interactivity ownership with proven secure routing, existing editing access, special-mode fallback and exact restoration.** Source-backed minimum coherent capability: Logres Primary actions, usable normal-page key routing/feedback, drag/edit/bind access or deliberate accessible stock editing fallback, out-of-combat activation, and seamless fail-open to Blizzard Main/Override/vehicle/possess/extra actions whenever Logres does not safely own a mode. The stock Main must not become an invisible clickable region. Do **not** conflate normal Main suppression with ownership of special actions; preserve special UI. Investigate exact native source/transition semantics before mutation and use a targeted panel regression, not another broad audit or unrelated aura work.

## Verified State

- **P0184 pushed and verified on GitHub `main` `4e999b1`.** P0183 R1 native harmful Logres icons are visually present per user, with native containers `ready=true active=true` in `LOGRES_DIAGNOSTICS_LATEST.lua` loadCount **234**. Phase 0 **Run All complete**, 35-row UI Ownership Immersion ON **17 PASS / 18 STOCK / 0 FAIL / 0 DEFERRED**, no reported Lua/command error in that latest run. The 18 STOCK entries are **deliberately retained policy surfaces, not a list of 18 visible unwanted bars**, and are often marked `not inspected`.
- Existing Logres Secondary/Utility Bars 2–3 are replacement-owned; Bars 4–5 routing and intentionally retained stock access have their own documented policy. Native dock folds navigation, objectives, XP/progress and micro-menu with on-demand Blizzard access; cast native fallback remains available. Quiet chat, Player/Target shell, and relevant Logres HUD surfaces are exercised. The only user-reported **remaining unwanted persistent normal-screen bar** is Main; that narrower visual statement does **not** override deliberate pet, class-resource, party, quest, target-of-target, boss/focus, private/group aura or special-control retention.
- `Logres/Actions/Primary.lua` explicitly reports `stockSuppressionAuthorized=false`, `specialPagingCoverage=normal-pages-only` and `stockPreserved=true`. UI ownership row `main_action` remains STOCK and `special_actions` remains STOCK. Existing read-only normal-page evidence **does not** authorize a Main hide. D-023/D-044 govern combat/special/edit/restoration. Secure state must be capability-gated and fail open; no blanket frame hiding.
- Debuff functionality **accepted for visually observed appearance only** (P0183 R1/P0184); defer styling to whole-screen Phase H polish. Blizzard aura presentation still serves completeness fallback; no runtime proof for every separate player/hostile-target state or all combat transitions.
- Preserve P0182 failed filter-only attempt, first P0183 ZIP's prewrite `__pycache__` hash-manifest failure and R1 repair, original P0178 >60-upvalue startup FAIL, P0175 R2 nil-row FAIL, and the intermittent post-loot ObjectiveTracker flash (OPEN / INTERMITTENT / UNREPRODUCED).

## Next Action

**P0185 is a documentation-only memory consistency checkpoint** against verified `4e999b1`; no runtime change or WoW retest. After push verification, proceed **directly to the narrow MainActionBar implementation**. Validate actual normal-screen Main disappearance **and no invisible stock click region**, functional Logres Primary normal-page input/edit access, special-mode and combat fail-open/restoration when naturally available, and Immersion OFF recovery. Use the developer panel (Phase 0 **Run All**, **UI Ownership Check**, and corresponding action/ownership controls) for available checks; do not demand redundant reruns of P0183. Do not manufacture rare gameplay to prove environmentally absent special modes.

## Success Criteria

The visually redundant normal Main presentation is absent when Logres has replacement coverage and present/usable when it does not, including special/override/vehicle/possess requirements. Routing, action execution/feedback, edit access, exact restoration, and interactions remain usable; no hidden clickable stock bar, protected-action, taint, Lua or secret-value failures. No assertion that all STOCK classifications are removed; the whole-screen integration/visual polish stage follows capability-safe H.1 closure.

## Do Not Reopen Without New Evidence

No exact player HP, conventional player health bar, enemy exact level/class/difficulty, secret-capable reads, broad stock UI suppression, polling or periodic forcing, or combat-unsafe protected mutation. PvP remains a modifier, not Immersion OFF. Keep class/pet, party/CompactParty, special actions, quest and on-demand native access, target-of-target, nameplates and private/group aura fallbacks until independently replacement-proven. The intermittent ObjectiveTracker flash remains OPEN / INTERMITTENT / UNREPRODUCED.

## Relevant References

- `docs/memory/patches/P0185_MAIN_BAR_MEMORY_RECONCILIATION.md`
- `docs/memory/evidence/P0185_MAIN_BAR_MEMORY_AUDIT_2026-10-09.md`
- `docs/memory/patches/P0184_ACCEPT_P0183_RUNTIME.md`
- `docs/memory/evidence/P0184_ACCEPT_P0183_RUNTIME_2026-10-09.md`
- `docs/memory/decisions/D-023_SELECTIVE_STOCK_ACTION_REPLACEMENT.md`
- `docs/memory/decisions/D-044_CLASS_PET_SPECIAL_CONTROL_SOURCE_AND_FALLBACK_POLICY.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/memory/investigations/ACTIVE.md`
- `docs/ROADMAP.md`
