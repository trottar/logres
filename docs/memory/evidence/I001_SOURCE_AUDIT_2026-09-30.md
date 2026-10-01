# I-001 Source Audit Evidence — 2026-09-30

Scope: source/documentation pass only. This record is **not runtime proof**.

## Baseline repository state

Logres memory bootstrap was verified pushed at:
`353c5b02b71323f33e7db31ca87086d797162681`

## Maintained Forever-compatible source

### DynamicCam Forever support

Commit:
https://github.com/mpstark/DynamicCam/commit/a665caf25fe3b451cbf4bd26cf5e22e02ae67d25

Relevant findings:
- Forever currently reports Blizzard `WOW_PROJECT_ID` as MAINLINE.
- DynamicCam therefore distinguishes Forever using the interface version (1.60.x range).
- Unified TOC includes interface `16001`.
- Conditional TOC metadata refers to the game type as `camelot`.
- Forever is treated as having a modern/retail-like event surface for the interaction cases DynamicCam needs.

Follow-up DynamicCam commits further removed impossible flying/vehicle situations and added Forever-specific camping behavior. These show active 2026 Forever maintenance rather than a stale compatibility branch.

## Current API documentation

The following Warcraft Wiki API pages currently mark the APIs as present for **Forever 1.60.1** unless noted.

### Restricted actions / secrets

- https://warcraft.wiki.gg/wiki/Secret_Values
- https://warcraft.wiki.gg/wiki/API:issecretvalue
- https://warcraft.wiki.gg/wiki/API:C_RestrictedActions.GetAddOnRestrictionState
- https://warcraft.wiki.gg/wiki/API:InCombatLockdown
- https://warcraft.wiki.gg/wiki/SecureActionButtonTemplate

Key documented behavior:
- tainted addon code can receive secret values but generally cannot inspect, compare, or perform arithmetic on them;
- certain native display APIs accept secrets and apply secret aspects;
- combat lockdown restricts protected-frame attribute, anchor, visibility, macro, and binding changes.

### Health/power and secret-safe presentation

- https://warcraft.wiki.gg/wiki/API:UnitHealth
- https://warcraft.wiki.gg/wiki/API:UnitHealthMax
- https://warcraft.wiki.gg/wiki/API:UnitHealthPercent
- https://warcraft.wiki.gg/wiki/API:UnitPowerPercent
- https://warcraft.wiki.gg/wiki/ScriptObject_ColorCurveObject
- https://warcraft.wiki.gg/wiki/API:StatusBar_SetValue
- https://warcraft.wiki.gg/wiki/API:Region_SetAlpha
- https://warcraft.wiki.gg/wiki/API:FontString_SetText

Key documented behavior:
- health/power percentage APIs are part of the modern restriction system;
- curves/color curves exist specifically to display potentially secret values;
- bar value, alpha, vertex color, and text have secret-capable widget aspects;
- secret strings can be displayed without addon Lua reading their contents.

### Unit metadata

- https://warcraft.wiki.gg/wiki/API:UnitLevel
- https://warcraft.wiki.gg/wiki/API:UnitClassification

Both are currently documented for Forever and without secret-return predicates on their API pages.

### Casting

- https://warcraft.wiki.gg/wiki/API:UnitCastingInfo
- https://warcraft.wiki.gg/wiki/API:UnitChannelInfo

Both are present for Forever and use `SecretWhenUnitSpellCastRestricted`.

### Navigation / state

- https://warcraft.wiki.gg/wiki/API:C_Map.GetPlayerMapPosition
- https://warcraft.wiki.gg/wiki/API:GetPlayerFacing
- https://warcraft.wiki.gg/wiki/API:IsInInstance
- https://warcraft.wiki.gg/wiki/API:UnitIsPVP

Player map position and facing are documented as restricted outside world use and unavailable in instanced content.

### Questing

- https://warcraft.wiki.gg/wiki/API:C_QuestLog.GetNextWaypoint

The API can return a quest waypoint map and coordinates when available.

### Social/chat

- https://warcraft.wiki.gg/wiki/API:C_ChatInfo.InChatMessagingLockdown
- https://warcraft.wiki.gg/wiki/API:C_ChatInfo.SendChatMessage
- https://warcraft.wiki.gg/wiki/API:C_ChatInfo.SendAddonMessage

The existence of send APIs does not establish that Logres may automate replies in all contexts. Lockdown/restriction behavior remains a runtime/design question.

### Camera

- https://warcraft.wiki.gg/wiki/API:GetCameraZoom
- https://warcraft.wiki.gg/wiki/API:CameraZoomIn
- https://warcraft.wiki.gg/wiki/API:CameraZoomOut
- https://warcraft.wiki.gg/wiki/API:C_CVar.SetCVar

DynamicCam source additionally demonstrates active Forever usage of camera CVars.

## Source-pass confidence rules

Promote a fact into architecture only at the strength actually supported:
- API page says Forever: DOCUMENTED;
- maintained addon relies on it: SOURCE-BACKED;
- user's client reproduces it: RUNTIME VERIFIED.

If runtime evidence conflicts with this record, runtime evidence wins and the conflict itself is retained as a negative finding.
