# P0152 — Secure Pet-Action Execution Probe

Date: 2026-10-05
Durable baseline: `b62397b116cf028326167b7f8bf7010ed94f3717`
Candidate runtime: `0.0.74-dev`
Result: **R6 PREPARED — R5 PROTECTED-CLICK + RESOURCE-OVERLAP FAIL PRESERVED; BLIZZARD-DELEGATED PET CONTROL NEXT**

## Intended question

Prove secure pet-action execution without claiming PetActionBar replacement completeness.

## Initial delivery failure

The first P0152 artifact was refused pre-write because older feature checkers still froze historical runtime versions. R1 repaired that checker class and added a global version-pin policy.

## R1 runtime failure

R1 then exposed a separate implementation error: it created a bespoke pet button strip instead of reusing the already-proven `Logres.ActionButton` infrastructure. Runtime screenshots showed only one correctly rendered ability, misleading custom numbers, a bespoke yellow `A` state marker, and left click did not execute the selected pet command.

Classification: **REAL P0152 RUNTIME/CONTROL/VISUAL FAIL**. The Blizzard capability is not disproven; the adapter implementation was wrong.

## R2 delivery failure

R2 preserved the corrected shared-action runtime design but was refused during exact prepared-candidate validation before tracked writes. `check_memory_health.py` rejected the generated active-memory files because `CURRENT.md` omitted the mandatory canonical heading schema and `CURRENT_HANDOFF.md` did not point readers to `CURRENT.md`.

Classification: **PRE-WRITE DELIVERY / MEMORY-SCHEMA FAILURE**. No R2 tracked writes occurred. R3 keeps the same runtime code and repairs only the active-memory delivery surfaces plus this durable record.

## R3 correction (same runtime adapter as R2)

R2 makes pet controls a thin specialization of the existing action interface:
- shared `ActionButton.CreateCluster` and `ActionButton.Create`;
- ten horizontal slots in stock order, no custom number labels;
- explicit secure `type1="pet"` / `action1=slot` for left click;
- correct token-texture resolution without relying on the ambiguous numeric `isToken` runtime value;
- shared checked treatment for ordinary active state;
- right-click hardware path toggles autocast only when `autoCastAllowed` is ordinary true;
- autocast state is indicated through shared frame art rather than a bespoke letter marker;
- stock PetActionBar remains visible/usable.

Still excluded: drag/reorder/edit, bindings, PetActionBar suppression/restoration, PetFrame ownership, and other class/special controls.

## Required runtime proof

1. ARM out of combat.
2. Confirm populated pet actions render with normal Logres action-button styling and correct slot order.
3. Left-click an inactive Follow/Stay-type command and confirm the pet visibly changes state.
4. Right-click an autocast-capable ability (for example Torment where available) and confirm autocast toggles.
5. Run Check; secure left-click proof requires PostClick + pet event + ordinary active-state change + zero failures.
6. Hide probe and run Run All separately.
## R3 runtime load-order failure

R3 reached WoW but failed immediately during module initialization on `/reload`:

`PetActionExecutionProbe.lua:417: attempt to index upvalue 'ActionButton' (a nil value)`

The probe file was ordered in the TOC before `Actions\Button.lua`, so `local ActionButton = Logres.ActionButton` captured nil before the established shared action primitive was loaded. This is a **real runtime integration/load-order failure**, not a failure of the secure `type="pet"` capability.

## R4 correction

R4 keeps the R3 shared-action pet adapter unchanged and changes only dependency order:
- `Actions\Button.lua` loads before `HUD\PetActionExecutionProbe.lua`;
- the pet probe still loads before `Actions\Primary.lua`;
- `check_pet_action_execution_probe_contract.py` now enforces `Button < PetProbe < Primary`.

No pet execution, autocast, visual, suppression, binding, or ownership scope changes are introduced by R4.

## R4 runtime layout failure

R4 fixed the load order and reached the shared Logres action presentation, but the temporary pet row was centered at `y=-190`, overlapping the established bottom action clusters. The user could not reliably click the pet buttons.

Classification: **REAL RUNTIME USABILITY / LAYOUT FAIL**. Secure pet capability is not disproven.

## R5 correction

R5 preserves all R4 pet execution/autocast behavior and changes only the temporary pet cluster position to `y=-120`, above the established player action clusters. The static P0152 contract now enforces that placement.

