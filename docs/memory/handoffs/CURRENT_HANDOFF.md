# Current Handoff

Authoritative state: `../CURRENT.md`.

P0089 runtime implementation is verified pushed at `1781c038`.

Current pushed runtime:
`0.0.35-dev`.

P0090 runtime target:
`0.0.36-dev`.

Active work:
**F.6 — Contextual objective progress pulse.**

P0089 runtime evidence:
- live quest 237 objective source refreshed correctly;
- Skullthumper `3/10 -> 4/10`;
- Seer remained `3/10`;
- QUEST_LOG_UPDATE `85 -> 86`;
- QUEST_WATCH_UPDATE `6 -> 7`;
- stale-source concern is closed PASS.

Production pulse:
**UNPROVEN for that natural change.**
No post-change Objective Progress Check was captured before reload.

Preview:
**REGRESSION CONFIRMED.**
P0089 intentionally changed Preview to an explicit synthetic generic sample.
The prior quest-looking sample was also synthetic and must not be restored as
fake live data.

P0090:
- Preview reads current active objective rows safely;
- maximum two rows, matching production presentation;
- synthetic sample is fallback only when current rows are unavailable;
- Preview does not mutate baseline;
- production change detection/events remain unchanged.

Next proof after push:
live Preview -> natural objective change -> automatic pulse ->
Objective Progress Check -> Quest Probe.

User performs all commits/pushes.
