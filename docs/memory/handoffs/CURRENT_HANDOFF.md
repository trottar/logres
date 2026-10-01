# Current Handoff

Authoritative state: `../CURRENT.md`.

P0061 is verified pushed at `01665d1`.

D.5 is complete.

Current work:
**D.6 — Restoration / integration validation**

P0062 source/design review is prepared.

Resolved runtime direction:
- no new suppression policy;
- one integrated Restoration Check;
- out-of-combat reversible preference cycle;
- out-of-combat ImmersionController disable/re-enable recovery cycle;
- in-combat check is non-mutating and accepts legal protected pending state;
- addon-owned recovery state only;
- add explicit Player secure-interaction ownership state;
- Context Policy Check remains the context/PvP/instance proof surface;
- reload persistence remains a real `/reload` proof step.

After P0062 is pushed and verified, implement P0063 targeting `0.0.27-dev`.

P0062 is documentation-only; no WoW redeploy required.

User performs all commits/pushes.
