---
memory_schema: 1
as_of: 2026-10-05
project: logres
---

# Durable Project Memory

This file contains long-lived project facts and rules. It is not a chronological development log.

## Identity

**Logres** is an immersive, world-first interface addon for World of Warcraft Forever.

The name is Arthurian/Camelot-adjacent: an homage to the Camelot/Classic+ lineage without naming the addon `Camelot` itself.

## Core product thesis

Logres should move the player's attention away from interface abstraction and back toward the world, character animation, spatial awareness, sound, and encounter behavior.

Minimalism alone is not the goal. **Selective information disclosure** is part of the experience.

Three information classes guide the design:

1. **Always perceptible** — information needed instinctively, such as primary actions, resource state, severe health danger, and current target.
2. **Contextually revealed** — information that becomes useful in combat, PvP, interactions, quest updates, or other relevant states.
3. **Intentionally obscured** — information the game may know but Logres deliberately does not foreground, such as exact player health, numeric enemy level, explicit elite classification, and explicit difficulty labels.

## Established design facts

- Player health has no conventional health bar.
- Player danger is communicated through an organic charcoal/cold-burgundy peripheral health tunnel whose clear usable field contracts as health worsens; no conventional player health bar is used.
- Resource presentation is compact and percentage-oriented; the accepted production baseline uses a shared compact bar with visible `%` text for percentage-based Logres-owned values except player health.
- Cast bars are not part of the intended visual language. A minimal cast-confirmation glyph may exist only to confirm that a cast/channel is active when animation alone is ambiguous.
- Enemy level is not shown numerically.
- Enemy relative danger may be hinted by restrained name color/text treatment.
- Elite/rare classification is not proactively exposed by default; unexpectedly discovering that an enemy is formidable is an intended experience.
- Allies and pets use the same restrained information philosophy, with role/accessibility exceptions to be designed deliberately.
- Action buttons are organized as square/rectangular clusters, not primarily as a long horizontal row.
- Primary actions remain legible; secondary/tertiary and utility clusters are contextually faded/revealed.
- Immersion mode is an orchestrated project state, not merely "hide chat."
- The compass is part of immersion/world presentation and should automatically disappear in instances. Heading and manual-waypoint production visuals are proven; quest/POI/tracking roles remain capability-gated.
- PvP flagging modifies immersion toward greater situational usefulness rather than simply turning immersion off.
- Questing, XP presentation, camera behavior, social silence, and later navigation should share one visual/state language.
- D-039 is the approved twelve-sheet World Ghost / Selective Hybrid E visual baseline.
- D-040 makes `Logres/Media/` plus `Logres/Media/Theme.lua` the production asset/token boundary for approved visual translation.
- Active Quest is an optional one-focus presentation, not a permanent multi-quest tracker; exact mechanical counts belong behind deliberate inspection/hover in the approved baseline.
- P0126 makes that Active Quest baseline production-proven at `89b0c563` / `0.0.58-dev`: count-free objective labels remain visible, progress is bar-only, exact counts stay hover-only, and Blizzard quest-management surfaces remain available.
- D-035 defines NPC quest interaction as a future Logres-owned experience only after per-surface information/control capability is proven; fail open to Blizzard until then.
- P0129 makes the observed NPC quest-offer read path runtime-proven at `e50676b9` / `0.0.59-dev`: real offer title/body/objective, stable available-gossip quest ID/title, and one two-choice reward metadata sample were ordinary/non-secret with zero call failures; all quest/gossip mutation function groups were present but `invoked=0`. `QUEST_PROGRESS` / `QUEST_COMPLETE` and other unobserved categories remain deferred.
- P0130 makes the bounded/paged NPC quest-offer narrative production-proven on `0.0.61-dev`: full source prose is paged, objective text is wrapped, Blizzard controls remain available, and the active narrative restores across Immersion OFF -> ON. The initial `0.0.60-dev` restore failure remains preserved as evidence.

## Development facts

- Canonical host/development environment: Windows 11 with WSL.
- Source repository lives in the WSL Linux filesystem.
- User performs all commits and pushes.
- Failures/rejections/rollbacks are durable knowledge and must be recorded.
- The current DynamicCam `RPG` profile was captured in G.1 on 2026-10-02; exact camera values must come from `docs/memory/evidence/G1_DYNAMICCAM_PROFILE_CAPTURE_2026-10-02.md` and its canonical JSON, not conversational memory. Request a fresh export again only if the profile changes or later evidence conflicts.

## Open technical facts

WoW Forever API feasibility is not considered settled until the relevant capability work records it.

In particular, do not assume unrestricted availability of:
- health/power data during combat;
- target classification;
- cast information;
- unit auras;
- map position;
- quest position/objective bearings;
- chat automation;
- secure action mutations during combat;
- camera changes in every context.

Record source findings and runtime behavior separately.

- P0131 proves quest-offer Accept / Decline mutation capability on Forever: Decline passed on `0.0.62-dev`; Accept passed on corrected `0.0.63-dev` after preserving correlation across intermediate `QUEST_FINISHED` until matched `QUEST_ACCEPTED`. Capability proof does not authorize Blizzard control suppression; production Logres controls must be proven first.
