# P0209 R7 — Two-step native pet action handoff (2026-10-14)

Status: LOCAL DEFAULT OFF / NOT PUSHED / WOW R7 UNVERIFIED. Input: exact P0209 R6 manifest over pushed main `f6b9a3a`. No GitHub writes.

## R6 live evidence — accepted scoped result, not full native control proof

User provided two screenshots and `LOGRES_DIAGNOSTICS_LATEST.lua`, Forever Classic 1.60.1 build 70374, Logres `0.0.118-dev`, loadCount 275. ON: `requested=true armed=true activations=1 restores=0 failures=0 reason=native-anchor-staged-probe-retained-visual-unverified`. OFF: `requested=false armed=false activations=1 restores=1 failures=0 reason=requested-off`. User said "Worked as expected" for this focused staging/restoration test. Native control click/autocast, combat, Edit Mode and visual after suppression NOT YET PROVEN. R5 `0.0.117-dev` had hidden Logres controls immediately on ON without establishing native visibility, which was a user-visible failure.

## Narrow R7 hypothesis and bounded test

Dominos reuses Blizzard PetActionBar.actionButtons and provides native binding support; Bartender4 owns a secure replacement pet button bar. R7 does not copy their permanent UI suppression: it retains Blizzard's original secure PetActionBar together and uses existing Logres fallback. R6 proves staging can be observed without removing the fallback; R7 requires a second explicit Phase H ON press as human confirmation before changing the Logres-owned probe's visibility. No native hidden-parent, native frame Hide/Show, native child reparent, secure state drivers, combat mutation, or unsafe secret inspection. The first ON remains exactly fail-open; second ON may reproduce the R5 presentation failure and must therefore be reported separately. It is not a complete fix until second ON preserves native functionality, OFF restores, and combat/Edit Mode work safely.

On R7 `/reload`, Phase H Native Pet Bar Check should show default OFF. First Native Pet Bar ON (TEST): native bar is staged; Logres cluster remains visible. Inspect the native bar; if absent, use OFF and report FAIL (DO NOT press ON again). If present, press ON a second time, confirm Logres duplicate disappears but Blizzard secure buttons remain visible and usable. Native Pet Bar OFF: verify native anchor and Logres cluster restoration. Check BugCatcher for Lua/taint/protected errors. Test Edit Mode only after OFF. Natural combat test after successful click/restoration proof; failure remains open until independently observed. Panel remains 18 actions. Prior P0197 combat duplicate OPEN.

## R7 actual user result: WRONG DIRECTION (loadCount 276)

**P0209 R7 RUNTIME MECHANICS CONFIRMED BUT DESIGN REJECTED / R8 LOCAL CANDIDATE.** LoadCount 276: native bar moved on first ON, Logres controls disappeared on second ON, OFF reversed that handoff (`activations=1 restores=1 failures=0`), which inverted user-required UX. R8 reuses R2 client-observed secure state driver, but uses a constant `hide` for BOTH Blizzard PetFrame/PetActionBar and NEVER hides Logres secure pet buttons. Immersion OFF / PET STOCK release drivers; native Blizzard owner methods refresh after release. Runtime still UNVERIFIED, including unit frame driver, combat, interaction, Edit Mode and fallback; no commit/push. Prior P0209 R0-R7 and P0206/P0197 problems remain.
