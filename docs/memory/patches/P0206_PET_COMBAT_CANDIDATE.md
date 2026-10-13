# P0206 — Default-OFF reversible PetActionBar hidden-ancestor runtime trial

Date: 2026-10-11. Baseline: verified pushed `main` `79a8e2308a37135b61db8ad8a0433cae5ec8b4bd` (P0205). P0206 is an **UNVALIDATED runtime candidate** bumping `0.0.109-dev` to `0.0.110-dev`; NOT a production acceptance.

## One narrow hypothesis

An addon-owned, permanently hidden parent installed on the native PetActionBar *outside combat* could prevent a Blizzard `Show()` during combat from creating a duplicate native row. The existing Logres ten-slot secure pet cluster must remain active, clickable and safe before the trial may arm. The native Edit Mode root must be restored to its original, opaque captured parent when PET is explicitly opened, Immersion is OFF, readiness is withdrawn, or the trial is turned OFF. This has not been proven in the client. See `docs/memory/evidence/P0205_FOREVER_PET_COMBAT_SOURCE_AUDIT.md` for the exact 70338 source and limitations.

## Delivery failures and six-row panel correction

- R0 **SHADOW PREWRITE FAIL**: adding ON/OFF/Check as Phase H actions exceeded the 15-action panel layout (18 total); static checker stopped prior to tracked writes.
- R1 **REJECTED**: a proposed slash-only workaround would have removed visible Phase H controls. It was not applied and the user explicitly rejected that workflow regression.
- R2 keeps **all existing 15 controls plus the three new pet-combat buttons** in the existing three-column Phase H grid with six rows. Button host grows to 180px and diagnostic result area begins 32px lower to preserve a visible gap. Both the panel contract checker and an additional trial checker require this geometry. No actions are removed or moved into a slash-only path.

## Implementation scope

- New `PetCombatCandidate` module loaded after `NativeSurfaceReplacement`; automatic module creation but **requested=false each /reload**, no SavedVariables persistence.
- `/logres petcombat on|off|check`; matching Phase H panel controls. Candidate ON is a session-only opt-in and is only applied outside combat when native snapshotted `petActions` and secure Logres pet controls are ready, Immersion ON, manual PET closed. Commands during combat are rejected without mutation.
- Captures stock parent only as an opaque setter argument, reparents stock to a hidden Logres host out of combat, and restores that parent before the existing native fold is removed. Does not read native visibility, native aura payload or hidden frame alpha.
- P0197 existing OnShow and deferred post-combat recovery unchanged, plus a P0206 candidate audit in Native Access Check.
- No polling, state-driver takeover, repeated hide, protected combat mutation, user CVar changes, D-045 coordinate movement or artwork replacement.
- A failed SetParent arm attempts immediate restoration, turns the trial off, records an error. A restore error is a **real runtime FAIL**, never accepted silently. Edit Mode or external reparenting may invalidate the ancestor; no automatic reassertion is attempted. On client error/taint, stop and correct before accepting.

## Explicit tests (NOT YET PERFORMED)

1. Deploy, `/reload`, run `/logres petcombat check` and verify `requested=false armed=false`, and `/logres nativeuicheck` no regression.
2. With ordinary active pet, enable `/logres petcombat on` outside combat, run check; validate native stock row not visible and Logres pet left-click, right-click/autocast, tooltip/keybindings to the extent available. `armed=true` is a structural snapshot, not a native visibility inspection.
3. Use native **PET** access outside combat; stock controls must be clickable and complete. Close PET and verify trial can rearm. Test `/logres petcombat off` for original parent/stock ownership and no invisible hitboxes.
4. Naturally occurring combat: observe visually whether Blizzard's row reappears. Do not use protected native visibility inspection. Run `/logres nativeuicheck` in combat and out; capture addon-owned petbar-reshow and petcombat counters.
5. Immersion OFF/ON restoration, Edit Mode placement/availability, pet state changes and `/reload` resetting default OFF. Unsupported or unavailable cases are recorded DEFERRED, not PASS.
6. Any Lua, taint, protected-action or native fallback failure: mark FAIL and stop; do not push a false runtime acceptance.

## Known limitations / negative evidence

- This is **not** a proven combat-safe ownership solution. Blizzard Edit Mode can manipulate the pet root's parent/anchor; the trial neither detects nor overrides that protected lifecycle. Parent changes, bindings, secure pet execution and manual PET restoration all require runtime proof.
- When trial OFF, the existing P0197 duplicate issue remains possible. The accepted P0197 post-combat recovery does not imply successful in-combat presentation.
- A user-initiated OFF or PET open *during combat* cannot immediately change protected stock ownership and is deferred/rejected. The normal secure Logres pet buttons remain the intended active combat path for the trial, subject to proof.
- NPC world-label quest-dialogue occlusion, native target harmful icon wrapping, ObjectiveTracker flash and H.3 polish remain separate OPEN issues.
