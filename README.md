# Logres

**Project Logres** is an immersive, world-first interface addon for World of Warcraft Forever.

Logres is under active Phase H integration and polish development. Working HUD and navigation components exist, but third-party navigation data and broad POI completeness remain experimental, and no public release is approved yet.

Design decisions, technical findings, failures, rejected approaches, evidence, and active development state are maintained as repository-native durable memory under `docs/memory/`.

## External data and installation

QuestieDB (`Questie/QuestieDB`) is an **optional** external navigation-data integration. Logres works without it, but when a compatible standalone QuestieDB is installed, Logres can use some historical nearby NPC/service coordinates in its compass. These database locations are *possible* sites, not evidence of current quest availability: P0337 requires corroborating current native quest-offer data before presenting a possible quest giver. Native/Blizzard map access remains available, and map/POI coverage is incomplete. See [`docs/DEPENDENCIES.md`](docs/DEPENDENCIES.md) for the verified-target Forever download, SHA-256, installation/update steps, optional-provider fallback, and redistribution restrictions. Do not substitute the separate `LibQuestDB` addon.

**Internal alpha QA only:** `python3 tools/alpha_prefreeze_audit.py` runs a read-only source and internal staging inventory audit; `python3 tools/stage_alpha_candidate.py --check` runs the existing read-only staging preflight. Both are **INTERNAL** checks, not client installation acceptance. Public redistribution is **not approved** while project-root licensing (L-019), real-client safety and release gates remain unresolved.

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
