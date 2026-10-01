# D.5 Context / PvP / Instance Orchestration Source Review — 2026-10-01

Status: SOURCE / DESIGN RESOLVED
Date: 2026-10-01

## Goal

Resolve one deterministic Phase D policy across:
- immersion preference;
- world vs instance context;
- combat;
- PvP flagging;
- already-proven replacement capabilities.

Do not create a monolithic "mode" variable.

The state engine remains orthogonal.

## Existing state contract

Current State already exposes:
- `context`;
- `inInstance`;
- `instanceType`;
- `combat`;
- `pvpFlagged`;
- `mounted`;
- `resting`;
- `onTaxi`;
- `interacting`;
- `interactionType`.

D.5 does not add new observed state.

For the first orchestration pass:
- context;
- combat;
- PvP

are the only state facts that affect the supported Phase D policy.

Mounted/resting/taxi/interacting remain available for later systems but do not
change current stock-suppression ownership.

## Existing runtime ownership

ImmersionController currently derives:

```text
action replacement = immersionEnabled
Quiet Mode = immersionEnabled AND world context
Player replacement = immersionEnabled
Target replacement = immersionEnabled
Party replacement = false
```

This is already close to the desired D.5 matrix.

ActionContext independently resolves action-cluster presentation with precedence:

```text
combat > PvP flagged > instance > world
```

Current presentation alpha:

| Presentation policy | Primary | Secondary | Utility |
| --- | ---: | ---: | ---: |
| world | 1.00 | 0.45 | 0.20 |
| PvP | 1.00 | 0.75 | 0.40 |
| instance | 1.00 | 0.70 | 0.45 |
| combat | 1.00 | 1.00 | 0.75 |

D.5 keeps that precedence.

## D.5 supported-domain matrix

When `immersionEnabled=false`, the preference is the hard restore override:

| Domain | Desired |
| --- | --- |
| Bar 2–3 stock replacement | OFF |
| Quiet Mode | OFF |
| Player selective replacement | OFF |
| Target selective replacement | OFF |
| Party suppression | OFF / unsupported |

When `immersionEnabled=true`:

| State | Bar 2–3 replacement | Quiet Mode | Player replacement | Target replacement | Action presentation |
| --- | --- | --- | --- | --- | --- |
| world idle | ON | ON | ON | ON | world |
| world PvP idle | ON | ON | ON | ON | PvP |
| world combat | ON | ON | ON | ON | combat |
| world PvP combat | ON | ON | ON | ON | combat |
| instance idle | ON | OFF | ON | ON | instance |
| instance PvP idle | ON | OFF | ON | ON | PvP |
| instance combat | ON | OFF | ON | ON | combat |
| instance PvP combat | ON | OFF | ON | ON | combat |

Party / CompactPartyFrame remain stock in every row.

## Why Player / Target remain replaced in instances

Player and Target selective replacement are now proven capabilities.

They preserve the stock information/children that Logres does not yet replace:
- Player direct class/resource/pet dependencies remain outside suppression;
- Target auras/raid/quest/ping context remain preserved;
- target-of-target remains Blizzard-owned;
- boss frames remain untouched.

The sparse Player / Target presentation is combat-capable and aligns with the
product rule that combat-critical presentation may remain in instances.

Therefore instance entry does not restore the conventional main Player or
Target shell.

## Why Bar 2–3 replacement remains active in instances

The Phase C replacement is proven for:
- execution;
- binding routing;
- activation feedback;
- exact restoration;
- combat deferral.

Instances increase action relevance rather than reducing it.

Therefore supported action replacement follows the immersion preference, not
world/instance context.

Primary stock replacement remains unsupported and outside D.5 ownership.

## Why Quiet Mode restores in every instance

Quiet Mode is the only currently supported domain whose first-pass policy is
context-sensitive.

Instance communication is conservatively treated as important.

Therefore:

```text
world + immersion ON -> Quiet Mode ON
instance + immersion ON -> Quiet Mode OFF
```

This remains true in:
- combat;
- PvP flagging;
- any current instance subtype.

D.5 does not branch on `instanceType` yet.

Subtype-specific communication policy can be added only with a deliberate
reason and runtime proof.

## PvP policy

PvP is a modifier, not Immersion OFF.

PvP flagging does not restore:
- stock Bar 2–3;
- stock Player shell;
- stock Target shell;
- passive world chat.

PvP currently affects action visibility through ActionContext.

At idle it raises Secondary / Utility visibility.

Combat still has higher presentation precedence.

This preserves caution without returning to a maximal stock HUD.

## Combat policy

