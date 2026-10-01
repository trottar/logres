# D-023 — Selective stock action-bar replacement

Status: ACCEPTED
Date: 2026-10-01

## Decision

C.5 begins with selective replacement of only the stock action domains already
fully represented by Logres.

First supported stock replacement domains:

| Logres role | Blizzard frame | Stock bar | Slots |
| --- | --- | --- | --- |
| Secondary | `MultiBarBottomLeft` | Bar 2 | 61–72 |
| Utility | `MultiBarBottomRight` | Bar 3 | 49–60 |

## MainActionBar

Do not suppress `MainActionBar` in the first C.5 pass.

Reason:
Blizzard repurposes it for bonus, vehicle, override, and temporary shapeshift
states and can transition to `OverrideActionBar`.

Primary stock suppression requires a later special-state fallback contract.

## Suppression semantics

For first-pass supported multi-bars:

**suppressed** means:
- stock frame alpha `0`;
- stock bar/button mouse input disabled;
- matching Logres key routing active.

It does not mean:
- rewriting Blizzard's action-bar settings;
- taking permanent ownership of Blizzard frame visibility;
- globally hiding all action bars.

## Restoration

Before suppression, capture:
- bar alpha;
- bar mouse-enabled state;
- each action button's mouse-enabled state;
- existing Logres routing state.

On restoration, restore those captured values.

Do not assume the player's stock presentation state is always the default.

## Combat

Replacement transitions occur only outside combat.

Combat-time requests defer until `PLAYER_REGEN_ENABLED`.

No insecure protected-frame interactivity mutation during combat.

## Routing coupling

A suppressed stock domain must have its matching Logres key routing active.

This is one atomic replacement capability:

```text
stock visual/mouse suppression
+
Logres secure action path
+
Logres key routing
+
Logres activation feedback
+
restoration
```

If routing cannot be applied, do not suppress the stock bar.

If suppression cannot be safely applied, release/retain the stock path.

## First-proof persistence

C.5 first runtime proof is session-only and defaults OFF after reload.

Reason:
fail-open behavior is more important than persistence while suppression and
restoration are still being validated.

Later integration may persist the replacement preference once recovery is
proven.

## Unsupported domains

Remain Blizzard-visible:
- MainActionBar;
- OverrideActionBar;
- Bar 4;
- Bar 5;
- other extra action bars;
- possess/stance/special surfaces.

D-020 remains the long-term layout/profile direction.

## Stock settings

Never change `PROXY_SHOW_ACTIONBAR_*` merely to suppress a bar.

Those settings belong to the user's Blizzard/Edit Mode configuration.

## Exit from first runtime proof

The selective replacement implementation is successful when:
- Bar 2 and Bar 3 disappear visually;
- they leave no invisible mouse interaction;
- Secondary/Utility keys route through Logres;
- Logres execution/feedback remains correct;
- replacement OFF restores stock bars and prior routing exactly;
- combat-time ON/OFF requests defer safely;
- Primary and unsupported Bars 4–5 remain available;
- no protected/taint/Lua/secret errors occur.
