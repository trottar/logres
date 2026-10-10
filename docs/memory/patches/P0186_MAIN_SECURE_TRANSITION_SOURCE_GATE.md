# P0186 — Pinned native MainActionBar secure-transition source gate

Date: 2026-10-09. Exact baseline: verified GitHub `main` `60886bbededd8203c9a457dec23784cd53b64486` (P0185), runtime `0.0.98-dev`.

## Narrow question

Can the remaining ordinary native `MainActionBar` be suppressed by extending existing stock Bar 2–5 alpha/mouse handling, without first changing Primary secure routing or native-mode ownership?

**Answer: NO. SOURCE BLOCKER / NO RUNTIME MUTATION.** Pinned Forever native `ActionBarController.lua` dispatches both normal and several *unskinned special* states through `MainActionBar`, reassigning its protected `actionpage`; only certain skinned override/vehicle states move to `OverrideActionBar`. It explicitly shows Main again in its transition validator. Logres `Primary.lua` currently pages only normal bars 1–6 and `SetOverrideBindingClick` binds `ACTIONBUTTON1`–`12` to Logres buttons while enabled; `RefreshOverrideBindings` cannot run in combat. Its present `GetStockOwnershipGate` explicitly refuses authorization. Copying `StockReplacement:SuppressBar` to Main would therefore couple invisible controls, normal-only secure routing, and potentially unhandled combat/special transitions. Registering a new visibility driver on the Blizzard frame without a source+runtime ownership contract could also compete with native state and lack exact driver restoration.

## Pinned source and observed code

- Native source: `Gethe/wow-ui-source@15666a6e67938a1ab5caf041406464251db111ca`, `Interface/AddOns/Blizzard_ActionBarController/ActionBarController.lua`, especially `ActionBarController_UpdateAll`, `ActionBarController_ResetToDefault`, and `ValidateActionBarTransition`.
- Native `Interface/AddOns/Blizzard_ActionBar/Shared/MainActionBar.lua`: Main is an Edit Mode / input-transition owner, with explicit `Show`/`Hide` paths.
- Native `Interface/AddOns/Blizzard_ActionBar/Shared/ActionBar.lua`: `MainActionBar.actionButtons` and child button containers are created and laid out by Blizzard.
- Logres `Logres/Actions/Primary.lua`: `PRIMARY_PAGE_DRIVER`, `SetBindingRoutingEnabled`, `RefreshOverrideBindings`, `GetStockOwnershipGate`.
- Logres `Logres/Actions/StockReplacement.lua`: existing scoped Bar 2–5 exact alpha/mouse snapshot/restoration; does not include Main.
- D-023 and D-044 forbid partial Main and special-control removal.

## Consequence and next implementation

**P0186 is a narrow source-result checkpoint, NOT Main suppression, NOT runtime PASS, and NOT a reason to reopen debuffs or a broad stock-UI audit.** The next *runtime-code* candidate must first prove a coherent **secure normal/special mode-aware Primary route**, including a way for `ACTIONBUTTON1`–`12` to reach stock actions when Logres does not own that mode, without combat-time insecure binding refresh. Build matching stock Main presentation ownership only when the same secure controller can make normal stock disappear with zero click region, allow native special fallback in combat, preserve native edit/keybind access, and restore the native visibility/interaction state exactly. If source or runtime cannot establish those semantics, leave Main usable/visible rather than invent a hide. Prefer a targeted Phase H / Phase 0 ownership regression; environmental absence of special modes is DEFERRED. Avoid global Show hooks, polling, or periodic reassertion.

P0186 touches documentation/evidence only; it does not edit Lua, native UI state, runtime version, or checker source. There is no WoW redeploy or retest for P0186. User-owned commit/push remains required to make the checkpoint durable.
