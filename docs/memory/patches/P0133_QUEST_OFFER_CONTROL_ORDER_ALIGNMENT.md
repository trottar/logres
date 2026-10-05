# P0133 — Align Quest-Offer Action Order With Blizzard Fallback

Date: 2026-10-05
Result: **INSTALLED / PUSHED — RUNTIME + VISUAL PASS** (`f2feead6`)
Baseline: `671f9836c43f3a4c9755f296ccad4a9574a62848`
Runtime: `0.0.64-dev -> 0.0.65-dev`

## Purpose

Correct the only visual defect found during P0132 production-control validation:
the Logres offer controls used the opposite left/right order from Blizzard's
simultaneously visible fallback.

Canonical evidence:
`../evidence/P0132_PRODUCTION_OFFER_CONTROLS_RUNTIME_VISUAL_ORDER_2026-10-05.md`.

## Change

Swap only the horizontal placement:
- `Accept` -> left;
- `Decline` -> right.

No control object, label, color, click handler, exact-offer binding, mutation
call site, event correlation, visibility gate, preview behavior, or Blizzard
fallback policy changes.

## Rationale

During P0132 proof, Blizzard controls intentionally remain visible. Opposite action
ordering creates conflicting motor memory and unnecessary ambiguity.

While both surfaces coexist, Logres should mirror Blizzard's left/right semantic
order unless a future accepted design explicitly replaces the stock surface.

## Static contract

`check_quest_offer_controls_contract.py` gains an explicit placement contract:
- Accept position block must use the negative/left offset;
- Decline position block must use the positive/right offset.

This protects the runtime-validated arrangement from incidental refactors.

## Validation

1. Phase F -> `Quest Dialogue Preview`.
2. Navigate to the final page.
3. Confirm `Accept` is left and `Decline` is right.
4. Earlier pages still show no offer controls.
5. Open a real quest offer.
6. Confirm Logres and Blizzard action ordering is aligned while Blizzard remains
   visible/usable.
7. Phase H -> `Quest Offer Controls Check` -> PASS.
8. Phase 0 -> `Run All` -> PASS.

No real Accept / Decline mutation retest is required solely for this positional
change.

## Boundary

P0133 does not authorize Blizzard offer-control suppression and does not expand
into Continue / Complete, rewards, or gossip transitions.

## Final result

Durable commit:
`f2feead6ef528d9cf91bab09bce32d92a6763824`.

Canonical evidence:
`../evidence/P0133_QUEST_OFFER_ORDER_RUNTIME_VISUAL_PASS_2026-10-05.md`.

Final result:
- runtime `0.0.65-dev`;
- Accept left / Decline right;
- order matches Blizzard while fallback remains visible;
- earlier/final-page behavior remains correct;
- Quest Dialogue Preview PASS;
- Quest Offer Controls Check PASS;
- integrated `Run All` PASS;
- user visual acceptance.

Classification:
**RUNTIME + VISUAL PASS / ACCEPTED PRODUCTION BASELINE FOR THE PROVEN OFFER STATE.**
