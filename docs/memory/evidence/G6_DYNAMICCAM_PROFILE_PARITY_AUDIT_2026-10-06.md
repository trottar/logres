# G.6 — Captured DynamicCam Profile Parity Audit — 2026-10-06

Status: **SOURCE / PROFILE RESOLVED — CONSOLIDATED CONTEXT+ZOOM IMPLEMENTATION AUTHORIZED**

DynamicCam source:
`mpstark/DynamicCam@ae586a9c973c3f868c10440358d4a6e8c2fab5ff`

Canonical captured profile:
`G1_DYNAMICCAM_RPG_PROFILE_2026-10-02.json`

## Why this audit exists

The captured profile already specifies the intended camera behavior. Earlier Phase G work intentionally migrated narrow capability slices, but that left most enabled profile situations outside Logres.

The remaining work should therefore be organized by coherent behavior layers, not by one patch per situation.

## Enabled profile matrix

| Priority | ID | Situation | Captured zoom | Enter | Other captured behavior |
| ---: | --- | --- | --- | ---: | --- |
| 1000 | 160 | Taxi | conditional-out `50` | 5s | continuous yaw `-20`; UI opacity `0` |
| 130 | 200 | Hearth/Teleport | conditional-out `20` | 5s / cast duration | continuous yaw `+15`; UI opacity `0` |
| 120 | 303 | AFK | none | 0s | no captured rotation/UI override |
| 120 | 320 | Gathering | conditional-in `5` | 3s | yaw `-15`, pitch `+15` |
| 110 | 300 | NPC Interaction | conditional-in `5` | 2.5s | yaw `-45`; shoulder `-2`; UI opacity `0` |
| 50 | 006 | World Combat | conditional-out `15` | 2.5s | none stored |
| 20 | 302 | Fishing | conditional-out `50` | 2s | yaw `+10`, pitch `+10`; exit delay `1s` |
| 1 | 001 | City | conditional-in `5` | 2.5s | UI opacity `0.65`; situation camera settings |
| 0 | 004 | World | conditional-in `5` | 2.5s | none stored |

The profile uses `zoomRestoreSetting = never`.

## Source predicates

Pinned DynamicCam resolves:
- Taxi: `UnitOnTaxi("player")`.
- Hearth/Teleport: current player cast spell ID in the upstream teleport set; secret cast IDs are ignored. On enter, ordinary start/end times replace the configured enter duration with cast duration.
- AFK: `UnitIsAFK("player")`.
- Gathering: current player cast spell ID in the upstream mining/skinning/herbalism set; secret spell IDs are ignored.
- NPC Interaction: supported interaction frame shown plus `UnitExists("npc")`, with `FlightMapFrame` excluded. DynamicCam also has a small mounted-vendor self-exclusion through LibMountInfo; P0159 does not claim that edge and leaves it as a documented bounded parity exception until the mount-ID source is deliberately owned.
- World Combat: non-instance + live `UnitAffectingCombat("player")`.
- Fishing: player channel name matches Fishing spell `7620`.
- City: `IsResting()`.
- World: not resting and not in an instance.

DynamicCam evaluates enabled situations and selects the strictly highest numeric priority.

AFK and Gathering both use priority `120`. Upstream iteration is `pairs()` plus strict `>`, so the source does not provide a stable tie-break for simultaneous truth. P0159 deliberately chooses AFK before Gathering for deterministic Logres behavior; simultaneous AFK+Gathering is an exceptional edge and remains documented rather than fabricated as source parity.

## Fishing delay correction

DynamicCam situation `delay` is checked while **leaving the current situation**.

Therefore Fishing's `delay = 1` means a one-second exit hold. It is not an activation delay.

P0159 implements that finite hold with the existing controller frame and `GetTime()`. It does not add `C_Timer`, a ticker, or ongoing polling.

## P0159 ownership

P0159 owns:
- remaining source-backed context detection;
- priority selection;
- conditional zoom target/duration behavior;
- Teleport cast-duration override when ordinary/non-secret;
- AFK no-zoom context;
- Fishing one-second exit hold;
- engine-clamped diagnostics for requested high-out targets;
- event-driven reevaluation;
- profile predicate diagnostics.

P0159 does not own:
- continuous or degree rotation;
- rotation-back behavior;
- shoulder-offset camera CVar ownership;
- profile-wide/situation-specific camera CVar ownership;
- reactive zoom;
- DynamicCam UI hide/fade.

Those form the next consolidated parity layer, except UI hide/fade which must be reconciled with Logres Phase H presentation policy.

## Safety

No profile predicate may inspect a secret-capable value before secrecy is checked.

P0159 never calls `SetCVar`, `CameraZoomIn`, `CameraZoomOut`, or timer/ticker APIs.

DynamicCam coexistence remains fail-open: if DynamicCam is loaded, Logres relinquishes production camera ownership.

## Result

**P0159 CONTEXT+ZOOM PARITY IMPLEMENTATION AUTHORIZED.**
