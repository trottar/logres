# P0416 — User-authorized five-bar geometry and role-aware context (2026-11-09)

## Authority and intake

Baseline: verified GitHub `main` P0415 `43efc89b8651d278630d48517fb6101ca4d14a74`.
The user exported `logres-action-layout-request/v1` with exact centers and
source roles in `docs/design/layout/ACTION_BARS_V1.json` (Bar 1: primary 3x4,
13/75; Bar 2: secondary 2x6, 5/75; Bar 3: utility 6x2, 90/85;
Bar 4: secondary 6x2, 10/95; Bar 5: utility 6x2, 90/95; all scale 1).
This authored layout change does not re-open arbitrary-profile product
requirements superseded by D-032. P0195/H.2 is the existing source-backed
normalized mapping precedent.

## Exact source boundary

Central immutable five-entry `Integration/Layout.lua` source profile defines
source ID, role, grid shape, and normalized center. It is consumed by
`Primary.lua`, `SecondaryUtility.lua`, and `Context.lua`. Existing secure
12-action clusters are recreated on next addon load with the changed grid
shape; action IDs, paging, action slot ranges, saved keybindings, native action
bar replacement policy, extra-bar source settings and action drag/drop are
unchanged. The existing `ActionButton.CreateCluster/Create` geometry is reused.
Context reads each source's declared role before applying the existing
world/PvP/instance/combat alpha table; Primary remains opaque.

`ApplyApprovedV4()` still handles only out-of-combat semantic anchor moves.
Before any move, it checks all five authored button extents against the ordinary
UIParent width and height and tests their separation. If a narrower viewport
cannot fit the exact approved centers, it refuses and restores the pre-P0195
static anchors, recording the reason rather than silently clipping or shifting
or inventing alternate approved coordinates. A failed SetPoint transaction
also restores baseline anchors. Existing viewport/scale/combat-end events
retry; no polling, unsafe native inspection, hidden click regions or
persistent binding writes are introduced.

## Historical contract migration

`check_h2_unified_placement_contract.py` previously required P0195's
2x6 Primary/Bar4/Bar5 literals. They are superseded ONLY for authored
five-bar geometry; its 16 integration anchors, native-aura safety, placement
fallback and no-polling requirements are preserved. `check_action_context_contract.py`
previously required fixed Secondary/Utility SetAlpha calls; it now checks
source-role-driven SetAlpha while preserving non-zero contextual alpha,
no contextual Show/Hide, secure page and native action constraints.
The new P0416 checker verifies the approved JSON, exact five-source roles,
secure action/binding invariants, no extra Lua modules and OOC geometry guard.

## Related failures held separately

L-008: user screenshot November 9 shows Blizzard PetFrame/PetActionBar
reappearing while Immersion ON; user reports `/reload` and panel controls did
not correct it. Current `PetBarVisibilityTrial.lua` owns the constant-hide
secure drivers, while `NativeSurfaceReplacement.Ready` leaves both pet
surfaces stock. P0211/P0212 show an earlier reload failure and bounded visual
recovery. Cause of this recurrence is **OPEN / UNREPRODUCED**; do not add
polling, force hide, reparent or change pet code as part of this layout patch.
Request in-game Phase H Native Pet Bar Check, Native Access Check, Pet State
Diagnostic, and Phase C Pet Action Probe Check while the failure is present;
export Report Bug diagnostics without first toggling visibility.

## Test evidence and gate

Author-side script must verify the exact baseline source, construct the full
post-change candidate and run all historic `tools/check_*.py`, the new P0416
checker, syntax and whitespace validation. Static pass does not prove WoW
Forever UI runtime or click behavior. In-game test must capture full-screen
view at current resolution, interaction/keyboard/routed clicks for all five
clusters, enabled/disabled Bar 4/5, Immersion OFF/ON, action editing fallback,
UI-scale resize and normal combat deferral. Preserve any overlapping menu,
clipped frame, missing action, taint or protected error as FAIL and do not
close L-009 until a scoped player-visible result.
