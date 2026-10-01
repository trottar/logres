# Phase C — Action Interface

Status: ACTIVE

## Objective

Replace the conventional horizontal action-bar experience with Logres' compact square/rectangular action constellation while preserving secure-action correctness.

## Product model

Logical groups:
- Primary Cluster;
- Secondary/Tertiary Cluster;
- Utility Cluster(s).

Presentation:
- Primary: persistently legible;
- Secondary/Tertiary: subdued outside combat, stronger in PvP, fully available in combat;
- Utility: peripheral or normally faded, intentionally revealed.

## C.1 — Secure action capability/source review

**Status: COMPLETE.**

Before building buttons, resolve:
- secure action-button templates available on Forever;
- action slot binding/attribute model;
- drag/drop and pickup constraints;
- combat-lockdown rules;
- visibility/state-driver options;
- whether layout mutation is safe during combat;
- keybinding display/interaction requirements;
- stock action-bar suppression constraints and restoration.

Use source evidence before choosing architecture.

## C.2 — Primary action cluster

**Status: ACTIVE.**

Implement the first secure rectangular/square cluster.

Initial proof target:
- 12 named secure primary action buttons;
- existing ACTIONBUTTON1–12 bindings routed through temporary override click bindings;
- icon, cooldown, count, usability, and range presentation;
- mouse + keyboard execution;
- combat-lockdown-safe mutation/defer behavior;
- stock Blizzard action bars remain visible during proof.

Success:
- actions activate correctly;
- keybinds work;
- icons/cooldowns/state remain correct;
- combat lockdown produces no forbidden mutation;
- layout is visually legible.

Do not suppress stock action bars until this replacement is proven.

## C.3 — Secondary / utility clusters

Add:
- secondary/tertiary actions;
- utility groups;
- initial context visibility policy.

PvP is a modifier, not a separate monolithic mode.

## C.4 — Contextual visibility

Integrate with observed state:
- world;
- combat;
- PvP;
- instance.

Visibility policy must respect secure-state restrictions.

## C.5 — Stock action-bar replacement

After Logres secure clusters are runtime proven:
- suppress relevant Blizzard action bars;
- preserve restoration path;
- validate reload/immersion/module restoration behavior.

D-017 governs ownership and safety.

## C.6 — Action interface integration validation

Validate:
- combat transitions;
- PvP modifier;
- instance behavior;
- keybind/action correctness;
- stock-bar suppression/restoration;
- coexistence with Phase B HUD.

## Phase C exit

Phase C completes when:
- primary/secondary/utility action clusters are functional;
- secure/combat-lockdown behavior is proven;
- stock action bars can be safely suppressed/restored;
- Phase B HUD and action constellation coexist;
- no required player control is lost.
