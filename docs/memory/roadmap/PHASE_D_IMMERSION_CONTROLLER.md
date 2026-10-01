# Phase D — Immersion Controller

Status: ACTIVE

## Objective

Turn proven Logres capabilities into coherent immersion orchestration while
preserving fail-open access to Blizzard controls and information that Logres
does not yet replace.

D-017 and D-024 are authoritative.

## D.1 — Immersion orchestration contract / source review

**Status: COMPLETE.**

Resolved:
- preference/state separation;
- controller boundary;
- Phase C action replacement integration;
- Quiet Mode first-pass boundary;
- protected unit-frame security/interaction;
- PlayerFrame child-resource dependency;
- target aura/control dependency;
- normal + compact party-frame paths;
- fail-open restoration.

## D.2 — Immersion Controller runtime foundation

**Status: COMPLETE.**

Implement:
- `ImmersionController` module;
- subscribe to D-010 preferences;
- subscribe to observed state;
- derive desired policy;
- automatically request proven Bar 2–3 replacement when immersion is ON;
- restore Bar 2–3 replacement when immersion is OFF;
- world/instance Quiet Mode desired flag in diagnostics, but do not yet hide
  chat until D.3;
- developer `Immersion Check`.

Do not suppress Player/Target/Party in D.2.

Primary action routing remains manual because Primary replacement remains
unsupported.

### D.2 P0048 implementation

Version `0.0.21-dev`.

Adds `ImmersionController`.

Runtime behavior:
- persisted immersion ON automatically requests proven Bar 2–3
  replacement;
- immersion OFF restores it;
- state/preferences both trigger policy reconciliation;
- Quiet Mode desired state is computed but not applied until D.3;
- Player/Target/Party remain unsuppressed;
- Primary routing remains manual.

### D.2 final runtime result

P0048 runtime passed on `0.0.21-dev`.

Verified accepted behavior:
- persisted immersion owns Bar 2–3 replacement;
- reload orchestration works;
- immersion OFF/ON restores/reapplies supported replacement;
- unsupported Primary and unit-frame domains remain outside ownership.

D.2 closes.

## D.3 — Quiet Mode runtime suppression

**Status: COMPLETE — INSTANCE TRANSITION PROOF DEFERRED BY ENVIRONMENT.**

Implement runtime visual silence:
- chat frames;
- chat tabs;
- selected safe social visual surfaces after source confirmation.

Rules:
- do not change saved chat visibility/dock configuration;
- do not alter communication status;
- preserve intentional edit-box use;
- world default ON while immersion is enabled;
- conservative instance default OFF;
- restore/reconcile after chat-window updates.

### D.3 source refinement

D-025 is canonical.

Direct ChatFrame Hide/Show is rejected because Blizzard's frame scripts
persist `SetChatWindowShown`.

First-pass Quiet Mode uses:
- runtime alpha zero;
- mouse disabled;
- exact state snapshots/restoration;
- edit-box ignore-parent-alpha for intentional outbound chat;
- reconciliation after Blizzard chat-window updates.

Implementation next.

### D.3 P0050 implementation

Version `0.0.22-dev`.

Quiet Mode now:
- follows ImmersionController world policy;
- suppresses passive chat/tabs through runtime alpha/mouse state;
- keeps intentional chat edit boxes independent from parent alpha;
- restores exact captured runtime presentation;
- reconciles after Blizzard chat-window updates;
- never writes ChatWindowShown for suppression.

Runtime proof is next.

### D.3 final runtime result

P0050 runtime passed on `0.0.22-dev`.

Verified:
- passive chat/social presentation is quiet in the world;
- intentional chat input remains available;
- immersion restoration/reapplication works;
- no reported runtime regression.

Instance transition proof is deferred by environment because no nearby
instance was naturally available.

Do not require travel solely to manufacture this proof.

D.3 closes.

## D.4 — Unit-frame interaction + selective suppression

