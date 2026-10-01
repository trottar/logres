# B.6 — HUD Integration Validation

Status: DEVELOPER PANEL PREPARED; INTEGRATED RUNTIME VALIDATION NEXT
Opened: 2026-10-01

## Goal

Validate the completed Phase B HUD pieces as one coherent system before Phase B closes.

B.6 is primarily an integration/transition validation item.

It should not add another HUD feature unless testing exposes a concrete defect.

## Validation-surface improvement — P0029

Repeated copy/paste of slash-command diagnostics created unnecessary friction.

P0029 adds a rudimentary movable in-game Logres control/diagnostic panel.

The panel is now the preferred B.6 validation surface.

It exposes:
- Run All;
- Status;
- State Check;
- Sensor Check;
- Preference Check;
- Lifecycle Check;
- HUD Check;
- Immersion ON/OFF;
- HUD Preview ON/OFF;
- scrolling results.

Slash commands remain available.

The panel calls the same command implementation rather than duplicating checks.

## Components under validation

Phase B currently includes:
- player health vignette;
- player primary-resource percentage;
- sparse target name + health percentage;
- player cast/channel/interruption cue;
- current-target cast/channel cue;
- pet + party1–party4 compact name/health rows.

## B.6 runtime sequence after P0029

### 1. Panel baseline

After reload:
- `Logres Control / Diagnostics` should open;
- version should be `0.0.13-dev`;
- panel should be movable/closable;
- Run All should display results for the current registered checks;
- individual buttons should display their corresponding results.

Expected:
all static/runtime diagnostics PASS.

### 2. Immersion controls

Use panel buttons:
- Immersion OFF;
- Immersion ON.

The Phase B HUD should hide/restore.

The developer panel itself must remain visible.

### 3. Healthy world baseline

Confirm:
- no player-health vignette at healthy state;
- resource percentage visible;
- no target block without a target;
- no stale cast cue;
- only real pet/party rows shown.

### 4. Combat + target

During ordinary combat:
- health vignette responds to injury;
- target health depletes;
- player resource updates;
- player cast cue can coexist with target presentation;
- pet/party health rows continue updating;
- no obvious overlap makes the central HUD unreadable.

### 5. Target lifecycle

Confirm:
- acquire target -> target block appears;
- switch target -> target block updates;
- clear target -> block disappears;
- target cast cue does not remain stale after target change/loss.

Target-caster true-path runtime proof remains deferred until a natural caster appears.

### 6. Cast lifecycle

Player:
- cast start/stop;
- channel start/stop;
- interruption/failure.

Confirm no stale cue remains after the lifecycle ends.

### 7. Party/pet lifecycle

Where practical:
- party row persists correctly during combat;
- pet row persists correctly during combat;
- health updates remain responsive.

B.5 already proves real pet and party true paths.

### 8. Integrated immersion

With multiple HUD elements active, use panel:
- Immersion OFF;
- Immersion ON.

Confirm:
- Logres HUD hides;
- developer panel remains accessible;
- current HUD state restores correctly;
- no stale presentation appears.

### 9. Combat exit

Confirm cleanup remains sane after combat ends.

## Visual integration

B.6 classifies visual issues separately from architecture/runtime defects.

Known visual debt:
- health vignette uses rough procedural rectangles;
- exact central spacing is provisional;
- ally/pet stack placement is provisional ahead of Phase C;
- cast cues are first-pass geometric runes;
- developer panel is intentionally utilitarian.

A visual issue blocks Phase B only if it makes the HUD materially unusable or ambiguous.

## Deferred evidence that remains valid

Still deferred:
- ordinary mounted=true sensor from Phase A.2;
- current-target cast true-path because no convenient caster has yet been available.

These have explicit retry conditions.

## Phase B exit target

Phase B can close when:
- the developer panel successfully runs recurring validation;
- all implemented HUD components coexist without functional regressions;
- no stale presentation survives target/cast/immersion transitions;
- secret-safe transports remain error-free;
- layout is usable enough to proceed to Phase C;
- known polish debt is recorded rather than confused with architecture failure.
