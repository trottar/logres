# P0205 — Exact Forever 70338 PetActionBar combat ownership source/API audit

Date: 2026-10-11 (source version / user-local checkpoint). Baseline: verified pushed Logres `main` `566bb8b569b1fd53f869ac051ab62cbd9fa380a2` (P0204). **SOURCE FINDINGS AND TECHNICAL DECISION ONLY; NO LUA / TGA / TOC CHANGE.** Runtime Logres remains `0.0.109-dev`.

## Exact upstream source / provenance

The observed client is WoW Forever `1.60.1.70338`, interface `16001` (P0204). This version is present at `Gethe/wow-ui-source` branch `forever`, pinned commit `943764493e6b16d63ded3ab304150d1f05e58b57`, `version.txt` = `1.60.1.70338`.

Relevant upstream Git blob SHA references at that commit:

- `Interface/AddOns/Blizzard_ActionBar/Shared/PetActionBar.lua`: `1857b3a84a94668ae86743d17f6f501d0cfe3161`.
- `Interface/AddOns/Blizzard_ActionBar/Mainline/PetActionBar.xml`: `246dc82a496cca2df6b1145e9673fc9b9a7456ba`.
- `Interface/AddOns/Blizzard_RestrictedAddOnEnvironment/SecureStateDriver.lua`: `4861b5fd4a3249c97f1a2fea45a4c13833d5117c`.
- `Interface/AddOns/Blizzard_EditMode/Shared/EditModeSystemTemplates.lua`: `ff591eb3b4f8f3be24527a87d6b7d6310f245b5f`.

Readable upstream URLs (pinned commit):

- https://github.com/Gethe/wow-ui-source/blob/943764493e6b16d63ded3ab304150d1f05e58b57/Interface/AddOns/Blizzard_ActionBar/Shared/PetActionBar.lua
- https://github.com/Gethe/wow-ui-source/blob/943764493e6b16d63ded3ab304150d1f05e58b57/Interface/AddOns/Blizzard_ActionBar/Mainline/PetActionBar.xml
- https://github.com/Gethe/wow-ui-source/blob/943764493e6b16d63ded3ab304150d1f05e58b57/Interface/AddOns/Blizzard_RestrictedAddOnEnvironment/SecureStateDriver.lua
- https://github.com/Gethe/wow-ui-source/blob/943764493e6b16d63ded3ab304150d1f05e58b57/Interface/AddOns/Blizzard_EditMode/Shared/EditModeSystemTemplates.lua

These are exact upstream *static source* findings, not proof of the behavior of a newly introduced addon-specific secure transition.

## Established behavior and cause

- `PetActionBarMixin:OnEvent` calls `self:Show()` when a pet is available on `PET_BAR_UPDATE`, player `UNIT_PET`, `PET_UI_UPDATE`, or `UPDATE_VEHICLE_ACTIONBAR`; `OnLoad` can also show the pet bar. The screenshot and P0204 `onShow=2/combatDeferred=1` confirm this is a live conflicting-ownership pattern, although the precise triggering one of these events is **not known**. The `lastReconcile` context is not event identity.
- `PetActionBar` is an Edit Mode-owned root: XML has `parent="UIParent"`, `inherits="EditModeActionBarTemplate"`, `enableMouse="true"`, and ten secure pet buttons. It is **not** a disposable visual texture or inert overlay. Blizzard may manipulate parent/placement through the Edit Mode manager (the EditMode source includes a `BreakFromFrameManager()` reparent to `UIParent`).
- Forever `SecureStateDriver.lua` implements `RegisterStateDriver` through `RegisterAttributeDriver` and applies `state-visibility` as secure `Show()`/`Hide()` on the registered frame. The manager periodically evaluates registered conditions at approximately 0.2 seconds and also responds to combat-related events. This proves the mechanism exists in source but **not** that a driver registered by Logres on Blizzard's PetActionBar can arbitrate safely against Blizzard's own `Show`, Edit Mode, stock fallback or registration ownership.
- Current Logres `NativeSurfaceReplacement:Fold` holds an opaque stock `shown` restoration token, then hides only out of combat; its OnShow hook deliberately defers combat-time Hide. The P0197 recovery `recovered 0→1` is **PASS for one post-combat transition**; the simultaneous pet rows in combat remain **FAIL / REPRODUCED**. `snapshots.petActions ~= nil` means folded by policy/snapshot only, not guaranteed unrendered.

## Evaluated combat-safe approaches — NO automatic production authorization

1. **Insecure `PetActionBar:Hide()` in combat, combat HookScript hide, OnUpdate timer/poll or periodic reassertion:** **REJECTED.** Protected-action risks and the same known lifecycle race; violates project security discipline.
2. **Unconditional `RegisterStateDriver(PetActionBar, "visibility", "hide")`:** **NOT APPROVED.** Native root is Edit Mode-managed; secure driver may compete with native Show/Hide, and stock availability / manual PET open / exact restoration are not proven. The state-driver manager's periodic evaluation is engine-owned but does not itself constitute a validated Logres ownership contract.
3. **Hidden Logres-owned ancestor and out-of-combat reparenting of Blizzard PetActionBar:** **SOURCE-PLAUSIBLE, UNVALIDATED.** A hidden parent should prevent descendant display/clicks when ancestor ownership is retained; nevertheless the native frame is Edit Mode-managed, its original parent/anchor and interactive restoration must be preserved, and outside code may reparent. The source and existing diagnostics do not prove the required invariants in WoW Forever. Do not ship automatic reparenting yet.
4. **Reciprocal secure visibility handoff: make stock controls available in combat, Logres presentation only outside combat:** **SOURCE-PLAUSIBLE, UNVALIDATED.** The secure state-driver facility supports combat conditional transitions in principle, but native Show presence, action/keyboard access, manual PET toggles, Edit Mode, and restoration must all be validated. Do not hide the Logres secure cluster in combat without an assured active, usable Blizzard fallback.

## Decision / next work item

**A static source-only audit cannot establish safe runtime ownership arbitration. P0197 remains OPEN; P0205 changes no runtime behavior.** The next bounded engineering candidate should be **explicitly opt-in and default OFF**: a combat-safe, reversible test of *one* preconfigured secure visibility/ancestor strategy, armed and disarmed **only outside combat**, with feature readiness checks, snapshot-restoration semantics, addon-owned diagnostics, and a reliable user-controlled route to stock pet buttons. Static checker constraints must be deliberately adjusted only for that tightly scoped candidate. No new broad hooks, native secret/presentation inspection or layout changes. Test PET manual access, Immersion OFF/ON, existing secure pet controls, entering/leaving combat, native re-show and Edit Mode before enabling by default. If any native control becomes unusable, fail open to stock and record FAIL before advancing.

This audit does not retroactively accept native target harmful-aura two-column fit, NPC green label occlusion, ObjectiveTracker flash, or H.3 visual fidelity; those remain separate open/deferred items.
