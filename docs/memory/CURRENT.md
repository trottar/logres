---
memory_schema: 1
as_of: 2026-10-05
project: logres
---

# Current State

## Active Objective

**Correct P0152 on the established shared action-button infrastructure, then prove pet execution/autocast while Blizzard fallback remains usable.**

Formal Phase G / G.5 remains open and paused while the approved visual sequence is finished.

## Current Work Item

**P0152 R7 — shared-action pet adapter execution/range/layout correction on candidate runtime `0.0.74-dev`; runtime retest required.**

Latest verified durable checkpoint:
P0151 `b62397b116cf028326167b7f8bf7010ed94f3717`.

Current accepted runtime:
`0.0.73-dev` on Forever `1.60.1.70235` — P0150 read-only class/pet/special probe PASS for the observed scope with environmental deferrals.

P0152 R1 is preserved as a **real runtime/control/visual FAIL**:
- it duplicated the proven action-button infrastructure with a bespoke pet strip;
- only one pet ability rendered correctly;
- custom number labels were misleading;
- a bespoke yellow `A` marker was inappropriate;
- left click did not execute the intended pet command;
- stock PetActionBar remained the functional fallback.

P0152 R2 corrected the implementation design but was refused during exact prepared-candidate validation before tracked writes because its generated `CURRENT.md` and handoff violated the mandatory memory schema. The shared-action runtime candidate itself had already passed all checkers reached before `check_memory_health.py`.

P0152 R3 then applied the shared-action adapter successfully but failed immediately on `/reload`: `PetActionExecutionProbe.lua:417` attempted to index local upvalue `ActionButton`, which was nil. Cause: the TOC loaded `HUD\PetActionExecutionProbe.lua` before `Actions\Button.lua`, so the module captured `Logres.ActionButton` before the shared action primitive existed. This is a real runtime load-order/integration failure; it does not disprove the secure pet-action path.

P0152 R4 changes only dependency order: `Actions\Button.lua` loads before `HUD\PetActionExecutionProbe.lua`, and the P0152 static contract now enforces `Button < PetProbe < Primary`.

P0152 R4 then reached the shared-action UI but failed usability validation because the temporary pet row at `y=-190` overlapped the established player action clusters. R5 moved it to `y=-120`, but that coordinate directly overlaps the established player resource bar at `y=-118`. R5 also exposed a more important control failure: hardware left click on the Logres pet button triggered Blizzard's protected-action block. The direct addon secure `type1="pet"` / `action1=slot` path is therefore **runtime-failed on Forever 70235 in this implementation** and must not be treated as proven.

P0152 R6 keeps the established shared action-button presentation but changes the protected control boundary:
- `Logres.ActionButton.CreateCluster` / `ActionButton.Create` still own button geometry, art, cooldown frame, checked treatment, hover/press/activation feedback, and sizing;
- ten pet slots remain in stock left-to-right order;
- no custom slot-number labels and no yellow `A` marker;
- Logres pet buttons use secure `type="click"` delegation to the corresponding Blizzard `PetActionBar.actionButtons[slot]`, so Blizzard owns both protected left-click execution and right-click autocast mutation;
- direct Logres `CastPetAction` / `TogglePetAutocast` calls remain forbidden;
- the temporary pet row anchors below `LogresHUDResourceBar` with an 18px gap, placing it in the known gap above the primary action cluster rather than using a guessed absolute Y coordinate;
- pet token textures resolve through Blizzard token globals without interpreting the ambiguous `isToken` runtime payload;
- ordinary active/autocast state uses the shared button presentation;
- stock PetActionBar remains visible and usable.


P0152 R6B then reached the correct pet-slot/icon mapping without Lua/protected errors, but runtime validation still failed: secure click delegation to Blizzard pet buttons was inert; every pet icon was tinted red because the adapter treated `inRange=false` as authoritative even when `checksRange` was false; and the ten-wide row still intruded into the central player-action territory. This is a real runtime adapter failure, while the slot/presentation mapping itself is accepted.

P0152 R7 keeps the proven shared presentation and correct slot mapping, removes secure click delegation, and retries the source-supported `type1="pet"` path **without the R5 insecure `PreClick` hook**. Baseline state is captured during ARM, so no addon code runs before secure execution. Right-click autocast uses secure `type2="macro"` plus `/petautocasttoggle <ordinary pet spell name>` only for autocast-capable slots. Range tint now requires `checksRange=true`, and the pet cluster moves to D-032's lower-left class/pet territory as a 5x2 cluster anchored below `LogresHUDAllies`.

Still excluded: drag/reorder/edit, keybinding replacement, PetActionBar suppression/restoration, PetFrame ownership, and unrelated class/special controls.

## Verified State

P0150 R3 remains runtime PASS at `46e06295` / `0.0.73-dev`: 22/22 expected events/APIs, pet 10/7 populated, one safe secret power skip, ordinary false special-mode flags, zero failures, and separate Run All PASS.

