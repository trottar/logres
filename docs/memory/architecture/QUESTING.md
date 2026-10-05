# Questing Architecture

## Intent

Quest experience is a core Logres product domain.

Presentation should remain world-focused and visually consistent with Logres:
- authored NPC quest interaction;
- bounded/paged narrative reading;
- brief objective updates;
- optional current-focus Active Quest context;
- compass integration where technically possible;
- contextual XP display rather than a permanent conventional bar.

Canonical future-ownership decision:
`../decisions/D-035_QUEST_INTERACTION_OWNERSHIP.md`.

## Phase F implementation boundary — D-031

Phase F separated:
- passive quest/XP information;
- Blizzard-owned quest interaction/control.

That boundary remains authoritative for the **existing Phase F runtime**.

Current proven Phase F behavior is therefore additive/fail-open:
- contextual XP pulse;
- additive NPC quest detail presentation;
- contextual objective progress pulse;
- stock Blizzard quest interaction remains available.

D-035 changes the future endpoint, not the historical proof.

## Future NPC quest ownership — D-035

When safely capability-proven, Logres should own the player-facing NPC quest
flow:
- offer/progress/completion narrative;
- paging for long source text;
- objective/action text;
- accept / decline;
- continue / complete;
- reward presentation and reward selection;
- quest-related gossip transitions needed to reach those quest states.

No quest choice is automated.

Blizzard remains the fallback for any corresponding surface Logres has not
deliberately replaced and runtime-proven.

The full quest log, watch/super-track management, stock Objective Tracker, and
non-quest gossip remain separate capability domains.

## Narrative interaction

Preferred quest-reading composition:
- title;
- fixed-height source-text reading area;
- one page for short text;
- discrete player-driven pages for longer text;
- subtle page indicator/navigation;
- objective/action text that may wrap when needed.

Logres must not invent narrative facts or replace source quest text with
fabricated prose.

Paging source text is distinct from quest-state actions such as Continue,
Complete, Accept, or Decline.

## Control replacement gate

Before suppressing a Blizzard quest control, Logres must replace the matching
information and interaction.

Applicable replacements must preserve:
- clear player intent;
- quest-state correctness;
- eligibility/error feedback;
- reward identity and choice information;
- usable cancellation/decline paths where present;
- fail-open restoration/fallback.

A visual prototype is not replacement proof.

## Destination / compass boundary

Quest state/destination discovery feeds the existing Compass when capability is
proven.

Quest destination APIs may return nothing.

Tested quest IDs `436`, `237`, and later negative samples remain evidence that a
quest compass marker cannot be assumed available.

A quest compass marker requires a runtime-proven real destination.

## XP boundary

F.3 is complete.

Production contextual XP:
- positive same-range XP delta only;
- `+N XP · progress%`;
- approximately two seconds;
- no permanent XP bar;
- no stock XP suppression without a separate replacement gate.

Runtime, integration, and visual proof are accepted.

## Existing NPC quest detail runtime

F.4 is complete.

The current production slice remains additive:
- title;
- restrained body excerpt;
- optional objective line;
- temporary world-oriented text;
- no Logres-owned quest controls yet.

This remains valid runtime behavior while D-035 defines the future replacement
direction.

## Objective boundary

Runtime-proven objective rows and progress pulses do not by themselves replace
the stock Objective Tracker or quest-log management.

Missing/uncached objective data must not be converted into a fabricated empty or
completed state.

## Fail-open

Missing, secret, invalid, uncached, or failed inputs leave the relevant Blizzard
information/control surface available.

No stale quest destination, objective state, NPC text, reward choice, or quest
action is fabricated.


## Phase H+ Context-message production primitive — P0122

P0122 translates the approved Context-message sheet into one shared visual
primitive consumed by the already-proven XP and objective-progress producers.
It adds the thin line / center-diamond treatment and keeps presentation transient,
world-first, and mouse-transparent.

XP source/timing semantics are unchanged. Objective source/change-detection
semantics are unchanged.

The warmer/brighter completion treatment is capability-grounded: it is selected
only when an existing objective row reports a real `finished` transition to true.
Logres does not infer completion from counts or text and does not add quest turn-in
/control events for this styling.

## Phase H+ Active Quest one-focus presentation — P0126

P0126 implements the D-032/D-039 optional Active Quest surface from already-proven
passive quest data.

Focus policy:
1. super-tracked quest when available;
2. selected quest fallback.

The renderer reuses `QuestObjectiveProgress` guarded quest-ID/objective readers,
then reads the already-proven title/completion flags with the same secret-first
boundary.

Default presentation contains:
- exact quest title;
- restrained qualitative phrase derived only from safe progress/completion state;
- count-free normalized objective wording for each visible row;
- shared progress bars where ordinary measurable counts exist;
- no persistent `N/M` or `%` mechanical counts.

Deliberate row hover reveals exact source objective wording and exact counts.

The full Blizzard quest log and Objective Tracker remain available. P0126 performs
no quest watch/super-track mutation, no quest-control action, and no quest waypoint
lookup.

## P0126 runtime / visual acceptance

P0126 is durable at `89b0c563` / `0.0.58-dev`.

Accepted Active Quest behavior:
- super-tracked quest first, selected fallback;
- exact title;
- restrained qualitative ambient phrase;
- count-free normalized objective labels;
- bar-only progress;
- exact source wording/counts on deliberate hover;
- quiet complete/ready state;
- independent persisted toggle;
- Blizzard quest log / Objective Tracker remain available.

The initial `0.0.55-dev` hover tooltip failure remains preserved as evidence; R1
corrected it and the final R3 runtime/checkall passed.

The next questing work is not Active Quest expansion. It is the D-035 NPC
quest-interaction source/capability audit before any Blizzard interaction surface
is replaced.

## P0128 NPC quest interaction source audit

P0128 resolves the source/API layer for D-035 without changing runtime ownership.

Current Forever source references expose:
- offer/progress/completion narrative reads;
- reward item/choice/currency/spell reads;
- Accept/Decline/Continue/finalize quest functions;
- structured gossip quest/option reads and quest/option selection functions.

Only the historical `QUEST_DETAIL` passive read path and reward XP have prior
runtime proof in this interaction domain.

The next slice is therefore read-only. P0129 must observe real interaction states,
reward/gossip data, secret/failure behavior, and function presence before any
mutation-specific probe is selected.

Blizzard quest/gossip UI remains authoritative and visible.

## P0129 read-only interaction probe

P0129 adds a diagnostic-only, event-driven runtime producer for the D-035
capability gate.

It retains the Phase-F fail-open ownership model:
- no quest action is invoked;
- no gossip selection is invoked;
- no Blizzard quest/gossip presentation is suppressed.

The probe captures only bounded sanitized evidence and keeps event history for
detail/progress/complete/gossip states so a later developer-panel click can report
naturally observed interaction state.

The probe does not run inside `checkall`; contextual absence is a deferral rather
than a generic addon failure.
