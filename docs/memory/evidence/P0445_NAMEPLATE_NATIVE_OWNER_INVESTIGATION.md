# P0445 — Native nameplate visual ownership investigation (docs-only)

Date: 2026-11-11. Verified GitHub main `2281af2b8480c8aef7443006ce115dcdeec5f7bd`, P0444 / `0.0.315-dev`; author kit Git tree `d6872f57fc184ec5d60adeb7c53ba03111d5ffa4`. L-011 PARTIAL; D-042 remains ACCEPTED. **No new Forever capture was supplied with P0445.** This records a source/evidence investigation, not P0444 visual PASS or a new runtime change.

## Observed versus inferred

- Forever P0442 session 106 incidents #11479–11485 established two combat attachments, two detachments, and zero recorded attachment failures; screenshots show **Blizzard's yellow name/health/border/level and Logres's red name/health at the same location**. This is native-visual overlap (VISUAL FAIL), not attachment failure. See P0443 evidence.
- P0443's guessed opaque 208x44 owned rectangle was visually rejected as a black background while Blizzard's plate was still visible (VISUAL FAIL). P0444 removed the rectangle and backing gate; its transparency in Forever is **UNVERIFIED** pending Report Bug > H capture. Do not retry matte/mask/black box.
- Current `Logres/HUD/HUD.lua`: `BuildLiveWorldEnemy()` creates a mouse-disabled, noninteractive 198x54 addon-owned frame at 100% size/alpha and without a `BACKGROUND` texture. `RefreshLiveWorldEnemy()` anchors it to the accessible native plate's `CENTER` and updates only owned name, HP percentage, and ordinary aura lanes. `WorldTargetProbe:AcquireLiveEnemyTargetAnchor()` gates selected-hostile, attackable, non-forbidden, not-behind-camera anchors. Native nameplate visuals are **not replaced** by this operation. The inference that co-location causes overlapping drawings follows from the source plus the P0442 screenshot; it does not require native child inspection.
- Selected target icon spacing is still +/-25px. The 50% size/opacity secondary is synthetic only and requires independently confirmed aggro, not `UnitIsUnit(nameplate.."target", "player")` or player-targeting event counts.

## Ownership candidates and blockers

| Approach | Assessment at P0444 | Gate |
| --- | --- | --- |
| Cover native with an owned opaque rectangle | Rejected P0443 visual FAIL; violates full transparency | CLOSED; do not repeat |
| Hide the entire native plate / disable its nameplate CVar | Removes or jeopardizes the approved anchor and Blizzard targeting/fallback | NOT AUTHORIZED under D-042 |
| Move owned display away from native plate | Avoids an exact collision, but leaves two independent name/health presentations; P0441 did this | Not a duplicate removal |
| Make the native UnitFrame transparent | Third-party pattern, **not proved safe in this Forever build**; may affect hit testing, cast/status/auras, native updates, taint, or restoration | DEFERRED; no call to `SetAlpha`/`Hide` |
| Suppress only specifically identified decorative native regions | Potential future capability-gated owner transfer, but current project has no verified child owner, safe mutation contract, or restoration proof | DEFERRED; requires first-party exact-build source review, isolated safe test, and D-042 decision |

External research leads **only**, not direct Forever proof: `https://github.com/xIGBClutchIx/ForeverPlusPlus/blob/main/docs/forever-api.md` documents a 2026-09-26 native `UnitFrame` containing `HealthBarsContainer`, `name`, `LevelFrame`, `CastBarsContainer`, `AurasFrame` and hit/selection surfaces. `https://www.curseforge.com/wow/addons/forever-combat-text/files/9107445` reports taint/protected-region failures after touching native nameplate presentation, motivating safe nonmutation. `https://www.curseforge.com/wow/addons/clearviewforever` describes visual transparency but explicitly leaves some 3D selected-name visuals unresolved; its optional clickability language is not Logres acceptance. Retail 12.0 `UnitFrame:SetAlpha(0)` advice must not be transplanted as a Forever guarantee. Study techniques without copying others' licensed code.

## Exact next evidence and implementation boundary

1. **First finish P0444 Forever** through right-click Report Bug > H > World Enemy ON outside combat, combat hostile selection, target change and nameplate removal, status, left-click Report Bug, OFF, `/reload`, then `python3 tools/export_panel_diagnostics.py`. Capture selected HP/name/aura opacity, +/-25px spacing, transparent backing, visible native duplicate, native click targeting, cast/status cues, and failures separately. Lua, taint or protected error is FAIL, never a deferral.
2. Inspect first-party **same-build Forever** Blizzard nameplate creation/layout and click owner offline (without probing private/secret live values); distinguish actual native 2D name/HP/level visuals, independent 3D names, hit-test, casts, auras, and target selection. Third-party add-on field lists are leads, not authority.
3. Author a distinct, explicit D-042 amendment only if a *reversible* native-visual transfer is supportable. A future opt-in trial must preserve stock hit/click owner, required cast/aura/status, restoration on OFF, target change, disable, nameplate removal and any failure, and stock fallback when any capability is unknown. Any secret-capable restoration value may only be passed opaquely to its native setter, never compared or logged. No child mutation, alpha hooks, polling/reassertion, CVar forcing, or broad suppression is authorized by this investigation.
4. Do not promote secondary 50% display on the basis of event-time targeting. Confirm independent per-unit aggro and safe attach/detach before a separate change.

**Author negative evidence:** R0 author-check REFUSED 278/308 solely because the handoff title exceeded the historic 8000-byte limit and omitted the canonical issue-ledger path. R1 repaired the handoff but targeted checks REFUSED 32/34 because the active CURRENT checkpoint was P0445 while four protected roadmap headings must still start P0444. R2 restores P0444 as active and keeps P0445 as docs-only evidence without weakening checkers. Final author-check result is separately required. No user/remote writes.

**Disposition:** P0445 is documentation/analysis only. No runtime code, settings, visuals, saved variables, native control, attachment lifecycle or diagnostic behavior changed. L-011 PARTIAL / native duplicate OPEN; P0444 Forever UNVERIFIED. Continue from an actual P0444 client capture and an exact-build ownership contract, not from a guessed masking geometry.
