# P0417 — Repair stale PET STOCK readiness after P0409 panel consolidation

Baseline: verified GitHub `main` P0416 `d11b76ab786f3b08151c426e52502a3415fb4877`.
Date: 2026-11-09. State: source-backed corrective candidate; WoW Forever UNVERIFIED.

## Observed client failure

User reports the five new action bars generally fit, minor offsets remain,
and Blizzard PetFrame plus PetActionBar persist under Immersion ON. New
`LOGRES_BUG_REPORT_LATEST.zip` contains Forever session 73 incident 8609,
`0.0.293-dev` (client 1.60.1 build 70862), and a screenshot. The panel output
before the incident confirms:

- `petbardriver check`: `requested=true armed=false pending=false nativeDriver=false activations=0 failures=0 reason=secure-pet-unit-or-stock-access-unavailable`;
- `Native Access Check`: NativeSurfaceReplacement `petInteraction=true` and `petFrame:stock petActions:stock`, with other stock domains folded;
- `Pet State Diagnostic`: ten configured pet buttons; probe armed/visible;
- `Pet Action Probe Check`: READY, `occupied=8`, zero setup failures;
- Immersion Enabled true. `nativeuicheck PASS` refers to the separate five
  NativeAccess domains, **not** a native pet suppression visual PASS.

These observations establish that pet suppression never armed. They do not
show a Blizzard re-show event overpowering a registered driver.

## Narrow root cause and correction

`Logres/Immersion/PetBarVisibilityTrial.lua` `Trial:Ready()` checks
`native.buttons.pet`. Its `getNative()` returns the
`NativeSurfaceReplacement` module, which does not initialize or construct any
`buttons` table. P0409 removed the old on-screen native-access controls and
migrated them to `/logres panel` N. The existing pet fallback remains
`NativeSurfaceReplacement:Toggle("pet")`, which delegates to the current
visibility trial's `ToggleNativeAccess`, restoring the Blizzard stock pet
surfaces outside combat. The previous `native.buttons.pet` assertion cannot
succeed after that control migration; it incorrectly conflates a removed
presentation button with the extant stock-access capability.

P0417 replaces only that obsolete condition with a check of the module's
`Toggle` function, retaining `native:IsEnabled()` and the already-created
`petInteraction` secure button requirement. The original probe availability,
combat lockdown, Edit Mode restrictions, native frame presence and secure
`RegisterStateDriver` availability remain mandatory. The code does not add
polling, force-hide, protected inspection, reparenting, native mutations,
new bars, changed keybinds or saved settings.

## Acceptance boundary

Apply guarded package to an exact clean P0416 main checkout and run all
historical plus new static checker contracts. In WoW Forever, first screenshot
with pet and Immersion ON after `/reload`, then use Phase H **Native Pet Bar
Check** and **Native Access Check**. Expect trial armed with both native
drivers installed and no duplicate Blizzard PetFrame/PetActionBar. Test one
Logres pet action and (when safe) autocast, Phase N **PET STOCK** recovery,
Immersion OFF/ON, and normal combat/Edit Mode if naturally available. If
Ready succeeds but a secure driver is rejected or native pet presentation
still appears, preserve as a new runtime FAIL; do not invent a re-show fix.

The source-backed correction is not WoW proof. L-008 remains OPEN. P0416
small geometry offsets and other H.2 elements require a separate whole-screen
map approval; this patch does not change layout.
