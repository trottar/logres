# P0207 — Full native pet-frame / pet-action lifecycle audit (2026-10-13)

Status: **DOCS ONLY / SOURCE + USER-DIAGNOSTIC EVIDENCE.** No runtime fix is accepted here. Last verified pushed Logres `main`: `79a8e2308a37135b61db8ad8a0433cae5ec8b4bd` (P0205). The user's **uncommitted** P0206 R6 candidate was running Logres `0.0.112-dev`; this record is prepared over that state, not a claim R6 was pushed. WoW Forever client `1.60.1.70338`, interface `16001`, diagnostics loadCount 265. Exact upstream source tree: `Gethe/wow-ui-source@943764493e6b16d63ded3ab304150d1f05e58b57`.

## Definition: two independent Blizzard surfaces

| Surface | Exact upstream XML and runtime owner | Source-driven presentation | Logres current treatment / diagnosis |
| --- | --- | --- | --- |
| `PetFrame` unit portrait / health / mana / pet contextual interaction | `Blizzard_UnitFrame/Mainline/PetFrame.xml`: secure clickable `PetFrame` under `PlayerFrame`, inherits `PlayerBottomManagedFrameTemplate, SecureUnitButtonTemplate, EditModePetFrameSystemTemplate`; contains health/mana, auras/happiness and secure PET menu | `PetFrameMixin:UpdateShownState()` uses `self.isInEditMode` **or** `UnitIsVisible(self.unit) and PetUsesPetFrame() and not PlayerFrame.vehicleHidesPet`. Updated on pet/vehicle events; Edit Mode `RefreshPetFrame()` calls `UpdateShownState()`. | **Still forcibly folded by Logres R6.** `NativeSurfaceReplacement:Ready("petFrame")` accepts an HUD ally/pet row plus secure target/menu overlay as sufficient. That is **not proof of complete native unit-frame information and interaction replacement**. |
| `PetActionBar` 10 pet abilities / secure clicks | `Blizzard_ActionBar/Mainline/PetActionBar.xml`: interactive Edit Mode-owned `UIParent` root with 10 secure pet buttons | `PetActionBarMixin:OnLoad` and `OnEvent` explicitly call `Show()` when native pet action conditions hold, and `Hide()` otherwise. Edit Mode `SetupActionBar` snapshots native shown-state; its checkbox can force `Show()`, exit can reset earlier shown-state. | P0206 R6 adds `if key == "petActions" then return false end` in `Native:Ready`, so **no new native action fold is requested**, but `petActions:stock` only means **no Logres fold snapshot**. It is **not a visibility or clickability observation**. |

**Important parent nuance:** `PlayerFrameReplacement:SuppressStock` alters **`PlayerFrameContainer` and `PlayerFrameContentMain`** alpha and mouse behavior at PlayerFrame root; it does **not** Hide/SetAlpha(0) the whole `PlayerFrame` parent. Therefore PetFrame's XML parenthood alone does not establish that this module hides the pet portrait. Evaluate child ownership and secure click separately; do not attribute the disappearance to parent alpha without evidence.

## Exact source references

