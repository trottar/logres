# P0209 R6 — Native relocation visibility isolation (2026-10-14)

Status: PREPARED / DEFAULT-OFF / RUNTIME UNVERIFIED / NO PUSH. Baseline: pushed P0208 GitHub `main` `f6b9a3a58bfc9081043455038df33b706c6e9e6f` plus the exact locally applied P0209 R5 R1 (`0.0.117-dev`, P0209_R5_MANIFEST.txt). No changes to GitHub.

## Actual R5 R1 user evidence — RUNTIME FAIL

WoW Forever Classic 1.60.1 interface 16001, Logres `0.0.117-dev`, loadCount **274**. ON at 1792027987 reports `requested=true armed=true activations=1 failures=0 reason=native-buttons-acquired-unverified`; OFF at 1792028016 reports `restores=1`, second ON/OFF reaches `activations=2 restores=2`. User screenshot and observation: **Logres pet bar disappears when ON is clicked and returns on OFF; no functional native bar established at the Logres anchor.** No protected errors reported in the attached Logres diagnostics. `armed` was only addon mutation bookkeeping, not native visibility proof. PetFrame remains stock owned; exact visibility of PetFrame is separate, and no native presentation data is inspected.

## Source-confirmed cause and R6 gate

R5 `Trial:Acquire()` calls `stock:ClearAllPoints(); stock:SetPoint(...)`, then unconditionally calls `probe.HideProbe` before asserting `native-buttons-acquired-unverified`. Because Blizzard PetActionBar implements independent show/hide policy (PetActionBarMixin:OnEvent/Update in `Blizzard_ActionBar/Shared/PetActionBar.lua`) and is an EditModeActionBarTemplate frame, moving the frame does **not** prove that native buttons are visible or clickable. R5 withdrew the established Logres controls without such proof. R6 removes early duplicate suppression and ensures `IsAcquired` does not block the existing Logres probe auto-arm while its native anchor is staged. The bar anchor is still moved out of combat and restored via opaque native tokens; no protected stock visibility inspections, new native hooks, `Show`/`Hide`, secure child reparenting, state-driver swaps or polling.

## Required focused in-game test

Default OFF after `/reload`; with active pet and Immersion ON, Phase H **Native Pet Bar ON (TEST)** stages stock relocation while keeping Logres pet buttons visible. Observe whether a SECOND, distinct native ten-button bar appears in/near the existing class/pet anchor. Verify Logres pet buttons remain usable. Press **Native Pet Bar OFF** and verify original layout/fallback. If native bar still does not appear, record that as a distinct stock visibility/layout issue before any further suppression work. No combat test or commit until static and this visibility gate pass. P0197 combat duplication and P0206 secure errors remain OPEN.

## R6 actual result and R7 bounded next gate

P0209 R7 LOCAL / MANUAL TWO-STEP NATIVE HANDOFF (2026-10-14): R6 0.0.118-dev loadCount 275 user-confirmed ON/OFF staging/restoration **PASS** (activations=1 restores=1 failures=0), with both native and Logres pet buttons retained in the ON visual. Interaction, combat, Edit Mode and native ownership still UNVERIFIED. R7 default-OFF candidate: first ON reproduces R6 staging without suppression; second ON (only outside combat, after explicit human visual inspection) calls existing addon-owned `PetActionExecutionProbe:HideProbe`; it never hides Blizzard buttons or invents a second action executor. OFF restores stock anchor and re-arms Logres. Repeat R5 visual disappearance is an explicit FAIL, not acceptance. Historical P0209 R0/R1 prewrite, R2 combat swap, R3/R4 activation, R5 visual and original R5 prewrite, and P0206/P0197 problems remain recorded. No commit/push. Evidence: `docs/memory/evidence/P0209_R7_TWO_STEP_HANDOFF_EVIDENCE.md`.
