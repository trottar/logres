# D-024 — Immersion orchestration contract

Status: ACCEPTED
Date: 2026-10-01

## Decision

Phase D introduces an `ImmersionController` as the authority for **stock UI
suppression/restoration policy**.

It consumes:
- persisted user preference;
- observed state;
- proven module capabilities.

It does not become an observed-state source.

## Inputs

### Preference

```text
immersionEnabled
```

D-010 remains authoritative.

### Observed state

Relevant orthogonal facts include:
- `context`;
- `combat`;
- `pvpFlagged`;
- later proven flags where policy needs them.

### Capability state

The controller may request only already-proven replacement capabilities.

Initial proven stock replacement:
- Bar 2;
- Bar 3.

## Policy model

The controller derives a desired suppression policy.

Initial conceptual shape:

```lua
Policy = {
    immersionEnabled = boolean,

    actionReplacement = boolean,
    quietMode = boolean,

    playerFrameSuppression = false,
    targetFrameSuppression = false,
    partyFrameSuppression = false,
}
```

The `false` unit-frame values are capability gates, not final product intent.

## Initial effective policy

### Immersion OFF

Restore:
- Phase C stock Bar 2–3 replacement;
- Quiet Mode runtime suppression;
- later supported stock surfaces.

User preference wins.

### Immersion ON

#### Action replacement

Request Phase C selective stock replacement.

This is safe because execution, routing, feedback, restoration, and combat
deferral are already proven.

#### Quiet Mode

Initial default:

```text
world context -> ON
instance context -> OFF
```

PvP flagging alone does not disable Quiet Mode.

This follows the product rule that PvP is a modifier, not immersion-off.

The instance default is conservative so communication remains visible until
instance-specific Quiet Mode behavior is deliberately expanded.

#### Unit frames

Do not blanket-suppress Player/Target/Party yet.

D.1 proved missing capability:
- secure unit targeting/menu access;
- player class-resource child preservation;
- target aura policy;
- normal vs compact party-frame ownership.

## Controller boundary

The controller coordinates modules.

It does not duplicate them.

For action bars:

```text
ImmersionController
    -> StockActionReplacement:RequestEnabled(desired)
```

The StockActionReplacement module remains owner of:
- snapshots;
- Bar 2–3 alpha/mouse suppression;
- routing;
- combat deferral;
- restoration.

## Fail-open rule

If a requested replacement capability is unavailable or fails:
- preserve/restore Blizzard UI;
- report the failure diagnostically;
- do not mark the suppression as successfully applied.

A partial suppression state must not remove the player's only control path.

## Combat rule

Each suppression domain owns its own combat constraints.

The controller may express desired state during combat.

Protected-domain modules:
- defer unsafe mutation;
- reconcile after `PLAYER_REGEN_ENABLED`.

The controller must not force ordinary protected mutations merely to make all
domains transition simultaneously.

## Reload/login

At initialization:
1. State and Preferences establish authoritative snapshots;
2. replacement modules initialize;
3. ImmersionController computes desired policy;
4. each capability reconciles toward that policy;
5. failures remain fail-open.

This changes Phase C's test-only session behavior intentionally:

Phase C proved Bar 2–3 replacement defaulting OFF after reload.

Phase D may automatically request it after reload **only because persisted
`immersionEnabled=true` now owns that decision**.

Primary Action Keys remain manual because Primary stock replacement is not
supported.

## Quiet Mode contract

Quiet Mode is visual presentation only.

It must not:
- change communication status;
- auto-reply;
- alter saved chat-window visibility merely to silence the UI;
- prevent intentional outbound chat through the normal edit-box path.

## Unit-frame capability gate

Blizzard unit frames are secure interaction surfaces.

Before a stock unit frame is suppressed, Logres must account for the required
interaction/information it would remove.

### Player
Do not suppress the full PlayerFrame because class resource, rune, totem, pet,
and managed children may depend on it.

### Target
Do not suppress the full TargetFrame until secure interaction and target aura
policy are resolved.

### Party
Do not suppress normal or compact party frames until secure party interaction
and required group context have a replacement/fallback.

## Rejected

- adding `immersionEnabled` to State;
- globally hiding Player/Target/Party immediately;
- whole-PlayerFrame alpha zero;
- changing saved chat settings for Quiet Mode;
- duplicating StockActionReplacement logic in the controller;
- automatically seizing Primary action keys without Primary replacement;
- treating PvP flagging as immersion OFF.
