# Phase A — Core State Engine

Status: ACTIVE  
Opened: 2026-09-30

## Purpose

Turn the minimal Phase 0 state observer into the stable runtime contract that every later Logres subsystem consumes.

The state engine must describe reality without embedding presentation decisions.

HUD, Actions, Immersion, Compass, Questing, Social, and Camera will consume state; they must not independently reinvent global context detection.

## Design constraints

1. Prefer orthogonal facts/modifiers over combinatorial mega-states.
2. State detection is separate from presentation policy.
3. Event occurrence is not automatically equivalent to settled state.
4. State changes must be deterministic and observable.
5. Runtime state is not SavedVariables.
6. Do not persist secret combat data.
7. Add a state field only when a concrete subsystem needs it and its source can be justified.
8. Testing should minimize unnecessary user travel/repetition by collecting useful evidence automatically where practical.

## Current baseline

Phase 0.3 already provides:
- `context`: world / instance;
- `combat`;
- `pvpFlagged`;
- `inInstance`;
- `instanceType`;
- revision number;
- last triggering event;
- `STATE_CHANGED` callback publication.

Runtime proved:
- ordinary world state;
- combined instance + combat state;
- restoration after leaving instance;
- SavedVariables lifecycle;
- combat/restriction event timing is transitional.

## A.1 — State contract hardening

**Status: IMPLEMENTATION PREPARED; RUNTIME PROOF PENDING.**

Goal: define a stable consumer-facing state API before additional modules depend on internal tables.

Work:
- define the canonical state schema;
- distinguish internal mutable storage from consumer access;
- define callback payload semantics;
- define revision semantics;
- define initialization/unknown-state behavior;
- decide whether consumers receive snapshots, keyed changes, or both;
- prevent accidental external mutation of authoritative state where practical;
- add development diagnostics that expose state without becoming product UI.

Implementation:
- authoritative mutable table remains private to `Core/State.lua`;
- `Logres:GetState()` returns a fresh snapshot;
- `Logres:SubscribeState(handler)` publishes only real transitions and returns unsubscribe;
- callback payload is `(current, previous, changes, reason)`;
- revision advances only for actual canonical changes;
- `/logres statecheck` verifies snapshot isolation and no-op semantics without travel.

Success:
- one documented authoritative state contract;
- deterministic transition semantics;
- existing world/instance/combat/PvP behavior preserved;
- no consumer needs direct event knowledge;
- static state-contract check passes;
- travel-free runtime statecheck passes.

## A.2 — Additional context sensors

Add only the orthogonal facts required for planned immersion behavior.

Candidates:
- mounted;
- resting;
- NPC interaction;
- taxi/travel state where justified;
- player control/lifecycle conditions needed by later camera/immersion logic.

Before each field:
1. identify the owning feature;
2. identify the authoritative API/events;
3. record uncertainty;
4. test the narrow behavior.

Do not create combinatorial states such as `WorldMountedPvPCombat`.

## A.3 — User-controlled state

Introduce durable configuration state separately from observed game state.

Initial candidate:
- immersion enabled/disabled.

Requirements:
- persisted in `LogresDB`;
- clear default;
- state engine can expose effective state without conflating user preference with game facts;
- later settings UI can change it without rewriting subsystem logic.

## A.4 — Module lifecycle contract

Define how future Logres modules:
- register;
- initialize;
- enable;
- disable;
- subscribe to state;
- release temporary resources.

The lifecycle contract must remain lightweight. Do not build a framework larger than the addon requires.

## A.5 — Transition validation

Runtime-test the state contract using the smallest useful scenario matrix.

Required evidence should include:
- load/reload;
- world;
- instance;
- combat in at least one practical context;
- state restoration;
- any new sensors introduced in A.2/A.3.

Where manual travel is expensive, prefer:
- automatic transition logging;
- one combined scenario that exercises multiple orthogonal flags;
- deferred testing when an owning phase will naturally exercise the path.

## Exit criteria

Phase A completes when:
- state schema is stable enough for HUD/Immersion consumers;
- consumer-facing access/callback contract is documented and runtime proven;
- required context sensors are implemented;
- user-controlled immersion state is separated from observed game facts;
- module lifecycle is sufficient for subsequent phases;
- known failures/deferrals are recorded;
- no product HUD is required to prove the engine.
