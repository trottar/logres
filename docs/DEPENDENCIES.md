# External data and dependency policy

Logres is a World of Warcraft Forever addon. The current addon **does not have a mandatory QuestieDB dependency**: Logres loads and its native waypoint and focused accepted-quest compass paths work without it. P0226 includes an optional, read-only `QuestieDBLocationProbe` that reports `DEFERRED` when QuestieDB is absent. Database-backed compass markers are *planned*, not implemented or runtime-validated. Do not advertise P0226 as providing additional quest or service icons.

## Identifying the correct project

- **Provider:** [`Questie/QuestieDB`](https://github.com/Questie/QuestieDB) (standalone data addon), not the full Questie quest helper.
- **Pinned tested-target package:** [`QuestieDB-Forever.zip` from v1.0.6](https://github.com/Questie/QuestieDB/releases/download/v1.0.6/QuestieDB-Forever.zip), published October 12, 2026; the actual Logres + WoW Forever compatibility test is still pending.
- **SHA-256 for that package**, from the GitHub release asset digest:

  `d78b066c362eaf28258d9e2d041c0a7b03d6943a2dfc741dec70c6bfd8e1fc27`

- **Do not substitute** CurseForge's [`LibQuestDB`](https://www.curseforge.com/wow/addons/questdb): it is a *different* project with a different API and directory name.

## Manual installation and update (WSL / Windows WoW)

Close World of Warcraft before installing or updating. In WSL, set `ADDONS` to **your own** Forever `Interface/AddOns` directory; do not put a machine-specific path in the tracked repository. The commands download, verify, inspect, and install the official upstream ZIP while backing up an existing `QuestieDB` directory outside AddOns.

```bash
ADDONS="/path/to/World of Warcraft/_classic_beta_/Interface/AddOns"

(
  set -e
  TMPDIR_QDB="$(mktemp -d)"
  trap 'rm -rf "$TMPDIR_QDB"' EXIT
  mkdir -p "$ADDONS"

  curl -fL --retry 3 \
    -o "$TMPDIR_QDB/QuestieDB-Forever.zip" \
    "https://github.com/Questie/QuestieDB/releases/download/v1.0.6/QuestieDB-Forever.zip"
  echo "d78b066c362eaf28258d9e2d041c0a7b03d6943a2dfc741dec70c6bfd8e1fc27  $TMPDIR_QDB/QuestieDB-Forever.zip" \
    | sha256sum -c -
  unzip -q "$TMPDIR_QDB/QuestieDB-Forever.zip" -d "$TMPDIR_QDB/extracted"
  test -f "$TMPDIR_QDB/extracted/QuestieDB/QuestieDB_Forever.toc"

  if [ -d "$ADDONS/QuestieDB" ]; then
    BACKUP="$HOME/QuestieDB-backup-$(date +%Y%m%d-%H%M%S)"
    mv "$ADDONS/QuestieDB" "$BACKUP"
    echo "Previous QuestieDB backup: $BACKUP"
  fi

  cp -a "$TMPDIR_QDB/extracted/QuestieDB" "$ADDONS/QuestieDB"
  test -f "$ADDONS/QuestieDB/QuestieDB_Forever.toc"
  echo "QuestieDB Forever v1.0.6 installed"
)
```

Expected on disk: `<your Forever AddOns>/QuestieDB/QuestieDB_Forever.toc`. Enable **QuestieDB** in the character selection addon list and restart WoW. The data addon alone does not draw pins or add Logres glyphs. For P0226, open a real nearby available-quest gossip on a supported map and run `/logres questiedbprobe` (Phase E **QuestieDB Location Probe**); capture diagnostics. `provider=not-installed` means the separate addon is not loaded. Lack of a natural matching quest offer is DEFERRED, not a passing source test.

**Updates:** A new game patch may require a newer QuestieDB release. Review [upstream releases](https://github.com/Questie/QuestieDB/releases), compatibility notes and released ZIP checksums. Do not keep the v1.0.6 checksum for a different ZIP; update the documented release URL and hash together after validation. The game does not automatically update a GitHub-only manually installed addon. Keep a rollback backup and retest compass source compatibility after any change.

## Production compass policy

Priority: native Blizzard live positions when genuinely exposed, then QuestieDB historical spawn candidates where compatible, with map/phase/eligibility checks and bounded indexing. A QuestieDB quest-start coordinate **does not prove current character eligibility**. Hidden, recently patched, phased and server-specific quests may be absent from the data or differently visible in the client. Missing QuestieDB data must not be reported as a nonexistent quest. Stock Blizzard minimap access remains available; never scrape native protected/secret UI positions.

## Future CurseForge or public distribution

1. **Current classification:** optional integration for Logres as a whole, *not* a hard dependency in the Logres TOC or a guaranteed CurseForge-resolved package. If future features require QuestieDB, document those feature-specific requirements and fail-open behavior; only change to a hard dependency after a separate design decision and compatibility proof.
2. **Exact package identification:** the dependency is `Questie/QuestieDB` with folder name `QuestieDB`, not `LibQuestDB`/`QuestDB`. At this checkpoint no verified CurseForge package ID exists for the exact QuestieDB provider. Do not insert a guessed CurseForge `required-dependencies` slug/project ID or claim the CurseForge app will install it.
3. **Packaging:** distribute the Logres addon separately; prominently link the official QuestieDB GitHub release and installation steps. Do **not** silently bundle QuestieDB in Logres releases. The inspected upstream QuestieDB repository tree has no top-level LICENSE/COPYING file, so redistribution rights have not been established here; obtain explicit permission or a confirmed compatible license first. Revisit if the upstream publishes verified redistribution terms or a matching CurseForge entry.
4. **Documentation and QA:** maintain a supported-provider version table, install/update/rollback steps, missing-provider state, source limitations, and a real positive/negative runtime acceptance test on the intended Forever client. Dependency availability alone does not prove the compass gains POIs.

This file is a dependency policy and install guide, not a claim that unaccepted-quest or service POIs currently work.
