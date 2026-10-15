# P0209 R7 — Staged then explicitly confirmed native pet bar handoff

Status: prepared local runtime candidate `0.0.119-dev`, default OFF, not pushed; R7 in-game validation pending.

- Exact input requires P0209 R6 manifest, all source hashes and pushed P0208 HEAD `f6b9a3a`.
- R6 screenshot/diagnostic evidence at loadCount 275 is scoped ON/OFF staging PASS, *not* combat/click/edit proof.
- R7 ON stage preserves Logres pet buttons; ON again invokes addon-owned `Probe:HideProbe`, blocks probe rearm via existing `IsAcquired` fence; OFF releases the native original anchor, then arms Logres probe.
- Unknown/protected Edit Mode states, combat lockdown, missing native/probe/anchor: fail open. Error recovery retains the opaque native restore token. No native Show/Hide, hidden parent or new secure drivers.
- R5 visual disappearance remains an explicit prior runtime FAIL, not erased by R6 PASS.
- Existing 18 Phase H action cells preserved, including Native Pet Bar ON/OFF/Check.
- Static checker extended to enforce explicit two-step transition and prevent unconditional first-stage probe hiding.

Sources: `docs/memory/evidence/P0209_R7_TWO_STEP_HANDOFF_EVIDENCE.md`, P0209 R6 evidence and P0205 exact Blizzard source audit. In-game results unverified; no commit/push.

## R7 retrospective, runtime mechanics vs required behavior

**P0209 R7 RUNTIME MECHANICS CONFIRMED BUT DESIGN REJECTED / R8 LOCAL CANDIDATE.** LoadCount 276: native bar moved on first ON, Logres controls disappeared on second ON, OFF reversed that handoff (`activations=1 restores=1 failures=0`), which inverted user-required UX. R8 reuses R2 client-observed secure state driver, but uses a constant `hide` for BOTH Blizzard PetFrame/PetActionBar and NEVER hides Logres secure pet buttons. Immersion OFF / PET STOCK release drivers; native Blizzard owner methods refresh after release. Runtime still UNVERIFIED, including unit frame driver, combat, interaction, Edit Mode and fallback; no commit/push. Prior P0209 R0-R7 and P0206/P0197 problems remain.
