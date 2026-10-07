# G.1 Current DynamicCam Profile Capture — 2026-10-02

Status: PASS — CURRENT PROFILE CAPTURED AND MAPPED
Date: 2026-10-02

## Supplied files

The user supplied current DynamicCam SavedVariables and backup files.

Raw SHA-256:

- `DynamicCam.lua`:
  `9d8a1a639dd0606529513f609252cb813e465db51c4baa72293c408369458be0`
- `DynamicCam.lua.bak`:
  `0deb9842cfd6c1b86a84cb845e1420e98d06476d168e7885efa73def5bac9d2a`

They parse to the same semantic Lua data.

The raw files are not tracked because they contain unrelated character/profile
identifiers.

The exact stored `RPG` profile is preserved as:

`G1_DYNAMICCAM_RPG_PROFILE_2026-10-02.json`

Derived JSON SHA-256:

`b2833df63303aed238790e78f9cea68289772336d847a1ec82cb26464f1c607a`

## Profile selection evidence

The SavedVariables data contains 15 profile-key assignments:

- `RPG`: 12
- `Default`: 3

`RPG` is the only richly customized camera profile in the supplied data.

**G.1 migration target: `RPG`.**

Profile schema version:
`5`.

`zoomRestoreSetting`:
`never`.

## Situation ID mapping source

SavedVariables stores situation IDs but not their names/conditions.

IDs are mapped for interpretation against DynamicCam `DefaultSettings.lua` at:

`ae586a9c973c3f868c10440358d4a6e8c2fab5ff`.

| ID | Situation | Priority | Activation meaning |
| --- | --- | ---: | --- |
| 001 | City | 1 | resting |
| 004 | World | 0 | not resting and not in an instance |
| 006 | World (Combat) | 50 | not in an instance and in combat |
| 160 | Taxi | 1000 | on taxi |
| 200 | Hearth/Teleport | 130 | recognized hearth/teleport cast |
| 300 | NPC Interaction | 110 | supported NPC interaction frame + npc |
| 302 | Fishing | 20 | fishing channel; upstream delay 1 |
| 303 | AFK | 120 | AFK |
| 320 | Gathering | 120 | recognized gathering cast |

## G.2 interpretation correction

P0094 originally described `zoomType = in/out` as zooming **by** `zoomValue`.

That was a derived interpretation error, not an error in the captured JSON.

G.2 source review proves these are conditional absolute targets:

- `in`: go to `zoomValue` only if currently farther away;
- `out`: go to `zoomValue` only if currently closer.

Canonical correction:

`G2_DYNAMICCAM_ZOOM_SOURCE_AUDIT_2026-10-02.md`.

## Global `RPG` settings

Stored standard settings include:

- reactive zoom add-increments-always `0.1000000000000001`;
- reactive zoom max zoom time `2.5`;
- zoom restore `never`;
- `cameraZoomSpeed = 15.5`;
- `test_cameraDynamicPitch = 1`;
- dynamic-pitch pads `0.75`, `0.5`, `1`;
- dynamic-pitch cutoff distance `25`;
- `test_cameraOverShoulder = 1`;
- enemy and interact target focus enabled with yaw `0.75`, pitch `0.5`.

The canonical JSON remains authoritative for exact nested settings.

Fields absent from SavedVariables remain inherited behavior; they are not
reconstructed from the export.

## Enabled situations — corrected interpretation

### 001 — City
- enabled;
- enter transition stored `2.5`;
- `zoomType = in`, target `5` only when farther than 5;
- hide UI enabled at opacity `0.65`;
- reactive-zoom overrides stored.

### 004 — World
- enabled;
- enter `2.5`, exit `0`;
- `zoomType = in`, target `5` only when farther than 5;
- no stored rotation override;
- no stored UI-hide override.

### 006 — World (Combat)
- enabled;
- enter `2.5`, exit `0`;
- `zoomType = out`, target `15` only when closer than 15;
- no stored rotation override;
- no stored UI-hide override.

### 160 — Taxi
- enabled;
- enter/exit `5`;
- `zoomType = out`, target `50` only when closer;
- rotation speed `-20`;
- UI hide/fade stored.

### 200 — Hearth/Teleport
- enabled;
- enter/exit `5`;
- `zoomType = out`, target `20` only when closer;
- rotation speed `15`;
- UI hide/fade stored.

### 300 — NPC Interaction
- enabled;
- enter `2.5`;
- `zoomType = in`, target `5` only when farther;
- degrees rotation yaw `-45`;
- UI hide/fade stored;
- shoulder target `-2` with stored zoom curve.

### 302 — Fishing
- enabled;
- enter `2`;
- `zoomType = out`, target `50` only when closer;
- degrees rotation yaw `10`, pitch `10`, speed `15`;
- upstream exit delay `1`.

### 303 — AFK
- enabled;
- enter/exit `0`;
- no stored zoom, rotation, or UI-hide override.

### 320 — Gathering
- enabled;
- enter/exit `3`;
- `zoomType = in`, target `5` only when farther;
- degrees rotation yaw `-15`, pitch `15`.

## Explicitly absent situation groups

The stored `RPG` profile has no enabled situation entry for:

- mounted;
- dungeon/scenario;
- raid;
- arena;
- battleground;
- mailbox;
- vehicle;
- swimming;
- camping;
- profession-frame-open.

There is no explicit enabled instance camera situation.

## Selected first capability slice

World / World (Combat) remains the narrowest useful camera slice, with corrected
semantics:

- World: conditional target zoom `5`;
- World (Combat): conditional target zoom `15`;
- ordinary World/Combat transitions use `2.5` seconds;
- no stored UI-hide/rotation override in either situation.

## Result

**G.1 PASS.**

Exact profile values remain the canonical JSON. Operational zoom semantics are
governed by the G.2 source audit.
