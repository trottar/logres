# C.4 — Contextual Visibility / Secure Paging

Status: ACTIVE
Opened: 2026-10-01

## Goal

Make the proven Logres action constellation respond to gameplay context without
violating combat-lockdown rules.

C.4 also resolves the known Primary combat-time page-remapping limitation
before any stock action-bar suppression is considered.

## Proven base

C.2/C.3 provide:
- secure Primary execution;
- fixed Secondary execution;
- fixed Utility execution;
- shared secure action-button presentation;
- fail-open key routing;
- stock bars as fallback.

## Product policy

Desired direction:

### Primary

Always perceptible.

It may change emphasis, but should not disappear during ordinary gameplay.

### Secondary

Outside combat:
- dim/subdued.

PvP flagged:
- stronger visibility.

Combat:
- fully available.

### Utility

World/idle:
- peripheral, faded, or intentionally revealed.

Combat:
- available where needed.

Instance:
- policy may be more conservative.

## Architecture questions

Before runtime implementation, resolve:

1. Which visibility changes can be ordinary alpha changes?
2. Which protected-frame Show/Hide changes require secure drivers?
3. Can Logres keep protected buttons technically shown while using
   presentation-only alpha/interaction policy safely?
4. How should mouse interaction behave for visually faded buttons?
5. Which state inputs can be expressed through secure macro-condition drivers?
6. How should `combat`, `pvpFlagged`, and context interact without creating a
   monolithic combined mode?
7. How should Primary's combat-time action-page changes be securely driven?
8. Which paging states are class/form/override/vehicle-specific on Forever?
9. What must remain stock-controlled until those special states are proven?
10. How should future D-020 layout profiles attach visibility policies without
    making protected mutation unsafe?

## Primary paging debt

Current C.2 behavior:
if the primary action page changes during combat, Logres defers remapping until
`PLAYER_REGEN_ENABLED`.

That is acceptable while stock bars remain visible.

It is not acceptable before stock primary-bar suppression.

C.4 must either:
- implement a source-proven secure page/state driver;
- or explicitly retain stock bar visibility for unsupported paging states.

## Scope boundary

C.4 does not build the full D-020 layout editor.

It should make visibility/page policy data-driven enough that future layout
profiles can consume the same policy model.

## Exit

C.4 completes when:
- contextual action emphasis/visibility is runtime-proven;
- protected visibility transitions are combat-safe;
- Primary combat-time paging behavior is resolved or precisely capability-
  gated;
- PvP remains a modifier rather than a separate monolithic mode;
- no required action becomes inaccessible.
