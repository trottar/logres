# Current Handoff

Authoritative state: `../CURRENT.md`.

P0078 is verified pushed at `8b38fe64`.

Phase F / F.2 remains active.

F.2 capability results:
- contextual XP inputs/events proven;
- quest-detail passive reads proven;
- populated objective rows unproven;
- quest destination for quest 436 unavailable again.

Blocker:
P0078 Run All hit a real Restoration Check failure at the opposite-preference
settle stage.

Cleanup succeeded and final state reconverged.

P0079 adds failure-detail diagnostics only.
No suppression/recovery behavior is changed.

After P0079:
developer panel -> Restoration Check once -> Run All once -> `/reload` -> export
`LOGRES_DIAGNOSTICS_LATEST.lua`.

Production runtime remains:
`0.0.30-dev`.

User performs all commits/pushes.
