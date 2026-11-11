# P0451 — Secondary threat evidence qualification (2026-11-11)

## Baseline and runtime report

P0450 `main` verified at `55af0b9d18e0d93b146a8a4a1647daf21bd09d03`.
Forever 0.0.320-dev session 113, Report Bug #12040/#12042/#12044:
selected world HP and native-world auras visually accepted as single presentation;
4 world attachments, 4 native aura transfers, 4 addon-screen handoffs,
3 native detach/restorations and no recorded handoff/restore failures.
This is **selected-target visual PASS only**. A P0450 World Enemy OFF,
protected-state/taint/cast/click full acceptance is not established.

Session 113 lifecycle counters observed 8 secondary anchors and 2 secondary
`UnitIsUnit(nameplateN.."target", "player")` positives, one strict hostile
combat player-targeting event. They are **event samples, not distinct enemies**
and not evidence of actual threat/aggro. L-011 remains PARTIAL;
secondary 50% world presentation stays gated.

## P0451 hypothesis and procedure

At `NAME_PLATE_UNIT_ADDED`, `UNIT_TARGET`, `UNIT_FLAGS`, or
`UNIT_THREAT_LIST_UPDATE`, the same ordinary non-selected nameplate unit can
be checked against `UnitThreatSituation("player", unit)` and the *first*
result of `UnitDetailedThreatSituation("player", unit)` without storing a
unit token, GUID or native frame. A primary-threat candidate requires ordinary
status 2/3, ordinary detailed `isTanking=true`, and simultaneous verified
hostile, attackable, unit/player-combat, player-targeting and safe-anchor
conditions. All secret/unknown/refused/contradictory results are deferred.

Use the existing P0440 **Report Bug > H > Nameplate Lifecycle** control.
After natural combat with two enemies, click Report Bug to capture
`nameplateLifecycle.secondaryThreat*`; export diagnostics using
`python3 tools/export_panel_diagnostics.py`. The counters represent repeated
events, **not unique enemies or a continuous aggro state**. Compare positive
and negative events with actual gameplay and remove/target-change cases.

## Unchanged safety boundary

There is no secondary renderer, alpha takeover, scale promotion, nameplate
mutation, polling, native aura enumeration, or secret inspection in P0451.
Only addon-owned counters and last reason are retained. P0447 selected health,
P0444 transparent backing, P0449 world-native auras, P0450 duplicate handoff,
native click/cast/CC/selection/OFF fallback, +/-25px lanes and the P0443 matte
rejection stay unchanged. Threat API and per-unit state reliability must be
established in Forever before a production 50% secondary trial is authorized.

## Validation disposition

Static author-check, Lua syntax, exact baseline, rollback and ZIP receipt
are release gates. In-game positive, negative, secret/refusal and combat
transition evidence remains UNVERIFIED until user-provided Report Bug capture.

## R0 scoped refusal and reconciliation

R0 full author-check **REFUSED 313/314**: the P0450 historical checker
rejected P0451's new roadmap heading: it required P0450 as the first heading. P0451 revises only the
active-heading assertion, requiring P0451 first while preserving P0450 and
P0449 in their original order and the exact P0450 runtime ownership checks.
The refusal was isolated to the author candidate, with no user checkout
or GitHub write. No P0450 production behavior was changed.
