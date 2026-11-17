# P0464 — Per-unit native world aura repair

Baseline: GitHub/local main `9ec4fd4f913d3d85934d0aed3756cda98f55c46d`
(P0463). Runtime 0.0.333-dev. No source edits to accepted HP geometry,
50% secondary scale/opacity, identity/epoch classification, activation or
native objective tracker. No change to unrelated NPC interactions.

## Evidence and diagnosis

Latest export 2026-11-16T19:32:26-05:00, standalone/bundled diagnostic SHA256
`10ab72ed5500afe0b07b84bdb60d18e01c6df3e65595c315c4c93770105c9d9e`.
Session135 #13829, screenshot WoWScrnShot_111626_193141.jpg individually
inspected. Source/deployed/captured 0.0.332-dev match. Selected Mangy Wolf
68% Logres HP; user confirms both selected and secondary 50/50 HP work.
Native aura appearance remains FAIL, not partial acceptance. Layout claims0,
restores0, refusals4, reason native-aura-point-capture-refused. This is the
native GetPoint snapshot refusal, not proof of absent auras or addon load.
Owner/restoration failures0 do not override visible aura failure.
Native objective tracker refold observed; full quest/taint coverage unverified.

## Narrow repair and ownership

Retain historical P0463 layout helper/tests but never call it live. New
NativeDebuffs module prepares two styled CustomAuraContainers per OOC-built
selected/secondary HP owner. Harmful left, helpful right, 3 columns, up to12
each (at least the native 12 harmful/2 helpful display capacity). Icon inset,
Logres frame/color and 25px size reuse established theme. Native cooldown
and application-count consumers retain duration/stacks without addon data
reads. Secondary parent supplies the already accepted 50% size and opacity.

After ordinary HP attachment/Show succeeds, supported native SetUnit binds
the actual ordinary nameplate token, enables/updates/shows both consumers.
Only then may positively ordinary, unprotected/nonforbidden stock harmful
and helpful lists transfer via opaque IsShown tokens and SetShown(false).
All tokens captured before any suppression. No native point/count/child getters. Local IsShown flags are opaque
restoration tokens only; never tested, compared or serialized. Initialization callbacks are styling, never icon-presence
proof. No aura payloads, strings, timers, secure attributes or native unit
ownership are inspected or changed. Native CC/loss-of-control, cast/raid and
click surfaces remain untouched. The API contract establishes binding only;
it does not establish actual visible icons or client acceptance.

On failure stock remains/restores; aura setup cannot discard working HP.
On detach/OFF/token transition native shown restoration precedes owned
withdrawal. Refused restoration retains the active replacement and blocks
HP withdrawal/reuse; normal lifecycle/safe events retry, never polling.
Steady owners never rebind. Existing screen-target aura duplicate handoff
remains structurally gated, with native stock fallback when renderer refuses.
Report Bug exports renderer binds/releases/refusals/reason automatically.

P0450 readiness-as-visibility failure and P0461/P0463 failures remain history.
This repair requires both native per-unit consumers to accept full activation;
it never claims runtime visibility from allocation or counters. Any visual
failure keeps L-028 OPEN. No manual diagnostic-panel itinerary is needed.

## Source basis

Public Blizzard API source read 2026-11-16:
- https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_AuraContainer/Blizzard_AuraContainer.lua
- https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_AuraContainer/Blizzard_CustomAuraContainer.lua
- https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_AuraContainer/Blizzard_CustomAuraButton.lua
- https://github.com/Tercioo/Plater-Nameplates/blob/master/Plater_Auras.lua

SetUnit/SetEnabled are native consumer operations, separate from secure unit
attributes. Custom initialization configures icon/cooldown/count consumers;
the engine handles restricted values and later aura events. Flow layout uses
horizontal/vertical AnchorUtil enums. No third-party implementation copied.
Client API availability remains capability-gated; source models do not prove
Forever combat trust/taint execution.

## Release gates and runtime limitations

Execute actual-source P0464 fixture (styled distinct units, inherited50/50,
no GetPoint, steady no-rebind, setup/bind/update/show/shown capture refusal,
partial handoff rollback, opaque restoration pending and HP quarantine).
Run all seven earlier relevant source fixtures; baseline P0463 must fail the
new test. Full exact-candidate canonical checker inventory, Lua5.1 syntax,
diff hygiene, manifest, payload parity, wrong baseline/tamper/dirty/collision
refusal and injected POSTWRITE byte-for-byte rollback required before handoff.
Private scratch indexes only; actual user HEAD/refs/index preserved.

STATIC/source PASS is separate from client UNVERIFIED. No WoW execution or
visual/taint PASS by assistant. L-028 OPEN; L-011 PARTIAL; L-048 OPEN.
User may keep playing: Report Bug at observed fault, /reload then exporter.

### Mouse-region safety correction during release audit

Source XML shows native aura items have mouse hover regions. Alpha-zero
suppression could leave invisible regions. Final P0464 therefore hides whole
native list parents with SetShown(false) after capturing original local flags
opaquely, and restores those flags through SetShown before replacement removal.
No visibility proof/readback, child inspection or mouse-region mutation. Native
Show can fail open visibly; no hook/polling reasserts hiding. Actual re-show or
API refusal is client UNVERIFIED. No alpha suppression in the new aura owner.
Source: https://github.com/Gethe/wow-ui-source/blob/beta/Interface/AddOns/Blizzard_NamePlates/Blizzard_NamePlates.xml
and https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_NamePlates/Blizzard_NamePlateAuras.xml

### Measured release validation

327/327 full canonical exact-candidate checks and 8/8 relevant actual-source
fixtures PASS. New P0464 source fixture fails against unmodified P0463 (missing
PrepareWorldAuraOwner), confirming the test distinguishes this repair. Initial
author candidates refused on CURRENT/HANDOFF byte budgets; concise summaries
were repaired without weakening limits. No user-source writes occurred.
Final archive requires repeated canonical PREWRITE/POSTWRITE327/327, payload
parity, manifest, cleanup/diff hygiene, Lua5.1 runtime syntax, actual wrong-HEAD
simulation/tamper/dirty/new-path refusal and injected POSTWRITE exact rollback.
Final mouse-safety correction uses whole-list shown restoration, never alpha0.
Client UNVERIFIED; source tests do not establish visible icons or combat trust.
