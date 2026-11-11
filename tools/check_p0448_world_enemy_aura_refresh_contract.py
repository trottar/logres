#!/usr/bin/env python3
"""P0448: event-time ordinary target aura refresh, source/render proof, native fallback."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
h=read('Logres/HUD/HUD.lua')
a=read('Logres/HUD/StatusAuras.lua')
c=read('Logres/Core/Commands.lua')
d=read('Logres/Dev/Panel.lua')
attach=h.split('function HUD:RefreshLiveWorldEnemy(event, eventUnit)',1)[1].split('function HUD:SetLiveWorldEnemy',1)[0]
source=a.split('function StatusAuras:RefreshWorldEnemyLiveSource(reason)',1)[1].split('function StatusAuras:SetPreview',1)[0]
render=a.split('function StatusAuras:RefreshWorldEnemyLiveLanes()',1)[1].split('function StatusAuras:RefreshWorldEnemyLiveSource(reason)',1)[0]
assert 'auras:RefreshWorldEnemyLiveSource("world-enemy-attach")' in attach
assert attach.index('self:UpdateLiveWorldEnemyValues()') < attach.index('RefreshWorldEnemyLiveSource') < attach.index('ClaimNativeEnemyDecor(anchor)')
assert 'pcall(readUnit, "target")' in source
for key in ('self.last.target = snapshot','self:RecordLiveSnapshot("target", snapshot, reason or "world-enemy-attach")','self:RefreshWorldEnemyLiveLanes()','worldEnemySourceAttachScans','worldEnemySourceAttachFailures','worldEnemySourceLastReason','worldEnemySourceLastHarmful','worldEnemySourceLastHelpful','worldEnemySourceLastSecrets','worldEnemySourceLastFailures'):
    assert key in source,key
for forbidden in ('NativeDebuffs.SetActive','SetCVar(', 'C_Timer.', 'GetNamePlates(', 'GetAuraDataByIndex(', 'AurasFrame', 'RegisterEvent(', 'GetChildren('):
    assert forbidden not in source,forbidden
assert 'pcall(function()' in render and 'worldEnemyLiveRenderLastResult = "owned-render-refused"' in render
assert 'worldEnemyLiveRenderAttempts' in render and 'return ok' in render
for key in ('worldEnemySourceAttachScans','worldEnemySourceLastReason','worldEnemySourceLastHarmful','worldEnemySourceLastHelpful','worldEnemySourceLastSecrets','worldEnemySourceLastFailures','worldEnemyLiveRenderAttempts','worldEnemyLiveFailures','worldEnemyLiveRenderLastResult','worldEnemyLiveHarmfulSlots','worldEnemyLiveHelpfulSlots','worldEnemyLiveHarmfulShown','worldEnemyLiveHelpfulShown'):
    assert key in a,key
    assert '"'+key+'"' in d,key
    assert key in c,key
assert 'if event == "UNIT_AURA" then\n            self:Refresh(event, unit)' in a
assert 'item.frame:Show()' in a and 'item.frame:Hide()' in a
assert 'root:SetPoint("RIGHT", previewParent, "LEFT", -25, 0)' in a
assert 'root:SetPoint("LEFT", previewParent, "RIGHT", 25, 0)' in a
assert 'worldEnemySecondaryEnabled = false' in h
assert 'self:RestoreNativeEnemyDecor()' in h
assert 'P0443 matte' in read('docs/memory/evidence/P0448_WORLD_AURA_ATTACH_REFRESH.md')
assert 'L-028 | Target debuffs' in read('docs/memory/investigations/ISSUE_LEDGER.md')
current=read('docs/memory/CURRENT.md')
active=re.search(r'(?m)^\*\*(P[0-9]{4})\*\*',current.split('\n## Current Work Item\n',1)[1].split('\n## ',1)[0])
assert active
for p in ('docs/ROADMAP.md','docs/memory/roadmap/STATUS.md','docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md'):
    body=read(p)
    assert body.startswith('## '+active.group(1)+' —') and '## P0449 —' in body,p
assert current.count('## Next Action')==1
handoff=read('docs/memory/handoffs/CURRENT_HANDOFF.md')
assert handoff.startswith('# '+active.group(1)+':') and '# P0449:' in handoff
toc=re.search(r'^## Version: ([^\n]+)$',read('Logres/Logres.toc'),re.M)
boot=re.search(r'Logres.VERSION = "([^"]+)"',read('Logres/Core/Bootstrap.lua'))
assert toc and boot and toc.group(1)==boot.group(1) and toc.group(1).endswith('-dev')
print('P0448 PASS: event-time ordinary aura scan, cached target/owned render diagnostics, stable native world enemy and aura geometry')
