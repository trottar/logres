# WoW Forever API Boundaries

Status: **PROVISIONAL — SOURCE PASS COMPLETE, RUNTIME VERIFICATION ACTIVE**

Canonical investigation:
`../investigations/FOREVER_API_CAPABILITY_AUDIT.md`

## Client identity

Do not use `WOW_PROJECT_ID == WOW_PROJECT_MAINLINE` as proof that the client is Retail.

Maintained Forever-compatible addon source reports that Forever currently answers MAINLINE. Interface/build identification (currently 1.60.x / TOC 16001) plus capability tests are the provisional identification strategy.

## Secret values are a first-class architecture constraint

Forever exposes the modern secret-value model.

Logres code must assume that health, power, cast details, identity, aura, and related combat information can become secret depending on restriction state.

Rules:
- never perform ordinary arithmetic/comparison on a value merely because it was numeric out of combat;
- use `issecretvalue` in diagnostics, not product branching intended to recover the hidden value;
- prefer native curves/durations/secret-capable widget methods;
- never persist secret values to SavedVariables.

## Health vignette

Provisional feasible path:
- `UnitHealthPercent`;
- native curve maps health to an intensity/fill value;
- direct pass into secret-capable visual APIs (`StatusBar:SetValue`, alpha/vertex-color aspects).

This is not yet runtime validated.

The architecture should favor visual primitives that can consume the secret directly rather than code that needs to know "health < 30%".

## Resource percentage text

Provisional feasible path:
- `UnitPowerPercent`;
- secret-safe formatting to a secret string;
- `FontString:SetText`.

Runtime verification required.

## Hidden enemy metadata

`UnitLevel` and `UnitClassification` are documented available on Forever.

Product policy remains:
- numeric level is not displayed;
- elite classification is not explicitly warned by default;
- these values may be used internally only when the API permits and the design decision allows.

## Casting

Self cast/channel confirmation is expected to be feasible.

Enemy cast data may be secret in restricted contexts. No Logres architecture may require unrestricted target cast times or spell IDs.

## Secure actions

Action buttons must be treated as protected/secure UI.

Create and configure action mappings/layout outside combat. Any combat-time presentation changes must be proven safe for protected frames before adoption.

## Compass/navigation

`C_Map.GetPlayerMapPosition` and `GetPlayerFacing` are unavailable in instanced content.

World compass behavior must:
- check availability;
- suspend in instances;
- restore outside;
- never invent coordinates/bearings.

## State engine inputs

Source-backed candidates:
- combat: `InCombatLockdown` plus regen events;
- instance: `IsInInstance`;
- PvP flag: `UnitIsPVP("player")`;
- restriction state: `C_RestrictedActions.GetAddOnRestrictionState`.

Runtime probe will establish exact transition behavior.

## Quest waypoint

`C_QuestLog.GetNextWaypoint` is available, but waypoint coverage/semantics are not yet validated for Logres' quest helper.

## Quiet Mode

Visual chat suppression is conceptually separate from outbound communication.

Automatic replies remain unapproved until chat-lockdown/restriction behavior is runtime tested and a separate design decision is made.

## Camera

Basic zoom and camera CVars exist, and a maintained DynamicCam build supports Forever.

Logres must preserve user settings and validate each CVar before later camera ownership.
