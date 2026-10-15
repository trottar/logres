# P0209 R3 — Native pet-action button reuse runtime candidate

Status: PREPARED / RUNTIME UNVERIFIED (2026-10-14). Do not commit until actual user validation; user's explicit instruction is **NO PUSH**.

## P0209 R2 runtime failure (preserved)

R0 prewrite memory-schema FAIL; R1 prewrite 61/60 handleCommand captured-local FAIL. R2 applied and loaded as `0.0.114-dev`, loadCount 269. User observed driver ON hides Blizzard PetActionBar outside combat, but in combat **Logres pet bar disappears and Blizzard native bar returns**. P0209 R2 code explicitly specified native `[combat] show; hide` and Logres `[combat] hide; show`; observed behavior is the programmed reciprocal fallback but violates product intent. `petbardriver` diagnostics track driver registration, not native secure click/visibility proof. No push; P0208 `f6b9a3a58bfc9081043455038df33b706c6e9e6f` remains HEAD. PetFrame still stock. Do not classify P0197 resolved.

## Upstream solutions read, not copied

Bartender4 `Nevcairiel/Bartender4` master `PetBar.lua` and `PetButton.lua` implement a stable replacement pet-action bar with 10 `PetActionButtonTemplate` buttons, event feedback and bindings; `HideBlizzard.lua` suppresses native frames at setup (including parent redirection and event removal), not a combat swap. Its persistent hidden-parent approach is unsuitable for Logres's required reversible restoration and previously failed P0206 protected lifecycle.

Dominos `tullamods/dominos` main `Dominos/bars/petBar.lua` uses native `PetActionBar.actionButtons[index]` or `_G['PetActionButton'..index]`, with `OnFirstLoad` relocating the stock container to a `ShadowUIParent`; maintains native pet-button execution without a combat swap. Dominos's own `PetBar:AcquireButton` reparents secure buttons into an addon bar. P0209 R3 borrows **single native button ownership**, not the potentially unsafe hidden-parent / protected child reparent operations. Primary references:
- https://github.com/tullamods/dominos/blob/main/Dominos/bars/petBar.lua
- https://github.com/Nevcairiel/Bartender4/blob/master/PetBar.lua
- https://github.com/Nevcairiel/Bartender4/blob/master/HideBlizzard.lua

## R3 hypothesis, exact scope

Keep *Blizzard's entire existing PetActionBar* with its **original secure buttons** intact. Out of combat and only after an explicit Phase H ON command, capture `PetActionBar:GetPoint(1)` solely as an opaque restoration token and re-anchor `PetActionBar` to the existing Logres `classPet` anchor. Turn off only the pre-existing Logres `PetActionExecutionProbe` cluster to avoid duplicated controls. There is no new pet-action button, no `[combat]` state driver, no parent change, no native stock `Hide`/`Show`, no polling or OnShow reassertion, and no stock click-region suppression. Native bar visibility, pet ability execution, dragging and binding remain Blizzard's own. Combat leaves both placement and secure buttons undisturbed. Immersion OFF, explicit OFF, PET STOCK, and EditMode.Enter request out-of-combat anchor restoration. Guard the probe against auto-rearming while trial owns presentation. Preserve PetFrame and P0206 quarantine, H2 layout and all 18 Phase H controls.

Unlike Dominos, this **does not reparent secure native children** and so may render a larger stock-art bar rather than the final Logres art. This is a controlled ownership and restoration test, not visual polish.

## Security / uncertainty

Blizzard PetActionBar is an Edit Mode system with protected frame layout, and the client may reject out-of-combat manual reanchoring, reassert Edit Mode geometry later, or taint on anchor restoration. These are not resolved by source reasoning. Do **not** inspect/compare/format/count secret-capable Blizzard anchor values. The five results from `GetPoint(1)` are saved only as an opaque token and handed directly to `SetPoint()` on restoration. R3 assumes one primary stock anchor on this client; changing Edit Mode layouts during trial is not approved. Any Lua/taint/protected error or failed stock restoration marks RUNTIME FAIL, not PASS.

## Runtime acceptance gate

After deploy + `/reload`, check P0209 trial default OFF. With pet active and no combat, ON must leave one *native-button* bar at Logres classPet location, not Logres's duplicate action probe. Verify secure pet actions/autocast and native drag or bindings only when safe; in naturally occurring combat confirm **same native bar remains**, without flipping to the old stock location or emptying. OFF should restore Blizzard's original position and usable buttons. Check Immersion OFF/ON, native PET STOCK, Edit Mode after OFF, BugCatcher. Do not manufacture combat. Evidence status remains RUNTIME UNVERIFIED until user confirms each tested dimension.

## P0209 R3 actual runtime outcome (2026-10-14)

**P0209 R4 local corrective / UNVERIFIED (2026-10-14):** P0209 R3 (`0.0.115-dev`, loadCounts 270–271) **RUNTIME FAIL — activation never armed**. Repeated `/logres petbardriver on` rejected `editmode-unavailable-or-active`, `requested=false armed=false activations=0`, including after `/reload` and outside combat. The guard required an initialized `EditModeManagerFrame`; that Blizzard_EditMode frame can be absent when the manager is not loaded, which also means its Edit Mode is not active. R4 treats ONLY an absent manager as inactive; a loaded manager still must explicitly and ordinarily report inactive. No native pet move has yet been runtime proven. Evidence: `docs/memory/evidence/P0209_R4_EDITMODE_GATE_EVIDENCE.md`. Keep P0209 R0/R1 static failures, R2 swap failure and P0206/P0197 failures OPEN. No push.
