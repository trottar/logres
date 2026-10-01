# P0024 — Close B.3 and open B.4 with corrected cast scope

Date: 2026-10-01
Result: PREPARED — not durable until user commits/pushes

## B.3 result

P0023 runtime proof passed:
- sparse target name + health percentage;
- health depletion updates;
- target clear hides;
- immersion off/on hides/restores;
- no extra level/classification text.

B.3:
**COMPLETE**

## B.4 scope correction

The repository previously stated enemy cast UI remained deferred unless later justified.

That wording is corrected.

B.4 includes:
- player cast/channel cue;
- current-target cast/channel cue.

Both remain minimal and non-bar.

## Environmental limitation

The user currently has no nearby enemy caster.

Therefore:
- target-cast implementation remains required;
- target-cast true-path runtime proof may be deferred by environment;
- retry when a natural enemy/current target caster is available.

Do not require dungeon travel solely for this proof.

## Code changes

None.

## Deployment

No redeploy required.
