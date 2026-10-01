# WoW Forever API Boundaries

Status: **I-001 COMPLETE — CORE BOUNDARIES RUNTIME VERIFIED**

Canonical investigation:
`../investigations/FOREVER_API_CAPABILITY_AUDIT.md`

Runtime evidence:
- `../evidence/I001_RUNTIME_PASS_01_2026-09-30.md`
- `../evidence/I001_RUNTIME_PASS_02_2026-09-30.md`

## Client identity

Runtime on Forever 1.60.1 build 70124 / interface 16001:
- `WOW_PROJECT_ID = 1`;
- `WOW_PROJECT_MAINLINE = 1`.

Do not use `WOW_PROJECT_ID == WOW_PROJECT_MAINLINE` as proof that the client is Retail.

Prefer capability checks. Where identity is genuinely required, use validated interface/build detection until Blizzard exposes a distinct project ID.

## Lua compatibility

Forever's addon Lua environment did not provide `table.pack` in the initial probe.

Use a compatibility helper when preserving vararg counts is required.

## Secret values

Player health and power percentages were secret even in ordinary open-world, out-of-combat snapshots.

Target health/power percentages were secret for valid ordinary and elite targets in tested world/instance combat contexts.

Rules:
- do not perform ordinary Lua arithmetic/comparison on health/power percentages;
- do not attempt to recover secret values;
- use native curves/secret-capable widgets;
- never persist secret values.

## Health vignette — runtime verified architecture

Runtime proved:
- custom native curve construction;
- secret `UnitHealthPercent` through the custom curve;
- secret transformed value into `StatusBar:SetValue`;
- secret transformed value into texture alpha;
- same path during active combat lockdown and instance combat.

This is the required default implementation model.

See D-008.

## Resource percentage — runtime verified architecture

Runtime proved:
- secret `UnitPowerPercent`;
- secret-safe percentage formatting;
- `FontString:SetText(secretText)`.

A percentage-only resource display is feasible.

## Enemy metadata

Runtime proved non-secret numeric level and classification for:
- ordinary targets;
- ordinary targets during active combat;
- elite targets;
- elite target during active instance combat.

Product policy remains:
- no numeric level shown by default;
- no explicit elite warning by default.

Availability does not imply disclosure.

## Casting

Player cast-time and channel APIs were runtime verified while active and returned non-secret player metadata.

A minimal self-cast/channel confirmation glyph is feasible.

Enemy cast behavior remains deferred because the initial product does not require hostile cast timing.

## Combat / restrictions

`InCombatLockdown()` is runtime verified.

Event timing is transitional:
- `PLAYER_REGEN_DISABLED` can occur before lockdown/restriction state fully settles.

Read current state; do not assume a single event means every restriction has already reached final state.

Secure action mutation remains deferred to Phase C, where actual secure frames will be tested.

## Compass / navigation

Open world:
- map ID/position available;
- facing available.

Party instance:
- player map position unavailable;
- facing unavailable;
- map restriction state active.

After returning to world:
- position/facing restored.

Therefore compass behavior is:
- world-only where data is available;
- automatically suspended in instances;
- restored after exit;
- never fabricate bearings.

## PvP

`UnitIsPVP("player")` read path is runtime verified in the false/unflagged state.

Flagged transition remains deferred to Phase A state-engine testing.

## Quest waypoint

`C_QuestLog.GetNextWaypoint` is present but detailed behavior is deferred to Compass/Quest phases.

## Quiet Mode

Chat messaging-lockdown state is readable.

Visual suppression can be implemented independently.

Automated outbound replies remain unapproved and deferred to a dedicated future test/decision.

## Camera

Zoom and relevant camera CVar reads are runtime verified.

Mutation/restore behavior is deferred to Phase G and must preserve user settings.
