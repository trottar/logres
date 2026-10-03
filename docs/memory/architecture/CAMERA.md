# Camera Architecture

## Product intent

Camera behavior will eventually be integrated into Logres rather than requiring
a separate DynamicCam profile.

## Durable profile evidence

G.1 captured the current DynamicCam profile on 2026-10-02.

Canonical evidence:

- `../evidence/G1_DYNAMICCAM_PROFILE_CAPTURE_2026-10-02.md`
- `../evidence/G1_DYNAMICCAM_RPG_PROFILE_2026-10-02.json`

Request another export only if the profile changes or later evidence conflicts.

## Current configured contexts

The captured `RPG` profile enables:
- City;
- World;
- World (Combat);
- Taxi;
- Hearth/Teleport;
- NPC Interaction;
- Fishing;
- AFK;
- Gathering.

No explicit enabled instance camera situation is present.

For the first production slice:
- World means not resting and not in an instance;
- World (Combat) means not in an instance and live
  `UnitAffectingCombat("player")`;
- World (Combat) has higher priority than World.

Other profile contexts remain outside G.3.

## Correct zoom semantics

G.2 source review corrected a G.1 interpretation error.

DynamicCam `zoomType = in/out` is a conditional absolute target:

- `in`: target `zoomValue` only when currently farther away;
- `out`: target `zoomValue` only when currently closer.

Current World/Combat behavior:

- World: conditional target `5`;
- World (Combat): conditional target `15`;
- ordinary transition `2.5` seconds;
- zoom restore policy `never`.

Canonical source audit:
`../evidence/G2_DYNAMICCAM_ZOOM_SOURCE_AUDIT_2026-10-02.md`.

## G.2 runtime capability evidence

G.2 is closed with runtime + integration PASS.

P0095 first proved the reversible primary camera path out of combat.
P0096 corrected the context classifier to DynamicCam's live combat predicate.

Two captured `0.0.40-dev` live-combat runs reported:
- `combat=true`;
- `lockdown=true`;
- `cachedCombat=false`;
- `mismatch=true`;
- target reached;
- movement observed;
- starting zoom restored;
- no secret/error result.

The out-of-combat and post-combat paths remained clean, and Run All passed every
emitted check through `checkall: complete` on the same runtime.

Canonical runtime evidence:
`../evidence/G2_P0096_RUNTIME_PASS_2026-10-02.md`.

## Combat signal distinction

DynamicCam's captured World (Combat) situation is keyed by live
`UnitAffectingCombat("player")`, not Logres's cached `State.combat`.

For camera-context ownership, use the profile's actual live predicate.

`InCombatLockdown()` remains a separate restriction/protection signal and must
not be conflated with whether DynamicCam considers the player in combat.

P0096's observed `cachedCombat=false` / `mismatch=true` while live combat was
true is retained as evidence for that separation. It is not authorization to
redesign the core state engine.

## Ownership boundary

Camera ownership is separate from unrelated UI ownership.

DynamicCam UI-hide settings are evidence of desired experience, but Logres must
integrate them deliberately with the existing Immersion Controller rather than
copying DynamicCam's frame-hiding mechanics into the camera module.

DynamicCam and Logres must never drive camera movement simultaneously.

G.3 production ownership must capability-gate coexistence so that Logres
relinquishes camera movement when DynamicCam owns it, and vice versa through the
user's selected active addon configuration.

## Transition architecture

Accepted production direction for World/Combat:

- event/state-driven context selection;
- frame-based movement only while an active camera animation runs;
- animation frames are not context polling;
- use the runtime-proven `GetCameraZoom` + `MoveView*Start/Stop` path;
- read `cameraZoomSpeed`, but do not mutate it for this path;
- do not adopt LibCamera's temporary-CVar corrective fallback without separate
  evidence;
- stop active movement before beginning another transition;
- stop movement on interruption, disable, ownership loss, or failure;
- fail open to a usable current camera position;
- do not restore pre-combat zoom because the captured profile policy is
  `never`.

## Implementation sequence

G.1:
**COMPLETE — profile captured.**

G.2:
**COMPLETE — World/Combat primary camera capability runtime + integration
PASS.**

G.3 is current:
**Production World/Combat camera ownership.**

G.3 excludes rotation, UI hiding, shoulder offsets, spell-detection contexts,
taxi, City behavior, and global camera-CVar ownership.
