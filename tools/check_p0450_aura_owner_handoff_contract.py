#!/usr/bin/env python3
"""P0450: additive aura presentation ownership with strict restoration."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
n=read('Logres/HUD/NativeDebuffs.lua')
a=read('Logres/HUD/StatusAuras.lua')
h=read('Logres/HUD/HUD.lua')
c=read('Logres/Core/Commands.lua')
p=read('Logres/Dev/Panel.lua')
# Historical P0183 native source and P0449 world child creation remain intact.
assert 'function Native.Create()' in n and 'frames.target = createContainer(' in n
assert 'function Native.CreateWorldEnemyLanes(parent)' in n
assert '"RIGHT", "LEFT", -25, 0' in n and '"LEFT", "RIGHT", 25, 0' in n
# Screen target is addon-owned and only its opaque alpha is modified.
section=n.split('function Native.SetScreenTargetWorldOwned(state, worldOwned)',1)[1]
assert 'state.frames.target' in section
for required in ('frame.IsProtected','frame.IsForbidden','issecretvalue','frame.GetAlpha','frame.SetAlpha','state.screenTargetWorldAlpha','"screen-target-restored"','pcall(frame.SetAlpha, frame, 0)'):
    assert required in section, required
for forbidden in ('SetParent(', 'GetChildren(', 'C_UnitAuras', 'GetAuraDataByIndex', 'C_Timer.', 'SetCVar('):
    assert forbidden not in section, forbidden
assert 'function StatusAuras:SetWorldEnemyScreenAuraHandoff(worldOwned)' in a
assert 'SetScreenTargetWorldOwned' in a
assert 'self:SetWorldEnemyScreenAuraHandoff(false)' in a
# Two separate native LISTS may be owned only with world-native replacement;
# the Blizzard UnitFrame, cast, CC/LOC, click and whole aura root stay stock.
claim=h.split('function HUD:ClaimNativeEnemyDecor(anchor)',1)[1].split('function HUD:BuildLiveWorldEnemy()',1)[0]
for required in ('auraModule.worldEnemyNativeLanes','nativeDecorField(unitFrame, "AurasFrame")','nativeDecorField(auraRoot, "DebuffListFrame")','nativeDecorField(auraRoot, "BuffListFrame")','safeNativeDecor(harmful)','safeNativeDecor(helpful)','candidates[#candidates + 1] = harmful','candidates[#candidates + 1] = helpful','auraAccepted','self.worldEnemyNativeAuraOwned = auraAccepted'):
    assert required in claim, required
for forbidden in ('SetParent(', 'GetChildren(', 'GetRegions(', 'GetAuraDataByIndex', 'C_UnitAuras', 'SetCVar(', 'hooksecurefunc('):
    assert forbidden not in claim, forbidden
assert 'pcall(region.GetAlpha, region)' in claim
assert 'pcall(region.SetAlpha, region, 0)' in claim
restore=h.split('function HUD:RestoreNativeEnemyDecor()',1)[1].split('function HUD:ClaimNativeEnemyDecor(anchor)',1)[0]
assert 'pcall(entry.region.SetAlpha, entry.region, entry.original)' in restore
assert 'self.worldEnemyNativeAuraOwned = false' in restore
hide=h.split('function HUD:HideLiveWorldEnemy(reason)',1)[1].split('function HUD:UpdateLiveWorldEnemyValues()',1)[0]
assert 'statusAuras:SetWorldEnemyScreenAuraHandoff(false)' in hide
attach=h.split('function HUD:RefreshLiveWorldEnemy(event, eventUnit)',1)[1].split('function HUD:SetLiveWorldEnemy(enabled)',1)[0]
assert attach.index('if not pcall(frame.Show, frame)') < attach.index('auras:SetWorldEnemyScreenAuraHandoff(true)')
assert 'self.targetNameText:Hide()' in attach and 'self.targetHealthBar:Hide()' in attach
for key in ('worldEnemyNativeAuraLastResult','worldEnemyNativeAuraTransfers','worldEnemyNativeAuraRestores'):
    assert key in h and key in c and ('"'+key+'"') in p,key
for key in ('worldEnemyScreenAuraReason','worldEnemyScreenAuraHandoffs','worldEnemyScreenAuraRestores','worldEnemyScreenAuraFailures'):
    assert key in a and key in c and ('"'+key+'"') in p,key
for path in ('docs/ROADMAP.md','docs/memory/roadmap/STATUS.md','docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md','docs/memory/investigations/ACTIVE.md'):
    body=read(path)
    # P0451 is the active checkpoint; P0450's full historical heading and
    # P0449 predecessor remain recorded in order, not overwritten.
    assert any(line.startswith("## P0451 —") for line in body.splitlines()) and ('## P0450 —' in body)
    assert body.index('## P0451 —') < body.index('## P0450 —') < body.index('## P0449 —'), path
handoff = read('docs/memory/handoffs/CURRENT_HANDOFF.md')
assert any(line.startswith("# P0451:") for line in handoff.splitlines())
assert '# P0450:' in handoff and handoff.index('# P0451:') < handoff.index('# P0450:')
assert 'P0449 world aura visibility PASS' in read('docs/memory/evidence/P0450_WORLD_AURA_OWNERSHIP_HANDOFF.md')
assert '| L-011 | World-attached target anchor | PARTIAL |' in read('docs/memory/investigations/ISSUE_LEDGER.md')
assert 'P0449' in read('docs/memory/CURRENT.md')
assert re.search(r'(?m)^## Version: (\S+)$',read('Logres/Logres.toc')).group(1)==re.search(r'(?m)^Logres.VERSION = "([^"]+)"$',read('Logres/Core/Bootstrap.lua')).group(1)
print('P0450 PASS: separately gated native list and owned screen alpha handoff, restore and failure evidence')
