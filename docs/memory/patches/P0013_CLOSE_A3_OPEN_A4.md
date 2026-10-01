# P0013 — Close A.3 and open A.4

Date: 2026-09-30  
Result: PREPARED — not durable until user commits/pushes

## Intent

Record A.3 runtime proof, preserve the deployment false-start as a workflow lesson, close user-controlled state, and open module lifecycle work.

## Runtime result

After correct deployment of P0012:
- preference contract behavior looked correct;
- no Lua issue was reported;
- immersion off persisted across reload;
- immersion on persisted after restoration;
- schema 2 loaded/migrated without reported issue;
- observed state remained intact.

A.3:
**COMPLETE**

A.4:
**ACTIVE**

## Negative/workflow result

Before redeployment, the new slash commands printed the old help list.

Cause:
WoW was still running the prior deployed addon version.

Classification:
**DEPLOYMENT OMISSION — NOT PRODUCT FAILURE**

## Durable process change

Future runtime-code patch instructions must always repeat:

```bash
WOW_ROOT="/mnt/c/Program Files (x86)/World of Warcraft"
ADDONS="$WOW_ROOT/_classic_beta_/Interface/AddOns"

./tools/deploy_logres.sh "$ADDONS"
```

followed by `/reload` before in-game validation.

## Code changes

None.

This is an evidence/process/phase-transition checkpoint.

## Validation

```text
python3 tools/check_memory_health.py
python3 tools/check_addon_structure.py
python3 tools/check_state_contract.py
python3 tools/check_preference_contract.py
git diff --check
```