**Status: PLAYER SHELL PASS; TARGET SOURCE-RESOLVED; IMPLEMENTATION NEXT.**

Before suppression, complete the missing capability.

### Player
Resolve a safe conventional-shell suppression that preserves required:
- class resources;
- rune/totem resources;
- pet/managed children;

or provide Logres replacements first.

### Target
Add/prove equivalent secure unit interaction and resolve target aura policy
before suppressing the stock target surface.

### Party
Add/prove secure party targeting/menu interaction and account for:
- normal PartyFrame;
- CompactPartyFrame raid-style mode;
- required group context.

No blanket unit-frame hide.

### D.4 source review

Active investigation:
`../investigations/D4_UNIT_FRAME_INTERACTION_SUPPRESSION_REVIEW.md`

Resolve a capability ladder for Player/Target/Party rather than blanket
frame hiding.

### D.4 source result

D-026 is canonical.

Player:
- first supported selective suppression target;
- suppress conventional PlayerFrame container + main content only;
- preserve alternate/class/rune/totem/pet children;
- add secure Logres player interaction before disabling stock mouse.

Target:
- source-feasible but deferred from first runtime pass;
- requires secure Logres target interaction plus aura/raid-marker
  preservation and contextual metadata filtering.

Party:
- deferred;
- must cover both normal and compact secure party paths plus aura/group
  context.

First runtime implementation:
**Player secure interaction + selective shell suppression.**

### D.4 P0053 Player shell implementation

Version `0.0.23-dev`.

Implements the first D-026 unit-frame replacement:
- secure Logres player target/menu interaction;
- selective PlayerFrameContainer suppression;
- selective PlayerFrameContentMain suppression;
- stock PlayerFrame mouse suppression;
- exact restoration and combat deferral.

Does not suppress:
- whole PlayerFrame;
- TargetFrame;
- Party/CompactPartyFrame;
- alternate/class/rune/totem/pet direct children.

Runtime proof is next.

### D.4 P0053 runtime result

Player selective replacement passed on `0.0.23-dev`.

Accepted:
- conventional PlayerFrame shell suppression;
- secure Logres player interaction;
- stock interaction restoration;
- Immersion ON/OFF integration.

Environment-specific direct-child resource paths remain natural-play
follow-ups rather than blockers.

### D.4 next capability step

**Target selective suppression source/design review — ACTIVE.**

Resolve exact TargetFrame suppress/preserve child paths before runtime code.
Party remains deferred.

### D.4 Target source result

D-027 is canonical.

Target selective replacement is source-resolved.

Suppress:
- TargetFrameContainer;
- TargetFrameContentMain;
- TargetFrameContentContextual parent alpha.

Preserve through IgnoreParentAlpha:
- Auras;
- RaidTargetIcon;
- QuestIcon;
- PingIconFrame.

Add secure Logres target interaction with RegisterUnitWatch before stock
TargetFrame mouse removal.

Leave target-of-target, Focus, boss frames, and Party untouched.

**P0056 runtime implementation next.**

## D.5 — Context / PvP / instance orchestration

Integrate orthogonal state:
- context;
- combat;
- PvP;
- relevant later flags.

PvP remains a modifier, not immersion OFF.

Context policy may restore unsupported stock surfaces whenever Logres cannot
safely replace them.

## D.6 — Restoration / integration validation

Validate:
- immersion ON;
- immersion OFF;
- reload/login;
- combat-deferred changes;
- PvP;
- natural world/instance transitions;
- module disable/restore;
- developer recovery;
- no required control/information lost.

## Phase D exit

Phase D completes when:
- all suppression it claims is capability-safe;
- Immersion OFF reliably restores stock UI;
- Quiet Mode is reversible and does not alter communication status;
- Phase C selective action replacement is automatically orchestrated;
- supported unit-frame suppression preserves required controls/resources;
- context/PvP/instance behavior is deterministic;
- no protected/taint/Lua/secret regression occurs.
