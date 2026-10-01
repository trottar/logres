# Immersion Mode Architecture

Immersion Mode is a global presentation policy composed from contextual state.

Potential controlled subsystems:
- compass;
- quest presentation;
- camera;
- action-cluster visibility;
- HUD density;
- XP presentation;
- social/Quiet Mode.

## World

Full immersion features may operate.

## Combat

Retain the visual language while increasing access to immediately useful information.

## PvP flagged

Use a cautious modifier:
- keep world immersion where practical;
- increase access/visibility to relevant actions and target/party information;
- avoid overly tight cinematic camera behavior.

## Instance

Suspend world-navigation/compass behavior automatically.

Do not equate "instance" with disabling Logres entirely. Core combat HUD and action presentation remain Logres-controlled where technically safe.

## D-024 orchestration boundary

Phase D introduces ImmersionController as stock suppression/restoration policy
authority.

Inputs:
- D-010 preferences;
- observed State;
- proven capability status.

Initial automatic stock capability:
- Phase C Bar 2–3 replacement.

Initial Quiet Mode policy:
- world + immersion ON -> desired;
- instance -> conservative restore.

Unit-frame suppression remains capability-gated because stock secure unit
frames provide target/menu interactions and PlayerFrame owns un-replaced class
resource children.

The controller coordinates replacement modules rather than duplicating their
internal snapshot/combat logic.

## D.2 runtime controller

`ImmersionController` is the runtime policy coordinator.

It subscribes to:
- preferences;
- observed State.

It currently controls only a proven stock capability:
- selective Bar 2–3 replacement through StockActionReplacement.

It computes Quiet Mode desired state for D.3 but does not yet mutate chat.

It explicitly reports Player/Target/Party suppression as false capability
gates.

Primary routing remains manual until Primary stock replacement exists.

## D.3 Quiet Mode suppression boundary

Quiet Mode is presentation-only.

Do not directly Hide/Show ChatFrame objects because Blizzard frame scripts
persist ChatWindowShown state.

D-025 selects:
- runtime alpha suppression;
- mouse removal;
- exact restoration;
- edit-box IgnoreParentAlpha;
- chat-update reconciliation.

The controller still owns desired policy; the Quiet Mode module owns chat
presentation mechanics.

## D.4 unit-frame capability ladder

Unit-frame suppression is incremental.

First target:
- Player conventional shell only.

Required atomic pieces:
- visible Logres player presentation;
- secure Logres player target/menu interaction;
- selective stock shell suppression;
- stock mouse removal;
- exact restoration.

Target and Party remain gated behind their own interaction/context
requirements.

## P0053 Player selective replacement

The Player unit-frame replacement is not whole-frame ownership.

Logres suppresses only the conventional container/main content while preserving
the Blizzard parent and direct resource/pet children.

A secure Logres player button over the visible resource affordance replaces the
stock PlayerFrame target/menu click path while suppression is active.

## P0053 Player runtime result

The first selective unit-frame replacement passed runtime validation.

Player conventional shell suppression + secure Logres player interaction is now
proven for the tested workflow.

D.4 continues with Target selective suppression rather than expanding to
whole-frame ownership.

## D-027 Target selective replacement

Target replacement uses the same capability-safe pattern proven by Player, but
with a mixed contextual subtree.

The stock contextual parent is suppressed as a group; useful unreplaced
children explicitly ignore parent alpha.

This avoids chasing Blizzard metadata Show/Hide updates while retaining auras,
raid marker, quest context, and pings.
