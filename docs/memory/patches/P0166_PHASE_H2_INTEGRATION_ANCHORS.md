# P0166 — Phase H.2 integration anchors

Status: R1 PREPARED — R0 PREFLIGHT SELF-MISMATCH CORRECTED
Candidate runtime: `0.0.83-dev`
Baseline: `0e83af06cd03ea18671ff52ef8772bf2a4b8818a`

## Purpose

Begin Phase H.2 with stable integration-owned semantic anchors while preserving the accepted screen geometry and every existing ownership boundary.

## R0 delivery failure / R1 correction

The initial P0166 delivery artifact was refused during the shadow preflight before
any tracked file was written. `check_layout_integration_contract.py` required the
PetAction integration call as one exact single-line string, while the prepared
candidate intentionally formatted that call across multiple lines. The checker
therefore rejected its own generated candidate even though the semantic call was
present.

R1 changes only the static contract to validate the multi-line call with a
whitespace-tolerant regex, plus records this delivery failure durably. The runtime
candidate, layout policy, coordinates, ownership boundaries, and candidate version
remain unchanged.

## Runtime changes

Adds `Logres/Integration/Layout.lua` with thirteen semantic anchors:
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

Migrated production surfaces bind to these anchors.

Two incidental dependencies are removed:
- Objective Progress no longer anchors to `LogresHUDTarget`;
- Pet actions no longer anchor to `LogresHUDAllies`.

The authored coordinates are intentionally the existing accepted positions for this first H.2 checkpoint. Calibration happens from runtime visual evidence rather than by changing every coordinate at once.

## Non-goals

No new Blizzard suppression.
No action source/routing change.
No pet secure-execution change.
No camera policy change.
No aura/source expansion.
No arbitrary dragging/layout editor.

## Validation

Static:
- complete repository checker suite;
- new `check_layout_integration_contract.py`;
- updated objective-progress and pet-action contracts;
- `git diff --check`.

Runtime:
- `/logres layoutcheck`;
- Run All;
- ordinary world visual review;
- XP/objective Context preview;
- pet lower-left placement check.
