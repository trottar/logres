# I-001 — WoW Forever API Capability Audit

Status: ACTIVE — SOURCE PASS COMPLETE; RUNTIME PROBE NEXT  
Phase: 0.2  
Opened: 2026-09-30

## Question

What APIs, events, restrictions, and protected-state rules does the current WoW Forever client expose for the systems Logres intends to build?

## Why this must happen first

Logres intentionally depends on unusual presentation choices. Building against remembered Retail/Classic behavior risks architectural rework if Forever differs or inherits modern restrictions.

## Evidence classes used here

- **DOCUMENTED** — current API documentation marks the function/event as present for Forever.
- **SOURCE-BACKED** — maintained Forever-compatible addon source demonstrates an implementation assumption.
- **RUNTIME VERIFIED** — observed on the user's current Forever client.
- **UNKNOWN / NEEDS PROBE** — architecture should not depend on the result yet.

No item in this record is promoted to RUNTIME VERIFIED until the user's probe supplies evidence.

## Source-pass findings

### Client/project identification

**SOURCE-BACKED / NEEDS PROBE**

A current DynamicCam Forever-support change records:
- Forever reports Blizzard `WOW_PROJECT_ID == WOW_PROJECT_MAINLINE`;
- interface versions in the 1.60 line are used to distinguish Forever;
- the current Forever TOC interface entry is `16001`;
- DynamicCam names the game type `camelot` in a conditional TOC field.

Implication: Logres should not branch on `WOW_PROJECT_ID == WOW_PROJECT_MAINLINE` as proof of Retail. Prefer capability checks where possible, and where client identity is genuinely required, use validated build/interface identification.

Runtime probe must record `GetBuildInfo()` and `WOW_PROJECT_ID`.

### State/events

**DOCUMENTED / NEEDS PROBE**

Present on Forever:
- `InCombatLockdown()`;
- `IsInInstance()`;
- `UnitIsPVP("player")`;
- `PLAYER_FLAGS_CHANGED`;
- `PLAYER_REGEN_DISABLED` / `PLAYER_REGEN_ENABLED`;
- restricted-action state APIs.

`IsInInstance()` documents correct results at `PLAYER_ENTERING_WORLD`.

The maintained DynamicCam Forever implementation also treats Forever's event surface as retail-like for several interaction-manager/transmog/shipment events. That is useful compatibility evidence but not a blanket guarantee that every Retail event exists.

### Player health

**DOCUMENTED; SECRET-SAFE DISPLAY PATH PLAUSIBLE / NEEDS PROBE**

Present on Forever:
- `UnitHealth`;
- `UnitHealthMax`;
- `UnitHealthMissing`;
- `UnitHealthPercent`.

Modern restrictions matter:
- `UnitHealth` has secret returns;
- `UnitHealthPercent` participates in the secret-value/curve system;
- tainted addon Lua generally cannot compare or perform arithmetic on secret values.

The secret-value system provides native display mechanisms:
- numeric and color curves;
- `StatusBar:SetValue` secret bar-value aspect;
- `Region:SetAlpha` secret alpha aspect;
- vertex-color aspects.

This suggests a Logres health vignette can be implemented without exposing the numerical health value to Lua:
1. map health percentage through a native curve;
2. pass the resulting secret value directly to a permitted visual property;
3. never branch/arithmetic on the secret in addon Lua.

A promising design is four edge-oriented status bars/textures whose fill/alpha increases as health decreases. This remains a hypothesis until runtime proven.

### Player resource / mana percentage

**DOCUMENTED / NEEDS PROBE**

`UnitPowerPercent` is present and can become secret when unit power is restricted.

Secret strings can be produced through allowed formatting paths, and `FontString:SetText` accepts secret text by applying the Text secret aspect. Therefore a percentage-only resource readout appears feasible without Lua inspecting the value.

Runtime probe must test:
- percentage query;
- secret state in and out of combat;
- `string.format` on the returned value;
- `FontString:SetText` with the resulting string.

### Unit information

**DOCUMENTED / NEEDS PROBE**

`UnitLevel(unit)` and `UnitClassification(unit)` are present on Forever and are not currently documented with secret-return predicates.

This fits Logres well:
- level may be read internally for subtle relative styling;
- classification can be deliberately ignored for default presentation even when available;
- hidden elite classification remains an intentional design choice, not an API limitation.

Runtime probe must capture target level/classification for ordinary and elite targets, including in combat.

### Casting/channeling

**DOCUMENTED WITH RESTRICTIONS / NEEDS PROBE**

`UnitCastingInfo` and `UnitChannelInfo` are present and use `SecretWhenUnitSpellCastRestricted`.

Documented secrecy rules generally protect cast details for units other than the player/pet under restricted conditions.

