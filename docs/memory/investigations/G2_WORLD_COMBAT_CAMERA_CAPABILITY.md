# G.2 — World/Combat Camera Zoom Capability

Status: ACTIVE — PRIMARY PATH OOC PASS; COMBAT CLASSIFICATION FIX PENDING RETEST
Opened: 2026-10-02

Profile evidence:
`../evidence/G1_DYNAMICCAM_PROFILE_CAPTURE_2026-10-02.md`

Source audit:
`../evidence/G2_DYNAMICCAM_ZOOM_SOURCE_AUDIT_2026-10-02.md`

P0095 runtime evidence:
`../evidence/G2_P0095_COMBAT_CLASSIFICATION_FAIL_2026-10-02.md`

## Correct target behavior

World:
- if current zoom > 5, target 5;
- otherwise leave the closer zoom alone;
- ordinary transition 2.5 seconds.

World (Combat):
- if current zoom < 15, target 15;
- otherwise leave the farther zoom alone;
- ordinary transition 2.5 seconds.

## Combat predicate correction

DynamicCam situation 006 explicitly uses:

`return not IsInInstance() and UnitAffectingCombat("player")`

P0095 did not measure that predicate.

It recorded:
`Logres:GetState().combat`.

Core State currently derives that cached field from `InCombatLockdown()` during
registered state refreshes.

I-001 already established a timing nuance:
- `PLAYER_REGEN_DISABLED` may still see lockdown false;
- `ADDON_RESTRICTION_STATE_CHANGED` may still see lockdown false;
- a later event while fighting may finally see lockdown true.

Therefore the cached field may be false when the DynamicCam combat predicate is
already true.

This invalidates P0095 combat classification, not the camera movement result.

## P0095 runtime result

Two captured runs:
- DynamicCam loaded: false;
- API available: true;
- cameraZoomSpeed: 15.5;
- target reached: true;
- movement observed: true;
- starting zoom restored: true;
- secret: false;
- error: nil;
- reported combat: false on both runs.

Classification:
**PRIMARY CAMERA PATH OUT-OF-COMBAT PASS; IN-COMBAT CAPABILITY UNPROVEN.**

## P0096 diagnostic contract

At probe start capture independently:

- `combat` from live `UnitAffectingCombat("player")`;
- `lockdown` from live `InCombatLockdown()`;
- `cachedCombat` from `Logres:GetState().combat`;
- `mismatch` from live combat versus cached combat.

The first value matches DynamicCam's situation predicate.
The other values remain useful diagnostics but do not define G.2 context.

P0096 does not modify the core state engine and does not add polling/events.

## Runtime acceptance

With DynamicCam disabled:

1. out-of-combat reversible probe remains PASS;
2. naturally engage a mob;
3. start a probe while `UnitAffectingCombat("player")` is true;
4. second-click result reports `combat=true`;
5. targetReached/moved/restored all true;
6. record lockdown/cachedCombat/mismatch exactly as observed;
7. no Lua/taint/protected/secret error;
8. Run All PASS.

A `cachedCombat=false` result during live combat is evidence about cached state,
not a reason to relabel the live DynamicCam predicate as false.

## Out of scope

No automatic World/Combat camera behavior yet.
No core combat-state redesign in G.2.
No DynamicCam CVar fallback.
