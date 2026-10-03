# P0106 — Quest Interaction Ownership

Date: 2026-10-03
Type: DOCS-ONLY
Baseline: 6956008033b3f86c5b70d68c50486a4bed0ecdf1

## Purpose

Correct the long-term quest product boundary.

Phase F deliberately left quest interaction controls Blizzard-owned while Logres
proved passive quest presentation safely. That remains valid historical/runtime
evidence, but it is not the intended final product boundary.

D-035 establishes quests as a core Logres-owned experience.

The intended endpoint includes:
- paged NPC quest text;
- Accept / Decline;
- Continue / Complete;
- reward presentation and selection;
- required quest-related gossip transitions;
- eligibility/error feedback.

These controls remain player-driven. Logres must not auto-accept quests,
auto-complete quests, or auto-select rewards.

Blizzard quest interaction remains available as the fail-open fallback until
each corresponding Logres replacement is capability-proven.

Quest-log management, watch/super-track mutation, Objective Tracker ownership,
and unrelated gossip remain separately gated.

## Visual direction

The approved NPC quest-dialogue study establishes:
- short text in one bounded narrative block;
- longer text using discrete pages;
- long objective/action text wrapping to additional lines;
- authored Logres quest interaction controls to be designed separately.

## Runtime

No Lua/runtime behavior changes in this checkpoint.

No WoW redeploy required.
