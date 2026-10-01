# WoW Forever API Boundaries

Status: **PARTIALLY RUNTIME VERIFIED — I-001 ACTIVE**

Canonical investigation:
`../investigations/FOREVER_API_CAPABILITY_AUDIT.md`

Runtime evidence:
`../evidence/I001_RUNTIME_PASS_01_2026-09-30.md`

## Client identity — runtime verified

Do not use `WOW_PROJECT_ID == WOW_PROJECT_MAINLINE` as proof that the client is Retail.

Runtime on Forever 1.60.1 build 70124 / interface 16001:
- `WOW_PROJECT_ID = 1`;
- `WOW_PROJECT_MAINLINE = 1`.

Use capability checks where possible. Where client identity is genuinely required, use validated interface/build identification until Blizzard provides a distinct project ID.

## Lua compatibility — runtime verified negative boundary

Forever's addon Lua environment did not provide `table.pack` during the first probe.

Project code and diagnostics should use a compatibility helper when preserving vararg counts is required.

## Secret values are a first-class architecture constraint

Runtime showed player health and power percentages as secret even in ordinary open-world, out-of-combat snapshots.

Rules:
- do not perform ordinary Lua arithmetic/comparison on health/power percentage;
- never design product logic around recovering a secret value;
- use native curves/durations/secret-capable widget methods;
- never persist secret values to SavedVariables.

## Health vignette — transport path runtime verified

Runtime-proven operations:
- `UnitHealthPercent(unit)`;
- secret-safe formatting;
- `UnitHealthPercent(unit, true, CurveConstants.ZeroToOne)`;
- secret `StatusBar:SetValue`;
- secret `Texture:SetAlpha`.

The same operations succeeded while `InCombatLockdown()` was true.

Therefore the health vignette can be designed around secret-native visual transport rather than Lua thresholds.

Still required:
- prove a Logres-specific inverse/threshold curve suitable for vignette intensity/closure.

Do not implement:
```lua
if UnitHealthPercent("player") < 30 then
    ...
end
```

The percentage can be secret.

## Resource percentage text — runtime verified

Runtime-proven:
- `UnitPowerPercent("player")` returns secret;
- `string.format("%.0f%%", secretPercent)` succeeds and returns secret text;
- `FontString:SetText(secretText)` succeeds.

A percentage-only resource display is feasible without exposing the numeric value to Lua.

## Hidden enemy metadata — partially runtime verified

Ordinary valid targets returned:
- non-secret numeric level;
- non-secret `"normal"` classification.

Product policy remains:
- numeric level is not displayed;
- elite classification is not explicitly warned by default.

Still required:
- elite/rare target;
- valid target retained while active combat lockdown.

## Casting — open

`UnitCastingInfo` / `UnitChannelInfo` were callable, but the first pass did not capture an active player or target cast/channel.

Self-cast confirmation and enemy-cast behavior remain to be runtime verified.

## Secure actions / combat state

Protected action constraints remain a documented boundary.

Runtime adds an event-ordering warning:
- `PLAYER_REGEN_DISABLED` was observed before `InCombatLockdown()` settled to true;
- restriction state changed afterward.

State detection must read actual current state and tolerate transitions. Do not treat the first combat event as proof that every protected-state transition has already completed.

## Compass/navigation — open-world runtime verified

Open-world runtime proved:
- best-map lookup;
- player map position;
- non-secret X/Y;
- non-secret facing.

World compass inputs therefore exist.

Still required:
- instance entry proving the documented loss/unavailability there;
- quest waypoint behavior.

## PvP state — API runtime verified, flagged transition open

`UnitIsPVP("player")` is callable and returned non-secret false in the initial pass.

Still required:
- flagged transition.

## Quest waypoint — documented, not runtime verified

`C_QuestLog.GetNextWaypoint` is present, but waypoint coverage/semantics have not yet been exercised.

## Quiet Mode

`C_ChatInfo.InChatMessagingLockdown()` was callable and false during the first pass.

Visual chat suppression remains conceptually separate from outbound communication.

Automatic replies remain unapproved until a dedicated test establishes allowed behavior and a design decision is made.

## Camera — reads runtime verified

`GetCameraZoom()` and the camera CVars used by DynamicCam were readable in the initial pass.

Observed values changed during the session, so do not treat them as defaults.

No mutation behavior is yet promoted to runtime verified. Logres must preserve user settings before taking ownership of any CVar.
