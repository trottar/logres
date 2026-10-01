# B.5 — Allies and Pets

Status: IMPLEMENTATION PREPARED; RUNTIME PROOF NEXT
Opened: 2026-10-01

## Goal

Add restrained ally/pet condition awareness without recreating conventional party/unit frames.

## Source resolution

Blizzard group-header/state-driver code uses:
- `GROUP_ROSTER_UPDATE`;
- `UNIT_NAME_UPDATE`;
- `UNIT_PET`;

to refresh group/pet structure and identity.

P0027 combines those structural signals with per-unit:
- `UNIT_HEALTH`;
- `UNIT_MAXHEALTH`;
- `UNIT_NAME_UPDATE`.

## P0027 scope

Fixed candidate units:
- `pet`;
- `party1`;
- `party2`;
- `party3`;
- `party4`.

Each existing unit gets one compact row:

```text
Name                            Health %
```

No bars or portraits.

## Secret-safe path

Name:

```text
UnitName(unit)
    -> FontString:SetText
```

Health:

```text
UnitHealthPercent(unit, true, percentScaleCurve)
    -> FontString:SetFormattedText("%.0f%%", result)
```

Row visibility uses `UnitExists(unit)` only.

## Layout

The five-slot stack is anchored:
- left of the central HUD;
- center x `-330`;
- center y `-44`.

Rows are 23 px apart.

Only existing units are visible.

This is intentionally provisional ahead of Phase C action-cluster layout.

## Lifecycle

The ally row frames are created during HUD initialization.

Per-unit/roster events are registered during HUD enable and unregistered through the HUD-owned cleanup stack.

Immersion off hides the entire HUD root.

Immersion on refreshes all ally/pet rows.

## Runtime plan

After deploy:
1. confirm `0.0.12-dev`;
2. existing checks + `/logres hudcheck` pass;
3. verify no empty ally rows are visible for absent units;
4. if a player pet exists, verify its name + health % and health updates;
5. if party members are available, verify each present member appears once and health updates;
6. party join/leave should add/remove rows if practical;
7. immersion off/on should hide/restore available rows;
8. report any secret/Lua error.

## Environmental coverage

If no player pet is available:
**PET TRUE PATH DEFERRED BY CLASS/ENVIRONMENT**

Retry when a pet-capable character/state is available.

If no party is conveniently available:
**PARTY TRUE PATH DEFERRED BY ENVIRONMENT**

Retry on a natural group opportunity.

Do not force a group solely to close the proof.

## Exit

B.5 completes when:
- implementation is structurally correct;
- available pet/party paths are runtime proven;
- unavailable paths carry explicit deferrals;
- no conventional party frame is introduced.
