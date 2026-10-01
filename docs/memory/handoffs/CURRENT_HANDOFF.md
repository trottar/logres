# Current Handoff

Authoritative state: `../CURRENT.md`. Start there.

Current work:
**A.3 — User-Controlled State**

P0012 is prepared.

New persisted preference:
`immersionEnabled = true`

Preferences are deliberately separate from observed game state.

New development commands:
- `/logres preferencecheck`
- `/logres immersion [on|off|toggle]`

Runtime proof:
1. preferencecheck;
2. set off;
3. reload and confirm off;
4. set on;
5. reload and confirm on.

No travel required.

User performs all commits/pushes.
