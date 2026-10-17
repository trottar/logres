# P0227 — QuestieDB dependency and distribution checkpoint

Date 2026-10-16. **Docs-only candidate; no runtime implementation and no new POI PASS.**

## Remote and live source

GitHub `main` was verified at commit `45bbd0ea818f612e621636cd0e6bfce93dd4092d`, message `P0226: validate optional QuestieDB Forever location source` (includes P0225). User reports "pushed. No new compass items" with diagnostics from 0.0.134-dev. The latest `questiedbprobe` is DEFERRED `provider=not-installed`, `contract=not-checked`, `gossip=not-observed`, `positive=deferred`, and `negative=accepted-quest-excluded`. The P0226 module is a read-only probe and never feeds compass; no additional glyph was expected. P0225's newly probed native feeds had ordinary-empty results in the prior sample. Treat absent provider as environmental DEFERRED, not P0226 feature PASS or failure of the untested DB algorithm.

## P0227 original-archive failure and R1 repair

The user's first P0227 applier run stopped before tracked writes at the full shadow checker stage. `tools/check_memory_health.py` correctly reported `CURRENT heading '## Do Not Reopen Without New Evidence' occurs 0 times; expected exactly 1`, because the new `CURRENT.md` payload dropped an invariant heading. The reported worktree had only three pre-existing untracked preview PNGs. This is a **patch preparation/static-contract failure**, not a QuestieDB runtime failure. P0227 R1 restores the required heading and relevant prohibitions without modifying the checker or any Lua source. Targeted archive checks pass; the full repository shadow-check suite still runs in the user-side guarded applier and must pass before any commit. The rejected initial package is superseded; it is not an applied checkpoint.

## External download and name ambiguity

Official `Questie/QuestieDB` release v1.0.6, published 2026-10-12, provides `QuestieDB-Forever.zip`, 13,514,513 bytes, GitHub release asset sha256 `d78b066c362eaf28258d9e2d041c0a7b03d6943a2dfc741dec70c6bfd8e1fc27`. Its README and release notes state the archive contains an `QuestieDB/` folder and `QuestieDB_Forever.toc`, and that QuestieDB does not draw markers on its own. Release URLs: `https://github.com/Questie/QuestieDB/releases/tag/v1.0.6`, `https://github.com/Questie/QuestieDB/releases/download/v1.0.6/QuestieDB-Forever.zip`. Manual WSL installation, integrity check, backup, load/enabling and runtime probe are documented in `docs/DEPENDENCIES.md`.

CurseForge search exposed `LibQuestDB` (`https://www.curseforge.com/wow/addons/questdb`), a distinct library, **not the requested QuestieDB**; it cannot be declared as this provider's automated dependency. No verified QuestieDB-specific CurseForge project ID was found. QuestieDB upstream's inspected recursive tree exposes no root `LICENSE`/`COPYING`; redistribution/bundling rights are UNVERIFIED, and tracked policy forbids bundling absent proof. Avoid asserting this means the project has no license of any kind; it is a due-diligence gap.

## Accepted policy and next test

Logres currently has **optional** QuestieDB integration, no TOC hard dependency, and no live DB-provided compass markers. A future database-backed marker feature would require installed compatible QuestieDB while native waypoints/focused accepted quests must still work without it. Native API positive results take precedence, QuestieDB historical spawns cannot establish current quest eligibility, and Blizzard minimap stays available for hidden/new content. First, install upstream Forever ZIP, verify loaded/contract/flavor, capture a real quest offer on the audited map and check the bounded positive and negative probes before further map integration. Runtime remains DEFERRED until observed.
