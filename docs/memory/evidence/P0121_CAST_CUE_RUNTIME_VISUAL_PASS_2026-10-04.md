# P0121 Cast-Cue Runtime / Visual Evidence — 2026-10-04

Status: **PLAYER CAST RUNTIME + VISUAL PASS; TARGET CAST/CHANNEL ENVIRONMENTALLY DEFERRED**

Durable implementation: `fc928d9972d6eef43586b1d852281a7b95c229a4`
Runtime: `0.0.51-dev`

## Observed result

After deploying P0121, the user reported that the approved cast-state visual
translation "works great." The player-side cast cue therefore has direct
in-client runtime + visual acceptance.

No nearby enemy caster was naturally available during validation, so the target
cast/channel true path was not exercised. This is an environmental deferral,
not PASS or FAIL, and does not justify contrived travel/gameplay solely to
manufacture proof.

Player channel and interrupted/failed variants are implemented on the same
existing event-driven lifecycle but were not separately called out in the user
report, so this evidence does not over-claim individual state coverage.

## Preserved contract

The accepted result keeps:
- event-driven `UNIT_SPELLCAST_*` lifecycle only;
- no cast timer/progress bar;
- no spell text/icon metadata;
- no `UnitCastingInfo` / `UnitChannelInfo` dependency;
- target event payload fields ignored;
- brief interrupted/failed terminal state.
