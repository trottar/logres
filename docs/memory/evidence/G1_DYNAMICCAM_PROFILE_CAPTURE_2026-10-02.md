# G.1 Current DynamicCam Profile Capture — 2026-10-02

Status: PASS — CURRENT PROFILE CAPTURED AND MAPPED
Date: 2026-10-02

## Supplied files

The user supplied a current DynamicCam SavedVariables file and its backup.

Raw SHA-256:

- `DynamicCam.lua`:
  `9d8a1a639dd0606529513f609252cb813e465db51c4baa72293c408369458be0`
- `DynamicCam.lua.bak`:
  `0deb9842cfd6c1b86a84cb845e1420e98d06476d168e7885efa73def5bac9d2a`

The two files have different byte ordering but parse to the **same semantic
Lua data**. The backup therefore adds no distinct camera behavior.

The raw files are not copied into the repository because they also contain
character/profile-key identifiers that are not required by Logres.

Instead, the exact stored `RPG` profile is preserved as the faithful derived
machine-readable record:

`G1_DYNAMICCAM_RPG_PROFILE_2026-10-02.json`

Derived JSON SHA-256:

`b2833df63303aed238790e78f9cea68289772336d847a1ec82cb26464f1c607a`

## Profile selection evidence

The SavedVariables data contains profile-key assignments for 15 entries:

- `RPG`: 12
- `Default`: 3

`RPG` is also the only richly customized camera profile in the supplied data.

**G.1 migration target: `RPG`.**

This is the profile Logres will translate unless later user evidence says the
active camera configuration changed.

Profile schema version:
`5`.

`zoomRestoreSetting`:
`never`.

## Situation ID mapping source

The SavedVariables file stores numeric situation IDs but not their names or
conditions.

For interpretation only, IDs are mapped against current upstream
`mpstark/DynamicCam` `DefaultSettings.lua` at commit:

`ae586a9c973c3f868c10440358d4a6e8c2fab5ff`

That source identifies the enabled `RPG` situation IDs as:

| ID | DynamicCam situation | Upstream priority | Activation meaning |
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

The numeric settings below come from the supplied profile, not from upstream
defaults.

## Global `RPG` settings

Stored standard settings:

- reactive zoom add-increments-always:
  `0.1000000000000001`
- reactive zoom max zoom time:
  `2.5`
- zoom restore:
  `never`
- `cameraZoomSpeed = 15.5`
- `test_cameraDynamicPitch = 1`
- `test_cameraDynamicPitchBaseFovPad = 0.75`
- `test_cameraDynamicPitchBaseFovPadFlying = 0.5`
- `test_cameraDynamicPitchBaseFovPadDownScale = 1`
- `test_cameraDynamicPitchSmartPivotCutoffDist = 25`
- `test_cameraOverShoulder = 1`
- enemy target focus:
  enabled `1`, yaw `0.75`, pitch `0.5`
- interact target focus:
  enabled `1`, yaw `0.75`, pitch `0.5`

Stored zoom-based shoulder curve:

| Zoom | Shoulder |
| ---: | ---: |
| 0 | 0 |
| 2 | 0 |
| 7 | 1 |
| 50 | 1 |

Fields absent from SavedVariables are inherited DynamicCam defaults and are not
silently reconstructed here. G.2 source review must resolve any inherited
behavior needed by Logres.

## Enabled situations — exact stored overrides

### 001 — City

- enabled
- enter transition: `2.5`
- exit transition: not stored
- zoom action: `in` by `5`
- hide UI: enabled
- UI fade opacity: `0.65`
- keep custom frames: true
- reactive zoom enabled
- reactive zoom add increments: `2.5`
- reactive zoom add-increments-always:
  `0.1000000000000001`
- reactive zoom increment-add difference: `1.2`
- reactive zoom max zoom time: `2.5`
- situation CVars:
  - `cameraDistanceMaxZoomFactor = 1`
  - `cameraZoomSpeed = 15.5`

### 004 — World

- enabled
- enter transition: `2.5`
- exit transition: `0`
- zoom action: `in` by `5`
- no stored rotation override
- no stored UI-hide override

### 006 — World (Combat)

- enabled
- enter transition: `2.5`
- exit transition: `0`
- zoom action: `out` by `15`
- no stored rotation override
- no stored UI-hide override

### 160 — Taxi

- enabled
- enter transition: `5`
- exit transition: `5`
- zoom action: `out` by `50`
- rotation enabled
- rotation speed: `-20`
- hide UI enabled
- fade opacity: `0`
- keep custom frames: true
- keep alert frames: false
- keep tooltip: false
- custom-frame map (25 entries):

`BagBrotherFrame1=true`, `BagBrotherFrame2=true`, `BagBrotherFrame3=true`, `BagBrotherFrame4=true`, `BagBrotherFrame5=true`, `BagBrotherFramebank=true`, `BagBrotherFrameinventory=true`, `BagFrame=true`, `BagnonBankFrame2=true`, `BagnonBankFrame3=true`, `BagnonBankFrame4=true`, `BagnonBankFrame5=true`, `BagnonFrame1=true`, `BagnonFrameinventory=true`, `BagnonInventory1=true`, `BankFrame=false`, `CharacterBag0Slot=true`, `ContainerFrame1=true`, `ContainerFrame2=true`, `ContainerFrame3=true`, `ContainerFrame4=true`, `ContainerFrame5=true`, `FirstAidFrame=true`, `Tooltip=true`, `VendorPriceTooltip=true`

