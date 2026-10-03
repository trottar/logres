# G.4 — City Camera Ownership

Status: ACTIVE — CONTRACT REVIEW; NO RUNTIME CODE YET
Opened: 2026-10-03

## Objective

Define the smallest deliberate City/resting camera slice that can extend the
runtime-proven G.3 ownership model without importing unrelated DynamicCam
presentation behavior.

## Starting evidence

G.1 captured the current DynamicCam `RPG` profile and maps situation 001 to City:
- activation meaning: resting;
- priority: 1;
- enabled;
- stored enter transition: 2.5 seconds;
- `zoomType = in` with target 5 only when currently farther than 5;
- DynamicCam UI hide/fade enabled at opacity 0.65;
- reactive-zoom overrides also stored.

Canonical profile evidence:
`../evidence/G1_DYNAMICCAM_PROFILE_CAPTURE_2026-10-02.md`.

G.3 already proves that live World (Combat) selection must use
`UnitAffectingCombat("player")` and has higher precedence than ordinary World.
The same precedence must remain true when the resting/City slice is introduced.

## Narrow hypothesis

The camera-only City slice can likely reuse the proven resting sensor and G.3
MoveView transition architecture while treating DynamicCam's City UI hide/fade
behavior as a separate Logres presentation-policy question.

This is a hypothesis, not yet an implementation decision.

## Questions to resolve before code

1. Confirm exact City enter/exit zoom semantics from the captured JSON and
   DynamicCam source behavior rather than inferring omitted fields.
2. Confirm context precedence: live World (Combat) must win over resting/City
   while combat is true.
3. Decide whether City camera ownership should only own zoom in G.4 or whether
   any reactive-zoom override is necessary for semantic equivalence.
4. Keep DynamicCam City UI hide/fade out of the camera slice unless repository
   presentation policy deliberately adopts an equivalent Logres-owned behavior.
5. Define interruption/relinquish behavior by reusing the proven G.3 fail-open
   ownership model rather than adding polling or broad hooks.

## Explicit exclusions

G.4 does not yet authorize runtime code for:
- Taxi;
- Hearth/Teleport;
- NPC Interaction;
- Fishing;
- AFK;
- Gathering;
- rotation;
- shoulder offsets;
- global camera CVars;
- DynamicCam-wide UI hiding.

## Completion criterion

G.4 contract review completes when exact City camera semantics, precedence,
coexistence, and scope are written down from source/profile evidence and the
smallest targeted runtime proof is identified.
