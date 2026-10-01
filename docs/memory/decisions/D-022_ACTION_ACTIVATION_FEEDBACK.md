# D-022 — Action activation feedback

Status: ACCEPTED
Date: 2026-10-01

## Decision

A Logres action button must visibly respond when the player uses it.

GCD, cooldown, range, and usability state are not sufficient activation
feedback by themselves.

## Required first-pass feedback

Each secure action button provides:

1. **pressed state**
   - conventional pushed/depressed visual while physically clicking;

2. **activation pulse**
   - brief additive flash after the secure click path fires;
   - applies to mouse and Logres-routed keyboard execution.

## Scope

The pulse confirms:

**the Logres button was activated**

It does not claim:

**this exact button is the currently casting spell**

Ongoing cast/channel state remains represented by the separate cast cue until
a dedicated secret-safe action-to-cast association is justified.

## Visual language

Keep it restrained:
- brief;
- neutral warm activation;
- no giant proc glow;
- no extra text;
- no timing bar.

Final art may change later.

The functional requirement remains:
action use must have immediate local feedback.

## Suppression gate

Do not suppress Blizzard action bars until this feedback is runtime-proven.

The stock action interface currently supplies a pressed-state affordance that
must not disappear without a Logres replacement.
