# Action Cluster Architecture

## Visual model

Logres uses compact square/rectangular button groups rather than treating the primary action interface as one long row.

Logical groups:
- Primary Cluster
- Secondary/Tertiary Clusters
- Utility Clusters

## Presentation intent

- Primary: persistently legible.
- Secondary/Tertiary: nearby and visually related; low opacity or hidden depending on state.
- Utility: normally absent/faded, revealed intentionally.
- Combat: increases relevant visibility.
- PvP flagged: increases caution/secondary visibility before combat.
- Instance: may use more conservative visibility rules.

## Secure execution contract

D-018 is authoritative.

Protected actions execute through `SecureActionButtonTemplate`.

Standard action-slot buttons use secure:
- `type = "action"`;
- `action = slot`.

Ordinary presentation code must not directly invoke protected `UseAction`.

## Protected mutation boundary

Protected action buttons and affected parents cannot be freely:
- shown/hidden;
- moved/re-anchored;
- re-attributed;
- rebound;

during combat lockdown.

Ordinary code checks `InCombatLockdown()`.

If an out-of-combat mutation is requested during combat:
- remember the requested refresh/change;
- apply after `PLAYER_REGEN_ENABLED`.

If a genuine combat-time conditional protected transition is needed, use a verified SecureStateDriver/AttributeDriver design.

## C.2 primary cluster

Initial implementation target:
- 12 buttons corresponding to the primary action-button domain;
- compact rectangular/square layout;
- named secure buttons;
- existing ACTIONBUTTON1–12 keys preserved through session override click bindings.

Stock Blizzard bars remain visible during C.2 proof.

## Action presentation

Prefer current Forever `C_ActionBar` APIs.

Ordinary:
- occupancy;
- icon;
- usability;
- range.

Secret-capable:
- cooldown duration;
- charges/count.

Cooldown:

```text
GetActionCooldownDuration
    -> DurationObject
    -> Cooldown:SetCooldownFromDurationObject
```

Count:

```text
GetActionDisplayCount
    -> FontString:SetText
```

Do not inspect secret cooldown/count values in Lua.

## Bindings

Do not silently rewrite the user's saved bindings.

For C.2:
- inspect `ACTIONBUTTON1`–`ACTIONBUTTON12` with `GetBindingKey`;
- install session override clicks to named Logres buttons;
- clear overrides on disable;
- update out of combat on `UPDATE_BINDINGS`;
- defer updates until combat ends if necessary.

## Editing

Full drag/drop editing is not part of C.2.

Stock Blizzard bars remain the action-layout editing surface until later Phase C work proves a Logres editing path.

## Suppression

D-017 governs stock-bar suppression.

Action bars stay visible until Logres:
- executes actions reliably;
- preserves keybinds;
- handles required page/special-bar behavior;
- provides restoration.
## C.2 implementation boundary

P0032 implements the first live secure cluster.

Geometry:
- 12 buttons;
- 4 x 3;
- lower center;
- stock Blizzard action bars retained.

The current primary action page is mapped to 12 secure action attributes
out of combat.

Binding:
- reads `ACTIONBUTTON1` through `ACTIONBUTTON12`;
- applies temporary override clicks;
- displays the first existing key;
- never saves/reassigns the user's persistent bindings.

Presentation:
- icon;
- native cooldown DurationObject;
- direct display count;
- usability tint;
- range tint;
- native checked-state registration.

Combat:
- action execution remains secure;
- ordinary page/binding protected mutation is deferred until combat ends.

Known C.2 limitation:
combat-time primary-page changes are not yet secure-driven and therefore do
not reconfigure Logres buttons until `PLAYER_REGEN_ENABLED`.

This limitation blocks stock action-bar suppression, not the C.2 proof.
## C.2 execution failure correction

P0032 demonstrated that presentation and secure execution are separate proof
domains.

Presentation updated correctly while secure action execution was inert.

P0033 aligns the click/release setup with Blizzard action-button precedent:
- `type = action`;
- `typerelease = actionrelease`;
- `AnyUp`;
- `LeftButtonDown`;
- `RightButtonDown`.

P0033 also makes temporary primary-key routing opt-in until runtime proof is
complete.

The test still covers both mouse and keyboard execution.

The toggle exists to guarantee fail-open recovery, not to reduce test scope.
## C.2 final result

C.2 secure primary action execution is production-proven after the P0033
correction.

Verified:
- mouse secure execution;
- existing-key secure execution;
- range presentation;
- 4 x 3 primary geometry.

P0032's failed automatic key takeover is retained as negative evidence.

P0033's fail-open Action Keys controls remain the safe development model.

Known non-blocking visual debt:
cast/channel cues still appear but their color differentiation became
imperceptible during the P0033 test. Cause remains unisolated.

## C.3 entry

C.3 extends the proven secure-button architecture to secondary/utility action
domains.

Implementation should first refactor common secure action-button behavior into
reusable cluster primitives rather than cloning the primary module.

Contextual visibility policy remains primarily C.4 work.

