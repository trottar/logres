# Current Handoff

Authoritative state: `../CURRENT.md`. Start there.

Current work:
**A.4 — Module Lifecycle Contract**

A.3 is complete.

Verified:
- separate preference contract;
- `immersionEnabled` persistence;
- schema 2 runtime path.

Important workflow rule:
**Every patch that changes runtime addon code must include the full deploy block before in-game validation commands.**

Do not say only "redeploy as usual."

Next work should design a lightweight module lifecycle before implementing it.

User performs all commits/pushes.
