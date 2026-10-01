# D-017 — Blizzard UI suppression and restoration ownership

Status: ACCEPTED
Date: 2026-10-01

## Problem

During Phase B, Logres replacement HUD elements were intentionally built and validated while the stock Blizzard UI remained visible.

The roadmap did not explicitly state when the stock UI would be hidden.

That ambiguity is removed by this decision.

## Principle

Logres must not hide a Blizzard surface before a functional Logres replacement exists and has been validated.

Suppression is therefore capability-gated.

Restoration must be deliberate and reliable.

## Ownership matrix

### Phase C — Action Interface

Owns replacement of:
- primary Blizzard action bars;
- secondary/utility action presentation where Logres has equivalent secure controls.

Phase C proves secure action-button behavior and combat-lockdown-safe visibility/layout rules before stock action bars are suppressed.

### Phase D — Immersion Controller

Owns global suppression/restoration orchestration.

Initial Phase D stock-UI targets include:
- Blizzard player frame;
- Blizzard target frame;
- Blizzard focus/related stock frame only if Logres has a justified replacement;
- Blizzard party frames where Logres party presentation is active;
- chat frames/tabs through Quiet Mode where permitted;
- action-bar suppression once Phase C replacement is proven.

Phase D also owns:
- immersion OFF restoration;
- context-sensitive exceptions;
- instance/PvP policy;
- module-level restoration behavior.

### Phase E — Compass and Navigation

Owns minimap/navigation suppression only after Logres compass/navigation replacement is sufficient for the current context.

Do not remove required navigation without a viable replacement.

### Phase F — Quest Experience

Owns suppression/replacement of:
- stock quest tracking/presentation where Logres provides equivalent awareness;
- persistent XP bar where Logres contextual XP presentation replaces it.

### Phase G — Camera

Does not suppress Blizzard UI by itself.

It participates in Phase D presentation policy.

### Phase H — Integration and Polish

Finalizes:
- suppression defaults;
- user overrides;
- accessibility exceptions;
- compatibility fallbacks;
- restoration failure handling.

## Restoration rule

Immersion OFF must provide a safe route back to usable Blizzard UI where suppression has been applied.

A Logres replacement must never leave the player without required controls because the stock UI was hidden prematurely.

## Developer panel

The developer/control panel is exempt from immersion suppression during development so it can restore settings and run diagnostics.

Final product behavior for developer tooling may change later.

## Result

Current Phase B state is expected to show both:
- Blizzard UI;
- Logres Phase B HUD.

That is not the intended final presentation.

It is the validated transitional state before Phases C/D begin replacement and orchestration.

## D.1 refinement

Phase D source review found that "replacement exists" must include interaction
and dependent-child capability, not only visual information.

Stock unit frames are secure click surfaces.

Full PlayerFrame suppression would also suppress class-resource / rune / totem /
pet children.

Therefore D.2 does not immediately hide Player/Target/Party.

D-024 defines the capability gate and revised implementation order.
