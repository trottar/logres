# Visual Component Inventory

Status: CANONICAL PARALLEL ART INVENTORY
Date: 2026-10-02

Canonical visual decision:
`../decisions/D-034_SELECTIVE_HYBRID_E_AND_VISUAL_COMPONENTS.md`.

This inventory describes visual objects that Logres art direction must account
for. It intentionally includes both existing runtime surfaces and accepted
future Phase H+ compositions.

It is not a statement that every listed object is currently implemented or
that every Blizzard surface may be suppressed.

## 1. Shared visual primitives

Design a small reusable family rather than treating every consumer as an
unrelated widget:

- compact percentage bar + percentage text;
- minimal action button;
- status / aura icon;
- cast-state cue;
- compact name/value label;
- narrative text block;
- transient Context message block;
- world-attached annotation;
- low-weight ghost/minimal backing;
- authored parchment/heraldic meaning panel;
- divider / rule;
- restrained corner/cap ornament;
- Logres heraldic glyph family;
- focus / hover / activation / warning highlight;
- contrast shadow/backplate for bright world backgrounds.

## 2. Player reaction space

Required art objects:
- health tunnel outer-dark pressure;
- health tunnel injury layer;
- health tunnel critical-pressure layer;
- health tunnel near-death layer;
- player primary-resource percentage bar + `%` text;
- player cast cue: cast;
- player cast cue: channel;
- player cast cue: interrupt/failure;
- urgent/actionable player-debuff grouping;
- urgent status-icon treatment;
- accommodation for class-resource presentation;
- accommodation for Blizzard-owned alternate/special power surfaces.

Player health remains perceptual pressure, not a conventional health bar. D-036
freezes the intended continuous mapping: remaining health roughly corresponds to
remaining clear/usable visual field, with mild high-health easing and increasingly
severe critical collapse.

## 3. Action interface

Ordinary Logres action roles:
- Primary cluster: up to 12 buttons;
- Secondary role/cluster: up to 12 buttons per supported source;
- Utility role/cluster: up to 12 buttons per supported source.

Separate special-control domains:
- pet actions;
- stance/form controls;
- totem/class-special controls;
- possess/override/vehicle/special controls where Logres later gains proven
  ownership, with stock fallback otherwise.

Per-button states / overlays that art must support:
- occupied;
- empty;
- hover/focus;
- pushed/pressed;
- checked/toggled;
- cooldown;
- count/charges;
- hotkey label;
- activation flash/pulse;
- usable;
- unusable;
- insufficient resource;
- out of range;
- contextual peripheral opacity;
- combat emphasis.

Art studies must stress-test full ordinary density: 36 simultaneous buttons in
the current proof constellation.

## 4. Navigation

Compass core objects:
- baseline/tape;
- cardinal ticks;
- intercardinal ticks;
- cardinal labels;
- intercardinal labels;
- fixed center heading marker;
- restrained compass end-cap/heraldic ornament;
- hidden/suspended transition treatment.

D-037 future marker roles:
- manual waypoint: explicit player destination, authored muted-blue Logres glyph;
- quest destination: distinct quest/heraldic destination glyph, only when a real
  destination bearing is capability-proven;
- local radius POI: restrained nearby service/place marker within realistic local
  awareness; exact categories/radius/positions remain capability work;
- tracking: tiny repeated generic Logres tracker glyph, same visual meaning across
  tracked categories and not a literal stock yellow dot.

Manual waypoint is currently runtime-proven. Quest destination, local POI, and
tracking-result source/position capability remain separate future proof domains.
Exact glyph construction and marker collision/density behavior remain focused art
work.

## 5. Active Quest

Accepted future objects:
- optional Active Quest panel;
- quest title/identity;
- restrained ambient progress phrase;
- quest emblem/glyph or small thematic marker;
- quiet/collapsed default state;
- deliberate hover/inspection state;
- exact objective row(s) for deliberate inspection;
- mechanical count/detail treatment on inspection;
- completed-objective treatment;
- divider / panel ornament;
- feature-off state.

Active Quest is a one-focus contextual object, not a permanent multi-quest
tracker.

## 6. Context / transient information

Shared Context region objects:
- Context anchor/container, normally visually absent or nearly absent;
- XP pulse;
- objective-progress pulse;
- objective-complete pulse;
- future accepted quest/state pulse;
- generic short heading;
- generic mechanical/value line where needed;
- normal arrival transition;
- normal recede/fade transition;
- urgent Context emphasis variant.

XP, objective change, completion, and later accepted transient producers should
share this visual family rather than each inventing unrelated chrome.

## 7. NPC quest interaction

Current runtime is still additive, but D-035 establishes the future authored
quest-interaction family.

Narrative objects:
- quest title;
- fixed-height source-text reading area;
- short single-page presentation;
- discrete long-text pages;
- subtle page indicator;
- previous/next-page affordance where needed;
- objective/action text with controlled multi-line wrapping;
- entrance/reveal and recede treatment;
- optional faint divider/flourish.

