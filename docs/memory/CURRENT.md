---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase B — Core HUD.**

## Current Work Item

**B.3 — Target Presentation.**

P0023 prepares sparse current-target presentation:

```text
Target Name
Health %
```

No numeric level, classification, portrait, or target health bar is introduced.

## Verified State

- Phase A complete.
- B.1 health vignette complete.
- B.2 primary resource percentage complete.
- P0022 B.2 closure pushed at `f89f43f`.
- current runtime baseline before P0023: `0.0.9-dev`.
- `UnitName("target")` is available on Forever and may become secret under identity restrictions.
- `FontString:SetText` accepts secret text arguments.
- target health percentage can reuse the native 0–100 secret-safe percentage curve.
- `UnitExists("target")` provides ordinary show/hide control.
- target resource is deliberately deferred from the initial B.3 patch.

## Next Action

Install/review/commit/push P0023.

Because runtime code changes, deploy explicitly:

```bash
WOW_ROOT="/mnt/c/Program Files (x86)/World of Warcraft"
ADDONS="$WOW_ROOT/_classic_beta_/Interface/AddOns"

./tools/deploy_logres.sh "$ADDONS"
```

Then:

```text
/reload
/logres status
/logres statecheck
/logres preferencecheck
/logres lifecyclecheck
/logres hudcheck
```

Confirm version:
`0.0.10-dev`

B.3 runtime proof:
1. no target -> target block absent;
2. acquire target -> name + health % appear;
3. damage an ordinary target -> health % updates;
4. switch targets -> text updates;
5. clear target -> block disappears;
6. immersion off/on -> hide/restore current target;
7. during ordinary combat, confirm target name/health remain functional with no secret-value errors;
8. if an elite target is naturally available, confirm no numeric level/classification is shown.

No dungeon travel is required solely for B.3.

## Success Criteria

B.3 succeeds when:
- sparse target name + health percentage render;
- target acquisition/change/loss update correctly;
- health percentage updates;
- ordinary combat does not produce secret/Lua errors;
- immersion hide/restore works;
- no level/classification/portrait/bar is exposed;
- target resource remains optional/deferred unless new evidence justifies it.

## Do Not Reopen Without New Evidence

- **B.1:** complete.
- **B.2:** complete.
- **Target disclosure:** D-003 + D-013.
- **Target identity:** may be secret; direct native text forwarding only.
- **Target health:** native curve + SetFormattedText only.
- **Target resource:** deferred from initial B.3.
- **Actions:** Phase C.
- **Deployment:** full deploy block required.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/decisions/D-013_TARGET_PRESENTATION_CONTRACT.md`
- `docs/memory/investigations/B3_TARGET_PRESENTATION.md`
- `docs/memory/decisions/D-003_ENEMY_INFORMATION_DISCLOSURE.md`
- `docs/memory/decisions/D-008_SECRET_SAFE_HEALTH_AND_RESOURCE_PATH.md`
- `docs/memory/architecture/HUD.md`
- `Logres/HUD/HUD.lua`
- `tools/check_hud_contract.py`
