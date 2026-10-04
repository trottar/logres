# P0120 — Shared Percentage-Bar Primitive

Date: 2026-10-04
Result: **INSTALLED / PUSHED — CORE RUNTIME + VISUAL PASS; ORNAMENT DEFERRED** (`6c5f8901`)
Verified baseline ancestor: `c342bc176a9d5de80ec116d0c6b31fa595cd75b3`
Runtime: `0.0.49-dev -> 0.0.50-dev`

## Purpose

Translate the approved D-039 resource-bar sheet into a reusable addon-capable
normal/compact percentage-bar primitive without reopening the visual design.

This patch is intentionally isolated from the active Taxi workstream. It does
not modify Camera source, G.5 investigations/evidence, `CURRENT.md`, or
`CURRENT_HANDOFF.md`.

## Runtime scope

P0120 adds production media/tokens and migrates Logres-owned percentage
presentation for:
- player primary resource;
- detached current-target health;
- pet health;
- party1–party4 health.

Each bar retains visible percentage text. Player health is not migrated and
continues to use the D-036 peripheral health tunnel.

## Secret-safe contract

The existing native 0–100 curve output is forwarded directly to:
- `StatusBar:SetValue`;
- `FontString:SetFormattedText`.

The value is never inspected, compared, stringified by ordinary Lua, persisted,
or used for threshold branching.

Health -> StatusBar transport is already proven by D-008. The player-resource
`UnitPowerPercent` -> `StatusBar:SetValue` path is the explicit runtime gate for
this checkpoint and must not be declared PASS from static checks alone.

## Presentation

- normal bar: player resource + detached target health;
- compact bar: pet/party health rows;
- dark track, restrained bronze line work, diamond endcaps;
- visible `%` text remains to the right;
- player resource uses ordinary `UnitPowerType` token selection for the approved
  mana/rage/energy/focus/runic/alternate color families;
- target health uses a fixed restrained target tint in this slice;
- ally health uses the approved quiet green family;
- target reaction/danger coloring remains separately capability-gated.

## Validation gate

In client:
1. Phase B -> HUD Check must PASS.
2. Player resource bar must fill/update with resource changes and retain readable
   percentage text without Lua/secret errors.
3. Current-target health bar must update during damage/healing and clear when the
   target is lost.
4. Pet/party compact bars should be checked when naturally available; unavailable
   environmental coverage is DEFERRED, not PASS.
5. Immersion OFF/ON must hide/restore the bar surfaces with the rest of the HUD.
6. Player health must remain the tunnel/vignette treatment; no player health bar.

Any Lua, secret-value, taint, or protected-action error is a failure.


## Runtime / visual result

P0120 is durable at `6c5f8901`. The deployed `0.0.50-dev` build passed HUD
diagnostics and the user accepted the in-client bar result as working well.
The production primitive is intentionally simpler than the approved sheet; that
simplification is accepted for now and additional ornament is deferred to later
whole-screen visual calibration.

Canonical evidence:
`../evidence/P0120_PERCENTAGE_BAR_RUNTIME_VISUAL_PASS_2026-10-04.md`.
