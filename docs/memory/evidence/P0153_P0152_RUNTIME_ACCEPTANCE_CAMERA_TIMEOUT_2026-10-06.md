# P0153 Evidence — P0152 Runtime Acceptance + Camera Timeout

Date: 2026-10-06
Runtime: `0.0.74-dev`
Client: Forever `1.60.1.70235`
Verified code checkpoint: `00aef4a90e5999140dc9082e68e934cfc854cb05`

## P0152 accepted runtime result

The R12 pet-state diagnostic reported:
- `module=true`;
- `pet=10`;
- `readable=7`;
- `activeIndicators=2`;
- `autocastIndicators=1`;
- `armAttempts=2`, `armDispatches=2`, `armPending=false`;
- automatic arm trigger `UNIT_PET`;
- slot 2 active;
- slot 4 autocast allowed/enabled;
- slot 6 active.

The first ten tracked buttons resolved through click-specific secure attributes (`type1=pet`, `action1=1..10`). The seven naturally populated/readable rows matched the previously observed pet-action state.

The user visually confirmed that the active/autocast indication now works and confirmed that pet button presses still execute. The Logres pet cluster was present by default after reload; manual panel ARM was not required for normal visibility.

Classification:
**P0152 R12 RUNTIME + CONTROL + STATE-PRESENTATION PASS for the bounded pet-action slice.**

Exact ornament, contrast, and final composition are deliberately deferred to later whole-interface polish. This acceptance does not authorize PetActionBar suppression, edit/reorder, binding replacement, PetFrame ownership, or unrelated class/special ownership. Stock PetActionBar remains the fail-open completeness fallback.

## Preserved correction history

All earlier P0152 failures remain authoritative project knowledge, including the initial bespoke-strip failure, load-order failure, layout/protected-click failures, inert delegation/range/layout failure, presentation baseline delivery refusals, R9 no-change visual failure, and the effective-binding diagnostic result that led to R12.

R12 succeeds because presentation resolves the same click-specific secure attributes used by the working pet controls rather than looking only at raw generic button attributes.

## Integrated Run All result

The final integrated Run All completed all listed checks, but it was **not globally clean** because `cameraworldcombat` failed once.

Observed camera failure:
- `context=world`;
- `reason=PLAYER_ENTERING_WORLD`;
- `action=transition-timeout`;
- requested/effective target `5`;
- start `6.8119101524353`;
- current `6.7657418251038`;
- final `6.7526960372925`;
- elapsed `3.2540000000154` seconds;
- `targetReached=false`;
- `failures=1`;
- `secret=false`;
- error `camera transition timed out before target`.

All other listed Run All checks in that run reported PASS.

The P0152 commit does not modify camera runtime files. Therefore the evidence does not establish that P0152 caused the timeout. Because this is one observation and prior camera checks passed, classification is:

**OPEN / INTERMITTENT / UNREPRODUCED CAMERA REGRESSION WATCH.**

Do not erase the failure, but do not patch it speculatively. The next action is one targeted normal world-entry retest through the Phase G developer-panel camera check followed by a separate Run All.
