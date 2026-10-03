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

## Ownership boundary

Camera ownership is separate from unrelated UI ownership.

DynamicCam UI-hide settings are evidence of desired experience, but Logres must
integrate them deliberately with the existing Immersion Controller rather than
copying DynamicCam's frame-hiding mechanics into the camera module.

Two addons must not drive the camera simultaneously during capability proof.
P0095 refuses to run while DynamicCam is loaded.

## Transition architecture

Accepted source direction for the first slice:

- event/state-driven context selection;
- frame-based movement is permitted only while an active camera animation runs;
- animation frames are not context polling;
- prove `GetCameraZoom` + `MoveView*Start/Stop` first;
- read `cameraZoomSpeed`, but do not mutate it in the first probe;
- do not adopt LibCamera's temporary-CVar corrective fallback without evidence;
- stop movement on interruption, disable, or failure;
- fail open to a usable current camera position.

## Implementation sequence

G.2 is the current capability slice:
**World/Combat camera zoom capability.**

It excludes rotation, UI hiding, shoulder offsets, spell-detection contexts,
taxi, and global camera-CVar ownership.
