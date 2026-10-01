# B.5 — Allies and Pets

Status: ACTIVE
Opened: 2026-10-01

## Goal

Add restrained ally/pet condition awareness without recreating conventional party/unit frames.

## Product intent

Default presentation should remain sparse.

For allies/pets:
- name;
- health percentage;
- compact condition awareness.

Do not default to:
- portraits;
- large health bars;
- detailed role/level metadata;
- dense raid-frame-style grids.

## Initial B.5 scope

Start with:
- player pet, when one exists;
- party members currently available through standard party unit tokens.

Keep the first implementation architecture-oriented and compact.

Raid-scale presentation is not part of the initial B.5 proof unless naturally needed later.

## Secret-safe boundary

Ally/pet health percentages are secret-capable.

Expected health path:

```text
UnitHealthPercent(unit, true, percentScaleCurve)
    -> FontString:SetFormattedText("%.0f%%", secretPercent)
```

Identity may also be secret-restricted.

Expected name path:

```text
UnitName(unit)
    -> FontString:SetText
```

Do not:
- perform Lua arithmetic/comparison on ally/pet health;
- read secret text back for logic;
- branch on a secret name;
- persist ally/pet health/name values.

## Visibility / existence

Use ordinary unit-token existence checks for structural show/hide decisions.

Candidate units:
- `pet`;
- `party1`;
- `party2`;
- `party3`;
- `party4`.

Each compact row can be independently shown/hidden from unit existence.

## Layout direction

Initial compact layout should sit away from the center target/player readouts.

Candidate:
- small vertical stack along the lower-left or lower-right central HUD region;
- name + health % per row;
- no background panel unless needed for readability.

Exact anchor should be chosen to preserve room for Phase C action clusters.

## Source questions before implementation

Resolve:
1. exact party/pet name and health event coverage on Forever;
2. whether `GROUP_ROSTER_UPDATE` plus unit events is sufficient;
3. pet creation/destruction/update signals;
4. whether party health events are reliably unit-filterable for party1–party4;
5. whether a single event frame or per-unit frames gives the clearest secret-safe ownership;
6. layout that will not collide with the future action constellation.

## Runtime proof strategy

Pet:
- test if the current character has an accessible pet;
- otherwise record pet true-path as environmental/class limitation.

Party:
- test with available party members if practical;
- if no party is available, record party true-path as environmental deferral.

Do not require forming a group solely to manufacture proof if the environment is inconvenient.

## Accessibility

A future healer-oriented/conventional mode may be added separately.

That does not change the default sparse Logres presentation contract.

## Exit

B.5 completes when:
- ally/pet compact presentation is implemented;
- available true paths are runtime proven;
- unavailable pet/party paths are explicitly deferred with retry conditions;
- no conventional party frame is introduced.