### 200 — Hearth/Teleport

- enabled
- enter transition: `5`
- exit transition: `5`
- zoom action: `out` by `20`
- rotation enabled
- rotation speed: `15`
- hide UI enabled
- fade opacity: `0`
- keep custom frames: true
- keep alert frames: false
- keep tooltip: false
- custom-frame map (25 entries):

`BagBrotherFrame1=true`, `BagBrotherFrame2=true`, `BagBrotherFrame3=true`, `BagBrotherFrame4=true`, `BagBrotherFrame5=true`, `BagBrotherFramebank=true`, `BagBrotherFrameinventory=true`, `BagFrame=true`, `BagnonBankFrame2=true`, `BagnonBankFrame3=true`, `BagnonBankFrame4=true`, `BagnonBankFrame5=true`, `BagnonFrame1=true`, `BagnonFrameinventory=true`, `BagnonInventory1=true`, `BankFrame=false`, `CharacterBag0Slot=true`, `ContainerFrame1=true`, `ContainerFrame2=true`, `ContainerFrame3=true`, `ContainerFrame4=true`, `ContainerFrame5=true`, `FirstAidFrame=true`, `Tooltip=true`, `VendorPriceTooltip=true`

### 300 — NPC Interaction

- enabled
- enter transition: `2.5`
- exit transition: not stored
- zoom action: `in` by `5`
- rotation enabled
- rotation type: `degrees`
- yaw: `-45`
- hide UI enabled
- fade opacity: `0`
- emergency show with Escape: false
- keep custom frames: true
- keep alert frames: false
- keep tooltip: false
- shoulder-offset zoom enabled
- shoulder lower bound: `2`
- shoulder upper bound: `7`
- situation `test_cameraOverShoulder = -2`
- stored zoom-based shoulder curve:

| Zoom | Shoulder |
| ---: | ---: |
| 0 | 0 |
| 2 | 0 |
| 7 | -2 |
| 50 | -2 |

Custom-frame map (31 entries):

`BagBrotherFrame1=true`, `BagBrotherFrame2=true`, `BagBrotherFrame3=true`, `BagBrotherFrame4=true`, `BagBrotherFrame5=true`, `BagBrotherFramebank=true`, `BagBrotherFrameinventory=true`, `BagFrame=true`, `BagnonBank1=true`, `BagnonBankFrame=true`, `BagnonBankFrame2=true`, `BagnonBankFrame3=true`, `BagnonBankFrame4=true`, `BagnonBankFrame5=true`, `BagnonFrame1=true`, `BagnonFrameBank=true`, `BagnonFrameinventory=true`, `BagnonInventory1=true`, `Bagnon_Bank=true`, `BagonBank1=true`, `BankFrame=false`, `CharacterBag0Slot=true`, `ContainerFrame1=true`, `ContainerFrame2=true`, `ContainerFrame3=true`, `ContainerFrame4=true`, `ContainerFrame5=true`, `FirstAidFrame=true`, `StackSplitFrame=true`, `Tooltip=true`, `VendorPriceTooltip=true`

### 302 — Fishing

- enabled
- enter transition: `2`
- exit transition: not stored
- zoom action: `out` by `50`
- rotation enabled
- rotation type: `degrees`
- yaw: `10`
- pitch: `10`
- rotation speed: `15`
- upstream activation delay: `1`

### 303 — AFK

- enabled
- enter transition: `0`
- exit transition: `0`
- no stored zoom override
- no stored rotation override
- no stored UI-hide override

### 320 — Gathering

- enabled
- enter transition: `3`
- exit transition: `3`
- zoom action: `in` by `5`
- rotation enabled
- rotation type: `degrees`
- yaw: `-15`
- pitch: `15`

## Explicitly absent situation groups

The stored `RPG` profile has **no enabled situation entry** for:

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

In particular, there is no explicit instance camera situation in the current
`RPG` profile.

This is an important correction to the earlier generic Phase G context list:
instance behavior is not a custom profile slice unless later evidence adds one.

## Implementation implications

The smallest evidence-backed camera slice is **World / World (Combat)**:

- 004 World:
  zoom **in by 5**, enter `2.5`, exit `0`;
- 006 World (Combat):
  zoom **out by 15**, enter `2.5`, exit `0`.

Reasons:

1. both are active in the current `RPG` profile;
2. both depend on Logres state already observed (`combat`, instance/world);
3. neither situation has a stored rotation override;
4. neither situation has a stored UI-hide override;
5. they isolate camera zoom capability before UI hiding, shoulder offsets,
   rotation, teleport spell detection, gathering spell detection, or taxi
   presentation are introduced.

## Unresolved capability questions

The export alone does not prove:

- which exact camera API path DynamicCam uses for timed `in` / `out` deltas;
- whether camera calls/CVars are restricted or secret-capable on Forever;
- exact inherited values for omitted fields;
- restoration semantics Logres should use when camera ownership is disabled;
- whether DynamicCam and Logres can safely coexist during staged migration.

These are G.2 questions.

## Result

**G.1 PASS.**

Current profile evidence is sufficient to open:

**G.2 — World/Combat camera zoom capability contract and runtime proof.**
