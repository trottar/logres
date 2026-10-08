---
memory_schema: 1
as_of: 2026-10-07
project: logres
---

# Current State

## Active Objective

**Execute Phase H.2 authored integration layout: stable semantic anchors first, then in-client spacing/collision calibration, then final whole-screen polish.**

Phase G remains complete for claimed observed scope. H.1 stock-surface suppression/coexistence is now complete for every surface Logres currently has enough replacement/restoration evidence to suppress safely.

## Current Work Item

**P0166 R1 — establish integration-owned semantic anchors without changing ownership or broad visual policy.**

P0165 R1 is durable at `0e83af06` / `0.0.82-dev` and runtime-accepted. The initial P0165 camera rebase Lua failure remains preserved as negative evidence; R1 corrected only the stale four-argument rebase call.

The initial P0166 delivery artifact was refused during shadow preflight before any tracked write because the new layout checker demanded the PetAction `Layout.Bind` call as one exact single-line fragment while the generated candidate used the intended multi-line form. P0166 R1 corrects only that checker/source self-mismatch and records it durably; runtime code, geometry, and policy are unchanged.

P0166 creates `Integration/Layout.lua` and migrates the currently production-owned Logres surfaces to named semantic anchors:
- Navigation;
- Active Quest;
- Quest Dialogue;
- Context Objective;
- Context XP;
- Player Reaction;
- Target Fallback;
- Primary Actions;
- Secondary Actions;
- Utility Actions;
- Allies;
- Class/Pet;
- Passive Status.

The authored coordinates intentionally preserve the current accepted screen geometry in this first H.2 slice. The material changes are ownership/decoupling: objective progress no longer depends on `LogresHUDTarget`, and the pet-action cluster no longer depends on `LogresHUDAllies`.

No Blizzard suppression, action routing, camera policy, source ownership, aura ownership, or secure execution behavior is expanded.

## Verified State

P0165 R1 runtime acceptance on Forever `1.60.1.70245` / runtime `0.0.82-dev`:
- camera check PASS before integrated validation with failures=0, secret=false, reactive/profile failures=0;
- Run All PASS;
- natural Fishing re-exercised the previously crashing rebase path without Lua error/sound-spam recurrence; the Fishing camera remained active and reported failures=0;
- ordinary quest offer stock suppression PASS while open with requested/applied/snapshot=true, exact source `15666a6e67938a1ab5caf041406464251db111ca`, failures=0, secrets=0, emergency=0;
- Immersion OFF/ON produced exact ownership restoration/reapplication;
- production Decline resolved through `QUEST_FINISHED` and final Run All remained clean;
- final camera diagnostics after the Fishing/quest sequence reported targetReached=true, failures=0, secret=false, error=nil.

Classification:
**P0165 R1 RUNTIME PASS; H.1 CLOSED FOR CURRENTLY REPLACEMENT-PROVEN STOCK SURFACES.**

Stock fallbacks remain authoritative for every domain not already capability-proven, including minimap, Party/CompactPartyFrame, target aura/status and target-of-target, Main/Override/special actions, PetActionBar/PetFrame, class-resource/special frames, tracker/log, persistent XP, nameplates, and unsupported quest states.

## Next Action

Apply/deploy P0166 R1 and run one bounded layout gate:
1. `/reload`;
2. `/logres layoutcheck`;
3. Phase 0 -> Run All;
4. visually inspect ordinary world state with Primary/Secondary/Utility, resource bar, allies/pet area, passive helpful auras if present, Compass, and Active Quest if naturally available;
5. trigger XP/objective previews and confirm each remains in the authored central Context region;
6. arm/show the pet-action cluster and confirm it remains in the lower-left class/pet territory without relying on ally-frame geometry;
7. report any overlap or position that is materially wrong.

Do not begin ornament/final contrast polish until the integration geometry is accepted.

## Success Criteria

P0166 succeeds when:
- all thirteen semantic anchors exist with zero bind failures;
- migrated Logres surfaces report their expected integration-owned anchor;
- objective progress has no target-frame anchor dependency;
- the pet cluster has no ally-frame anchor dependency;
- existing action routing and secure pet/action execution remain unchanged;
- no new Blizzard surface is hidden;
- current accepted geometry is visually preserved except where decoupling removes incidental dependency;
- Run All remains clean;
- no Lua, taint, protected-action, or secret-value regression appears.

## Do Not Reopen Without New Evidence

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

- `docs/memory/evidence/P0166_R0_DELIVERY_PREFLIGHT_SELF_MISMATCH_2026-10-07.md`
- `docs/memory/evidence/P0166_P0165_RUNTIME_PASS_2026-10-07.md`
- `docs/memory/evidence/P0165_R0_CAMERA_REBASE_RUNTIME_FAILURE_2026-10-07.md`
- `docs/memory/patches/P0165_QUEST_OFFER_STOCK_SUPPRESSION.md`
- `docs/memory/patches/P0166_PHASE_H2_INTEGRATION_ANCHORS.md`
- `docs/memory/architecture/WORLD_FIRST_LAYOUT.md`
- `docs/memory/decisions/D-032_WORLD_FIRST_LAYOUT_AND_ACTION_ROLES.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/ROADMAP.md`
