# Current Handoff

Authoritative state:
`../CURRENT.md`.

Phase F:
**COMPLETE.**

Phase G:
**ACTIVE — G.2.**

P0093 is verified pushed at:
`de30c6f3`.

Current runtime remains:
`0.0.38-dev`.

G.1:
**CLOSED — PASS.**

Fresh current DynamicCam files were supplied and parsed.

Key facts:
- `DynamicCam.lua` and `.bak` are semantically identical;
- exact `RPG` profile preserved as canonical JSON;
- RPG has nine enabled contexts;
- no explicit enabled instance situation;
- World = zoom in by 5, enter 2.5, exit 0;
- World (Combat) = zoom out by 15, enter 2.5, exit 0.

Active work:
**G.2 — World/Combat camera zoom capability.**

Next:
source-audit DynamicCam's current timed zoom implementation and the relevant
Forever camera APIs/CVars before any production mutation.

G.2 scope excludes rotation, UI hiding, shoulder offset, taxi, teleport,
fishing, gathering, City, AFK, and global camera-CVar ownership.

P0094 is docs/evidence-only.
No WoW redeploy required.

User performs all commits/pushes.
