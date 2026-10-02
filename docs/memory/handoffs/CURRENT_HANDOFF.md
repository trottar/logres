# Current Handoff

Authoritative state: `../CURRENT.md`.

P0079 is verified pushed at `1aad7bad`.

Phase F / F.2 is complete.

F.2 result:
- contextual XP data/event path proven;
- quest-detail passive reads proven;
- populated objective rows unproven;
- quest destination for tested quest 436 unavailable;
- quest compass marker remains deferred.

P0078 Restoration Check failure:
**OPEN — INTERMITTENT / UNREPRODUCED.**

P0079 targeted validation:
- standalone Restoration Check PASS;
- Run All PASS including Restoration Check.

No restoration behavior change is justified.

Active work:
**F.3 — Contextual XP pulse implementation.**

P0080 adds an additive event-driven XP pulse plus:
- XP Check;
- XP Preview.

No stock XP UI suppression.

Runtime target:
`0.0.31-dev`.

User performs all commits/pushes.
