# D-035 — Quest interaction is a Logres-owned experience

Status: ACCEPTED
Date: 2026-10-03

## Decision

Quests are a core Logres experience.

The intended endpoint is not permanently:

```text
Logres presents quest information
+
Blizzard owns all quest interaction
```

When the required capability is deliberately proven, Logres should own the
player-facing NPC quest flow itself.

That future ownership includes:
- quest-offer narrative presentation;
- bounded/paged reading for long quest text;
- objective text associated with the interaction;
- accept / decline;
- quest-progress / continue;
- quest-completion / complete;
- reward presentation and player reward selection;
- quest-related gossip transitions needed to enter the corresponding quest
  interaction.

The player still makes every quest choice. This decision does not authorize
automatic acceptance, completion, reward choice, or gossip navigation.

## Phase F relationship

D-031 remains authoritative for the initial Phase F implementation and runtime
proofs.

Phase F intentionally used additive quest presentation while Blizzard retained
the authoritative controls. That was the safe capability boundary at the time,
not the final product goal.

D-035 supersedes only the **future ownership interpretation** of that boundary.

Existing Phase F behavior remains valid until a later capability slice
deliberately replaces it.

## Narrative paging

Long NPC quest text must not expand without bound.

The preferred authored interaction uses:
- a fixed narrative reading area;
- discrete pages when source text exceeds that area;
- a subtle page indicator;
- player-driven page advance/back where needed;
- no fabricated or AI-authored quest prose.

Short text may fit on one page.

Objective/action text may wrap to an additional line when needed rather than
being clipped into an unreadable single line.

Paging is presentation of source quest text, not a substitute for actual quest
state transitions such as Continue or Complete.

## Interaction requirements

Before any Blizzard quest control is suppressed, Logres must provide the
corresponding usable interaction and required information.

A replacement slice must account for the applicable surface, including:
- what action the player is taking;
- eligibility/error feedback;
- the exact quest state being acted on;
- reward identity and choice requirements before selection;
- cancellation/decline behavior where applicable;
- restoration/fallback if Logres cannot continue safely.

Do not remove a Blizzard quest information/control surface merely because a
visual prototype exists.

## Fail-open

Until a Logres quest interaction surface is capability-proven, the corresponding
Blizzard quest/gossip surface remains available.

On missing/secret/invalid data, unsupported interaction, protected failure, or
other uncertainty, fail open to Blizzard rather than leaving the player unable
to progress a quest.

## Scope boundary

This decision establishes ownership of the **NPC quest interaction flow**.

It does not automatically claim:
- the full quest log;
- watch-list management;
- super-track mutation;
- the stock Objective Tracker;
- non-quest gossip;
- speculative quest navigation data.

Those remain separate capability domains unless later accepted explicitly.

## Art-direction consequence

Quest-interaction art must now cover more than passive text.

Future component work should include:
- short and paged narrative reading;
- objective text wrapping;
- page navigation/indication;
- accept / decline;
- continue / complete;
- reward choices and selected reward state;
- eligibility/error feedback;
- quest-related gossip entry treatment where that transition is owned.

The World Ghost / Selective Hybrid E rule still applies:
meaning-heavy quest surfaces may carry authored Logres identity, while repeated
interaction controls should remain readable and restrained.
