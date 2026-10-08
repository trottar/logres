---
memory_schema: 1
as_of: 2026-10-07
project: logres
---

# Current State

## Active Objective

**Execute Phase H.2 authored integration layout: close the developer-panel access defect, then perform in-client spacing/collision calibration, then final whole-screen polish.**

Phase G remains complete for claimed observed scope. H.1 stock-surface suppression/coexistence remains complete for every surface Logres currently has enough replacement/restoration evidence to suppress safely.

## Current Work Item

**P0167 R2 — register Layout Check in the Phase H developer panel without changing layout geometry or ownership.**

P0166 R1 is durable at `a67e0cce` / `0.0.83-dev` and structurally runtime-accepted:
- integrated Run All reports `layoutcheck: PASS` with `anchors=13`, `binds=15`, `failures=0`, `missing=0`, `mismatched=0`;
- XP and Objective Progress preview paths execute cleanly;
- the pet-action cluster reports integration anchor `classPet`;
- integrated camera, suppression, action, restoration, and Compass checks remain clean in the accepted run.

The user then identified a real integration defect: `Layout Check` was not available as a Phase H panel action. Repository inspection confirms the slash command and Run All integration exist, but no `RegisterDevPanelAction` entry was added. Phase H was already at its 15-action panel capacity.

The first P0167 delivery artifact failed during candidate construction before any tracked write because its applier assumed a P0166 section already existed in `docs/memory/investigations/ACTIVE.md`. The pushed authoritative file did not contain that heading. R1 removed that false assumption, but R1 itself then failed before checker execution or tracked writes because one generated evidence `write()` call passed four positional arguments to a three-argument helper; its ZIP also contained generated Python bytecode. R2 corrects both delivery defects, preserves both failures as negative evidence, and synchronizes the older P0131 panel-phase checker so the complete suite agrees with the deliberate TEST-probe move.

P0167 R2 fixes only that access defect:
- add `Layout Check` to Phase H;
- move the two legacy `TEST Accept Current Quest` / `TEST Decline Current Quest` capability probes from H to their natural Phase F Quest Experience tab;
- keep panel capacity within the existing 15-action limit;
- leave all layout anchors, coordinates, Blizzard suppression, secure routing, camera policy, and capability ownership unchanged.

Candidate runtime: `0.0.84-dev`.

## Verified State

P0166 structural runtime evidence on Forever `1.60.1.70245` / runtime `0.0.83-dev`:
- Run All completed with all included checks PASS;
- layout diagnostic: `anchors=13`, `binds=15`, `failures=0`, `missing=0`, `mismatched=0`;
- Objective Progress had one live super-tracked quest row and its preview path passed;
- XP preview passed;
- pet-action ARM reported `anchor:classPet`, seven occupied slots, zero failures/secrets;
- camera diagnostics remained PASS with zero failures/secrets.

Classification:
**P0166 STRUCTURAL RUNTIME PASS. WHOLE-SCREEN VISUAL SPACING/COLLISION CALIBRATION REMAINS OPEN.**

The missing Phase H panel registration is a separate product/tooling defect, not a failure of the integration anchors themselves.

## Next Action

Apply/deploy P0167 R2 and run one bounded panel gate:
1. `/reload`;
2. open Phase H and run **Layout Check** from the panel; require PASS with `anchors=13`, `failures=0`, `missing=0`, `mismatched=0`;
3. Phase 0 -> Run All; require clean completion;
4. open Phase F and confirm the two legacy quest-offer TEST probe buttons are still available there; do not invoke them merely for this gate;
5. require no Lua, taint, protected-action, or secret-value regression.

After P0167 is accepted, proceed directly to H.2 whole-screen spacing/collision calibration. Do not reopen anchor ownership unless new evidence requires it.

## Success Criteria

P0167 R2 succeeds when:
- Phase H visibly contains a `Layout Check` button;
- that button runs the existing non-mutating layout diagnostic and passes;
- Phase H stays within panel capacity;
- the legacy quest-offer TEST probes remain reachable under Phase F;
- Run All remains clean;
- runtime version is synchronized at `0.0.84-dev`;
- no layout coordinate, suppression, routing, camera, or secure-execution behavior changes.

## Do Not Reopen Without New Evidence

- P0166 integration-anchor ownership is accepted for structural/runtime scope;
- P0165 R1 ordinary quest-offer Accept/Decline stock suppression is accepted for tested scope;
- PvP-confirmation and auto-accept quest offers remain Blizzard-owned;
- existing Quiet Mode, Player shell, Target selective suppression, and Bar 2–3 replacement remain accepted for tested scopes;
- no conventional player health bar;
- PvP is a modifier, not Immersion OFF;
- stock minimap, Party/CompactPartyFrame, target aura/status, target-of-target, PetFrame/PetActionBar, Main/Override/special action surfaces, unsupported class/special surfaces, alternate power, RuneFrame, TotemFrame, Objective Tracker, persistent XP, nameplates, and unsupported quest states remain available until separately replaced;
- player harmful/urgent and populated target aura production remain deferred;
- positive world-target nameplate attachment remains deferred;
- individual tracking-result positions remain source-blocked by D-043.

## Relevant References

- `docs/memory/evidence/P0167_P0166_RUNTIME_PASS_2026-10-07.md`
- `docs/memory/evidence/P0167_R0_DELIVERY_ACTIVE_ANCHOR_FAILURE_2026-10-07.md`
- `docs/memory/evidence/P0167_R1_DELIVERY_WRITE_ARITY_FAILURE_2026-10-07.md`
- `docs/memory/evidence/P0166_R0_DELIVERY_PREFLIGHT_SELF_MISMATCH_2026-10-07.md`
- `docs/memory/patches/P0166_PHASE_H2_INTEGRATION_ANCHORS.md`
- `docs/memory/patches/P0167_LAYOUT_CHECK_PANEL_REGISTRATION.md`
- `docs/memory/architecture/WORLD_FIRST_LAYOUT.md`
- `docs/memory/decisions/D-032_WORLD_FIRST_LAYOUT_AND_ACTION_ROLES.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/ROADMAP.md`
