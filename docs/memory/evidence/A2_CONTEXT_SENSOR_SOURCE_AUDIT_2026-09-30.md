# A.2 Context Sensor Source Audit — 2026-09-30

Status: SOURCE / DOCUMENTATION EVIDENCE  
Runtime status: NOT YET VERIFIED BY LOGRES A.2

## Purpose

Select the minimum additional orthogonal context facts needed by later Logres phases before modifying `Core/State.lua`.

Candidates reviewed:
- mounted;
- resting;
- taxi/flight path;
- player interaction.

The review intentionally avoids adding every detectable player condition.

## Evidence classes

- **DOCUMENTED** — current Warcraft Wiki API/event documentation marks the API/event for Forever.
- **SOURCE-BACKED** — maintained current addon source demonstrates the pattern on a Forever-aware codebase.
- **RUNTIME VERIFIED** — requires later in-client Logres testing.

This record does not promote source findings to runtime proof.

## Sensor 1 — mounted

### Decision

**ACCEPT FOR A.2 IMPLEMENTATION**

Canonical proposed fields:

```text
mounted: boolean
```

### Semantic definition

`mounted` means:

> The player is currently on a player-controlled mount, excluding taxi flight.

It does not mean:
- any travel;
- taxi;
- vehicle;
- druid travel form;
- airborne;
- flying-capable mount.

Those are separate facts if a future owner proves they are needed.

### API evidence

Current Warcraft Wiki marks:

`IsMounted()`

as available on Forever 1.60.1 and returning whether the character is mounted.

Source:
https://warcraft.wiki.gg/wiki/API:IsMounted

### Event/source evidence

Current maintained DynamicCam source at commit:

`ae586a9c973c3f868c10440358d4a6e8c2fab5ff`

uses its mounted situation with:
- `PLAYER_MOUNT_DISPLAY_CHANGED`;
- `UNIT_AURA`;
- condition `IsMounted() and not UnitOnTaxi("player")`.

DynamicCam is explicitly Forever-aware in the same current source line and separately removes flying-mount/vehicle situations for Forever.

Source:
https://github.com/mpstark/DynamicCam/blob/ae586a9c973c3f868c10440358d4a6e8c2fab5ff/DefaultSettings.lua

### Architecture consequence

Logres should keep `mounted` and `onTaxi` independent.

Do not create one ambiguous `traveling` flag.

### Runtime plan

Low-cost:
1. run status while unmounted;
2. mount in place;
3. run status;
4. dismount;
5. run status.

No travel is required.

---

## Sensor 2 — resting

### Decision

**ACCEPT FOR A.2 IMPLEMENTATION**

Canonical proposed field:

```text
resting: boolean
```

### Semantic definition

`resting` means exactly the result of `IsResting()`.

Do not rename or reinterpret it as:
- `inCity`;
- `inInn`;
- `safe`;
- `restedXPAvailable`.

Those concepts are not identical.

### API evidence

Current Warcraft Wiki marks `IsResting()` available on Forever 1.60.1.

It returns whether the player is currently resting.

Source:
https://warcraft.wiki.gg/wiki/API:IsResting

### Event evidence

`PLAYER_UPDATE_RESTING` is documented for Forever and fires when the player starts/stops resting.

Source:
https://warcraft.wiki.gg/wiki/Event:PLAYER_UPDATE_RESTING

Current maintained DynamicCam uses:
- `PLAYER_UPDATE_RESTING`;
- `IsResting()`

for its city/resting situations.

### Downstream owner

Resting state is useful to:
- later XP/rested presentation;
- later immersion/camera policy where a resting area matters.

The state engine exposes only the raw fact. It does not decide presentation.

### Runtime plan

Travel-free false/current-state verification is always possible.

A true transition should be tested if the character is already near a resting area; otherwise defer the true-path observation until naturally encountered. Do not require a dedicated trip solely for A.2.

---

## Sensor 3 — taxi / flight path

### Decision

**ACCEPT FOR A.2 IMPLEMENTATION**

Canonical proposed field:

```text
onTaxi: boolean
```

### Semantic definition

`onTaxi` means:

> `UnitOnTaxi("player")` currently reports that the player is on a flight path.

It does not include:
- normal mounts;
- teleport casts;
- vehicles;
- generic loss of player control.

### API evidence

Current Warcraft Wiki marks:

`UnitOnTaxi(unit)`

available on Forever 1.60.1.

Source:
https://warcraft.wiki.gg/wiki/API:UnitOnTaxi

### Event/source evidence

Current maintained DynamicCam uses:
- `PLAYER_CONTROL_LOST`;
- `PLAYER_CONTROL_GAINED`;
- condition `UnitOnTaxi("player")`.

Its current mounted situations explicitly exclude taxi via `not UnitOnTaxi("player")`.

This separation matches Logres' desired orthogonal-state model.

Current Warcraft Wiki documents `PLAYER_CONTROL_LOST` on Forever and notes taxi as one cause. The event is therefore only a refresh signal; `UnitOnTaxi("player")`, not the event itself, is the state authority.

