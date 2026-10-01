# D.4 — Unit-Frame Interaction + Selective Suppression Review

Status: ACTIVE — SOURCE / DESIGN RESOLUTION NEXT
Opened: 2026-10-01

## Goal

Determine the smallest capability-safe unit-frame suppression that advances
immersion without removing Blizzard controls, resources, aura information, or
secure interaction that Logres has not replaced.

D.1 already rejected blanket Player/Target/Party suppression.

D.4 must resolve selective ownership per surface.

## Constraints

### Player

Do not hide or alpha-zero the full PlayerFrame.

Current unresolved dependencies include:
- class resources;
- runes;
- totems;
- pet/managed children;
- other PlayerFrame-parented gameplay surfaces.

D.4 must determine whether the conventional player portrait/health/power shell
can be suppressed independently while those children remain functional.

If not, stock PlayerFrame remains visible until Logres replaces the missing
dependencies.

### Target

Current Logres target block replaces:
- target name;
- target health percent;
- target cast cue.

It does not yet replace all stock TargetFrame behavior.

D.4 must source-resolve:
- secure left-click targeting behavior;
- right-click unit menu behavior;
- target aura/buff/debuff presentation;
- target-of-target or dependent target surfaces where applicable;
- whether the conventional shell can be selectively suppressed without
  destroying required children.

### Party

Current Logres ally rows replace compact name/health awareness.

They do not yet provide equivalent secure party interaction.

D.4 must source-resolve:
- secure click targeting/menu behavior;
- normal PartyFrame ownership;
- CompactPartyFrame / raid-style party ownership;
- aura/debuff/group-role context;
- pet/vehicle/group special cases where relevant.

## Design preference

Prefer a capability ladder rather than an all-or-nothing frame hide.

Possible outcomes:
1. suppress only decorative/conventional shell regions;
2. preserve required Blizzard children/interactions;
3. add narrowly scoped secure Logres interaction where needed;
4. retain stock surface where replacement would otherwise be incomplete.

## Combat

Any protected-frame mutation must be:
- performed out of combat;
- deferred;
- or driven by a source-proven secure mechanism.

Do not ordinary-Lua mutate protected unit-frame ownership during lockdown.

## Recovery

Immersion OFF must restore every selectively suppressed stock region exactly.

Developer panel remains independent.

## Exit

D.4 source/design review closes when it has a documented per-domain decision:

- Player: suppressible subset or explicit deferral;
- Target: suppressible subset / required secure replacement / explicit deferral;
- Party: suppressible subset / required secure replacement / explicit deferral;

with:
- combat constraints;
- restoration ownership;
- interaction preservation;
- runtime proof plan.

Do not implement blanket unit-frame suppression before this review closes.
