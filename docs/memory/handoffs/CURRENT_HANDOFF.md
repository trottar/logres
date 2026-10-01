# Current Handoff

Authoritative state: `../CURRENT.md`. Start there.

Current phase:
**Phase B — Core HUD**

Current work:
**B.1 — HUD root + player health vignette**

P0018 is prepared.

New runtime:
- `Logres/HUD/HUD.lua`
- HUD lifecycle module
- four native health curves
- 16 edge textures
- `/logres hudcheck`

Important:
P0018 changes runtime addon code, so deploy explicitly before testing.

Runtime proof should use ordinary safe damage and healing only. Do not require a near-death test.

User performs all commits/pushes.