## R5 runtime protected-click / resource-overlap failure

R5 placed the temporary pet row at `y=-120`, which directly overlaps the established `LogresHUDResourceBar` centered at `y=-118`. More importantly, a hardware left click on the Logres pet button triggered Blizzard's "action only available to the Blizzard UI" protected-action block.

Classification: **REAL RUNTIME CONTROL + LAYOUT FAIL**. The direct addon `type1="pet"` / `action1=slot` implementation is not accepted on Forever 70235. Stock PetActionBar remained the safe fallback.

## R6 correction

R6 retains the established Logres `ActionButton` presentation and changes only the pet-specific control/placement adapter:
- secure `type="click"` delegates both mouse buttons to the matching Blizzard `PetActionBar.actionButtons[slot]`;
- Blizzard's own pet button therefore owns protected left-click cast/command execution and right-click autocast behavior;
- Logres runtime contains no direct `CastPetAction` or `TogglePetAutocast` mutation;
- the temporary row anchors below `LogresHUDResourceBar` with an 18px gap, deriving placement from an existing Logres surface instead of guessing Y coordinates;
- direct `type1="pet"` is forbidden by the P0152 checker until new evidence justifies reopening it.

This is still a bounded capability probe, not PetActionBar replacement completeness. Stock PetActionBar remains visible and required.

## R6 delivery refusal / R6B repair

The first R6 artifact was refused before writes because its baseline verifier accidentally reused pre-R5 hashes rather than the actual post-R5 payload hashes. All five R5 replacement-file pins were corrected in R6B from the delivered R5 artifact itself. Runtime code/policy is unchanged from the R6 candidate.


## R6B runtime execution/range/layout failure

R6B corrected the R6 delivery pins and reached runtime with the correct ten pet slots/icons. No new Lua/protected popup occurred, but secure click delegation to Blizzard `PetActionBar` buttons was inert. The adapter also tinted all pet actions out-of-range because it consumed `inRange=false` without requiring `checksRange=true`, and the ten-wide row still occupied the central action lane.

Classification: **REAL RUNTIME ADAPTER FAIL; SLOT/PRESENTATION MAPPING ACCEPTED.**

## R7 correction

R7 retains shared `Logres.ActionButton` construction and the accepted pet-slot mapping. It:
- removes click delegation;
- uses secure `type1="pet"` / `action1=slot` again, but with no insecure PreClick hook before protected execution;
- captures baseline active/autocast state during ARM instead;
- configures secure right-click `/petautocasttoggle <name>` macros only for ordinary autocast-capable slots;
- honors `checksRange` before applying the red range tint and uses `GetPetActionSlotUsable` for ordinary unusable tint;
- uses a 5x2 lower-left cluster anchored below `LogresHUDAllies`, matching D-032 instead of crossing the central resource/action lane.

Stock PetActionBar remains visible and usable. No suppression/edit/binding/PetFrame ownership is added.

## R8–R12 presentation/default-on correction history

After R7 restored working pet execution/layout, the remaining acceptance defect was presentation/lifecycle clarity. R8 and the first R10 panel delivery were refused by exact baseline checks; R9 made the pet cluster default-on but produced no visible state change; R11 diagnostics identified the root presentation mismatch: the working pet controls stored effective pet bindings on click-specific secure attributes while the presentation layer inspected only raw generic attributes.

R12 resolves effective `type1=pet` / `action1=slot` bindings for presentation and strengthens persistent active/autocast treatment without changing the working secure execution path.

## Final P0152 runtime acceptance

P0152 is durable at `00aef4a90e5999140dc9082e68e934cfc854cb05` / `0.0.74-dev`. The final pet-state diagnostic reports ten pet bindings, seven naturally readable/occupied slots, two active indicators, one autocast indicator, and successful default-on arming. The user confirmed the visual state treatment works and pet button presses remain functional.

Classification: **RUNTIME + CONTROL + STATE-PRESENTATION PASS for the bounded pet-action slice.**

Stock PetActionBar remains available. Edit/reorder, binding replacement, suppression/restoration, PetFrame ownership, and unrelated class/special domains remain separately gated. Exact pet-button ornament/contrast is deferred to later whole-interface polish.

The final integrated Run All also exposed one unrelated Camera World/Combat transition timeout. That global regression is preserved separately by P0153 and does not erase the accepted P0152 pet result.
