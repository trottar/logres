---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase D — Immersion Controller.**

## Current Work Item

**D.5 — Context / PvP / instance orchestration runtime validation.**

D.5 source/design review is complete.

## Verified State

- Phase 0 complete.
- Phase A complete.
- Phase B complete.
- Phase C complete.
- D.1 complete.
- D.2 complete.
- D.3 complete.
- D.4 complete for supported Player + Target selective replacement.
- Party/CompactPartyFrame suppression remains capability-deferred.
- P0058 pushed at `eba9998`.
- runtime remains `0.0.25-dev`.
- D-028 context orchestration matrix accepted.
- current ImmersionController already matches the first-pass D-028 ownership
  matrix.
- Bar 2–3 replacement remains ON across world/instance/combat/PvP whenever
  immersion is ON.
- Player selective replacement remains ON across those states whenever
  immersion is ON.
- Target selective replacement remains ON across those states whenever
  immersion is ON.
- Quiet Mode is ON only in world context while immersion is ON.
- Party suppression remains OFF in all states.
- ActionContext precedence remains:
  `combat > PvP > instance > world`.
- `instanceType` remains observed but does not alter D.5 first-pass policy.
- mounted/resting/taxi/interacting do not alter current Phase D suppression.
- TargetFrame intermittent reappearance remains OPEN / UNREPRODUCED.
- future Aura / Status Presentation domain remains deferred.
- Primary replacement/routing ownership remains deferred.
- D-020 live action editing remains deferred.
- cast cue color regression remains open visual debt.

## Next Action

Implement D.5 integrated runtime diagnostics.

Add a `Context Policy Check` to the developer panel / command path.

It should validate:
1. State context/combat/PvP snapshot exists;
2. ImmersionController desired action ownership matches immersion preference;
3. Quiet Mode desired state is `immersion && context == world`;
4. Player desired ownership matches immersion preference;
5. Target desired ownership matches immersion preference;
6. Party desired ownership is false;
7. ActionContext policy matches:
   - combat first;
   - then PvP;
   - then instance;
   - otherwise world;
8. no secret/protected UI state is inspected.

No behavioral policy change is required unless runtime proof exposes one.

## Success Criteria

D.5 runtime validation succeeds when:
- world idle policy passes;
- combat transition resolves combat presentation without replacement churn;
- PvP transition resolves PvP presentation when not in combat;
- world/instance transition changes Quiet Mode only among current supported
  replacement domains;
- unsupported Party remains stock;
- Immersion OFF restores supported replacement ownership;
- no Lua/taint/secret regression occurs.

Instance proof may remain environmental if no natural instance transition is
available.

## Do Not Reopen Without New Evidence

- **D.1–D.4 supported scope:** complete.
- **D.5 source/design:** complete; D-028 canonical.
- **Party suppression:** capability-deferred.
- **TargetFrame intermittent reappearance:** open/unreproduced.
- **Aura/status suppression:** deferred design domain.
- **Whole PlayerFrame / TargetFrame suppression:** rejected.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/D5_CONTEXT_ORCHESTRATION_SOURCE_REVIEW_2026-10-01.md`
- `docs/memory/decisions/D-028_CONTEXT_ORCHESTRATION_MATRIX.md`
- `docs/memory/investigations/D5_CONTEXT_PVP_INSTANCE_ORCHESTRATION.md`
- `Logres/Core/State.lua`
- `Logres/Immersion/Controller.lua`
- `Logres/Actions/Context.lua`
- `docs/memory/DESIGN_PRINCIPLES.md`
