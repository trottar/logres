# D-020 — Action layout customization direction

Status: ACCEPTED
Date: 2026-10-01

## Trigger

C.3 proved a hardcoded Logres action constellation:

```text
Secondary      Primary       Utility
   3 x 4         4 x 3         3 x 4
```

The user then supplied their normal Forever action layout and explained that
they actively use up to five stock action bars with different roles and
sizes.

Observed/described usage:
- Bar 1: primary;
- Bar 2: more combat/secondary abilities;
- Bars 3–4: utility;
- Bar 5: compact six-slot group.

Forever's stock UI already permits this kind of customization.

Logres should not regress that flexibility in its final action interface.

## Decision

The current C.2/C.3 cluster layout is a development/proof layout.

It is **not** the final fixed Logres action layout.

The long-term Logres action interface must support configurable layout
profiles.

## Required profile concepts

A future action-layout profile should be able to express:

### Action source/domain

Examples:
- primary paged action domain;
- fixed stock multi-bar domain;
- later supported custom action domains.

### Presentation role

Examples:
- Primary;
- Secondary;
- Utility;
- Micro Utility;
- user-defined/decorative role where appropriate.

Role affects default visual policy, not secure action semantics.

### Cluster geometry

At minimum:
- rows;
- columns;
- number of visible slots;
- orientation/layout ordering;
- anchor/position;
- spacing;
- scale.

A six-slot cluster must be representable without pretending it is a 12-slot
bar.

### Visibility policy

Eventually configurable within safe constraints:
- always;
- world;
- combat;
- PvP modifier;
- instance;
- explicit reveal.

Secure/combat-lockdown limitations still apply.

### Binding behavior

Layout changes must not silently rewrite the user's saved bindings.

The existing fail-open temporary-routing principle remains authoritative until
a dedicated binding/editor contract is proven.

## Capability gate

Customization does not authorize premature suppression.

A configured Logres profile must not hide a stock action surface unless all
actions the player depends on remain safely accessible.

D-017 remains authoritative.

## Implementation timing

Do not derail C.4 to build the full layout editor now.

Near-term Phase C must:
- keep architecture data-driven enough to permit later variable cluster
  definitions;
- avoid baking final product semantics into fixed `Secondary`/`Utility`
  runtime modules;
- retain stock bars as a fallback.

A proper in-game action-layout editor/profile UI can be introduced after the
secure/context policy is proven, then finalized during later integration and
polish work.

## Developer/control panel

The existing diagnostics panel is not the final action-layout editor.

However, its in-game control architecture is a useful precursor to the future
settings/menu surface.
