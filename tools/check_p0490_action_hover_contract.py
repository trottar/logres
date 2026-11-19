#!/usr/bin/env python3
"""P0490 primary resting alpha and per-cluster hover without secure mutation."""
from pathlib import Path
import re
import shutil
import subprocess

R = Path(__file__).resolve().parents[1]
c = (R / 'Logres/Actions/Context.lua').read_text()
a = (R / 'Logres/Core/Commands.lua').read_text()
p = (R / 'Logres/HUD/PetActionExecutionProbe.lua').read_text()
b = (R / 'Logres/Core/Bootstrap.lua').read_text()
t = (R / 'Logres/Logres.toc').read_text()

assert c.count('primary = 0.50,') == 3 and c.count('primary = 1.00,') == 1
assert c.count('secondary = 0.00,') == 3 and c.count('utility = 0.00,') == 3
assert 'secondary = 1.00,\n        utility = 0.75,' in c
for required in (
    'function Context:InstallHoverHooks()',
    'button:HookScript("OnEnter", function()',
    'button:HookScript("OnLeave", function()',
    'self:SetHovered(source, true)',
    'self:SetHovered(source, false)',
    'if self.policyName ~= "combat" then',
    'function Context:SetHovered(source, hovered)',
    'if self.hoverEffectsEnabled ~= true then',
    'function Context:ResolvedAlpha(policyName, role, source)',
    'return ALPHA_POLICY.combat[role]',
    'primary.cluster:SetAlpha(primaryAlpha)',
    'feedback:SetAlpha(primaryAlpha)',
    'sides.clusters[source].frame:SetAlpha(alpha)',
    'feedback:SetAlpha(alpha)',
    'pet:ApplyContextOpacity(petAlpha)',
    'self.hoverEffectsEnabled = false',
    'self:ApplyPolicy("combat")',
    'hoveredPet = self.hovered.pet == true',
    'hoverHookCount = self.hoverHookCount',
):
    assert required in c, required
assert 'actionDebug.primaryAlpha == expectedPrimary' in a
assert 'actionDebug.bar4Alpha == expectedBar4' in a
assert 'actionDebug.bar5Alpha == expectedBar5' in a
assert 'actionDebug.petAlpha == expectedPet' in a
assert 'contextDebug.petAlpha >= 0' in a
assert 'function Probe:ApplyContextOpacity(alpha)' in p
assert re.search(r'Logres.VERSION = "(.*?)"', b).group(1) == re.search(r'^## Version: (.*?)$', t, re.M).group(1)
for forbidden in (
    'SetAttribute(', 'SetBinding(', 'SaveBindings(', 'TargetNearestEnemy(',
    'ClearTarget(', 'TargetUnit(', 'C_Timer.', 'OnUpdate',
    'GetMouseFocus(', 'GetMouseFoci(', 'GetCursorPosition(', 'PetActionBar:Hide(',
):
    assert forbidden not in c, f'forbidden secure/polling/mouse inference: {forbidden}'
assert 'P0490' in (R / 'docs/memory/CURRENT.md').read_text()
assert 'L-055' in (R / 'docs/memory/investigations/ISSUE_LEDGER.md').read_text()
assert 'P0490_ACTION_MOUSEOVER_OPACITY.md' in (R / 'docs/memory/patches/PATCH_INDEX.md').read_text()
assert (R / 'tools/test_p0490_action_hover.lua').is_file()
engine = shutil.which('texlua') or shutil.which('lua')
if engine:
    subprocess.run([engine, str(R / 'tools/test_p0490_action_hover.lua')], cwd=R, check=True)
else:
    print('P0490 actual-source Lua hover fixture DEFERRED: no interpreter')
print('P0490 hover policy / protected-input contract: PASS')
