#!/usr/bin/env python3
"""P0489 exact ownership/alpha policy; targeting is deferred protected work."""
from pathlib import Path
import re, subprocess
R=Path(__file__).resolve().parents[1]
c=(R/'Logres/Actions/Context.lua').read_text()
p=(R/'Logres/HUD/PetActionExecutionProbe.lua').read_text()
a=(R/'Logres/Core/Commands.lua').read_text()
t=(R/'Logres/Logres.toc').read_text()
b=(R/'Logres/Core/Bootstrap.lua').read_text()
assert c.count('secondary = 0.00,')==3 and c.count('utility = 0.00,')==3
assert c.count('primary = 0.00,')==3 and c.count('primary = 1.00,')==1
assert 'secondary = 0.85,\n        utility = 0.75,' in c
assert 'sides.clusters[source].frame:SetAlpha(alpha)' in c
assert 'feedback:SetAlpha(alpha)' in c and 'feedback:SetAlpha(primaryAlpha)' in c
assert 'pet:ApplyContextOpacity(petAlpha, locked == true)' in c
assert 'self:ApplyPolicy("combat")' in c
assert 'driver:SetAttribute("_onstate-logrescombat", COMBAT_ALPHA_SNIPPET)' in c
assert 'petAlpha = self.petAlpha' in c
assert 'feedbackFramesUpdated = self.feedbackFramesUpdated' in c
assert 'function Probe:ApplyContextOpacity(alpha, feedbackOnly)' in p
assert 'self.cluster:SetAlpha(alpha)' in p
assert 'button.activationFeedbackFrame:SetAlpha(alpha)' in p
assert 'self:ApplyContextOpacity(self.contextAlpha)' in p
assert 'self.contextFeedbackCount = updated' in p
assert a.count('primary = 0.00,')==3 and a.count('primary = 1.00,')==1
assert a.count('secondary = 0.00,')==3 and a.count('utility = 0.00,')==3
assert 'actionDebug.petAlpha == expectedPet' in a
assert 'contextDebug.petAlpha <= 1' in a
assert re.search(r'## Version: (\S+)',t).group(1)==re.search(r'Logres.VERSION = "(.*?)"',b).group(1)
for forbidden in ('TargetNearestEnemy(', 'ClearTarget(', 'TargetUnit(', 'C_Timer.', 'OnUpdate', 'SetBinding(', 'SaveBindings(', 'PetActionBar:Hide('):
    assert forbidden not in c and forbidden not in p, 'forbidden mutation '+forbidden
assert 'P0489' in (R/'docs/memory/CURRENT.md').read_text()
assert 'L-055' in (R/'docs/memory/investigations/ISSUE_LEDGER.md').read_text()
assert 'L-056' in (R/'docs/memory/investigations/ISSUE_LEDGER.md').read_text()
assert 'P0489_ACTION_BAR_ALPHA_POLICY.md' in (R/'docs/memory/patches/PATCH_INDEX.md').read_text()
print('P0489 action/pet opacity policy contract: PASS')

assert 'button:SetAttribute(' not in c and 'cluster:SetAttribute(' not in c
