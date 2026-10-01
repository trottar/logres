# P0005 — Minimal addon skeleton

Date: 2026-09-30  
Result: PREPARED — runtime proof pending

## Intent

Create the smallest coherent real Logres addon after completing the Forever API capability audit.

## Adds

### Addon runtime
- `Logres/Logres.toc`;
- `Core/Bootstrap.lua`;
- `Core/Database.lua`;
- `Core/State.lua`;
- `Core/Commands.lua`;
- `Core/Lifecycle.lua`.

### Tooling
- `tools/deploy_logres.sh`;
- `tools/check_addon_structure.py`.

### Memory
- runtime system/state architecture;
- Phase 0.3 current state/roadmap/handoff.

## Invariants

- no product HUD yet;
- no health vignette yet;
- no target frame yet;
- no compass yet;
- no action clusters yet;
- no Quiet Mode yet;
- no camera mutation yet;
- no secret combat values persisted;
- no character/target identifiers persisted.

## State model

Phase 0.3 observes:
- world vs instance;
- combat lockdown;
- PvP flag;
- instance type.

State changes publish through the internal callback bus.

## Combat timing

The implementation incorporates I-001's negative timing result:
`PLAYER_REGEN_DISABLED` is not treated as a guarantee that all restriction state has already settled.

The state module refreshes from multiple transition signals, including restriction-state changes.

## SavedVariables proof design

`LogresDB.meta.loadCount` increments each addon initialization.

Runtime proof should show:
- first observed load count;
- `/reload`;
- increased load count.

This is lifecycle evidence, not telemetry.

## Static validation

Required before commit:

```text
python3 tools/check_memory_health.py
python3 tools/check_addon_structure.py
git diff --check
```

## Runtime validation

Required after deploy:
- clean load;
- `/logres status`;
- reload persistence;
- combat state transition;
- instance transition if convenient.

## Negative results

No runtime claim is made by this patch.

Any first-load or state failure must be recorded before modification.
