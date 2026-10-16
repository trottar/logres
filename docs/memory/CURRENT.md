---
memory_schema: 1
as_of: 2026-10-15
project: logres
---

# Current State

## Active Objective
Phase H.3 integrated visual fidelity. P0213 was verified pushed on `main` at `18dee5f`; user reports the compass contrast is fine but requires future work to follow the **twelve approved repo art sheets**, rather than piecemeal invented style values. Approved D-039 / D-040 design and D-045 v4 geometry remain authoritative. Tested pet suppression is closed for observed reload/Immersion/combat presentation, with other interactions unverified.

## Current Work Item
**P0214 approved sheet-03 action-media derivative candidate (`0.0.123-dev`, WoW visual UNVERIFIED).** Rebuild the five shared production TGA textures using the approved action-button state sheet as the visual source, preserving real Blizzard icon rendering, cooldown, key/count visuals, secure execution, 42px button geometry, 5px gap, shared pet treatment, and every current v4 semantic anchor. The original approved PNG remains unchanged. This is one coordinated visual-family replacement, not a new layout or gameplay feature. No action-bar scaling/position change is needed without client visual evidence; user has authorized limited scaling/placement later if template fidelity requires it.

## Verified State
- GitHub main `18dee5f71c2284ae5442a5db97a40594340b25a7` (P0213) independently verified on 2026-10-15.
- User states P0213 compass contrast is acceptable. Latest provided `LOGRES_DIAGNOSTICS_LATEST.lua` reports `0.0.122-dev` loadCount 280; final Phase 0 Run All completed with layoutcheck PASS, compasscheck PASS, no reported failure in that final ordinary-world run. This is not proof of all H.3 art fidelity or native interactions.
- Twelve exact approved designs under `docs/design/approved/` are canonical. P0116, P0120–P0137, P0200 already translated many primitives. Do not blindly recreate assets or reengineer source behavior without comparing present production art.
- P0211/P0212 user-confirmed pet presentation: native pet frame/action bar absent on Immersion-ON reload, returns OFF and absent ON, no duplicate in observed combat. Other pet interactions, some natural aura states and special modes remain UNVERIFIED/DEFERRED.
- P0214 static candidate has no WoW appearance, compositing, art alpha, or gameplay PASS until explicit in-client proof.

## Next Action
Apply the guarded P0214 asset-family patch against P0213. Deploy and compare shared action/pet frames with approved sheet 03 in-game at normal UI scale using **Phase C → Action Check / Feedback Test**, **Phase H → H.2 Map / Layout Check**, **Phase 0 → Run All**, and normal Immersion OFF/ON presentation. Review one real gameplay screenshot, then determine whether any **bounded** button sizing or cluster placement adjustment is actually needed to achieve D-039 and D-045. Preserve all 12 approved sheets unchanged. Record any visual regression as FAIL before further patches.

## Success Criteria
Approved frame/state language appears on main, secondary, utility, Bar 4–5 and shared pet buttons, icons remain dominant, state feedback clear (pressed stronger than hover), unchanged secure clicks/cooldowns/hotkeys and stock fallback, no clipping/orphan click regions, and zero newly observed Lua/taint/protected errors. Geometry and source boundaries remain unchanged. Missing natural states are DEFERRED.

## Do Not Reopen Without New Evidence
Do not touch the working pet visibility driver or protected action routing, manually hide native protected elements, inspect secret-capable state, use polling, remove stock fallback or alter v4 semantic positions speculatively. No new player exact HP, target exact danger/level, speculative aura source, or fictional compass marker. Visual media is not execution policy.

## Relevant References
- `docs/memory/evidence/P0214_APPROVED_ACTION_ASSET_FIDELITY.md`
- `docs/memory/patches/P0214_APPROVED_ACTION_ASSET_FIDELITY.md`
- `docs/design/approved/README.md`
- `docs/memory/decisions/D-039_APPROVED_VISUAL_BASELINE.md`
- `docs/memory/decisions/D-040_PRODUCTION_VISUAL_ASSET_TRANSLATION_CONTRACT.md`
- `docs/design/layout/SCREEN_MAP_V4.json`
- `docs/design/H3_APPROVED_ART_RUNTIME_FIDELITY.md`
- `docs/memory/evidence/P0213_H3_COMPASS_CONTRAST_EVIDENCE.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/memory/investigations/ACTIVE.md`
- `docs/ROADMAP.md`