Sources:
https://warcraft.wiki.gg/wiki/Event:PLAYER_CONTROL_LOST
https://github.com/mpstark/DynamicCam/blob/ae586a9c973c3f868c10440358d4a6e8c2fab5ff/DefaultSettings.lua

### Important constraint

`PLAYER_CONTROL_LOST` is not synonymous with taxi.

It can also occur for loss-of-control effects.

Therefore:
- never set `onTaxi = true` merely because `PLAYER_CONTROL_LOST` fired;
- always re-read `UnitOnTaxi("player")`.

### Downstream owner

Primary:
- Phase G camera taxi profile.

Possible secondary:
- immersion policy that should not treat taxi as ordinary player-controlled mounting.

### Runtime plan

Do not require a dedicated flight-path trip for A.2.

Verify:
- API current false state;
- registration/load safety.

Defer true taxi transition until naturally convenient or until Phase G if it has not occurred earlier.

---

## Sensor 4 — player interaction

### Decision

**ACCEPT FOR A.2 IMPLEMENTATION**

Canonical proposed fields:

```text
interacting: boolean
interactionType: number
```

Where:
- `interactionType = Enum.PlayerInteractionType.None` / `0` means no tracked interaction;
- `interacting` is the corresponding boolean convenience fact.

### Semantic definition

This is **PlayerInteractionManager frame interaction state**, not a guessed high-level category like `talkingToNPC`.

The type remains the Blizzard `Enum.PlayerInteractionType` numeric value.

Future presentation modules may interpret particular types.

### Event evidence

Current Warcraft Wiki documents on Forever:
- `PLAYER_INTERACTION_MANAGER_FRAME_SHOW: type`;
- `PLAYER_INTERACTION_MANAGER_FRAME_HIDE: type`.

The payload is `Enum.PlayerInteractionType`.

The current enum list includes Forever-specific values such as:
- `PetUntrainer` = 80;
- `RewardsShop` = 81.

Sources:
https://warcraft.wiki.gg/wiki/Event:PLAYER_INTERACTION_MANAGER_FRAME_SHOW
https://warcraft.wiki.gg/wiki/Event:PLAYER_INTERACTION_MANAGER_FRAME_HIDE

This is strong evidence that the Interaction Manager event surface is active in Forever 1.60.1.

### API evidence

Current Warcraft Wiki marks:

`C_PlayerInteractionManager.IsInteractingWithNpcOfType(type)`

available on Forever 1.60.1.

Source:
https://warcraft.wiki.gg/wiki/API:C_PlayerInteractionManager.IsInteractingWithNpcOfType

### Negative finding / constraint

The current documented PlayerInteractionManager function list does **not** expose a universal:

```text
GetCurrentInteractionType()
```

getter.

Do not invent or depend on such a function.

Do not scan every possible enum value on every global state refresh.

Implementation should treat the documented SHOW/HIDE event payload as the primary interaction-type signal.

### Event-latch rule

Proposed implementation behavior:
- SHOW(type): set current interaction type to `type`;
- HIDE(type): clear only if the hidden type matches the currently tracked type;
- initialize to `None`.

This avoids a stale HIDE event erasing a newer interaction.

### Reload caveat

Whether an already-open interaction frame survives `/reload` without replaying SHOW is not established by this source review.

If runtime testing exposes a stale/unknown interaction state after reload, preserve it as a negative result and investigate a narrow recovery strategy.

### Downstream owners

- Phase D Immersion Controller;
- Phase F Quest Experience;
- Phase G interaction camera profile.

### Runtime plan

Low-cost when near any ordinary interaction:
1. status before interaction;
2. open merchant/gossip/quest/trainer/etc.;
3. status;
4. close;
5. status.

Do not require a dedicated long trip.

---

## Rejected / deferred sensors

### Generic `traveling`

**REJECTED**

It collapses unrelated facts:
- mount;
- taxi;
- teleport;
- vehicle;
- movement.

Consumers should compose raw facts.

### Flying / airborne

**DEFERRED**

Forever-specific maintained DynamicCam source currently removes flying-mount situations for Forever.

No early Logres consumer needs this fact.

### Vehicle

**DEFERRED**

Current maintained DynamicCam explicitly removes its vehicle situation for Forever.

Do not add a speculative vehicle field to A.2.

### Druid travel form

**DEFERRED**

Class-specific and not required by the current cross-class state contract.

Reopen only if a concrete immersion/camera requirement needs it.

### Generic loss of control

**DEFERRED**

Not required by the planned initial presentation policy.

`PLAYER_CONTROL_LOST` is used only as one refresh signal for `onTaxi`.

## Proposed A.2 schema addition

```text
mounted: boolean
resting: boolean
onTaxi: boolean
interacting: boolean
interactionType: number
```

These remain orthogonal to:
- combat;
- PvP;
- instance;
- context.

No combinatorial state names are introduced.

## Implementation gate

Before A.2 is considered complete:
- add the fields through the D-009 state contract;
- add only the required event signals;
- filter noisy unit events to the player;
- add a travel-free sensor consistency diagnostic;
- runtime-test mounted locally;
- runtime-test interaction/resting when convenient;
- do not block A.2 solely on a dedicated taxi trip.
