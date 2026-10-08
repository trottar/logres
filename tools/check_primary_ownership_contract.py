#!/usr/bin/env python3
"""P0173: primary diagnostic remains read-only and does not suppress Main."""
from pathlib import Path
import sys

root = Path(__file__).resolve().parents[1]
primary = root / "Logres/Actions/Primary.lua"
commands = root / "Logres/Core/Commands.lua"
controller = root / "Logres/Immersion/Controller.lua"
errors = []
for path in (primary, commands, controller):
    if not path.is_file():
        errors.append("missing: " + str(path.relative_to(root)))
if primary.is_file():
    text = primary.read_text(encoding="utf-8")
    section = text.split("function Primary:GetStockOwnershipGate()", 1)
    if len(section) != 2:
        errors.append("missing primary gate function")
    else:
        gate = section[1]
        for token in (
            '"IsPossessBarVisible"', '"HasVehicleActionBar"',
            '"HasOverrideActionBar"', '"HasTempShapeshiftActionBar"',
            '"HasExtraActionBar"', 'issecretvalue(value)',
            'local stock = _G.MainActionBar',
            'result.sourcePresent',
        ):
            # `result.sourcePresent` is in the command check, not the gate.
            if token != 'result.sourcePresent' and token not in text:
                errors.append("missing primary token: " + token)
        for forbidden in ('MainActionBar:Hide(', 'MainActionBar:SetAlpha(',
                          'RegisterStateDriver(', 'SetBinding(',
                          'SaveBindings(', 'C_Timer.', 'OnUpdate'):
            if forbidden in gate:
                errors.append("forbidden primary mutation: " + forbidden)
        if 'stockSuppressionAuthorized = false' not in gate:
            errors.append("gate must not authorize stock hiding")
if commands.is_file():
    text = commands.read_text(encoding="utf-8")
    for token in ('local function runPrimaryOwnershipCheck()',
                  'primary:GetStockOwnershipGate()',
                  'runPrimaryOwnershipCheck()',
                  'if command == "primaryownershipcheck" then',
                  'suppressAuthorized=false stockPreserved=true'):
        if token not in text:
            errors.append("missing diagnostic: " + token)
if controller.is_file():
    text = controller.read_text(encoding="utf-8")
    if 'primaryActionRoutingOwned = false' not in text:
        errors.append("controller must retain primary ownership gate")
print("Logres P0173 primary ownership contract")
print("=====================================")
for err in errors:
    print("ERROR:", err)
print("PASS: 0 errors" if not errors else f"FAIL: {len(errors)} errors")
sys.exit(bool(errors))