Interaction objects for future capability-proven ownership:
- Accept;
- Decline;
- Continue;
- Complete Quest;
- reward-choice presentation;
- selected-reward state;
- eligibility/error feedback;
- quest-related gossip entry treatment where Logres owns that transition.

Do not invent quest narrative or silently summarize away source meaning.

Blizzard quest/gossip controls remain visible/available fallback until the
corresponding Logres interaction and information are deliberately proven.

## 8. Target / world-target system

Desired world-attached objects:
- target selection/association marker;
- target name/identity;
- target health percentage bar + `%` text;
- target cast/channel/interruption cue;
- target status-icon grouping;
- urgent/actionable target-status emphasis;
- accommodation for Blizzard quest-target marker;
- accommodation for raid-target marker;
- accommodation for unit ping signal.

Fallback detached objects:
- sparse target container;
- target name;
- target health percentage bar + `%` text;
- target cast cue;
- target status area only when deliberately replaced/proven.

The detached target remains a fallback until world-attached information and
interaction are capability-proven.

## 9. Player aura / status system

Reserve visual language for:
- urgent harmful status/debuff icon;
- urgent player-debuff group;
- passive beneficial buff/aura icon;
- passive peripheral aura group;
- duration treatment;
- stack/count treatment;
- dispellable/actionable emphasis;
- crowd-control emphasis;
- defensive/offensive state emphasis;
- PvP caution/emphasis state.

Exact filtering, healer/support fallback, duration policy, and suppression
remain separate design/capability work.

## 10. Pet and party / allies

Compact information objects:
- pet name/identity;
- pet health percentage bar + `%` text;
- pet status accommodation where later owned;
- party-member name;
- party-member health percentage bar + `%` text;
- compact party condition/status cue;
- party-row container/group;
- urgent party-row emphasis;
- passive party-row state.

Current Logres data rows do not replace Blizzard secure party interaction,
auras, role/accessibility, or compact-party surfaces; stock party UI remains
available until separately replaced.

## 11. Class / pet / special-control territory

Separate visual/capability domains even when spatially colocated:
- pet action cluster;
- stance/form cluster;
- totem cluster;
- rune/class-resource presentation;
- combo-point / discrete-pip presentation;
- class-special buttons;
- possess/override/vehicle fallback treatment.

Do not force discrete class mechanics into the percentage-bar primitive.

## 12. Global opacity and motion language

The visual system must define reusable states/transitions for:
- normal opacity;
- peripheral/receded opacity;
- combat emphasis;
- PvP caution emphasis;
- hover/focus reveal;
- disabled/unavailable treatment;
- normal fade-in;
- normal fade/recede;
- urgent reveal;
- Context pulse;
- Active Quest inspection expansion/reveal;
- action activation flash;
- health-tunnel critical/near-death motion if later accepted.

## 13. Settings / inspection presentation

Future Phase H visual language should also account for:
- feature toggles;
- supported action-source -> Secondary/Utility role assignment;
- limited authored layout/grid option controls if later accepted;
- hover/inspection tooltip/detail treatment;
- accessibility option controls;
- settings section headers/dividers;
- fallback/capability explanations where useful.

## 14. Blizzard-owned coexistence surfaces

Full-screen art studies must leave room for stock surfaces that Logres does not
currently replace. D-037 defines a future minimap-replacement endpoint, but D-030
remains current runtime authority until the complete replacement gate is proven:
- minimap;
- Objective Tracker;
- quest log;
- quest accept/decline/continue/complete controls while corresponding Logres
  replacements are not yet capability-proven;
- reward selection while the Logres reward-choice replacement is unproven;
- gossip controls outside proven Logres quest-related transitions;
- PartyFrame / CompactPartyFrame;
- alternate-power area;
- un-replaced direct player class-resource children;
- RuneFrame;
- TotemFrame;
- PetFrame;
- target auras/status until deliberately replaced;
- target raid marker;
- target quest icon;
- target ping;
- target-of-target;
- FocusFrame;
- boss target frames;
- unsupported vehicle/override/possess action surfaces;
- Blizzard chat/edit-box surfaces when not passively suppressed by Quiet Mode.

These coexistence objects are composition constraints, not candidates for
blanket visual replacement.

## 15. Current component-board plan

Before component implementation/polish, art studies should cover at least:

1. **Core World Ghost / Selective Hybrid board**
   - compass;
   - Active Quest;
   - health tunnel;
   - percentage-bar primitive;
   - Context;
   - NPC quest interaction: short/paged narrative, wrapped objective text, and
     future action/reward control states;
   - four navigation marker roles: manual waypoint, quest destination, local POI,
     generic tracking glyph;

2. **Combat-density board**
   - full 36 ordinary action buttons;
   - cast cues;
   - urgent player status;
   - passive status;
   - world-target annotations;
   - party/pet rows;
   - separate class/pet/special-control territory.

3. **State sheet**
   - action-button states;
   - percentage-bar states;
   - cast states;
   - health-tunnel stages;
   - status-icon urgency states;
   - hover/inspection states;
   - opacity/context states;
   - target world/fallback treatments.
