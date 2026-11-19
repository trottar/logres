#!/usr/bin/env python3
"""P0493 combat keybind plate alpha mirrors secure action-root transition."""
from pathlib import Path
import re, subprocess, shutil
R=Path(__file__).resolve().parents[1]
c=(R/'Logres/Actions/Context.lua').read_text()
p=(R/'Logres/Dev/Panel.lua').read_text()
b=(R/'Logres/Core/Bootstrap.lua').read_text()
t=(R/'Logres/Logres.toc').read_text()
for name in ('primary','secondary','utility','bar4','bar5','pet'):
    assert 'self:GetFrameRef("'+name+'Feedback" .. index)' in c,name
    assert 'bindFeedback("'+name+'"' in c or ('"'+name+'"' in c and 'bindFeedback(source' in c), name
assert 'driver:SetFrameRef(source .. "Feedback" .. index, feedback)' in c
assert 'self.secureFeedbackRefs = feedbackCount' in c
assert 'if locked and self.secureDriverReady == true then' in c
assert 'policyName = "combat"' in c
assert 'secureFeedbackRefs = self.secureFeedbackRefs' in c
assert '"secureFeedbackRefs"' in p
assert ':SetAlpha(0) end' not in c # rest remains ordinary and hover-aware
for forbidden in ('C_Timer.', 'OnUpdate', 'GetMouseFocus(', 'GetMouseFoci(',
                  'TargetNearestEnemy(', 'ClearTarget(', 'SaveBindings(',
                  'SetBinding(', 'GetBindingKey(', 'button:SetAttribute('):
    assert forbidden not in c,forbidden
assert re.search(r'Logres.VERSION = "(.*?)"',b).group(1)==re.search(r'## Version: (\S+)',t).group(1)
assert 'P0493' in (R/'docs/memory/CURRENT.md').read_text()
assert 'L-055' in (R/'docs/memory/investigations/ISSUE_LEDGER.md').read_text()
assert (R/'docs/memory/evidence/P0493_SECURE_KEYBIND_ALPHA.md').is_file()
assert 'P0493_SECURE_KEYBIND_ALPHA.md' in (R/'docs/memory/patches/PATCH_INDEX.md').read_text()
engine=shutil.which('texlua') or shutil.which('lua')
if engine: subprocess.run([engine,str(R/'tools/test_p0493_secure_feedback_alpha.lua')],cwd=R,check=True)
else: print('P0493 actual-source Lua fixture DEFERRED')
print('P0493 secure feedback alpha contract: PASS')
