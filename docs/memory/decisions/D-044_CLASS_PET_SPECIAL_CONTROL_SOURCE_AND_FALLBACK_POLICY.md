# D-044 — Class / Pet / Special-Control Source and Fallback Policy

Status: ACCEPTED — SOURCE POLICY; RUNTIME-GATED
Date: 2026-10-05

## Decision

Use the exact Forever `1.60.1.70205` source audit from P0149 to keep class, pet,
and special-control ownership split by capability rather than treating them as
ordinary action-bar or percentage-resource extensions.

Pinned P0149 source:
`Gethe/wow-ui-source@e3ecc27b64d30fdc735a3f6579b866858f9f9df1` (`1.60.1.70205`).

P0151 source-continuity note: the accepted P0150 R3 runtime client is `1.60.1.70235`. Matching Forever source is `Gethe/wow-ui-source@a84e2b1b41d3d4137127c07e4da448aa3251d6f1`, the direct child of the 70205 pin. That commit changes only `version.txt`; the audited `SecureTemplates.lua` and `PetActionBar.lua` blobs are unchanged. The source findings below therefore remain applicable to the current client.

No stock suppression is authorized by source evidence alone.

## Pet actions

Pet actions are a separate secure-control domain.

Source establishes:
- ten stock pet slots;
- readable pet action/cooldown/usable state;
- pet-bar event invalidation;
- a secure `SECURE_ACTIONS.pet` path in `SecureTemplates.lua`.

A Logres `SecureActionButtonTemplate` using `type="pet"` and an ordinary pet-action
slot is therefore a source-plausible secure cast replacement candidate.

That does **not** complete stock PetActionBar ownership. Before stock suppression,
Logres must deliberately cover or retain safe fallback for:
- left-click secure casting;
- autocast state and right-click toggle behavior;
- drag/reorder/edit behavior;
- bindings/key routing;
- cooldown/range/usable/active feedback;
- combat-safe setup;
- exact restoration.

`PetFrame` remains a separate secure unit-frame surface and is not included in pet
action ownership.

## Stance / form

State/cooldown source is available through the shapeshift-form APIs and update
events.

Stock activation uses `CastShapeshiftForm`. The audited secure-template source has
no dedicated stance/shapeshift secure action type.

Therefore source availability does not authorize a Logres stance-control
replacement. A later runtime/security checkpoint must prove a combat-safe action
path and restoration before stock StanceBar interaction is removed.

## Totems

Totem information is source-available but `GetTotemInfo` and
`GetTotemTimeLeft` are secret-capable by slot.

All totem reads must be secret-first. Right-click dismissal via `DestroyTotem` is
a separate mutation capability and is not authorized by read proof.

TotemFrame remains stock until information, dismissal policy, interaction, and
restoration are deliberately proven.

## Runes and class resources

Rune cooldown state and class-resource power state have supported source paths.

Class-resource values may be secret-capable. Production must therefore be
secret-first and fail open.

Class mechanics remain semantically discrete. Combo points, charged points, runes,
soul shards, arcane charges, holy power, essence, and similar resources are not
automatically percentages and must not be forced into Logres's shared percentage
bar.

Per-resource presentation and capability may be proven independently.

## Alternate power

Alternate power remains a specialized Blizzard-owned domain. Its source depends on
class/power-type selection and secret-capable unit-power reads.

Do not suppress it until its semantics, runtime safety, presentation completeness,
and restoration are separately proven.

## Possess / override / vehicle / extra action

These are integrated action-bar modes, not ordinary Primary/Secondary/Utility
sources.

Blizzard may:
- switch secure action pages;
- use a dedicated OverrideActionBar;
- expose possess cancel;
- expose vehicle exit;
- expose taxi early landing;
- expose vehicle pitch;
- expose extra-action controls.

Logres must not route or suppress these surfaces as ordinary Bar 1–3 replacement.
A future dedicated capability would need to replace every required control and
fail open to stock UI.

## Runtime proof

P0150 may implement one bounded read-only diagnostic that observes naturally
available state across these domains.

P0150 must not mutate actions, paging, autocast, form, totems, vehicle/possess
state, or Blizzard presentation.

Environmental absence is a deferral, not failure.
