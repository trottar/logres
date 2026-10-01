# C.5 — Stock Action-Bar Replacement

Status: ACTIVE — SOURCE / DESIGN RESOLUTION NEXT
Opened: 2026-10-01

## Goal

Begin replacing Blizzard action-bar surfaces only where Logres already provides
a proven functional replacement.

D-017 remains authoritative:

**never hide a Blizzard surface before its Logres replacement is proven and
restorable.**

## Proven Logres coverage

Current Logres action coverage:

### Primary
- Primary action domain;
- secure execution proven;
- mouse feedback proven;
- routed-key feedback proven.

### Secondary
- slots 61–72;
- secure execution proven;
- contextual visibility proven;
- routed-key path proven.

### Utility
- slots 49–60;
- secure execution proven;
- contextual visibility proven;
- routed-key path proven.

## User's real action-bar layout

The user's actual Forever setup uses up to five stock action bars:
- Bar 1: Primary;
- Bar 2: additional / Secondary abilities;
- Bars 3–4: Utility;
- Bar 5: compact six-slot bar.

Current Logres does not yet represent all of those domains.

Therefore C.5 must not globally suppress every Blizzard action bar.

## Key-routing requirement

P0041 runtime proved an important distinction:
- stock bindings bypass Logres activation feedback;
- Logres override routing produces Logres activation feedback.

Therefore stock-bar suppression and Logres key routing are one capability
boundary.

If Logres suppresses a stock action surface:
- the corresponding Logres key-routing domain must be active;
- routing must survive normal reload/reinitialization as part of replacement
  state;
- disabling/restoring the replacement must release Logres overrides and return
  normal stock binding behavior;
- failure must release back to Blizzard rather than strand the user's keys.

Developer-only opt-in routing is not sufficient for a suppressed bar.

## First C.5 design questions

Resolve before runtime suppression:
1. Which exact Blizzard frames correspond to the three already-proven Logres
   action domains on Forever?
2. Which frames can be hidden/restored without taint or protected mutation
   during combat?
3. What replacement state owns suppression, Logres routing, and restoration?
4. Should suppression only change out of combat?
5. What happens when combat starts during a pending suppression/restoration
   request?
6. How are vehicle, override, possess, and temporary form/bonus states handled?
7. How do Bars 4–5 remain accessible while only proven domains are replaced?
8. How should D-020 future layout profiles extend suppression one domain at a
   time?
9. How does Immersion OFF restore stock action surfaces and binding behavior?
10. What diagnostics prove suppression and restoration paths?

## Initial capability gate

C.5 should start selectively.

Candidate first replacement domains:
- stock Bar 1;
- stock Bar 2;
- stock Bar 3;

only if exact Forever frame ownership and restoration are source-resolved.

Bars outside proven Logres coverage remain visible.

No all-bars suppression.

## Fail-open rule

Any failure in Logres action modules, key routing, suppression state, or special
action-state support must preserve or restore the Blizzard action path.

L-011 remains authoritative.

## Exit

C.5 completes when:
- supported stock surfaces can be suppressed safely;
- matching Logres key routing is active whenever those surfaces are replaced;
- reload behavior is deterministic;
- Immersion OFF / replacement OFF restores stock surfaces and bindings;
- unsupported action domains remain available;
- special action states have explicit fallback behavior;
- no protected/taint regression occurs.
