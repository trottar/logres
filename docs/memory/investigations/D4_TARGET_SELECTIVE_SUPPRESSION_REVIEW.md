# D.4 — Target Selective Suppression Review

Status: ACTIVE — SOURCE / DESIGN RESOLUTION NEXT
Opened: 2026-10-01

## Goal

Resolve the next D-026 unit-frame capability:

**secure Logres target interaction + selective TargetFrame suppression**

without losing useful target auras, raid-marker coordination, or secure unit
interaction.

## Existing Logres target capability

Already proven:
- target name;
- target health percent;
- target cast cue.

Intentionally hidden by policy:
- exact target level;
- classification / explicit difficulty metadata;
- conventional portrait/health-bar presentation.

## Source constraints already established

Current TargetFrame separates:
- conventional container/main content;
- contextual content;
- aura container;
- raid-target marker;
- other contextual indicators.

The stock frame is also a secure unit button.

Therefore the target replacement cannot be implemented as a blanket
TargetFrame Hide/alpha-zero.

## Review questions

Resolve before runtime code:

1. Which exact TargetFrame children constitute the conventional shell and can
   be suppressed safely?
2. Which exact child owns target auras and can remain visible independently?
3. Which exact child owns the raid-target marker and can remain visible?
4. Which contextual indicators expose level/classification/difficulty metadata
   that Logres must suppress by design?
5. Can Blizzard's aura/raid-marker children remain usable when main target
   content is selectively suppressed?
6. What stock TargetFrame mouse/click state must be disabled?
7. What secure Logres target interaction surface should replace it?
8. Should secure target visibility use `RegisterUnitWatch()`?
9. What combat-time transitions must defer?
10. What exact restoration snapshot is required?

## Expected secure Logres target interaction

Likely secure contract:
- `SecureUnitButtonTemplate`;
- `unit=target`;
- left click -> target;
- right click -> togglemenu;
- secure unit watch for target existence;
- visible association with the Logres target name/health affordance.

This must be source-confirmed before implementation.

## Preferred outcome

Target selective replacement should preserve useful world information through
Blizzard children only where Logres has not yet replaced them:
- target auras;
- raid-target marker.

It should suppress:
- portrait/frame shell;
- conventional health/power bars;
- level/classification-style metadata;
- other stock metadata that conflicts with Logres information-hiding policy.

## Exit

This source/design review closes when the repository has an exact child-path
contract for:
- suppress;
- preserve;
- secure interaction;
- combat deferral;
- restoration;
- runtime proof.

Do not write TargetFrame suppression code until this review closes.
