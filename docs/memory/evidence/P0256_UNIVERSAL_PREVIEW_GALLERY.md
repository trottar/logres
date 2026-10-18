# P0256 — Unified visual preview tab and repository-wide coverage inventory

Date: 2026-10-18. Authoritative GitHub `main` `fc74e14565d1111fb97a78d1a34cc2c759f62ee7` (P0255 pushed).

## User requirement (scope correction)

**EVERY Logres UI element** must have reproducible visual preview coverage, not merely the NPC quest UI. All visual preview actions must live in a single **P — Previews** tab in the developer panel; roadmap tabs remain for diagnostics, policy toggles, and live interaction tests. NPC dialogue is the first repair target; a user-reported ~20-minute gameplay session exposed numerous further, still-unspecified bugs. Do not turn an unspecified bug report into fabricated diagnoses. Record the broad bug backlog as OPEN / DETAILS PENDING until the user supplies evidence after dialogue work.

## Source audit

GitHub main contains 55 addon Lua files across HUD, actions, immersion, navigation, quest, camera, settings and development. The developer command registry contains 94 phase actions before P0256. The 18-button phase viewport cannot host all current visual preview actions on one page. No new WoW interaction is necessary to navigate the registry.

P0256 introduces **P — Previews**, an explicitly paginated central gallery. It migrates every registered visual-preview command, including original health percentage presets, aura samples, compass role art, XP, objective progress, active quest states, quest narrative and guaranteed/multiple reward samples. The action feedback pulse is a non-claim visual demonstration; it is also collected under previews. Two existing developer slash preview commands (HUD preview on/off) receive gallery buttons. Each P page has up to 18 actions, with previous/next controls and an N/M counter. Nonpreview checks and mutating controls remain in their original roadmap tabs. The P tab is not a second name for Phase H or a new roadmap phase.

## Per-surface preview inventory (design obligation, NOT implementation acceptance)

| Visual surface / states | Preview coverage before P0256 | Next required work |
| --- | --- | --- |
| Player health/injury visual bands (0–100%) | Health presets, live exit | Verify all bands and persistence transitions |
| Player cast/channel, target cast/channel, interrupt | No direct visual state picker | Add isolated sample/clear states |
| Player/resource/pet metadata and status percentage bars | Incomplete | Add player/resource/pet/special state samples without native suppression |
| Target label, friendly/hostile/dead/unknown and contextual HUD | Incomplete | Add identity-safe state samples |
| Player helpful, harmful, target helpful/harmful aura states | Helpful and status preview subsets | Add remaining category, count, urgency and clear samples |
| Primary action keys/icons/feedback/overlays, secondary/utility clusters | Action feedback pulse only | Add icon, cooldown, binding and highlight previews without secure mutations |
| Pet action slots/state and native pet replacement fallback | Probe/checks only | Add visual pet samples with combat-safe fail-open handling |
| Context message, dock, quiet/social cue | No coherent element-level samples | Add explicit state/clear previews |
| Compass tape, cardinal ticks, quest glyph, waypoint, tracking and services | Compass artwork ON/OFF | Add per-glyph and multi-location fixtures, no fabricated live POI claims |
| XP, objective progress, active quest journal/context/complete states | Several existing previews | Expand edge and overflow states |
| NPC quest narrative: offer single/multi page, page indicator, Accept/Decline | One offer narrative preview | Add dedicated page1/final-page and in-panel-action fixtures |
| NPC quest progress/Continue | No dedicated visual fixture | Add narrative/progress/action-state previews; native action remains gated |
| NPC completion: single/multi page, guaranteed/choice/zero rewards, overflow, money, fallback | Single/multiple reward samples | Add final-page gate and full item/state matrix (read-only) |
| NPC quest gossip and interaction feedback | No isolated preview | Add visual-only transition/feedback fixtures |
| Settings, docks, in-addon panels/menu surfaces | Settings panel is live, not a preview | Add read-only preview mode and restore state |
| Immersion visibility/ownership (stock off/on) | Functional diagnostics, not isolated visual fixture | Add nonmutating display-context presentation preview where safe |

The table deliberately distinguishes existing partial preview capability from missing coverage. **P0256 does NOT complete all element-level previews.** Every missing row remains OPEN and must be implemented in successive targeted patches, with NPC dialogue first. Do not add a fake 'preview' button that merely reports PASS while displaying nothing.

## Safety and acceptance

The gallery is a presentation/reorganization change. It reuses existing preview command strings without invoking them automatically; no new game mutation, protected frame operation, secret read, claim, accept, or decline is introduced. Preview actions remain explicitly player-initiated. The `H.2 Map` diagnostics subview remains on Phase H because it is a calibration/audit control, not a Logres UI sample. The previously reported Blizzard quest-frame flash after an actual claim is OPEN: do not remove native restoration, hide a protected frame, or add timer/polling merely to conceal it. Quest 237 remains reserved (no claim). The user-reported P0255 offer-placement screenshot displays `0.0.154-dev`, whereas P0255 source is `0.0.155-dev`: thus the screenshot does **not** independently prove P0255 runtime behavior; P0255 acceptance is UNVERIFIED, not silently PASS or FAIL.

Accept P0256 only after all repository checkers pass and WoW shows the P tab, page navigation, actual preview display, correct command registration, and retained diagnostics/actions on the original tabs. Static proof alone does not establish visual runtime success.
