# Logres

**Project Logres** is an immersive, world-first interface addon for World of Warcraft Forever.

The project has completed **Phase 0 — Foundation** and is now in **Phase A — Core State Engine**. The real addon runtime exists, but product HUD features are intentionally not implemented yet.

Design decisions, technical findings, failures, rejected approaches, evidence, and active development state are maintained as repository-native durable memory under `docs/memory/`.

## Development environment

Canonical development uses Windows 11 + WSL, with the repository stored in the WSL Linux filesystem.

Static checks:

```bash
python3 tools/check_memory_health.py
python3 tools/check_addon_structure.py
python3 tools/check_state_contract.py
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
```

The Phase 0.3 skeleton currently provides lifecycle, SavedVariables, and basic state observation only.
