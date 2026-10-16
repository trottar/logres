---
memory_schema: 1
as_of: 2026-10-16
project: logres
---

# Current State

## Active Objective
Phase H.3 implementation of the twelve approved visual sheets under `docs/design/approved/`, within frozen D-039 and v4 D-045 layout. GitHub `main` P0217 `b841afa39ca15edfad12ac8f675efcb80acd0df6` verified. User confirms P0217 dock and sparse unit presentation function and look as expected; P0214–P0217 observed visual work is accepted within tested scope, with optional final refinement deferred.

## Current Work Item
**P0218** `0.0.127-dev` presentation-only H.3 sheet-04 compact StatusAuras candidate. Reuse the existing approved aura count-plate TGA behind true stack counts, and show a thin warm rail only for already classified urgent visible addon-owned status icons. Preserve native WoW icons, established icon bounds/ordering, existing status source/read/tooltip safety, the secure NativeDebuffs renderer, Blizzard aura fallback, and original player-helpful presentation. No new source, gameplay decision, suppression, v4 geometry or polling.

## Verified State
- GitHub main `b841afa` P0217 verified. `0.0.126-dev` loadCount 287 latest ordinary world Run All completes, 13/13 v4 measured, native access/action/stock/restoration PASS and 17 ownership PASS/18 intentionally STOCK/0 FAIL; user confirms P0217 tested appearance and interaction. No obvious new regression in that scope.
- Native harmful renderer remains active, but real populated harmful-icon membership and multi-effect display remain environmentally unverified. Latest source has target helpful positive evidence; do not conflate this with harmful coverage. Old combat-time and pet failure evidence remains preserved.
- P0218 has no WoW proof until user performs panel previews and tests. This is a controlled visual translation, not completion of the whole UI.

## Next Action
Apply guarded P0218 atop exact verified P0217 HEAD, run all repository static checkers against the prepared shadow, deploy, `/reload`. Developer panel Phase D Status Aura Preview ON/OFF and Status Aura Check, Phase H Native Access Check and Layout Check, Phase 0 Run All. Compare passive, harmful, urgent and 2+ stack plate legibility; ensure preview OFF restores live/stock presentation, and check for errors. If there is no naturally populated harmful unit, record DEFERRED instead of PASS. Do not force or inspect restricted aura sources.

## Success Criteria
- Status visual stack count has a restrained readable approved plate only when an ordinary count greater than one is supplied; no misleading permanent plate.
- Urgent icon distinction is visually legible through existing frame tint/marker and a narrow warm rule without obscuring native icon or changing classification.
- All action/pet/native fallback behavior preserved, no new LUA/taint/secret errors in tested ordinary world; source-restricted live harmful states deferred.

## Do Not Reopen Without New Evidence
No changes to approved action/quest/resource/navigational placement, secure pet driver, native stock controls, PlayerHelpfulAuras look, native harmful member transport, aura source/priority decisions, tooltip protected gates, or exact health/level policy. No assumptions that static checks or preview prove all restricted live states.

## Relevant References
- `docs/memory/evidence/P0218_H3_AURA_STATE_PLATES.md`
- `docs/memory/patches/P0218_H3_AURA_STATE_PLATES.md`
- `docs/design/approved/04_status_aura_icon_primitive.png`
- `docs/memory/decisions/D-039_APPROVED_VISUAL_BASELINE.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/memory/evidence/P0217_H3_NATIVE_DOCK_TARGET_ALLY_ART.md`
