#!/usr/bin/env python3
"""P0460: selected owner removes only on matching ordinary nameplate identity."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda path:(R/path).read_text(encoding='utf-8')
h=read('Logres/HUD/HUD.lua')
p=read('Logres/HUD/WorldTargetProbe.lua')
c=read('Logres/Core/Commands.lua')
d=read('Logres/Dev/Panel.lua')
resolve=h.split('function HUD:ResolveObservedSelectedNameplateUnit(probe)',1)[1].split('\nend\n',1)[0]
for item in ('self.worldEnemyObservedNameplateEpochs','probe:OrdinarySecondaryRole(unit)',
             'if isTarget == true then','if selected then return nil end', 'return selected'):
    assert item in resolve,item
for forbidden in ('UnitGUID(', 'issecretvalue(', 'GetAlpha(', 'SetAlpha(',
                  'GetNamePlateForUnit(', 'GetNamePlates(', 'OnUpdate', 'C_Timer.',
                  'SetParent(', 'SetAttribute(', 'SetPoint(', 'anchor ==', 'anchor ~='):
    assert forbidden not in resolve,forbidden
refresh=h.split('function HUD:RefreshLiveWorldEnemy(event, eventUnit)',1)[1].split('\nend\n',1)[0]
assert refresh.index('probe:AcquireLiveEnemyTargetAnchor(') < refresh.index('self:ResolveObservedSelectedNameplateUnit(probe)')
assert refresh.index('self:ResolveObservedSelectedNameplateUnit(probe)') < refresh.index('if self.worldEnemyLiveVisible then')
assert 'self.worldEnemyLiveAnchorUnit = anchorUnit' in refresh
assert 'self.worldEnemyLiveAnchorEpoch = anchorUnit' in refresh
assert 'self.worldEnemyLiveAnchorEpoch ==\n                self.worldEnemyObservedNameplateEpochs[anchorUnit]' in refresh
assert 'self:HideLiveWorldEnemy("selected-anchor-transition")' in refresh
assert 'self:UpdateLiveWorldEnemyValues()' in refresh
assert 'self:ClaimNativeEnemyDecor(anchor)' in refresh
block=h.split('local worldTrialEvents = CreateFrame("Frame")',1)[1].split('self.worldTrialEvents = worldTrialEvents',1)[0]
assert block.index('if event == "NAME_PLATE_UNIT_ADDED" and plateUnit then') < block.index('if self.worldEnemyLiveRequested then')
assert block.index('if event == "NAME_PLATE_UNIT_REMOVED" then') < block.index('self.worldEnemyObservedNameplateEpochs[plateUnit] = nil')
assert 'probe:IsLiveEnemyRemovalRelevant(' in block
assert 'if relevant then' in block and 'self:HideLiveWorldEnemy("nameplate-removed")' in block
assert 'self.worldEnemyLiveIgnoredOtherRemovals =' in block
assert 'self:HideSecondaryAggroTrial("world-transition")' in block
assert 'self:HideLiveWorldEnemy("world-transition")' in block
assert '"PLAYER_ENTERING_WORLD"}) do' in h
assert 'self.worldEnemyLiveAnchorEpoch = nil' in h
assert 'self.worldEnemyObservedNameplateEpochs = {}' in h
assert 'function Probe:IsLiveEnemyRemovalRelevant(eventUnit, attachedUnit)' in p
assert 'if unit == attachedUnit then return true, "attached-unit-removed" end' in p
assert 'return false, "other-unit-removed"' in p
assert 'function HUD:ObserveSecondaryAggroTrial(event, eventUnit, decision)' in h
assert '"secondary-removed"' in h
assert 'if decision ~= "eligible" then' in h
assert '"secondary-hostile-plate-skinned"' in h
assert 'self.worldEnemySecondaryTrialArmed = secondaryBuilt == true' in h
for field in ('worldEnemyLiveObservedTokenResolutions',
              'worldEnemyLiveUnknownTokenQueries',
              'worldEnemyLiveIgnoredOtherRemovals'):
    assert field in h and field in c and '"'+field+'"' in d,field
assert (R/'tools/test_p0460_selected_removal_source.lua').is_file()
for path in ('docs/ROADMAP.md','docs/memory/roadmap/STATUS.md',
             'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
             'docs/memory/investigations/ACTIVE.md','docs/memory/patches/PATCH_INDEX.md'):
    t=read(path)
    assert '## P0460 —' in t and '## P0459 —' in t,path
for path in ('docs/memory/CURRENT.md','docs/memory/handoffs/CURRENT_HANDOFF.md',
             'docs/memory/PRE_HANDOFF_AUDIT.md',
             'docs/memory/evidence/P0460_SELECTED_REMOVAL_IDENTITY.md'):
    assert 'P0460' in read(path),path
assert '| L-011 |' in read('docs/memory/investigations/ISSUE_LEDGER.md')
assert 'P0459 Forever session 131 #13499' in read('docs/memory/investigations/ISSUE_LEDGER.md')
assert len(read('docs/memory/CURRENT.md').encode())<9800
assert len(read('docs/memory/handoffs/CURRENT_HANDOFF.md').encode())<8192
v1=re.search(r'(?m)^## Version: ([^\s]+)$',read('Logres/Logres.toc'))
v2=re.search(r'(?m)^Logres.VERSION = "([^"\n]+)"$',read('Logres/Core/Bootstrap.lua'))
assert v1 and v2 and v1.group(1)==v2.group(1)
print('P0460 PASS: ordinary selected-token attribution, independent secondary, fail-open restoration, diagnostics and evidence (STATIC)')
