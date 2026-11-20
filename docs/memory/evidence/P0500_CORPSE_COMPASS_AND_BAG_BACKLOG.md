# P0500 — Corpse direction in world compass; deferred bag-slot access (2026-11-20)

## Observed and baseline

P0499 main `c5f0aad8bcac8d152b5fc2cc95dfe771cf8b06a3`, tree
`e44f21e1e3e63263fa9e1567e83a7e8f1559d1ca` verified by read-only
GitHub call. User reports action bars working well with no other bugs
noticed in current session: L-055 **scoped positive**, not comprehensive
long-term runtime PASS or closure. User also asks for the corpse on the
compass while dead, and reports having to disable Immersion to equip a
new bag. These are separate issues L-058 and L-059.

## L-058 source and capability design

The world compass already has a 0.05 s heading and 0.15 s waypoint/POI
sampler, a first-class angle reservation, map-distance calculation,
headings and a focused text label; do not create a new timer/OnUpdate.
`C_DeathInfo.GetCorpseMapPosition(uiMapID)` is documented for Classic;
external Forever addon docs independently describe the same API and
Blizzard's DeathMapDataProvider. No direct live Forever corpse coordinate
sample has been provided to Logres, so availability/valid map projection
remain UNVERIFIED rather than fabricated. No reliance on external addon.

P0500 adds a distinct addon-owned tombstone marker, only when the player's
death state is a positively classified ordinary boolean and the native corpse point and player
point both resolve to valid ordinary coordinates on the SAME map ID. A
special edge cue indicates that the true body bearing is off the visible
compass tape; its edge placement is not represented as a real bearing.
The marker reserves tape occupancy ahead of quest/POI/user waypoint
symbols and receives focused body label when faced. Optional yards use
C_Map.GetMapWorldSize for that exact map, and are omitted if unavailable.
Death/ghost/resurrect/world events refresh the cue immediately, while
movement uses the existing 0.15s sampler. Invalid/secret/unavailable
state hides only Logres's corpse cue, leaving stock map and native
corpse guidance available. No native tracking, protected click, target,
map pin or user waypoint changes; no saved position.

## L-059 inventory/equipment deferral

Equipping a replacement bag required disabling Immersion to expose the
native bag-slot equipment interaction. The owner, presentation and
protected-action viability are not yet captured; do not guess a slot
implementation or remove the Blizzard surface. Future scoped work should
identify native slot access from an intentionally opened bag/character
panel and implement a capability-gated, OOC usable access route with
native restoration and fail-open controls. P0500 does not touch bags.

## Validation and runtime acceptance

Source/fixture checks exercise death/ghost position, secret/unavailable
fences, proper absolute map bearing, world-yard conversion and off-tape
cues. These are not in-client acceptance. Test real death -> spirit
release -> ghost movement, body behind and ahead, body across zone/map
boundaries, resurrection, Immersion OFF and standard native map access.
Capture Report Bug showing `compassCorpse` state if absent. No travel or
intentional death is required solely for proof; defer until natural play.
