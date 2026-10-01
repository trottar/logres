# P0020 — Close B.1 and open B.2

Date: 2026-10-01
Result: PREPARED — not durable until user commits/pushes

## Trigger

P0019 runtime proof passed.

The user confirmed:
- visible health-vignette progression;
- immersion off hides it;
- immersion on restores it;
- healing recedes/removes it.

## B.1 result

**COMPLETE**

Production-proven:
- real HUD module;
- secret-safe health curve transport;
- preference integration;
- health event refresh;
- usable injury progression.

Remaining rough rectangular geometry is visual-polish debt.

## B.2

Opened:
**Resource Presentation**

Default direction:
- compact player resource percentage;
- no conventional bar;
- secret-safe `UnitPowerPercent` formatting;
- HUD-owned presentation;
- immersion preference integration.

## Code changes

None.

## Deployment

No redeploy required.

## Validation

```text
python3 tools/check_memory_health.py
python3 tools/check_addon_structure.py
python3 tools/check_state_contract.py
python3 tools/check_preference_contract.py
python3 tools/check_module_contract.py
python3 tools/check_hud_contract.py
git diff --check
```
