# P0209 R4 — R3 no-op / Edit Mode unloaded gate audit

Date: 2026-10-14. Status: LOCAL CORRECTIVE TRIAL, RUNTIME UNVERIFIED, NO PUSH.

Actual R3 diagnostics: Logres 0.0.115-dev loadCount 270–271, `petbardriver on` repeated `rejected (editmode-unavailable-or-active)` while out of combat. `requested=false armed=false activations=0 failures=0 mode=one-native-bar-no-combat-swap` persisted, so no native anchor move or duplicate probe hide happened. The user observed no change. This is a **RUNTIME FAIL of the R3 activation path**, not a negative test of native-button positioning/secure combat continuity. Preserve R0/R1 prewrite failures, R2 runtime combat swap failure and P0206/P0197 failures.

Root cause from exact R3 Lua: `editModeActive()` returned nil when global `EditModeManagerFrame` was absent or method unavailable; `Trial:Ready()` required exactly false and rejected both missing manager and actual Edit Mode. Gethe Forever UI source at commit `943764493e6b16d63ded3ab304150d1f05e58b57`: `Blizzard_EditMode/Shared/EditModeManager.xml` defines global `EditModeManagerFrame` when Blizzard_EditMode loads; `Shared/EditModeManager.lua` defines `IsEditModeActive()`, `EnterEditMode()` and `ExitEditMode()`. If the manager does not exist, that Blizzard Edit Mode is not active. The old guard conflated unloaded manager with active editing. The uploaded diagnostics do not distinguish absent manager from missing method, but both mapped to the same rejection.

R4 correction: manager **absent** -> inactive with reason `manager-not-loaded`. A manager present with missing method/query failure/restricted or nonboolean result still fails closed; active manager still blocks. Never inspect a secret-capable result before `issecretvalue`. Capture an addon-owned `lastEditModeGate` for diagnostics without checking protected native frame presentation. All other gates (pet availability, armed Logres probe, out-of-combat, immersion enabled), opaque anchor restoration, default OFF, native button continuity, 18 Phase H panel actions remain. No new `Show/Hide`, parent operations, state driver, polling, or protected combat mutation.

R4 is not a proven solution. Once user runs ON in WoW, check whether another readiness gate rejects (`logres-pet-probe-unavailable`) or native SetPoint is refused. Do not workaround a new failure by weakening gates or claiming success; record it. Tests of secure clicks, Edit Mode return, position restoration, and natural combat are still mandatory. No commit until accepted.

References:
- https://github.com/Gethe/wow-ui-source/blob/943764493e6b16d63ded3ab304150d1f05e58b57/Interface/AddOns/Blizzard_EditMode/Shared/EditModeManager.xml
- https://github.com/Gethe/wow-ui-source/blob/943764493e6b16d63ded3ab304150d1f05e58b57/Interface/AddOns/Blizzard_EditMode/Shared/EditModeManager.lua
- https://github.com/tullamods/dominos/blob/main/Dominos/bars/petBar.lua

## P0209 R4 actual runtime failure (2026-10-14)

**P0209 R5 local candidate / WOW UNVERIFIED (2026-10-14):** R4 (`0.0.116-dev`, loadCounts 272–273) **RUNTIME FAIL**: `petbardriver on` rejected `editmode-manager-state-invalid`, `activations=0`. Blizzard's verified `IsEditModeActive()` returns an uninitialized `nil` before the first Edit Mode entry; R4 misclassified it. R5 accepts only ordinary nonsecret initial `nil` as inactive, still rejects active/restricted/unknown states, and changes no pet-action ownership or combat logic. **R5 initial ZIP PREWRITE FAILED** before any tracked-file write: its generator wrongly required `docs/memory/investigations/ACTIVE.md` to start with `# `, despite the valid `## P0209 R4` heading inherited from R3/R4. This R5 R1 archive corrects that heading expectation with an exact R4 section anchor; runtime behavior is unchanged. P0209 R0/R1 static failures, R2 combat-swap failure, R3/R4 activation failures, and P0206/P0197 protected/combat defects remain recorded. No push. Evidence: `docs/memory/evidence/P0209_R5_EDITMODE_INITIAL_NIL_EVIDENCE.md`.
