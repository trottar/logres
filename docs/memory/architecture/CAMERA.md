# Camera Architecture

## Product intent

Camera behavior will eventually be integrated into Logres rather than requiring
a separate DynamicCam profile.

## Current durable profile evidence

G.1 captured the user's current DynamicCam SavedVariables on 2026-10-02.

Canonical derived evidence:

- `../evidence/G1_DYNAMICCAM_PROFILE_CAPTURE_2026-10-02.md`
- `../evidence/G1_DYNAMICCAM_RPG_PROFILE_2026-10-02.json`

The raw uploaded files are not tracked because they contain unrelated
character/profile-key identifiers. Their SHA-256 values and semantic-equivalence
result are recorded in the evidence file.

The exact stored `RPG` settings must be taken from that evidence, not from
conversation or reconstructed memory.

Request another fresh export only if the user says the DynamicCam profile has
changed or later evidence contradicts the captured record.

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

It does **not** contain an explicit enabled instance camera situation.

## Architecture boundary

Camera ownership is separate from unrelated UI ownership.

DynamicCam profile fields that hide UI are evidence of the user's desired
experience, but Logres must integrate that behavior deliberately with the
existing Immersion Controller rather than blindly duplicating DynamicCam's
frame-hiding implementation inside a camera module.

Likewise, camera transitions must fail open and must not leave stale CVar,
rotation, zoom, or control state after Logres relinquishes ownership.

## Implementation sequence

The first capability slice is G.2:
**World/Combat camera zoom capability.**

It isolates:
- World zoom in by 5;
- World (Combat) zoom out by 15;
- 2.5-second enter transitions;
- existing Logres world/combat state.

Rotation, UI hiding, shoulder offsets, spell-detection contexts, taxi, and
global camera CVar ownership remain later evidence-backed slices.
