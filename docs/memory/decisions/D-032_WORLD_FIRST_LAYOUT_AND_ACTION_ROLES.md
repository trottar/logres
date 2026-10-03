# D-032 — World-first layout and action-role direction

Status: ACCEPTED
Date: 2026-10-02

## Decision

Phase H+ integration should organize Logres by **ownership, urgency, and
relationship to the world**, not by reproducing conventional MMO frame groups.

The world remains the dominant visual surface. Before adding a detached HUD
surface, prefer attaching information to the relevant world object when that
can be done safely and without losing required information or interaction.

Canonical layout architecture:
`../architecture/WORLD_FIRST_LAYOUT.md`.

## Semantic regions

The intended composition is:

- top center: Compass / navigation;
- upper right: optional Active Quest context;
- center: transient Context presentations;
- lower center: player resources and Primary actions;
- lower left: separate class/pet controls plus Secondary action roles;
- lower/right periphery: passive player status and Utility action roles;
- target information: attached to the actual target in the world whenever the
  required information can be represented safely.

These are semantic regions, not frozen pixel coordinates.

## Active Quest

Active Quest is an optional feature, not a replacement quest list.

It presents only the player's current active focus, sourced from safe
selected/super-tracked quest identity when available.

Ambient wording should fit Logres rather than expose raw game-system phrasing
by default. Avoid persistent mechanical text such as `6/10 bears killed` when a
safe qualitative presentation can communicate progress.

Rules:
- do not invent quest narrative or semantic facts not present in source data;
- qualitative wording may derive only from known safe progress state;
- exact objective wording and counts remain available through deliberate
  inspection such as hover;
- the whole Active Quest feature is independently toggleable;
- the full Blizzard quest log remains available for management and detail.

## Context

`Context` is the dedicated transient information region.

Examples include:
- XP changes;
- quest/objective progress changes;
- objective completion;
- other short-lived state changes accepted later.

Context is not a permanent tracker. Producers publish brief presentations into
the region rather than each choosing unrelated permanent screen anchors.

## Action roles

Logres owns the authored action aesthetic when its action interface is enabled.

Primary:
- fixed role;
- remains the central, mentally available action cluster.

Supported extra action bars:
- the player assigns each supported source bar to a Logres role such as
  Secondary or Utility;
- role assignment expresses meaning, not arbitrary geometry;
- Logres controls role placement, spacing, contextual emphasis, and visual
  language.

Example only:
- Bar 2 and Bar 5 may be Secondary;
- Bar 3 and Bar 4 may be Utility.

Those assignments are not universal defaults.

Logres is not intended to become a general-purpose action-bar layout/profile
editor. Limited authored options such as a small set of grid shapes or moving a
whole cluster may be considered if implementation cost stays low and secure
behavior remains clear.

Players who want unrestricted bar placement/layout may disable the Logres
action presentation and use the stock UI or a specialist addon.

This decision supersedes D-020's earlier requirement for arbitrary Logres
layout profiles and a full Logres layout editor. D-020 remains historical
context for the secure-runtime proof and the need for safe editing fallback.

## Class, pet, stance, totem, and special controls

These controls may share a visual territory but remain separate capability
and secure-action domains.

Do not collapse pet actions, stance/form controls, totems, or other
class-specific mechanics into the ordinary Secondary/Utility source model
merely because they are colocated.

## Target direction

The intended default target representation is the **actual target in the
world**, with relevant information attached to or spatially associated with
that target when possible.

A detached Logres target frame is therefore an optional/fallback presentation,
not the desired default endpoint.

The existing sparse target frame and D-027 selective suppression remain valid
runtime capabilities until world-attached presentation safely replaces all
required information and interaction. Do not remove a proven fallback merely
because the future default is world-attached.

## Aura / status placement

Status ownership and urgency determine placement:

- urgent/actionable player debuffs belong near player resources / central
  reaction space;
- passive player buffs/auras belong in a quieter peripheral region;
- target status should attach to the world target when safe and useful.

This is a placement direction, not authorization to suppress stock aura/status
surfaces. The dedicated aura capability gate remains authoritative.

## Fail-open boundary

No future layout decision overrides capability gating.

A Blizzard information/control surface remains available until Logres has a
safe deliberate replacement or fallback for the information or interaction it
would remove.

## Phase H ownership

Phase H should integrate these regions and settings after current capability
work is complete. Exact ordering and pixel geometry remain Phase H design work;
this decision establishes product direction rather than a frozen implementation
schema.


## Visual-system refinement — D-034

D-034 defines the current visual working anchor and canonical component
inventory without changing D-032's spatial/ownership rules.

In particular:
- meaning-heavy surfaces may carry more authored Logres ornament;
- high-density interaction surfaces remain comparatively simple;
- percentage-based Logres-owned values use a shared compact bar + `%` text
  direction, with player health explicitly remaining the perceptual tunnel.
