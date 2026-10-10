# P0186 — Source evidence: Main normal presentation vs secure special routing

Date: 2026-10-09. Baseline verified remote `60886bbededd8203c9a457dec23784cd53b64486`; `0.0.98-dev`. Source finding only; no in-client validation was run for this investigation.

### Pinned Forever native transition behavior

Source: `Gethe/wow-ui-source@15666a6e67938a1ab5caf041406464251db111ca`, `Interface/AddOns/Blizzard_ActionBarController/ActionBarController.lua`.

- `ActionBarController_UpdateAll` selects dedicated `OverrideActionBar` only for certain *skinned* vehicle/override states.
- With non-skinned `HasBonusActionBar`, `HasOverrideActionBar`, `HasVehicleActionBar`, `HasTempShapeshiftActionBar`, or pet battle, it instead sets **MainActionBar**'s `actionpage` to vehicle/override/temp/bonus/native page as appropriate.
- `ValidateActionBarTransition` calls `MainActionBar:Show()` in Main state and `MainActionBar:Hide()` in dedicated Override state. Native code thus owns transitions; permanently hiding Main is not safe proof of special-mode fallback.
- Native `MainActionBar.lua` also registers input/MKB transitions which can show Main.

### Logres source contrast

- `Logres/Actions/Primary.lua`: 12 buttons, page driver `[bar:2]2; ... [bar:6]6; 1`; secure activation is ID + driven page. Its override bindings map `ACTIONBUTTONn` to Logres `Primary` clicks. It cannot clear or replace those bindings under `InCombatLockdown()`. Its source-status gate flags five special modes but does not authorize suppression (`stockSuppressionAuthorized=false`).
- `Logres/Actions/StockReplacement.lua`: captures and suppresses Bars 2–5 only; mouse/alpha mutation and routing restoration are out-of-combat operations.
- `Logres/Immersion/Controller.lua`: `primaryActionRoutingOwned=false`. Primary binding replacement is not a coordinated production Main ownership capability.

### Classification

**NOT READY / BLOCKED FOR DIRECT HIDE** by source. This is a new, concrete source-level negative finding against simply reusing Bar 2–5 presentation suppression. It does not prove that a future secure-state mechanism is impossible, and does not claim that any particular transition was observed live. A fail-open, dedicated secure route+presentation candidate remains the immediate H.1 work. No change to other stock ownership; P0183 visuals and P0184 runtime acceptance unchanged.
