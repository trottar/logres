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

**Status: P0032 RUNTIME FAILED; P0033 FIX PREPARED.**

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

Do not suppress stock action bars until this replacement is proven.### P0032 implementation

- 12 secure primary action buttons;
- 4 x 3 layout;
- current primary action page mapping;
- native action-button registration;
- icon/cooldown/count/usability/range presentation;
- session-only preservation of existing ACTIONBUTTON1–12 keys;
- `Action Check` developer-panel diagnostic;
- stock Blizzard action bars remain visible.

Known limitation:
combat-time action-page changes defer Logres page remapping until combat ends.
A later secure paging/state-driver work item is required before stock-bar
suppression.### P0033 execution correction

P0032 runtime:
- presentation/range updates PASS;
- mouse execution FAIL;
- routed key execution FAIL.

P0033:
- adds secure actionrelease/down-click configuration;
- removes internal slot-number labels;
- makes Logres key routing opt-in with Action Keys ON/OFF;
- keeps both mouse and keyboard execution in the required runtime test.


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
