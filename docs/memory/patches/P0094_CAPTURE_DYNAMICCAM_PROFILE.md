# P0094 — Capture Current DynamicCam Profile

Date: 2026-10-02
Result: PREPARED — DOCS/EVIDENCE ONLY

## Baseline

P0093 verified pushed:
`de30c6f3dfd9855a9c96c25d1d48e3c628fe9748`.

## Purpose

Satisfy Phase G / G.1 with the user's current DynamicCam SavedVariables,
preserve the exact migration-relevant `RPG` settings durably, and open the first
narrow camera capability slice.

## Input evidence

User supplied:
- `DynamicCam.lua`;
- `DynamicCam.lua.bak`.

Raw SHA-256:
- current: `9d8a1a639dd0606529513f609252cb813e465db51c4baa72293c408369458be0`;
- backup: `0deb9842cfd6c1b86a84cb845e1420e98d06476d168e7885efa73def5bac9d2a`.

The files parse to identical semantic data.

## Durable profile record

The raw files contain unrelated character/profile-key identifiers, so P0094
does not commit them verbatim.

Instead it commits:
- a human-readable evidence map;
- canonical JSON containing the exact stored `RPG` profile.

Canonical JSON SHA-256:
`b2833df63303aed238790e78f9cea68289772336d847a1ec82cb26464f1c607a`.

## G.1 result

**PASS / CLOSED.**

The captured `RPG` profile has:
- schema version 5;
- `zoomRestoreSetting = never`;
- nine enabled situations:
  City, World, World (Combat), Taxi, Hearth/Teleport, NPC Interaction, Fishing,
  AFK, Gathering;
- no explicit enabled instance situation.

Numeric settings are preserved exactly from the supplied profile.

Situation names/conditions/priorities are mapped against upstream DynamicCam
commit:
`ae586a9c973c3f868c10440358d4a6e8c2fab5ff`.

## Next slice

**G.2 — World/Combat camera zoom capability.**

Target:
- World: zoom in by 5, enter 2.5, exit 0;
- World (Combat): zoom out by 15, enter 2.5, exit 0.

Reason:
these are current profile behaviors that require camera zoom only and reuse
existing Logres world/combat state.

## Boundaries

P0094 does not:
- change runtime code;
- deploy to WoW;
- implement camera mutation;
- infer omitted SavedVariables defaults;
- copy DynamicCam UI-hiding mechanics into Logres;
- open an instance camera slice absent from the captured profile.

## Deployment

Docs/evidence only.

**No WoW redeploy required.**
