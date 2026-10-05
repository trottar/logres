# Future Class / Pet / Special-Control Capability Audit

Status: **OPEN — P0149 SOURCE/CAPABILITY AUDIT AFTER P0148 DEPTH VISUAL ACCEPTANCE**
Opened: 2026-10-05

## Why this exists

The approved visual system covers the shared action-button language and reserves
space for class/pet/special controls, but ownership is intentionally incomplete.
These domains must not be treated as ordinary Bar 1–3 replacements.

Canonical visual inventory separates:
- pet action cluster;
- stance/form cluster;
- totem/class-special cluster;
- rune/class-resource presentation;
- combo-point / discrete-pip presentation;
- possess/override/vehicle/special controls.

D-026 and the current player-shell replacement deliberately preserve direct player
class-resource children, RuneFrame, TotemFrame, PetFrame, alternate-power, and
unknown/unproven children.

## P0149 audit questions

Pin the exact Forever `1.60.1.70205` matching source generation and resolve, per
domain:

1. **Information source**
   - what ordinary state can be read;
   - whether values are secret-capable;
   - what event model invalidates the state;
   - whether discrete mechanics must stay discrete rather than percentage-based.

2. **Action/control ownership**
   - secure button/action type or native control path;
   - paging/state-driver semantics where applicable;
   - combat-lockdown restrictions;
   - whether the control can be safely reproduced or routed by Logres.

3. **Blizzard presentation / fallback**
   - what stock frame/control owns the current presentation and interaction;
   - whether presentation and interaction can be separated safely;
   - exact restoration requirements;
   - fail-open behavior when Logres cannot own the domain.

4. **Scope separation**
   - pet actions are not ordinary Primary/Secondary/Utility bars;
   - stance/form and totem/class-special controls are not generic action-grid slots;
   - class-resource presentation is distinct from secure action mutation;
   - possess/override/vehicle surfaces retain stock fallback unless separately
     capability-proven.

## Standing constraints

Until a later capability checkpoint proves otherwise:
- do not suppress RuneFrame;
- do not suppress TotemFrame;
- do not suppress PetFrame;
- do not suppress alternate-power presentation;
- do not suppress unknown/direct player class-resource children;
- do not suppress possess/override/vehicle controls;
- do not route unsupported special actions through the ordinary Bar 2–3 replacement;
- do not force discrete class mechanics into the shared percentage-bar primitive.

Protected setup/mutation must remain combat-safe and fail open to stock UI.

## Expected P0149 result

After P0148 is visually accepted, produce a per-domain capability matrix and identify the smallest justified runtime
probe or production slice, if any. Source evidence alone does not authorize stock
suppression.
