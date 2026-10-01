# B.4 Cast Confirmation Runtime Proof — 2026-10-01

Status: VERIFIED WITH ENVIRONMENTAL DEFERRAL
Final tested baseline: `4c27c6c54b7804285e2ebcf4a21e2554a8a82e58`

## Runtime result

P0025 implemented minimal event-driven cast/channel cues for:
- the player;
- the current target.

The user tested the player side and reported that all tested behavior works well.

Verified player behaviors:
- normal casting cue;
- channeling cue;
- interruption behavior.

No conventional cast bar was introduced.

No Lua/secret-value error was reported.

## Player cue result

Production behavior is proven for:
- amber normal-cast state;
- blue channel state;
- brief red interruption/failure snap;
- stop/cleanup after the lifecycle ends.

This closes the required player-side runtime proof.

## Current-target cue

The current-target cue is implemented in P0025.

Its event path:
- registers spellcast lifecycle events directly for `"target"`;
- ignores all spellcast payload fields;
- does not query `UnitCastingInfo("target")`;
- does not query `UnitChannelInfo("target")`.

## Environmental deferral

The current environment did not provide a convenient enemy/current-target caster.

Therefore the current-target true-path runtime proof is:

**DEFERRED BY ENVIRONMENT**

This is not a product failure and does not remove the feature.

Retry when:
- a naturally encountered current target casts or channels;
- a future combat/instance test presents a caster.

Do not require travel solely to manufacture this scenario.

## Immersion behavior

The cast cues are children of the already-proven `LogresHUDRoot`.

B.4 did not independently re-run the immersion toggle test specifically during an active cast.

The shared HUD-root hide/restore behavior was already runtime proven during B.1/B.2/B.3.

No separate B.4 regression was reported.

## Conclusion

B.4 exit criteria are satisfied:
- player cast cue proven;
- player channel cue proven;
- interruption cue proven;
- current-target cue implemented;
- target true path explicitly deferred by environment;
- no conventional cast bar;
- no reported secret/Lua error.

**B.4 — Cast Confirmation: COMPLETE WITH TARGET TRUE-PATH ENVIRONMENTAL DEFERRAL.**
