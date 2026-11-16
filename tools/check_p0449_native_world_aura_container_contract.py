#!/usr/bin/env python3
"""P0449: delegate secret-capable world aura presentation to Blizzard engine."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
n=read('Logres/HUD/NativeDebuffs.lua')
a=read('Logres/HUD/StatusAuras.lua')
h=read('Logres/HUD/HUD.lua')
panel=read('Logres/Dev/Panel.lua')
cmd=read('Logres/Core/Commands.lua')
create=n.split('function Native.CreateWorldEnemyLanes(parent)',1)[1].split('function Native.SetActive(',1)[0]
assert 'InCombatLockdown' in create and 'locked ~= false' in create
assert 'nativeReady()' in create and 'parent, "HARMFUL"' in create and 'parent, "HELPFUL"' in create
assert '"RIGHT", "LEFT", -25, 0' in create and '"LEFT", "RIGHT", 25, 0' in create
assert 'frame:SetEnabled(true)' in create and 'frame:UpdateAllAuras()' in create
assert 'return nil, "native-world-setup-refused"' in create
assert 'frame:AddAuraGroup(' in n and 'frame:SetUnit(unit)' in n
assert 'button:EnableMouse(false)' in n
for forbid in ('C_UnitAuras', 'GetAuraDataByIndex', 'GetAuraDataByAuraInstanceID', 'GetChildren(', 'SetCVar(', 'C_Timer.', 'AuraButtonMixin'):
    assert forbid not in create, forbid
# P0461 revised safety contract: the historical native helper is preserved,
# but must NOT create an independent live world renderer without proof of
# visible icons. Native nameplate auras are the designated fallback.
world_create=a.split('function StatusAuras:CreateWorldEnemyLiveLanes(parent)',1)[1].split('function StatusAuras:SetWorldEnemyScreenAuraHandoff(',1)[0]
assert 'CreateWorldEnemyLanes' not in world_create
assert 'self.worldEnemyNativeLanes = nil' in world_create
assert 'stock-nameplate-native-preserved' in world_create
assert '"restricted-no-ordinary"' in a
for key in ('worldEnemyNativeReady','worldEnemyNativeReason','worldEnemyNativeVisibilityProof'):
    assert key in a and key in cmd and ('"'+key+'"') in panel,key
assert '"unobserved"' in a
assert 'auras:CreateWorldEnemyLiveLanes(frame)' in h
assert 'frame:SetFrameStrata("HIGH")' in h
assert 'self:RestoreNativeEnemyDecor()' in h and 'worldEnemySecondaryEnabled = false' in h
assert 'root:SetPoint("RIGHT", previewParent, "LEFT", -25, 0)' in a
assert 'root:SetPoint("LEFT", previewParent, "RIGHT", 25, 0)' in a
current = read('docs/memory/CURRENT.md')
work = current.split('\n## Current Work Item\n',1)[1].split('\n## ',1)[0]
active = re.search(r'(?m)^\*\*(P[0-9]{4})\*\*(?:\s|$)',work)
assert active
for path in ('docs/ROADMAP.md','docs/memory/roadmap/STATUS.md','docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md','docs/memory/investigations/ACTIVE.md'):
    body=read(path)
    assert body.startswith('## '+active.group(1)+' —'),path
    assert '## P0449 —' in body,path
handoff=read('docs/memory/handoffs/CURRENT_HANDOFF.md')
assert handoff.startswith('# '+active.group(1)+':')
assert '# P0449:' in handoff
assert 'P0448 runtime aura FAIL' in read('docs/memory/evidence/P0449_NATIVE_WORLD_AURA_CONTAINER.md')
assert 'L-028 | Target debuffs' in read('docs/memory/investigations/ISSUE_LEDGER.md')
print('P0449 PASS: retained native capability and OOC guard; live renderer suspended under P0461 stock-aura policy')
