#!/usr/bin/env python3
"""P0499 L-055 independent secure cluster combat owner contract."""
from pathlib import Path
import re, shutil, subprocess
R=Path(__file__).resolve().parents[1]
c=(R/'Logres/Actions/Context.lua').read_text()
b=(R/'Logres/Actions/Button.lua').read_text()
p=(R/'Logres/Dev/Panel.lua').read_text()
boot=(R/'Logres/Core/Bootstrap.lua').read_text()
toc=(R/'Logres/Logres.toc').read_text()
assert 'local cluster = CreateFrame("Frame", name, UIParent)' in b
for fragment in (
    'self:ApplyPolicy("combat")',
    'self.disableEventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")',
    'RegisterStateDriver(rootDriver, "logresbar", "[combat] combat; rest")',
    'UnregisterStateDriver(root, "logresbar")',
    'self:SetAttribute("logresCombatAck", true) end end',
    'self.secureRootDriverCount = #self.secureRootDriverFrames',
    'rootDriver:SetFrameRef("cluster", root)',
    'self.secureRootDriversByKey[key] = rootDriver',
    'rootDriver:SetAttribute("logresCombatAck", false)',
    'local rootDriver = self.secureRootDriversByKey[key]',
    '"LogresActionAlphaRootDriver" .. key',
    'CreateFrame("Frame",',
    'secureRootAckCount = secureRootAckCount',
    'if not classified or secret ~= false then return nil end',
    'if (InCombatLockdown and InCombatLockdown())',
    'for _, root in ipairs(self.secureRootDriverFrames or {}) do',
    'self.secureRootDriverLastResult = ok and "six-registered"',
): assert fragment in c,fragment
for role,alpha in (('primary','1'),('secondary','0.85'),('utility','0.75'),('bar4','1'),('bar5','0.75'),('pet','0.85')):
    assert ('{"primary", primary.cluster, "1"}' if role=='primary' else
            '{"pet", pet.cluster, "0.85"}' if role=='pet' else
            '{"'+role+'", sides.clusters.'+role+'.frame, "'+alpha+'"}') in c,role
# No changes to preexisting central feedback / root secure driver.
assert 'driver:SetAttribute("_onstate-logrescombat", COMBAT_ALPHA_SNIPPET)' in c
assert 'RegisterStateDriver(driver, "logrescombat", "[combat] combat; rest")' in c
assert 'self.secureFeedbackRefs = feedbackCount' in c
assert 'if newstate == "combat" then' in c
assert ':SetAlpha(0) end' not in c
for item in ('"secureRootDriverCount"','"secureRootDriverLastResult"','"secureRootAckCount"'):
    assert item in p,item
for forbidden in ('C_Timer.', 'OnUpdate', 'SetBinding(', 'SaveBindings(',
                  'GetMouseFoci(', 'GetCursorPosition(', 'TargetNearestEnemy(',
                  'PetActionBar:Hide('):
    assert forbidden not in c,forbidden
assert re.search(r'^Logres.VERSION = "([^"\n]+)"',boot,re.M).group(1) == re.search(r'^## Version: ([^\r\n]+)',toc,re.M).group(1)
assert 'P0499' in (R/'docs/memory/CURRENT.md').read_text()
assert 'L-055' in (R/'docs/memory/investigations/ISSUE_LEDGER.md').read_text()
assert (R/'docs/memory/evidence/P0499_COMBAT_BAR_DIRECT_ROOT_DRIVERS.md').is_file()
for doc in ('docs/memory/patches/PATCH_INDEX.md', 'docs/memory/investigations/ACTIVE.md'):
    assert 'P0499' in (R/doc).read_text()
engine=shutil.which('texlua') or shutil.which('lua')
if not engine: raise SystemExit('P0499 actual-source Lua engine required')
for fixture in ('tools/test_p0499_cluster_template.lua','tools/test_p0491_secure_combat_alpha.lua'):
    subprocess.run([engine,str(R/fixture)],cwd=R,check=True)
print('P0499 direct-root combat contract: PASS')
