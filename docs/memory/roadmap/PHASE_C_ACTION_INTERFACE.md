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

**Status: COMPLETE.**

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
- keeps both mouse and keyboard execution in the required runtime test.### C.2 final runtime result

P0033:
- mouse execution PASS;
- existing-key execution PASS;
- range feedback PASS.

C.2 closes.

Known non-blocking debt:
- combat-time page remapping still defers until combat ends;
- cast/channel cue color differentiation became imperceptible during P0033 and
  remains recorded for later visual investigation.


## C.3 — Secondary / utility clusters

**Status: COMPLETE.**

Add:
- secondary/tertiary actions;
- utility groups;
- initial context visibility policy.

PvP is a modifier, not a separate monolithic mode.

### C.3 source resolution

First implementation:
- Secondary = slots 61–72 / MULTIACTIONBAR1BUTTON1–12;
- Utility = slots 49–60 / MULTIACTIONBAR2BUTTON1–12;
- 3 x 4 side clusters around the 4 x 3 Primary cluster;
- shared secure presentation primitive;
- independent fail-open key routing;
- no stock-bar suppression.

Bars 4–8 remain outside the first C.3 proof.### P0036 implementation

- shared secure action-button/presentation primitive;
- Primary keeps proven paging/binding orchestration;
- Secondary slots 61–72, 3 x 4 left cluster;
- Utility slots 49–60, 3 x 4 right cluster;
- independent fail-open multi-bar key routing;
- expanded Action Check;
- stock action bars remain visible.

Dynamic context visibility remains C.4.### C.3 final runtime result

P0036 runtime passed.

Verified:
- Primary remains functional;
- Secondary works;
- Utility works;
- three-cluster constellation is viable;
- no reported protected/taint/Lua/secret error.

C.3 closes.

D-020 records the important product requirement that this hardcoded geometry is
only a proof layout. Future Logres action layouts must support variable cluster
roles/sizes/shapes, including compact groups such as a six-slot utility bar.


## C.4 — Contextual visibility

**Status: COMPLETE.**

Integrate with observed state:
- world;
- combat;
- PvP;
- instance.

Visibility policy must respect secure-state restrictions.### C.4 source resolution

D-021:
- contextual emphasis initially uses non-zero alpha only;
- Primary stays full;
- Secondary rises world -> PvP -> combat;
- Utility remains peripheral but rises with context;
- true protected hiding is deferred unless required;
- Primary moves to secure button-ID + actionpage driver paging;
- unsupported special pages retain stock fallback.

First implementation should prove context alpha and normal secure paging before
expanding into every vehicle/override/form state.### P0039 implementation

Context:
- state-driven non-zero role alpha;
- world/PvP/instance/combat weighting;
- no protected contextual Show/Hide.

Primary paging:
- IDs 1–12;
- secure actionpage driver for normal pages 1–6;
- presentation synchronized separately;
- special page coverage explicitly remains `normal-pages-only`.

Stock Blizzard bars remain visible.### P0040 action activation feedback

P0039 context runtime:
- world PASS;
- combat PASS;
- PvP PASS;
- Utility intentionally more subdued.

Before C.5 stock-bar suppression, P0040 adds the missing local action-use
feedback:
- pushed/depressed state;
- brief activation flash on secure PostClick;
- mouse + routed-key proof.

C.4 remains open until this action feedback is runtime-proven.

### P0041 feedback isolation fix

P0040:
- correct version deployed;
- execution PASS;
- range/GCD PASS;
- visible activation feedback FAIL.

P0041:
- unprotected UIParent feedback overlay;
- independent of contextual cluster alpha;
- explicit hidden-at-rest/show-on-use pulse;
- explicit mouse pressed overlay;
- developer-panel Feedback Test.

### C.4 final runtime result

Context:
- world PASS;
- combat PASS;
- PvP PASS;
- Utility remains intentionally more subdued.

Activation:
- P0040 visual attempt FAILED;
- P0041 rendering fix PASS;
- mouse activation feedback PASS;
- Logres-routed keyboard feedback PASS.

Normal Blizzard stock bindings bypass Logres feedback. Enabling Logres
Action Keys routes execution through Logres and restores the activation-
feedback path. This becomes a C.5 replacement requirement.

Normal Primary page switching is not part of the user's workflow.
Special paging remains capability-gated with stock fallback.

C.4 closes.

## C.5 — Stock action-bar replacement

After Logres secure clusters are runtime proven:
- suppress relevant Blizzard action bars;
- preserve restoration path;
- validate reload/immersion/module restoration behavior.

D-017 governs ownership and safety.

### C.5 first-pass source resolution

D-023:
- first replacement scope is stock Bar 2 + Bar 3 only;
- `MultiBarBottomLeft` maps to Secondary slots 61–72;
- `MultiBarBottomRight` maps to Utility slots 49–60;
- preserve Blizzard Show/Hide ownership;
- suppress through alpha 0 + mouse disable;
- matching Logres routing must be active before suppression;
- restore exact prior presentation/routing state;
- transitions are OOC-only with combat deferral;
- first proof is session-only and defaults OFF after reload.

MainActionBar remains Blizzard-visible because Blizzard reuses it for
special action states.

Bars 4–5 remain visible because current Logres does not replace them.

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
## Deferred layout-profile requirement

D-020 is canonical.

Phase C architecture must remain compatible with future configurable action
layout profiles:
- action domain assignment;
- role assignment;
- variable rows/columns/visible slot count;
- compact six-slot clusters;
- position/spacing/scale;
- contextual visibility policy.

The full in-game layout editor is not required to complete C.4.


### C.5 replacement boundary

Stock suppression is selective.

Suppression requires:
- proven Logres action execution;
- proven local feedback;
- active Logres key routing;
- reliable stock restoration.

Current user layout uses more stock action domains than Logres currently
represents, so Bars 4–5 remain visible until later coverage/profile work.

### P0044 selective replacement implementation

Runtime version `0.0.20-dev`.

Adds session-only replacement for stock Bars 2–3:
- snapshot;
- automatic matching Logres routing;
- alpha/mouse suppression;
- exact restoration;
- combat deferral;
- replacement diagnostics.

Primary and unsupported Bars 4–5 remain Blizzard-visible.
