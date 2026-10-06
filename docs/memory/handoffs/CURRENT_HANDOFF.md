# Current Handoff

Authoritative state:
`../CURRENT.md`.

Latest verified durable checkpoint:
P0151 `b62397b116cf028326167b7f8bf7010ed94f3717`.

Current accepted runtime:
`0.0.73-dev` on Forever `1.60.1.70235` — P0150 read-only class/pet/special runtime PASS with environmental deferrals.

## Active work stream

**P0152 R7 — shared-action pet adapter execution/range/layout correction on candidate `0.0.74-dev`; runtime retest required.**

R1 is a preserved runtime/control/visual failure because it built a bespoke pet strip instead of reusing `Logres.ActionButton`. R2 corrected the runtime architecture but was refused pre-write when its generated CURRENT/handoff violated the mandatory memory schema. R3 keeps the same R2 runtime adapter and repairs the memory delivery only.

R3 then failed immediately on `/reload`: `PetActionExecutionProbe.lua` loaded before `Actions/Button.lua`, so its local `ActionButton = Logres.ActionButton` captured nil. R4 keeps the shared-action adapter unchanged and only moves the probe after `Actions/Button.lua`; the static contract now enforces the dependency order.

R4 then rendered correctly through the shared action infrastructure but overlapped the player action clusters. R5 moved the row to `y=-120`, which directly overlaps the established resource bar at `y=-118`; hardware left click also triggered Blizzard's protected-action block. The direct addon `type1="pet"` path is therefore preserved as a runtime failure on this client.

R6 keeps the established Logres action-button geometry/art/feedback path but delegates both left and right hardware clicks securely to the corresponding Blizzard `PetActionBar.actionButtons[slot]`. Blizzard therefore owns protected pet execution and autocast mutation while Logres owns presentation. The row anchors below `LogresHUDResourceBar` with an 18px gap, which places it in the known gap above the primary action cluster. Stock PetActionBar remains fallback. No edit/reorder/binding/suppression/PetFrame ownership is added.

## Runtime proof

After R6 deployment and `/reload`:
1. Phase H -> **Pet Action Probe ARM** out of combat;
2. confirm populated icons/order and normal Logres action-button presentation; no custom numbers or yellow `A`;
3. left-click an inactive Follow/Stay-type slot and visibly confirm the pet changes state;
4. right-click an autocast-capable ability and confirm autocast toggles;
5. Phase H -> **Pet Action Probe Check**; require zero failures and click/event/state-change evidence;
6. Phase H -> **Pet Action Probe Hide**;
7. Phase 0 -> **Run All**;
8. upload diagnostics.

Any Lua/secret/taint/protected-action error, wrong slot mapping, failed secure click, failed supported autocast toggle, or stock PetActionBar loss is a failure.

## Key references

- `../CURRENT.md`
- `../decisions/D-044_CLASS_PET_SPECIAL_CONTROL_SOURCE_AND_FALLBACK_POLICY.md`
- `../evidence/P0151_P0150_CLASS_PET_SPECIAL_RUNTIME_PASS_2026-10-05.md`
- `../evidence/P0152_R1_RUNTIME_CONTROL_VISUAL_FAIL_2026-10-05.md`
- `../evidence/P0152_R2_DELIVERY_MEMORY_SCHEMA_FAIL_2026-10-05.md`
- `../evidence/P0152_R3_RUNTIME_LOAD_ORDER_FAIL_2026-10-05.md`
- `../evidence/P0152_R4_RUNTIME_LAYOUT_OVERLAP_FAIL_2026-10-05.md`
- `../evidence/P0152_R5_RUNTIME_PROTECTED_CLICK_RESOURCE_OVERLAP_FAIL_2026-10-05.md`
- `../investigations/FUTURE_CLASS_PET_SPECIAL_CONTROL_CAPABILITY.md`
- `../patches/P0152_SECURE_PET_ACTION_EXECUTION_PROBE.md`
- `../architecture/VISUAL_IMPLEMENTATION_STATUS.md`
- `../roadmap/PHASE_H_INTEGRATION_POLISH.md`

## R6B runtime failure / R7 correction

R6B proved that pet-slot discovery, icon resolution, ordering, and shared Logres presentation are now correct. Runtime still failed in three narrower ways: secure click delegation to Blizzard pet buttons did nothing; all pet icons were red because range tint ignored `checksRange`; and the ten-wide row still intruded into the central action region.

R7 preserves the accepted mapping/presentation. It returns left click to the source-supported secure `type1="pet"` / `action1=slot` path but removes the R5 insecure PreClick hook entirely; ARM captures baseline state before the click. Right-click autocast is a secure macro configured out of combat only for ordinary autocast-capable pet abilities. Range tint now requires `checksRange=true`. Layout becomes a 5x2 cluster in D-032's lower-left class/pet territory, anchored below `LogresHUDAllies` and left of Secondary.