P0149 / D-044 source policy remains authoritative. Forever 70235 source is continuous with the audited 70205 secure pet paths; `SecureTemplates.lua` confirms secure `type="pet"` resolves the modified `action` attribute and calls `CastPetAction` internally.

The established Primary and Secondary/Utility action systems remain the authoritative action-button infrastructure. P0152 must specialize that infrastructure rather than create a parallel button system.

All other accepted production baselines and existing navigation/aura/world-target/party/camera deferrals remain unchanged.

## Next Action

Apply P0152 R7 directly over the current P0152 R6B working tree, redeploy, `/reload`, then:
1. Phase H -> **Pet Action Probe ARM** while out of combat;
2. verify populated pet abilities render with the normal Logres action-button styling and the same left-to-right slot order as the stock PetActionBar;
3. verify there are no custom numeric overlays or yellow `A` marker;
4. left-click an inactive Follow/Stay-type Logres pet slot and confirm the pet visibly changes state;
5. right-click an autocast-capable pet ability such as Torment and confirm autocast toggles;
6. run **Pet Action Probe Check** and require zero failures plus secure-click/event/state-change evidence;
7. run **Pet Action Probe Hide** out of combat;
8. run **Run All** separately;
9. upload refreshed diagnostics.

Any Lua, secret-value, taint/protected-action error, missing shared-action presentation, wrong slot mapping, failed left click, failed supported autocast toggle, or stock PetActionBar loss is a real failure.

## Success Criteria

P0152 succeeds only if:
- pet buttons visibly reuse the established Logres action-button language and geometry;
- all naturally populated pet slots appear in correct stock order;
- left-click execution works through the taint-minimized secure `type1="pet"` path with no insecure PreClick hook;
- an ordinary active-state transition plus addon-owned click/event evidence is captured;
- right click uses the secure macro path and toggles autocast for an ordinary autocast-capable slot without affecting non-autocast slots;
- stock PetActionBar remains usable throughout;
- no direct `CastPetAction` or `TogglePetAutocast` call is introduced in Logres runtime code;
- no edit/reorder/binding/suppression/PetFrame ownership is added;
- separate integrated regression checks remain clean.

## Do Not Reopen Without New Evidence

- no conventional player health bar;
- harmful/urgent player and populated target aura production remain deferred;
- positive world-target nameplate anchoring/attachment remains deferred;
- individual tracking-result positions remain source-blocked by P0142/D-043;
- stock minimap remains until replacement completeness is proven;
- party/CompactPartyFrame remain stock until secure interaction and required group/aura information are replaced safely;
- PetFrame remains stock independent of pet-action work;
- RuneFrame, TotemFrame, alternate-power, direct class-resource children, stance/form, and unsupported special-control surfaces remain Blizzard-owned until separately runtime/capability-proven;
- possess/override/vehicle/extra-action surfaces are not ordinary Bar 2–3 roles;
- Continue/Complete/reward/gossip quest ownership remains separately gated;
- P0119 Taxi landing retest remains pending/frozen;
- no max-distance CVar mutation, Taxi rotation, or Taxi UI fade is authorized.

## Relevant References

- `docs/memory/decisions/D-044_CLASS_PET_SPECIAL_CONTROL_SOURCE_AND_FALLBACK_POLICY.md`
- `docs/memory/evidence/P0151_P0150_CLASS_PET_SPECIAL_RUNTIME_PASS_2026-10-05.md`
- `docs/memory/evidence/P0152_R1_RUNTIME_CONTROL_VISUAL_FAIL_2026-10-05.md`
- `docs/memory/evidence/P0152_R2_DELIVERY_MEMORY_SCHEMA_FAIL_2026-10-05.md`
- `docs/memory/evidence/P0152_R3_RUNTIME_LOAD_ORDER_FAIL_2026-10-05.md`
- `docs/memory/evidence/P0152_R4_RUNTIME_LAYOUT_OVERLAP_FAIL_2026-10-05.md`
- `docs/memory/evidence/P0152_R5_RUNTIME_PROTECTED_CLICK_RESOURCE_OVERLAP_FAIL_2026-10-05.md`
- `docs/memory/evidence/P0152_R6_DELIVERY_BASELINE_HASH_FAIL_2026-10-05.md`
- `docs/memory/evidence/P0152_R6B_RUNTIME_EXECUTION_RANGE_LAYOUT_FAIL_2026-10-05.md`
- `docs/memory/investigations/FUTURE_CLASS_PET_SPECIAL_CONTROL_CAPABILITY.md`
- `docs/memory/patches/P0152_SECURE_PET_ACTION_EXECUTION_PROBE.md`
- `docs/memory/architecture/VISUAL_IMPLEMENTATION_STATUS.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/ROADMAP.md`
