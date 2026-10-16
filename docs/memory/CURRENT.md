---
memory_schema: 1
as_of: 2026-10-15
project: logres
---

# Current State

## Active Objective
**Phase H.3 approved art/interaction polish.** P0211/P0212 are remotely verified in GitHub main at `018ea0a` on 2026-10-15. The observed pet-visibility duplication defect is closed for user-tested reload, Immersion OFF/ON, and combat presentation. No additional pet suppression experiment is authorized absent new evidence. H.3 retains D-039 art, D-045 v4 geometry, and all protected/stock fallbacks.

## Current Work Item
**P0213 H.3 compass bright-background legibility candidate (`0.0.122-dev`, runtime UNTESTED).** P0202 real-client screenshot observed faint compass letters/ticks against pale sky. This scoped change brightens only label colors and adds Theme-driven dark text shadows to existing direction FontStrings. Tick assets/positions, bearings, fade, marker/data sources, frame geometry, action/pet controls, native access and secret-safe calculations are unchanged. No work on unproven action empty-state occupancy until a safe specific source/visual need is established.

## Verified State
- GitHub main verified on 2026-10-15: `018ea0aefd93ffb266e6333e5301a3ce8e443e22`, P0212 including P0211 runtime and evidence. P0211 is durable.
- Pet user visual PASS in bounded scope: Immersion-ON reload no Blizzard PetFrame/PetActionBar, OFF restores, ON hides, observed combat no duplicates. `0.0.121-dev` loadCount 279 showed driver armed/pending false/failures zero, startup first arm triggered by pet-probe-armed. Pet secure clicks/autocast, PET STOCK interaction, Edit Mode exit and BugCatcher remain UNVERIFIED.
- P0202 screenshot visually observed faint top-center compass against bright sky, supporting a narrow readability candidate, not a proven fix. P0200 H.3 native harmful aura art already exists; naturally populated multi-aura fit remains environmentally DEFERRED.
- Historical P0197/P0206/P0209 prewrite, protected and combat defects remain preserved in evidence. Current pet visibility should not be modified without a new reproduced failure.

## Next Action
Apply P0213 against exact P0212 HEAD. Full prewrite static checker suite and optional Lua syntax gate must pass. Deploy to WoW and use **developer panel Phase E → Compass Check** and **Phase H → H.2 Map → Layout Check / Overlay OFF/ON**, plus **Phase 0 → Run All**; visually compare legibility over light and dark world backgrounds. Record screenshot and diagnostics. Confirm no layout, pet, source or marker regression; classify unobserved manual waypoint/depth states DEFERRED. This is not a visual PASS until user confirms.

## Success Criteria
Readable compass direction labels over both bright and dark backgrounds, preserved quiet navigation hierarchy, unchanged v4 map/layout and secure interaction/fallback surfaces, no Lua/taint/protected errors, and no invented marker source or player exact HP. Panel results and user visual observation establish scope; static PASS alone does not.

## Do Not Reopen Without New Evidence
No pet visibility driver change, protected manual Hide/Show, native hidden-parent/reparent, combat-time protected mutation, polling, source/secret inspection, or removal of Blizzard fallbacks. Preserve all D-039 visuals beyond the compass label polish, D-045 geometry, H.3 authored helpful aura art, exact player HP omission and intentionally sparse target data. Bartender4/Dominos are reference implementations for future protected/action-bar work, not dependencies. Developer panel remains default validation.

## Relevant References
- `docs/memory/evidence/P0213_H3_COMPASS_CONTRAST_EVIDENCE.md`
- `docs/memory/patches/P0213_H3_COMPASS_CONTRAST.md`
- `docs/memory/evidence/P0212_PET_ACCEPTANCE_AND_WORKFLOW.md`
- `docs/memory/evidence/P0211_PET_STARTUP_RECONCILIATION.md`
- `docs/memory/evidence/P0202_H3_SCREENSHOT_VISUAL_EVIDENCE.md`
- `docs/design/H3_APPROVED_ART_RUNTIME_FIDELITY.md`
- `docs/memory/decisions/D-039_APPROVED_VISUAL_BASELINE.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/memory/investigations/ACTIVE.md`
- `docs/ROADMAP.md`
