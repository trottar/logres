# P0209 R5 — Edit Mode initial nil runtime failure and narrowly scoped fix

Date: 2026-10-14. State: P0209 R4 **RUNTIME FAIL**; R5 **LOCAL CANDIDATE / WOW UNVERIFIED**; no push.

## Actual R4 result

User screenshot of Phase H on Logres `0.0.116-dev` shows `/logres petbardriver on` rejected `editmode-manager-state-invalid`. The uploaded `LOGRES_DIAGNOSTICS_LATEST.lua` confirms loadCounts **272** and **273**, `combat=false`, `requested=false`, `armed=false`, `activations=0`, `failures=0`, `mode=one-native-bar-no-combat-swap`. The screenshots show no pet-bar movement. No native `SetPoint`, secure action, or pet-frame restoration could have been exercised. R4 is a **runtime failure of the activation gate**; it is not proof for or against native pet-button reuse.

## Narrow verified cause

Source: Gethe `wow-ui-source`, Forever UI commit `943764493e6b16d63ded3ab304150d1f05e58b57`, `Interface/AddOns/Blizzard_EditMode/Shared/EditModeManager.lua` lines 23–69, 98–125, 149–150.
- `OnLoad` does not initialize `self.editModeActive`.
- `EnterEditMode` sets it `true`; `ExitEditMode` sets it `false`.
- `IsEditModeActive` returns the field verbatim. The method may return ordinary `nil` before first Edit Mode entry.
- R4 required `type(active) == "boolean"`; its own status `editmode-manager-state-invalid` shows it reached that type rejection after passing the secret check. A pre-entry nil is therefore a source-supported explanation. The file alone cannot prove which nonboolean type was observed, but nil is the documented first-run case.

R5 changes only `editModeActive()`: once the `pcall(issecretvalue, active)` check has passed, an **ordinary nil** is classified as inactive. An active `true` still blocks; missing method, query error, secret/restricted value or unexpected other type still blocks. An absent manager was already allowed by R4. No other native presentation read is added. No pet bar position, combat, keybind, duplicate-probe or restoration algorithm changes.

## Existing addons and limits

Dominos `Dominos/bars/petBar.lua` reuses native pet buttons, while Bartender4 `PetBar.lua` supplies secure replacement pet buttons. Neither uses P0209 R2's reciprocal combat visibility swap. R3/R4's intact native PetActionBar movement is a **Logres-specific trial**, not a verbatim Dominos implementation and **not yet demonstrated to work** on Forever 1.60.1. No claim of equivalent behavior is made.

## Pending gates

Apply guarded R5 against local R4 manifest; pass all repository `check_*.py`. In-game: first ON should report `requested=true armed=true activations=1` or provide the next precise rejection/error. Only after activation succeeds validate bar position, secure button execution, combat continuity, Edit Mode OFF/restoration, Immersion OFF/ON and BugCatcher. A failed native protected mutation is a new runtime failure, not permission to weaken gates. Keep P0209 R0/R1 prewrite, R2 combat swap, R3 unloaded gate, R4 initial-state failure, and P0206/P0197 protected/combat evidence.

References: https://github.com/Gethe/wow-ui-source/blob/943764493e6b16d63ded3ab304150d1f05e58b57/Interface/AddOns/Blizzard_EditMode/Shared/EditModeManager.lua
https://github.com/tullamods/dominos/blob/main/Dominos/bars/petBar.lua
https://github.com/Nevcairiel/Bartender4/blob/master/PetBar.lua

## P0209 R5 first archive PREWRITE failure / R5 R1 correction

User-provided actual WSL apply result on 2026-10-14: `P0209 R5 APPLY FAIL: heading absent: docs/memory/investigations/ACTIVE.md`; no R5 manifest, no tracked R5 writes. R3 had prepended a level-two heading to ACTIVE and STATUS; R4 intentionally accepted/preserved that shape, but R5's applier required `s.startswith('# ')` for all four documents. This was a packaging/generator regression hidden by the synthetic first-level-heading fixture. R5 R1 replaces that requirement with an exact unique R4 heading anchor and verifies realistic R4 leading-heading shapes before release. Existing P0209 R0/R1 static failures, R2 combat swap, R3/R4 runtime activation failures, and P0206/P0197 failures remain OPEN. R5 R1 runtime activation remains unverified. The trial Lua is byte-for-byte identical to the original R5 ZIP. No commit/push.

## P0209 R5 R1 actual runtime failure and R6 disposition

P0209 R6 LOCAL / STAGED NATIVE VISIBILITY (2026-10-14): `0.0.117-dev` R5 R1 loadCount 274 activated ON (`requested=true armed=true activations=1`) and restored OFF (`restores=1`), but the user observed Logres pet buttons disappearing on ON and returning on OFF, with no native replacement visibly established. Source cause: R5 `Acquire()` called `probe.HideProbe` unconditionally after only `PetActionBar:SetPoint`. Blizzard native root has independent show policy. R6 (`0.0.118-dev`) retains the functional Logres cluster and allows rearm while attempting only out-of-combat native-bar anchor relocation. Default OFF; visibility proof and combat/click restoration UNVERIFIED. No commit/push; P0209/P0206/P0197 failures OPEN. Refer to `docs/memory/evidence/P0209_R6_NATIVE_ANCHOR_VISIBILITY_ISOLATION.md`.
