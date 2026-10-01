# B.6 — HUD Integration Validation

Status: ACTIVE
Opened: 2026-10-01

## Goal

Validate the completed Phase B HUD pieces as one coherent system before Phase B closes.

B.6 is primarily an integration/transition validation item.

It should not add another HUD feature unless testing exposes a concrete defect.

## Components under validation

Phase B currently includes:
- player health vignette;
- player primary-resource percentage;
- sparse target name + health percentage;
- player cast/channel/interruption cue;
- current-target cast/channel cue;
- pet + party1–party4 compact name/health rows.

## Core integration questions

### Healthy world baseline

Confirm:
- no player-health vignette at healthy state;
- resource percentage visible;
- no target block without a target;
- no stale cast cue;
- only real pet/party rows shown.

### Combat + target

Confirm during ordinary combat:
- health vignette responds to injury;
- target health depletes;
- player resource updates;
- player cast cue can coexist with target presentation;
- pet/party health rows continue updating;
- no obvious overlap makes the central HUD unreadable.

### Target lifecycle

Confirm:
- acquire target -> target block appears;
- switch target -> target block updates;
- clear target -> block disappears;
- target cast cue does not remain stale after target change/loss.

Target-caster true-path runtime proof remains deferred until a natural caster appears.

### Cast lifecycle

Player:
- cast start/stop;
- channel start/stop;
- interruption/failure.

Confirm no stale cue remains after the lifecycle ends.

### Party/pet lifecycle

Where practical:
- party row persists correctly during combat;
- pet row persists correctly during combat;
- health updates remain responsive.

Join/leave or pet summon/despawn transition should be exercised if naturally convenient, but B.5 already proves real pet/party presence and health transport.

### Immersion preference

With several HUD elements active:
- `/logres immersion off` hides the whole Logres HUD;
- `/logres immersion on` restores presentation from current state;
- no stale target/health/ally state appears after restoration.

### Existing state transitions

Regression-check the HUD across at least:
- world idle;
- ordinary combat;
- combat end.

If an instance transition is naturally convenient, observe it, but do not require travel solely for B.6 unless a specific defect needs it.

## Visual integration

B.6 should classify visual issues separately from architecture/runtime defects.

Known visual debt:
- health vignette uses rough procedural rectangles;
- exact central spacing is provisional;
- ally/pet stack placement is provisional ahead of Phase C action clusters;
- cast cues are first-pass geometric runes.

A visual issue blocks Phase B only if it makes the HUD materially unusable or ambiguous.

## Deferred evidence that remains valid

Do not incorrectly turn existing environmental deferrals into Phase B failures.

Still deferred:
- ordinary mounted=true sensor from Phase A.2;
- current-target cast true-path because no convenient caster has yet been available.

These have explicit retry conditions.

## Phase B exit target

Phase B can close when:
- all implemented HUD components coexist without functional regressions;
- no stale presentation survives target/cast/immersion transitions;
- secret-safe transports remain error-free;
- layout is usable enough to proceed to Phase C;
- known polish debt is recorded rather than confused with architecture failure.