Combat does not change desired stock-replacement ownership.

Under an already-enabled immersion session:
- Action replacement stays ON;
- Quiet Mode stays whatever context requires;
- Player replacement stays ON;
- Target replacement stays ON.

Only action presentation emphasis changes to the combat policy.

This is important operationally:

**combat enter/leave should not cause unnecessary protected replacement
mutation.**

The controller may reconcile because State changed, but each already-satisfied
replacement domain should no-op.

## Transition semantics

### World -> instance

Expected desired-state change:
- Quiet Mode ON -> OFF.

No desired-state change:
- Bar 2–3 replacement;
- Player replacement;
- Target replacement.

### Instance -> world

Expected desired-state change:
- Quiet Mode OFF -> ON.

No desired-state change:
- Bar 2–3 replacement;
- Player replacement;
- Target replacement.

### PvP flag transition

Expected:
- ActionContext presentation may change.

No desired-state change:
- Bar 2–3 replacement;
- Quiet Mode;
- Player replacement;
- Target replacement.

### Combat enter/leave

Expected:
- ActionContext presentation changes to/from combat.

No desired-state change in supported replacement modules.

### Immersion preference transition out of combat

OFF:
- restore Quiet Mode;
- restore Bar 2–3 stock surfaces;
- restore Player shell;
- restore Target shell.

ON:
- request all supported replacements;
- apply Quiet Mode according to current context.

### Immersion preference transition during combat

The controller may express the new desired state immediately.

Domains obey their own safety constraints.

Therefore a transition may be temporarily asynchronous:
- unprotected Quiet Mode may apply/restore immediately;
- protected action/unit-frame mutations may defer until combat ends.

This is accepted by D-024 and is safer than forcing synchronized protected
mutation.

## Precedence model

This is not one global state ladder.

Each domain consumes only the state it needs.

### Restore authority

Highest-level control:

```text
immersionEnabled=false -> restore every supported suppression domain
```

### Quiet Mode

```text
immersion OFF -> OFF
instance -> OFF
world -> ON
```

Combat and PvP do not override this.

### Action presentation

```text
combat > PvP flagged > instance > world
```

This is presentation emphasis, not suppression ownership.

### Player / Target / Bar 2–3 replacement

```text
immersion preference only
```

Current context/combat/PvP do not alter desired ownership.

### Party

```text
always stock / unsupported
```

## Fail-open

Capability failure outranks desired immersion policy.

If a replacement domain fails:
- preserve/restore its stock Blizzard surface;
- report diagnostic failure;
- do not infer that the whole immersion session must turn OFF.

Other proven domains may remain active.

This keeps imperfect capability local rather than turning every error into a
global mode switch.

## Instance subtype

`instanceType` remains in State and diagnostics.

D.5 first-pass policy deliberately does not branch on it.

Reasons:
- current supported replacements are valid across instance context;
- Quiet Mode already has the conservative all-instance fallback;
- no subtype-specific requirement has been runtime-proven.

## Mounted / resting / taxi / interaction

No D.5 stock-suppression behavior changes for these facts.

They remain orthogonal state available to:
- later camera policy;
- interaction UI;
- navigation;
- quest presentation;
- travel behavior.

Do not expand Phase D simply because the sensors exist.

## Future domain hooks

These are product-direction hooks, not Phase D runtime ownership.

Later phases should consume the same context model.

### Compass / navigation
- world: enabled / available;
- instance: faded or off where world navigation is inappropriate/unavailable.

### Quest presentation
- world: immersive quest/navigation behavior;
- instance: suspend world-oriented quest navigation where appropriate.

### Camera
- world: exploration profile;
- instance: instance profile;
- PvP: caution modifier;
- combat: may modify framing without becoming a separate global mode.

D.5 does not implement those systems.

## Runtime validation target

The next runtime patch should add a cross-module Context Policy Check.

It should validate:
- State values;
- ImmersionController desired ownership;
- ActionContext resolved policy;
- supported capability gates;
- no unexpected Party ownership.

It should not duplicate module logic or inspect secret/protected values.

World idle should be immediately testable.

Combat and PvP transitions should be tested naturally or deliberately where
safe.

Instance policy may remain environmental if no instance is nearby; do not
travel solely to manufacture proof.

## Sources

Repository source:
- `Logres/Core/State.lua`;
- `Logres/Immersion/Controller.lua`;
- `Logres/Actions/Context.lua`;
- `docs/memory/decisions/D-024_IMMERSION_ORCHESTRATION_CONTRACT.md`;
- `docs/memory/DESIGN_PRINCIPLES.md`.
