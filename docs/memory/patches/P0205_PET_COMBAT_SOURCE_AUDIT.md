# P0205 — Forever 70338 secure PetActionBar ownership source audit

Baseline: verified Logres `main` `566bb8b569b1fd53f869ac051ab62cbd9fa380a2` (P0204). **DOCS ONLY**. Runtime remains `0.0.109-dev`, and no WoW deployment is necessary.

Authoritative analysis: `docs/memory/evidence/P0205_FOREVER_PET_COMBAT_SOURCE_AUDIT.md`. Exact source: `Gethe/wow-ui-source@943764493e6b16d63ded3ab304150d1f05e58b57` (Forever 1.60.1.70338). Static source confirms Blizzard's event-driven PetActionBar Show, protected/interactive Edit Mode root, and the secure visibility state-driver mechanism. A direct protected `Hide()` in combat is rejected. Both a Logres-owned hidden ancestor and reciprocal secure combat ownership handoff remain unproven with respect to native Edit Mode, fallback, and secure pet controls; neither is enabled in P0205. P0197 post-combat recovery PASS remains bounded, in-combat duplicate FAIL remains OPEN/REPRODUCED.

**Next:** prepare one reversible **default-OFF** runtime candidate to test supported ownership/fallback behavior out-of-combat setup and in-combat transition, with addon-owned diagnostic state and a narrow checker. Do not declare runtime correctness from this audit. Existing P0203/P0204 negative observations remain authoritative.