- [PetFrame.lua](https://github.com/Gethe/wow-ui-source/blob/943764493e6b16d63ded3ab304150d1f05e58b57/Interface/AddOns/Blizzard_UnitFrame/Mainline/PetFrame.lua) — `PetFrameMixin:UpdateShownState`, `OnEvent`, `OnShow`, secure popup.
- [PetFrame.xml](https://github.com/Gethe/wow-ui-source/blob/943764493e6b16d63ded3ab304150d1f05e58b57/Interface/AddOns/Blizzard_UnitFrame/Mainline/PetFrame.xml) — exact parent, templates, pet health/resource and interaction children.
- [PetActionBar.lua](https://github.com/Gethe/wow-ui-source/blob/943764493e6b16d63ded3ab304150d1f05e58b57/Interface/AddOns/Blizzard_ActionBar/Shared/PetActionBar.lua) and [PetActionBar.xml](https://github.com/Gethe/wow-ui-source/blob/943764493e6b16d63ded3ab304150d1f05e58b57/Interface/AddOns/Blizzard_ActionBar/Mainline/PetActionBar.xml) — native pet event-driven Show/Hide and secure action buttons.
- [EditModeManager.lua](https://github.com/Gethe/wow-ui-source/blob/943764493e6b16d63ded3ab304150d1f05e58b57/Interface/AddOns/Blizzard_EditMode/Shared/EditModeManager.lua) — `SetupActionBar`/`RefreshActionBarShown`/`ResetActionBarShown`; `SetupPetFrame`/`RefreshPetFrame`.
- Logres `Logres/Immersion/NativeSurfaceReplacement.lua` at pushed main blob `88a32b492603bbeaac155c89bc3960ae2a298743`, with P0206 R6 uncommitted guard on `petActions`; `Logres/Immersion/PlayerFrameReplacement.lua` at pushed blob `780133009bcc45e6406daf465dc40ce08d987242`.

## Observed runtime evidence — exact limits

User-uploaded `LOGRES_DIAGNOSTICS_LATEST.lua`: `LogresDB.meta.loadCount=265`, interface 16001/build 70338. At loadCount **265**, R6 `0.0.112-dev` (`nativeuicheck` after Immersion OFF then ON): `native-surfaces: CANDIDATE desired=true folded=3 petInteraction=true folds=6 restores=3 pending=false surfaces=petFrame:folded petActions:stock playerBuffs:folded targetAuras:folded`; `petcombat: QUARANTINED requested=false armed=false`; pet action `onShow=0`. At later Run All, `folds=15 restores=12` with same pet surface categories. This verifies only **Logres-owned snapshot and event counters**. It does not prove native IsShown/click hit-testing; do not inspect protected Blizzard presentation state to fill this gap.

The `immersion off` and `immersion on` command acknowledgments appear in the same loadCount 265 trace, but **there is no native-surfaces diagnostic captured while Immersion was OFF** in that run. The subsequent `uiownershipcheck` has `pet_frame: STOCK` and `pet_actions: STOCK`, **both `observed=not inspected`**; its PASS is a policy result, not a visible-native PASS.

User repeatedly reports **Blizzard pet frame/bar intermittently absent**, including Immersion OFF; entering Edit Mode and clicking the separate dock **PET** control have at times made native surfaces reappear, followed by another disappearance. Precisely which one of the two Blizzard frames returned in each report, whether Edit Mode exit kept it visible, and what independent native pet event preceded each transition remain **UNATTRIBUTED**. Edit Mode source explains a temporary force-show *mechanism*; it does not prove the particular causal event from user reports. The PET control toggles both native pet domains through `manual.pet`, which is session state, but post-toggle native visibility was not captured.

Prior P0197 loadCount 260 established **combat duplication FAIL / REPRODUCED** and **one post-combat refold PASS**; it did not demonstrate safe native stock restore. P0206 R2 hidden-ancestor trial suppressed the visible duplicate, but Immersion OFF native controls did not return and BugCatcher reported a protected-function error without a stack identifying the exact action. Do not infer the exact taint source.

## Source-constrained failure mechanisms

1. **Confirmed policy defect — incomplete PetFrame ownership:** P0206 R6 prevented future **PetActionBar** folding, not **PetFrame** folding. PetFrame remains intentionally hidden in ordinary Immersion ON although a small HUD pet hint and secure target/menu overlay do not cover all Blizzard pet unit information, resource, auras, happiness, and interaction. This fails the project's stock-fallback rule. **OPEN / ACTIONABLE**.
2. **Confirmed restoration design weakness — stale shown token:** `Native:Fold` captures `frame:IsShown()` **opaquely** before Hide; `Native:Restore` subsequently passes that same value to native `SetShown`. This is an allowed opaque token mechanism, but the initial value can be stale relative to a later pet summon/vehicle transition or Blizzard visibility update. `pcall(SetShown)` succeeding is **not evidence of correct current PetFrame visibility**. **OPEN / NEEDS OWNER-DRIVEN RESTORATION**. Do not branch on or inspect that secret-capable token.
3. **Independent Blizzard visibility conditions:** `PetFrame:UpdateShownState()` depends on pet visibility, `PetUsesPetFrame()`, vehicle state and Edit Mode. `PetActionBar` depends on `PetHasActionBar()` and `UnitIsVisible("pet")`; these are not equivalent predicates. A pet can legitimately cause one surface to differ from the other. **NOT A BUG WITHOUT CONTEXT**.
4. **Edit Mode is not a persistent stock-restore guarantee:** Edit Mode may temporarily force action-bar Show and PetFrame edit state; action bars can be reset to the visibility state captured on entering Edit Mode. Reappearance there does not validate Logres restoration. **OPEN / INTERMITTENT USER OBSERVATION**.
5. **Policy diagnostics overclaim:** `petFrame:folded` / `petActions:stock` describe Logres's **snapshot ownership**; `uiownershipcheck` emits STOCK with `observed=not inspected`. Neither independently verifies on-screen native accessibility. **OPEN / DIAGNOSTIC LANGUAGE DEFECT**.
6. **PlayerFrame ancestor:** native `PetFrame` is a child of `PlayerFrame` but Logres's selective replacement hides internal player content rather than the parent frame. It could influence appearance/interaction indirectly, but no observed cause is established. **UNATTRIBUTED; no speculative fix**.
7. **Non-Logres addons/UI settings:** external addon ownership or Blizzard Edit Mode settings are not excluded by this upload. No evidence attributes current intermittence to either. **UNKNOWN; do not assert**.

## Negative results that must survive any later successful patch

- P0206 R0 PREWRITE FAIL: attempted 18 Phase H actions against 15-action panel contract.
- R1 attempted to remove developer-panel actions and rely on slash commands; **REJECTED DESIGN REGRESSION**. R2 restored a full 18-action panel.
- R2 **RUNTIME FAIL**: hidden-ancestor stock bar suppression with failed native restoration after Immersion OFF and BugCatcher protected-function error.
- R3 **PREWRITE FAIL**: hard-coded `0.0.111-dev` frozen runtime version in checker.
- R4 **APPLIER FAIL**: ZIP omitted original checker required by its R2 transform reconstruction.
- R5 **RUNTIME FAIL**: trial quarantined but old native `petActions:folded`; failed stock fallback.
- R6 **RUNTIME FAIL / INTERMITTENT**: petActions stock snapshot after reload, **petFrame still folded** and reported native controls intermittently missing; *no full native visibility/interaction PASS*. Do not treat the user's temporary Edit Mode/PET restoration as acceptance.

## Safe next change (not implemented in this audit)

Perform one narrow fail-open runtime patch **without another hidden ancestor, polling, native presentation inspection, or combat protected mutation**:

1. Independently disable `Native:Ready("petFrame")` folding until a complete secure pet unit replacement exists. Preserve existing target/menu overlay as additive only. Retain R6's `petActions` stock-first gate. Ensure out-of-combat restoration of existing snapshots, then reload for clean startup; do not use an invisible pet unit frame as an accepted substitute.
2. Keep PET dock access but make its labels clear about unit vs action exposure; **do not present PET as a developer-panel control**. Keep all 18 Phase H developer-panel actions.
3. Add/adjust **addon-owned** diagnostics so the 2 domain policies, manual PET state, transition reason and stock-owner restore result are reported separately; mark physical native visibility/secure clicks as **USER-VISUAL UNVERIFIED**, never as PASS from policy. Do not inspect protected/secret native visibility or native secure button states.
4. Validate with an active, visible pet out of combat: clean reload; inspect stock pet unit portrait and stock pet action buttons separately, switch Immersion OFF/ON, toggle PET open/closed, enter and leave Edit Mode; verify target/menu, pet abilities, autocast/drag/keybind fallback and absence of new Lua/taint errors. Observe combat incidentally, no forced travel. Capture panel result **while OFF** and **while ON**, plus visual outcome. All unsupported cases remain DEFERRED.
5. If pet action bar still disappears when Logres has made **no native pet surface fold and no parent mutation**, investigate Blizzard's native conditions/settings/other addons with targeted evidence; do not use unconditional Show/Hide or an arbitrary OnUpdate loop. Preserve the original P0197 combat overlap as OPEN.

This is a **source and existing-diagnostic audit**, not runtime acceptance, not a source edit, and not a claim that every native stock visibility condition has been reproduced.
