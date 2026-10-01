---
memory_schema: 1
as_of: 2026-09-30
project: logres
---

# Current State

## Active Objective

**Phase B — Core HUD.**

## Current Work Item

**B.1 — HUD root + player health vignette.**

P0018 is pushed at `fa342ad`.

Its first runtime visual did not satisfy B.1:
- no perceptible vignette during ordinary injury;
- a red pulse appeared only at very low health;
- that pulse may be Blizzard's own low-health effect.

The secret-safe transport is not yet considered failed because P0018 used the already-proven native path and no transport error was reported.

Current API/curve evidence confirms P0018's 0–1 curve x scale was correct.

P0019 prepares stronger visual tuning plus a full-health preview command to isolate Logres geometry from health input.

## Verified State

- Phase A complete.
- production HUD module exists.
- P0018 static HUD contract passed.
- P0018 visual progression did not pass user observation.
- normalized curve x scale 0–1 is confirmed.
- B.1 remains active.

## Next Action

Install/review/commit/push P0019.

Deploy explicitly, confirm version `0.0.8-dev`, then at full health:

```text
/logres hudpreview on
```

Confirm a clear static Logres edge treatment appears.

Then:

```text
/logres hudpreview off
```

Confirm it disappears.

Next take ordinary safe damage and determine whether the health-driven vignette becomes visible before low-health emergency state.

While injured:
- immersion off must hide it;
- immersion on must restore it;
- healing must reduce/remove it.

Do not intentionally reach near death.

## Success Criteria

B.1 succeeds only when:
- preview proves HUD geometry is visibly present;
- health-driven vignette becomes perceptible during ordinary injury;
- healthy state remains unobtrusive;
- damage/healing progression behaves;
- immersion off/on behaves;
- no secret-value/Lua errors occur;
- visual tuning is usable enough to proceed.

## Do Not Reopen Without New Evidence

- **Curve input scale:** normalized 0–1.
- **P0018:** visual failure, not silently reclassified as success.
- **Health transport:** D-008 remains authoritative until production evidence disproves it.
- **No near-death requirement:** preview exists to avoid risky testing.
- **Deployment:** full deploy block required.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/B1_HEALTH_VIGNETTE_RUNTIME_PASS01_2026-09-30.md`
- `docs/memory/investigations/B1_HEALTH_VIGNETTE.md`
- `docs/memory/decisions/D-008_SECRET_SAFE_HEALTH_AND_RESOURCE_PATH.md`
- `docs/memory/architecture/HUD.md`
- `Logres/HUD/HUD.lua`