Stock Blizzard bars remain visible during C.3 proof.
## C.3 source resolution

D-019 selects the first persistent extra-action domains:

Secondary:
- slots 61–72;
- MULTIACTIONBAR1BUTTON1–12.

Utility:
- slots 49–60;
- MULTIACTIONBAR2BUTTON1–12.

These are fixed-slot clusters, so unlike Primary they do not need page
remapping.

Initial geometry:

```text
Secondary      Primary       Utility
   3 x 4         4 x 3         3 x 4
```

C.3 extracts common secure button/presentation construction but deliberately
does not replace all proven Primary orchestration in one step.

C.4 remains the owner of state-driven cluster visibility.

Bars 4–8 remain stock-only after the first C.3 implementation and therefore
cannot be suppressed.
## C.3 P0036 implementation

Reusable secure presentation now lives in:

```text
Actions/Button.lua
```

It provides common button construction and action presentation.

Primary retains its proven page/binding orchestration.

New fixed clusters:

Secondary:
- slots 61–72;
- 3 x 4;
- left of Primary;
- MULTIACTIONBAR1BUTTON binding labels/routing.

Utility:
- slots 49–60;
- 3 x 4;
- right of Primary;
- MULTIACTIONBAR2BUTTON binding labels/routing.

All new key routing is fail-open and opt-in during proof.

Static alpha weighting is presentation-only.

C.4 remains responsible for context-driven visibility.

No stock bar suppression occurs in P0036.
## Action role assignment direction

D-032 supersedes the earlier general profile/editor direction in D-020.

The current hardcoded constellation remains a development/proof layout, but the
final Logres product is not intended to become a general-purpose action-bar
builder.

Long-term model:
- Primary is a fixed role;
- supported extra action-bar sources are assigned by the user to Secondary or
  Utility roles;
- Logres authors the role placement, spacing, contextual visibility, and visual
  language;
- a small set of grid-shape presets or whole-cluster position adjustments may
  be considered if secure implementation stays simple;
- unrestricted per-bar/per-button layout belongs to stock or specialist addons
  when Logres action presentation is disabled.

Role assignment must never silently rewrite saved bindings.

Pet, stance/form, totem, possess, and other special controls remain separate
capability domains even when visually colocated with Secondary controls.

C.2/C.3 runtime modules remain valid secure-action proofs. Future integration
may broaden supported source bars one domain at a time after execution,
routing, feedback, suppression, and restoration are proven for each domain.

## C.4 source resolution

D-021 separates action context policy from protected paging.

### Context

Initial contextual behavior is alpha-only:
- Primary always 1.00;
- Secondary subdued in world, raised in PvP, full in combat;
- Utility strongly subdued in world, raised in PvP/instance/combat.

Alpha is never zero.

The protected buttons remain clickable.

This is deliberate fail-open behavior.

### Secure paging

Primary moves toward SecureActionButtonTemplate's built-in ID/actionpage model.

The secure page selection is driven from macro-condition state rather than
ordinary Lua rewriting protected action attributes during combat.

Presentation synchronization remains an ordinary responsibility:
the visible icon/cooldown/count/range state must track the same concrete slot
the secure button will execute.

### Special states

Vehicle/override/temp-shapeshift/bonus/possess coverage is capability-gated.

Stock bars remain visible until relevant paths are runtime-proven.

### Future role-assignment compatibility

Context alpha is a role policy, not a permanent hardcoded frame policy.

D-032 role-assigned Secondary/Utility sources should consume the same policy without requiring arbitrary user-defined layout profiles.
## C.4 P0039 implementation

Context policy now lives in `Actions/Context.lua`.

It consumes orthogonal state and applies non-zero alpha by role.

No protected Show/Hide is used for first-pass contextual behavior.

Primary normal paging now uses:
- button IDs 1–12;
- secure `actionpage` attribute drivers;
- the normal `[bar:n]` condition family.

Primary presentation registration is separated from protected action
assignment through `ActionButton.RegisterPresentation`.

This lets icons/cooldowns/count/range follow the driven page without ordinary
Lua rewriting the protected secure action during combat.

Current capability gate:
`normal-pages-only`.

Special bonus/form/vehicle/override/possess action states remain stock-fallback
territory until proven.
## Action activation feedback

D-022 establishes local activation feedback as a required action-interface
capability.

The shared Logres ActionButton primitive now provides:
- pushed-state texture;
- short activation pulse.

Primary, Secondary, Utility, and future profile-driven clusters inherit the
same behavior.

The pulse confirms secure button activation only.

Logres does not infer ongoing button-specific cast state from restricted
spellcast payloads.

This feedback must be runtime-proven before stock action-bar suppression.

## Activation feedback isolation

P0040 proved that a feedback cue must not inherit the same contextual fade it
is supposed to confirm.

P0041 separates action-feedback presentation from the secure button's cluster
hierarchy. The feedback overlay is unprotected, parented to UIParent, anchored
to the secure button, and visually independent from Utility/Secondary alpha.

## Replacement couples suppression and key routing

