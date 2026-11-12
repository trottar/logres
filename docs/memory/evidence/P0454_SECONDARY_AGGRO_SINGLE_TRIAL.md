# P0454 — Ordinary basic aggro to single-secondary developer trial (2026-11-11)

## Baseline and Forever source evidence

Verified `main` P0453 `7050f9c267dd2f7de309b97e1a1ec42372d3d1ef`,
tree `5fc10c8634bd9147355b81dda06ab30f9cfff374`. Reconstructed
an exact local clean P0453 tree from the uploaded P0452 author kit and
P0453 guarded payload+manifest; compared the resulting Git tree SHA.
P0453 Forever Report Bug #12307/session 116 (Nov 11, 2026), captured
0.0.322-dev, deployed and source versions match; standalone diagnostics
SHA-256 `12620d60ee1b82f7d5d62d3cb33166e48cd197ca1a68da63398fbd067472bea4`.
Basic `UnitThreatSituation("player", nameplateN)` returned 18 ordinary
statuses, 11 primary 2/3 and 7 nonprimary 0/1, 0 secret, 0 failure;
10 missing-pair observations. `UnitDetailedThreatSituation` was secret
on 18 events, 0 ordinary, 0 failure. Eight basic-primary event samples
also passed same-event hostile/attackable/combat/targeting-player/
anchor gates. These are event samples, not distinct mobs or continuous
aggro; the old paired qualified counter remains zero. No user-facing
secondary 50/50 display existed in P0453.

## P0454 experiment and safety boundaries

P0454 preserves the historical paired threat path for evidence but
returns an independent ordinary-basic outcome: eligible (2/3 and all
same-event gates), nonprimary (0/1), unqualified (2/3 missing an ordinary
eligibility gate), or unknown (secret/missing/invalid/unavailable).
No secret output is compared or inspected, and player-targeting alone
cannot authorize presentation. Probe returns only scalar outcome; HUD
receives the event and an ordinary event-time nameplate token.

The existing **developer World Enemy ON** (which requires OOC) arms a
single precreated, addon-owned mouse-disabled secondary name/health
fixture: 50% scale and 50% alpha. Only if all gates and a fresh safe
non-selected nameplate anchor pass does HUD attach. Name/health values,
which may be secret-capable, are passed directly to native widget
consumers under pcall without Lua comparisons. Native unprotected name
and health decorative regions are captured with opaque alpha restore
tokens before dimming. No native frame, click, selection, cast, aura,
raid marker, or CC ownership is replaced. Existing Blizzard native
secondary auras remain visible and are **not** rescaled or hidden.
This is one-unit opt-in visual feasibility, not a general multi-enemy
renderer. Production `worldEnemySecondaryEnabled` remains false.

On ordinary basic 0/1, unknown/unqualified, nameplate removal, target
change, combat exit, World Enemy OFF, immersion OFF or a refused native
mutation, restore Blizzard name/health then hide the addon-owned frame.
Restoration refusal is counted and can retry at combat exit; do not
claim full safety without client evidence. Only one ordinary unit-token
is retained **inside HUD** for matching removal; none in the probe,
and no nameplate frame/GUID is retained. No polling, timers, native
plate enumeration or secret coercion. Existing selected world name/
100%-health/native delegated auras, P0444 transparency, P0450 screen
handoff, native click/cast/CC and their fallback are not changed.

## Failure classes and next test

P0451 combined detailed/basic cross-check produced 0 qualifications
because detailed values are restricted. P0453 separated sources and
showed ordinary basic status works on this client; the old combined
gate is now historical, not the new experimental eligibility signal.
P0454 **STATIC ONLY until installed in Forever**. A failed attach or
missing native decoration must show no owned secondary and leave stock
name/health visible; partial restore is a real failure, not a pass.

After checked user apply/push and deployment, arm World Enemy ON while
out of combat. In one natural multi-hostile encounter, observe a single
secondary at 50% while the selected enemy stays 100%, then lose aggro,
target another enemy, and switch OFF. Capture Report Bug and diagnostics,
including all restoration refusals, and check clicks/casts/auras and
Lua/taint. Never require contrived travel/combat just to obtain proof.
If no eligible event occurs, record DEFERRED rather than PASS or FAIL.
L-011 PARTIAL; L-028 OPEN; selected P0450 screenshot visual PASS scoped.
