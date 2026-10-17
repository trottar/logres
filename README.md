# Logres

**Project Logres** is an immersive, world-first interface addon for World of Warcraft Forever.

Logres is under active Phase H integration and polish development. Working HUD and navigation components exist, but third-party navigation data and broad POI completeness remain experimental, and no public release is approved yet.

Design decisions, technical findings, failures, rejected approaches, evidence, and active development state are maintained as repository-native durable memory under `docs/memory/`.

## External data and installation

QuestieDB (`Questie/QuestieDB`) is currently an **optional** external navigation-data integration: Logres continues to work without it, but proposed future database-backed quest-giver or service-location markers would need a separately installed compatible QuestieDB. The existing P0226 integration is only a diagnostic and **does not yet add database compass icons**. See [`docs/DEPENDENCIES.md`](docs/DEPENDENCIES.md) for the correct Forever download, checksum, installation/update steps, missing-provider fallback, and CurseForge redistribution policy. Do not substitute the distinct `LibQuestDB` addon.

## Development environment

Canonical development uses Windows 11 + WSL, with the repository stored in the WSL Linux filesystem.

Static checks:

```bash
python3 tools/check_memory_health.py
python3 tools/check_addon_structure.py
python3 tools/check_state_contract.py
python3 tools/check_preference_contract.py
python3 tools/check_module_contract.py
python3 tools/check_hud_contract.py
```

Deploy the development addon to a Forever AddOns directory:

```bash
./tools/deploy_logres.sh "/mnt/c/.../_classic_beta_/Interface/AddOns"
```

Then in game:

```text
/reload
/logres status
/logres statecheck
/logres sensorcheck
/logres preferencecheck
/logres lifecyclecheck
/logres hudcheck
/logres hudpreview on
/logres hudpreview off
/logres immersion
```

For the current project checkpoint, consult `docs/memory/CURRENT.md`; historical diagnostics above are examples, not a complete list of current development commands.
