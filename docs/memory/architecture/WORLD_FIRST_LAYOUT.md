# World-First Layout Architecture

## Product rule

Place information according to:

1. who or what owns the information;
2. how urgently the player must react to it;
3. whether it can be represented through the game world instead of a detached
   abstraction.

D-032 is authoritative for the accepted product direction.

## Regions

### Navigation

Top-center Compass and accepted world/navigation cues.

### Active Quest

Optional upper-right current-focus presentation.

It is one active quest context, not a permanent multi-quest tracker. Ambient
presentation is restrained and non-mechanical; exact objective details are
available through deliberate inspection.

### Context

A dedicated transient presentation region near the player's central attention.

XP, objective progress, completion, and later accepted short-lived events should
share this region instead of inventing unrelated anchors.

### Player reaction space

Lower-center resources and urgent player status.

Urgent/actionable debuffs belong near this area because they affect immediate
player decisions.

### Actions

Primary remains central and fixed in role.

Secondary roles live toward the left/specialized-control side. Utility roles
live toward the quieter periphery. Supported source bars are assigned to roles;
Logres authors the visual composition.

### Class / pet / special controls

Pet actions, stance/form controls, totems, and other class-specific systems are
separate domains even when visually colocated.

### Passive status

Lower/right peripheral region for less urgent player buffs/auras and similar
inspection-oriented state.

### World target

The actual creature/player in the world is the preferred target-information
anchor.

World-attached name/state/cast/status cues should replace detached target
abstractions only when capability and fallback requirements are proven.

The existing sparse Logres target frame remains an optional/fallback capability
until then.

## Anchor ownership

Presentation regions should be stable layout anchors owned by integration code,
not incidental dependencies between unrelated modules.

For example, Context should not permanently depend on the target frame merely
because an early objective pulse used that anchor.

Producer modules own their information and timing. Integration owns where that
class of information is presented.

## Geometry

This record does not freeze coordinates.

Phase H may establish authored defaults and a small set of safe adjustments,
but unrestricted frame/profile construction is outside the intended Logres
product boundary unless a later explicit decision reopens it.

## Safety

Layout integration never authorizes premature Blizzard suppression.

Existing secure interaction, restoration, secret-value, combat-lockdown, and
fail-open contracts continue to apply.
