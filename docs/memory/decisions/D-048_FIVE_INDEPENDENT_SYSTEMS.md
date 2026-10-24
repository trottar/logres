# D-048 — Five independent Logres systems and native-first fallback

**Status:** ACCEPTED product direction, 2026-10-23. This decision refines D-047 modularity and D-046 preview-first implementation; it is **not** authorization to change existing Lua ownership or claim the switches already work. Public alpha and 1.0 target five independently selectable domains.

## Product contract

Logres is a world-first addon with five user-selectable systems. Every system offers the player a meaningful **Logres / Blizzard** choice. A player may select Logres for any subset; the other domains must continue in Blizzard mode. The five selectors are **not** a single Immersion ON/OFF prerequisite.

| ID | Player-facing system | Logres scope | Blizzard fallback and retained controls |
| --- | --- | --- | --- |
| NAV | Navigation | Compass, heading, manual waypoint, and source-proven future quest/POI/tracking markers | Minimap and all tracking/map information not yet replaced remain available; do not hide minimap before D-037 completeness proof |
| ACT | Action bars | Primary/Secondary/Utility clusters and only capability-proven pet/special controls | Blizzard action controls, bindings, Edit Mode, special/vehicle/override and other unsupported domains remain safely available |
| NPC | NPC interactions | Quest narrative, gossip, trainers and eventually supported service presentation | Native quest detail/turn-in/choice, vendor and flight transactions, and unsupported NPC families stay usable; never strand an invisible native click region |
| STATUS | Player and enemy health/resources/status | Health tunnel, sparse target, resources, casts, buffs/debuffs, relevant pet/class indicators | Preserve native player, target, aura, party, compact-party, target-of-target and special controls wherever Logres has no complete safe replacement; no exact player HP/conventional player HP bar |
| CAM | Camera interactions | Accepted camera transitions, cinematic behavior and camera-context integration | Release Logres control without corrupting stock camera settings or DynamicCam; current camera code is a frozen baseline under D-047 |

STATUS is **one top-level selector**, not separate user-visible health/resource/aura domains. Domain-local settings are permitted, and *Active Quest* remains an optional content preference rather than a sixth top-level selector. PvP is a presentation modifier, not an automatic immersion-off condition. Quiet Mode remains a policy subordinate to intentional player preferences; outbound chat remains usable.

## Independence, capability and lifecycle

1. Settings select **requested** domain ownership; addon-owned diagnostics must separately report effective ownership, incomplete capability, native fallback and pending restoration. Do not claim a Logres domain owns a Blizzard surface merely because a boolean is true.
2. Enabling NAV must not force ACT/NPC/STATUS/CAM; disabling one domain must not clear another's user preference, presentation or input. No cross-domain forced ON/OFF. A future optional *Immersion preset* may batch selections for convenience, but is not a hidden master dependency.
3. On a toggle, native controls must be restored **before** the Logres replacement relinquishes interaction; protected combat transitions must defer, preserve usable controls, and expose a pending state. Never poll, mutate secret-capable values, reassert generic stock Show/Hide, or leave click regions on-screen while visually absent.
4. Shared primitives, source adapters, presentation models, renderers, interaction controllers and lifecycle/parking belong to separate modules where beneficial. Source observation is independent of presentation policy. Use D-046 fixture → plain model → identical renderer → visual acceptance → guarded live adapter → separate controller.
5. Preserve saved configuration through a documented migration. Today `Logres/Core/Preferences.lua` and `Logres/Core/Database.lua` persist only `immersionEnabled` and `activeQuestEnabled`; the current global Immersion policy couples several domains. Do **not** silently reinterpret existing saves, flip a previously working user's display, or expose five switches as operational before isolated restoration is tested.
6. Full 2^5 = **32 configurations** should be covered by deterministic policy tests. In WoW, prioritize each domain independently ON/OFF, all stock, all Logres, and high-risk concurrent handoffs, combat, quest/service transitions, mode changes and reload. Static tests do not constitute runtime PASS.

## Planned implementation sequence, not yet code authorization

- Inventory existing modules and every dependency on `immersionEnabled`; establish a domain ownership map, explicit stock fallback and effective-state contract. This is a **read-only** audit first.
- Prepare pure policy / model tests and an inert settings preview; prove backward-compatibility migration behavior with fixtures.
- Split ownership **one domain at a time**, only after the correct Blizzard restore path is supported and validated in Forever. Start with a low-risk presentation domain; do not begin with frozen camera or protected secure action controls.
- An incomplete domain must work in native/fail-open mode. Do not automatically remove Blizzard minimap, party, enemy auras or special controls in the name of a five-switch UI.

## Alpha and 1.0 intent

The internal goal is **alpha-quality near Forever launch**, followed by defined 1.0 functionality after launch. Alpha can have unfinished optional features and native service fallbacks, but must not ship a known critical gameplay, secure-action, taint, or restoration failure. Five selectors are the target user-facing architecture even at 1.0; whether all are safe for the initial alpha depends on actual in-client testing. Do not publicly promise a date, feature or API result without verification. The release gate, phased roadmap and limitations live in `docs/memory/roadmap/LAUNCH_READINESS.md`.

## Frozen baselines

- P0320 user-visible gossip/quest-link functionality is accepted for its observed scope; P0321 at pushed `9a180c8` is **runtime UNVERIFIED** until client proof. Never classify the new stock parking as PASS based on code or checkers.
- Camera/DynamicCam state remains frozen by D-047, `Quest 237` remains reserved, stock quest detail and transaction controls remain native-owned, and the approved immersion/world-first visual identities remain intact.
- This decision is product/architecture memory, **not** a runtime mutation. Separate explicit implementation checkpoints are required.
