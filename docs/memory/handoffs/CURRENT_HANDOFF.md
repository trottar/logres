# Current Handoff

Authoritative state: `../CURRENT.md`. Start there.

**Phase 0 — Foundation is complete.**

The real P0005 addon passed its minimal runtime proof:
- clean load in tested scope;
- `/logres status`;
- SavedVariables/loadCount persistence across `/reload`;
- correct combined instance + combat state;
- correct return to ordinary world/non-combat state.

A separate out-of-instance combat retest was intentionally omitted because the underlying combat APIs were already verified in I-001 and duplicate travel was not justified.

Current phase:

**Phase A — Core State Engine**

Current work item:

**A.1 — State contract hardening**

Next patch should harden consumer-facing state access/callback semantics before adding more sensors or any HUD.

User performs all commits/pushes.