P0041 runtime proved that a stock binding can execute an action without passing
through Logres' button-feedback path.

When Logres key routing is enabled, the same key executes through the Logres
secure button and local activation feedback is present.

Therefore a stock action domain is not functionally replaced merely because
its buttons can be hidden.

Replacement ownership includes:
- visible Logres controls;
- secure execution;
- local activation feedback;
- matching key routing;
- reload/reinitialization behavior;
- stock restoration.

C.5 must manage those as one capability.

Developer-only routing defaults are not sufficient once a stock bar is actually
suppressed.

## Selective stock replacement

D-023 defines the first stock replacement boundary.

Supported first-pass stock surfaces:
- `MultiBarBottomLeft` -> Secondary;
- `MultiBarBottomRight` -> Utility.

Do not take ownership of Blizzard's own shown/hidden state.

Instead, while replacement is enabled:
- preserve frame existence and Blizzard visibility lifecycle;
- make supported stock bars visually transparent;
- remove their mouse interaction;
- route their keys through the Logres secure buttons.

Restoration restores exact captured values.

MainActionBar remains Blizzard-owned until special-state fallback is proven.

## P0044 replacement runtime ownership

`StockActionReplacement` owns the first selective replacement transaction.

It coordinates:
- stock presentation/interactivity;
- Secondary/Utility key routing;
- restoration snapshots;
- combat deferral.

The transaction is session-only for first proof.

A replaced stock domain cannot have its Logres routing manually disabled while
suppression is applied.

MainActionBar and unsupported stock domains remain outside this module's scope.

## Primary routing remains fail-open after reload

C.6 integrated runtime validation confirmed that Primary `Action Keys` must be
manually enabled again after reload.

This is intentional at the current capability boundary.

Primary stock UI is still Blizzard-owned and visible, so Logres does not
automatically seize `ACTIONBUTTON1–12` during addon initialization.

Automatic routing belongs to a replacement transaction, not merely to addon
load.

Current rule:
- Primary not replaced -> routing may remain manual/session-only;
- supported stock domain replaced -> matching Logres routing is automatic;
- future Primary replacement -> routing must become atomic with that
  replacement and restoration.

This preserves L-011 fail-open behavior.

## P0116 production visual primitive

D-039/D-040 move the proven secure action-button runtime onto the approved
World Ghost / Selective Hybrid E button chrome without changing action
semantics.

Production media:
- `Logres/Media/Theme.lua` owns paths and geometry tokens;
- `Logres/Media/Action/action_frame.tga` is the persistent frame;
- hover, pressed, checked, and activation-flash layers use separate approved
  derivatives.

The native WoW action icon remains dominant. Cooldown/count/range/usability
transport is unchanged.

The secure button hit box remains 38 x 38 with the proven 5-pixel cluster gap.
Decorative frame art may overscan by two pixels without changing secure
interaction geometry.

The existing independent UIParent activation-feedback frame is retained so
pressed/flash confirmation remains legible when Secondary/Utility cluster alpha
is subdued.

P0116 is not complete visual proof until in-client validation confirms actual
scale, hover/pressed hierarchy, checked persistence, feedback visibility, and
existing cooldown/range/resource/unusable states without Lua/taint/protected or
secret-value errors.


## P0116 runtime visual result and P0118 action-keybind polish

P0116 core production action presentation is runtime + visual PASS at actual UI
scale. The user accepted the frame/icon/feedback result and `Action Check` passed.
Specific checked/cooldown/range/resource/unusable visual-state coverage remains
deferred rather than inferred.

Primary key routing remains intentionally manual/session-only while the stock
Primary action surface remains Blizzard-owned. A `keys=false/12` observation is
therefore policy state, not action-visual failure.

P0118 changes only action-button presentation:
- default button size increases modestly from 38 px to 42 px;
- top-right metadata plate with stronger near-black inset fill;
- compact modifier notation uses lowercase modifier + hyphen + uppercase main
  key (`s-Q`, `c-C`, `a-E`);
- dark charcoal inset;
- thin weathered-bronze border;
- ivory key text;
- width follows the non-secret binding label;
- empty labels hide the plate completely;
- bottom-right action count placement is unchanged.

The plate uses texture/font regions on the existing secure button rather than a
new child Frame, so the refinement does not introduce protected frame
show/hide/resize mutations during combat.


### Keybind metadata alpha isolation

P0118 R4 confirms that keybind metadata must not inherit Secondary/Utility
contextual alpha: the black plate became visually ineffective at role alphas
`0.45` and `0.20` even though Primary was correct. Key-tag border, fill, and text
therefore use the existing UIParent feedback frame as an alpha-isolated
presentation surface. The underlying secure button and icon continue to inherit
normal role alpha.


### Keybind metadata plate layering

P0118 R5 establishes explicit draw sublevels for the keybind metadata plate on
the shared feedback frame: border at sublevel 0, black inset fill at sublevel
1, and key text at sublevel 2. This prevents the solid bronze border quad from
obscuring the intended black inset.