Implication:
- the player's own minimal cast-confirmation glyph is promising;
- hostile cast presentation must not assume readable spell/timing data in all combat contexts;
- Logres should favor cast events and secret-safe display primitives over arithmetic on start/end times.

Runtime probe should observe both self and target casts.

### Actions / secure buttons

**DOCUMENTED WITH RESTRICTIONS**

`InCombatLockdown` applies on Forever. Protected frames and secure action button attributes/anchors/show-hide state cannot be freely reconfigured by ordinary addon Lua in combat.

Architectural consequence:
- action clusters should be created/configured outside combat;
- combat behavior should prefer preconfigured secure state and permitted visual changes;
- never design Phase C around arbitrary in-combat movement or action reassignment.

Exact alpha/visibility behavior on the planned cluster hierarchy remains a runtime/implementation probe.

### Navigation / compass

**DOCUMENTED WITH HARD CONTEXT RESTRICTION**

Present on Forever:
- `C_Map.GetPlayerMapPosition`;
- `GetPlayerFacing`;
- world/map conversion functions.

Both player map position and facing are documented as unavailable in instanced content.

This directly supports existing decision D-005:
- world compass can use position/facing where available;
- instance entry suspends compass/navigation;
- Logres must not fabricate bearings.

Runtime probe must verify open-world values and instance nil/unavailable behavior on the user's client.

### Questing

**DOCUMENTED / NEEDS PROBE**

`C_QuestLog.GetNextWaypoint(questID)` is documented on Forever and can provide map ID plus x/y for the quest's next waypoint.

This is promising for compass integration but not sufficient by itself:
- not every quest necessarily yields a waypoint;
- objective selection semantics need investigation;
- cross-map behavior needs handling;
- instance map restrictions still apply.

### Social / Quiet Mode

**DOCUMENTED WITH RESTRICTIONS / NEEDS PROBE**

Present on Forever:
- `C_ChatInfo.InChatMessagingLockdown`;
- `C_RestrictedActions.GetAddOnRestrictionState`;
- `C_ChatInfo.SendChatMessage`;
- addon-message APIs.

Chat sending has restrictions/lockdown states. The source pass does **not** establish that an addon may safely implement automatic whisper replies in every intended context.

Current design consequence:
- hiding/suppressing Logres presentation can proceed independently;
- automatic outbound replies remain UNKNOWN / NEEDS A DEDICATED PROBE and should not be promised yet.

The diagnostic addon deliberately sends no chat messages.

### Camera

**DOCUMENTED + SOURCE-BACKED / NEEDS PROBE**

Present on Forever:
- `GetCameraZoom`;
- `CameraZoomIn`;
- `CameraZoomOut`;
- camera FOV defaults;
- public CVar access subject to CVar restrictions.

Current DynamicCam source supports Forever and uses camera CVars such as:
- `cameraDistanceMaxZoomFactor`;
- `cameraZoomSpeed`;
- `cameraFov`;
- `test_cameraOverShoulder`;
- dynamic pitch/focus CVars.

This is strong evidence that the later camera module is feasible, but exact mutation behavior and user settings must be runtime validated before Logres owns these values.

## Negative findings / constraints from the source pass

1. **`WOW_PROJECT_ID` is not a reliable Forever discriminator.**
   - Maintained addon evidence says Forever answers MAINLINE.
   - Do not build flavor logic around that assumption.

2. **Health/power cannot be treated as ordinary numbers in restricted contexts.**
   - Direct arithmetic/comparison on secrets can error.
   - Any design that starts with `UnitHealth()/UnitHealthMax()` math is rejected for Logres' modern/Forever path.

3. **Enemy cast details cannot be assumed readable during restricted combat.**
   - The no-cast-bar design avoids depending on this, but any later hostile cast cue must be secret-safe.

4. **Secure action clusters cannot be arbitrarily rearranged during combat.**
   - Dynamic combat layout must be designed through secure/preconfigured mechanisms, not ordinary frame mutation.

5. **Compass position/facing is unavailable in instances.**
   - This is a real API boundary, not merely an aesthetic choice.

6. **Automatic chat replies are not established by this pass.**
   - Quiet Mode must not advertise auto-response until separately proven.

## Runtime probe

A temporary diagnostic addon is provided at:

`tools/probes/LogresAPIAudit/`

It stores only sanitized/non-secret observations. Secret values themselves are never persisted.

Initial runtime scenarios:
1. open world, out of combat;
2. ordinary target;
3. elite target if convenient;
4. player enters combat;
5. player casts/channels;
6. target casts if convenient;
7. PvP flagged state when safe/convenient;
8. instance entry when convenient.

The probe should be run incrementally. A missing scenario remains UNKNOWN rather than inferred.

## Completion gate

I-001 completes only after architecture-critical source claims have runtime evidence or are explicitly deferred with rationale.

## Source evidence

See:
`../evidence/I001_SOURCE_AUDIT_2026-09-30.md`
