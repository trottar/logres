# D-018 — Secure action interface contract

Status: ACCEPTED
Date: 2026-10-01

## Decision

Logres action clusters use protected secure buttons.

Ordinary Lua owns presentation.

Secure templates own protected action execution.

Combat-lockdown boundaries are explicit.

## Secure execution

Each actionable button must inherit `SecureActionButtonTemplate`.

Standard action-slot buttons use:

```text
type = "action"
action = <slot>
```

Logres does not directly call protected `UseAction` from insecure code.

## Protected mutation

Outside combat:
- create/configure buttons;
- assign protected attributes;
- position/re-anchor protected cluster frames;
- establish/clear override bindings;
- perform edit-mode drag/drop.

During combat:
- do not perform ordinary protected mutation;
- presentation-only updates may continue where allowed;
- required protected state transitions must use a source-proven secure driver/handler;
- otherwise queue the change until `PLAYER_REGEN_ENABLED`.

## Initial primary cluster

C.2 starts by mirroring the existing primary action-slot domain.

Initial target:
- 12 named secure buttons;
- rectangular/square arrangement rather than a horizontal row;
- stock action bars remain visible during proof.

No stock-bar suppression occurs in C.2.

## Binding policy

Preserve the user's existing primary action bindings.

Use session-only override click bindings:

```text
ACTIONBUTTON1 key(s)  -> LogresActionButton1
...
ACTIONBUTTON12 key(s) -> LogresActionButton12
```

Rules:
- do not permanently rewrite saved bindings;
- apply/refresh only out of combat;
- defer binding refresh requested during combat;
- clear overrides on module disable.

## Presentation data

Allowed ordinary presentation:
- occupied/empty;
- action texture;
- usability;
- range;
- current/checked registration.

## Secret cooldown/count data

Cooldown/count values are secret-capable.

Cooldown:

```text
C_ActionBar.GetActionCooldownDuration(slot)
    -> Cooldown:SetCooldownFromDurationObject
```

Count:

```text
C_ActionBar.GetActionDisplayCount(slot)
    -> FontString:SetText
```

No Lua arithmetic/comparison/stringification of secret cooldown/count values.

## Native registration

Register each Logres button with:

```text
C_ActionBar.RegisterActionUIButton(
    button,
    actionSlot,
    cooldown
)
```

Use Blizzard's native action-button registration where it provides semantics rather than recreating them.

## Editing

C.2 is execution/presentation proof, not a full bar editor.

Drag/drop arrangement is deferred to a later Phase C item because action pickup is no-combat and edit behavior deserves its own contract.

The stock Blizzard bar remains available for arranging actions until Logres editing/replacement is proven.

## Suppression

D-017 remains authoritative.

Do not hide stock action bars until:
- Logres secure controls are proven;
- binding behavior is proven;
- required paging/special-bar behavior is accounted for;
- restoration is proven.
