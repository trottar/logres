# Current Handoff

Authoritative state: `../CURRENT.md`. Start there.

Current phase:
**Phase A — Core State Engine**

A.2 is complete.

Runtime verified:
- resting true/false;
- taxi transition;
- interaction transition.

Mounted=true remains deferred because the current beta/character environment cannot produce a mount test. This is not a failure.

Current work:
**A.3 — User-Controlled State**

First target:
`immersionEnabled`

The next patch should define a clean persisted-preference contract without conflating user choice with observed game state.

No settings UI is required yet.

User performs all commits/pushes.
