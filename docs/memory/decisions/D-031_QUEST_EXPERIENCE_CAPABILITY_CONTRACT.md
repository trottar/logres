# D-031 — Quest Experience Capability Contract

Status: ACCEPTED
Date: 2026-10-02

## Decision

Phase F separates passive quest/XP observation from Blizzard-owned quest
interaction/control.

The first production presentation candidate is a **contextual XP pulse**, not a
permanent XP bar and not stock XP-bar suppression.

Before that production slice, F.2 must runtime-prove the relevant Forever
quest/XP data paths and event behavior.

F.2 also tests quest destination output so a later quest marker can be fed into
the existing compass when, and only when, a real quest destination is proven.

## Passive information boundary

Source review identifies Forever-facing passive sources including:

- quest log identity/title/objectives;
- selected/super-tracked quest identity;
- quest completion/failure/turn-in readiness;
- quest-giver detail/progress/reward text;
- player XP/max XP/rested XP;
- quest destination APIs that may return nothing.

These are observation candidates only until runtime-proven on the tested client.

## Interaction/control boundary

The following remain Blizzard-owned:

- selecting/accepting/declining quests;
- continuing/completing quests;
- reward choice;
- gossip navigation;
- quest-watch mutation;
- super-track mutation;
- stock quest-log interaction;
- stock objective-tracker interaction.

Logres does not automate those controls in the initial Phase F slices.

## Quest compass boundary

Phase F owns the quest state/destination provider.

The existing Compass remains the navigation renderer.

A quest compass marker may be added only after F.2 proves, for a real
selected/super-tracked Forever quest:

1. a stable quest ID;
2. a usable destination from `C_QuestLog.GetNextWaypoint` and/or
   `C_QuestLog.GetNextWaypointForMap`;
3. a safe same-map bearing path;
4. update semantics that do not retain a stale destination.

Source presence alone is insufficient.

The previous negative samples for quest IDs `436` and `237` remain valid
negative evidence and are not erased.

## XP boundary

Candidate passive sources:

- `UnitXP("player")`;
- `UnitXPMax("player")`;
- `GetXPExhaustion()`;
- `PLAYER_XP_UPDATE`;
- `UPDATE_EXHAUSTION`;
- `QUEST_TURNED_IN` XP payload.

F.2 must verify normal/secret behavior before production arithmetic or
formatting.

The first production XP presentation, if runtime-proven, is:
- brief/contextual;
- shown after meaningful XP change;
- absent at level cap or unusable input;
- not a conventional permanent bar.

Stock XP presentation remains until replacement/suppression is separately
proven.

## NPC quest text boundary

Quest-giver text may be observed during the Blizzard quest interaction state.

The Blizzard quest/gossip frame remains the required interaction/control
surface until Logres has a deliberate replacement for:
- accept/decline;
- continue/complete;
- reward selection;
- error/eligibility feedback.

Early Logres NPC quest presentation must therefore be additive or fail-open.

## Objective boundary

`C_QuestLog.GetQuestObjectives` is source-present on Forever but may return
nothing while data is not cached.

Phase F must not turn missing objective data into completion or an empty-state
claim.

Objective presentation must distinguish:
- unavailable/not loaded;
- empty objective list;
- active objectives;
- completed objectives.

The stock objective tracker remains until Logres objective presentation and
interaction/fallback requirements are proven.

## Secret/protected rule

Every F.2/F.3 data path must check secret-capable values before:
- type inspection;
- comparison;
- counting;
- string formatting;
- arithmetic.

No secret value is persisted.

## Fail-open rule

Any absent, secret, invalid, uncached, or failed input leaves the corresponding
Blizzard information/control surface available.

No stale quest destination, objective state, NPC text, or XP value is
fabricated.

## Next

F.2 runs a single passive panel-driven probe covering:
- current quest/NPC interaction state;
- selected/super-tracked quest state;
- objectives;
- quest destination output;
- XP/rested XP;
- relevant event registration/counts.

No stock suppression occurs in F.2.

## Supersession note — D-035

D-031 remains authoritative for the **initial Phase F implementation boundary**
and the runtime evidence collected under that boundary.

It does **not** define the final product ownership of NPC quest interaction.

D-035 establishes the future Logres endpoint:
- NPC quest interaction is a core Logres experience;
- Logres should own offer/progress/completion reading and paging, player
  accept/decline, continue/complete, and reward selection when each surface is
  deliberately capability-proven;
- Blizzard quest/gossip controls remain fail-open fallback until the
  corresponding Logres information and interaction are safely replaced.

Quest-log/watch/super-track management remains a separate capability question
unless later accepted explicitly.
