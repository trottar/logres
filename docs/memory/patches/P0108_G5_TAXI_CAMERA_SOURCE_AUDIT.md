# P0108 — G.5 Taxi Camera Source/Profile Audit

Date: 2026-10-03
Result: **PREPARED — DOCS/SOURCE EVIDENCE ONLY**
Baseline: `ab83882f28f98b3d90cc6bee65e5d7c45928c536`
Runtime: `0.0.43-dev` unchanged

## Purpose

Resolve the Taxi camera contract far enough to identify the exact remaining
capability gate before production ownership.

## Source/profile findings

Pinned DynamicCam source plus the captured `RPG` profile establish:
- Taxi `160` uses `UnitOnTaxi("player")`;
- refresh events are `PLAYER_CONTROL_LOST` / `PLAYER_CONTROL_GAINED`;
- priority `1000` outranks interaction/combat/City/World;
- Taxi is conditional-out absolute target `50`;
- Taxi entry uses `5` seconds;
- ordinary Taxi exit uses destination entering time under restore `never`;
- rotation is independently implemented and can remain separately gated;
- UI hide/fade is separate presentation policy.

Logres already has a runtime-proven `state.onTaxi` sensor and needs no new poller.

## New blocking capability question

DynamicCam permits zoom target `50` on non-mainline clients, but source also
ties effective camera distance to `cameraDistanceMaxZoomFactor`.

The captured profile does not prove the effective current Forever runtime value,
and Logres has not accepted mutation of that CVar.

Production Taxi ownership is therefore not authorized yet.

## Authorized next step

A diagnostic-only developer-panel capability probe may be implemented to:
- read the CVar;
- attempt target `50` with the proven MoveView path;
- restore start zoom;
- record target/secret/error state;
- refuse with DynamicCam loaded;
- never mutate camera-distance CVar state.

A real Taxi ride is not required for this capability proof.

## Failure discipline

If target `50` is not reachable without CVar mutation:
- record the result as a negative capability finding;
- keep Taxi fail-open;
- open a separate camera-distance ownership decision;
- do not silently lower the Taxi target.

## Deployment

Docs/source-evidence only.

No WoW redeploy required.
