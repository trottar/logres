#!/usr/bin/env python3
"""P0272: opted-in, event-only native merchant/trainer centering; reversible."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
get=lambda p:(R/p).read_text(encoding='utf-8')
p=get('Logres/Quest/NativeServicePlacementTrial.lua')
c=get('Logres/Core/Commands.lua')
t=get('Logres/Logres.toc')
b=get('Logres/Core/Bootstrap.lua')
h=get('tools/check_p0271_native_placement_trial_contract.py')
e=[]
def need(ok,label):
 if not ok:e.append(label)
for token in ('local autoEnabled = false','function Trial.SetAuto(enabled)',
 'function Trial.ToggleAuto()','function Trial.AutoReconcile(reason)',
 'Logres:SubscribeState(function(state)','Trial.Restore("interaction-ended")',
 'Trial.Restore("auto-disabled")','Trial.Restore("native-hide")',
 'ensureAutoOnShow(candidate)','pcall(hook, frame, "OnShow", function()',
 'if autoEnabled then Trial.AutoReconcile("native-show") end',
 'if active or restorePending then', 'autoStarts = autoStarts + 1',
 'autoDeferred = autoDeferred + 1', 'autoEnabled = autoEnabled',
 'autoLast = autoLast', 'scope = "opt-in-gossip-merchant-trainer-only"',
 'nativeTransactions = 0','styling = "unchanged"',
 '[5] = { key = "merchant", name = "MerchantFrame" }',
 '[7] = { key = "trainer", name = "ClassTrainerFrame" }',
 'ordinary(count)','set(frame, "CENTER", UIParent, "CENTER", 0, 0)'):
 need(token in p,'missing lifecycle/safety token: '+token)
for bad in ('C_Timer.', 'OnUpdate','BuyMerchantItem(', 'RepairAllItems(',
 'SellCursorItem(', 'BuyTrainerService(', 'TakeTaxiNode(', 'SetParent(',
 'SetAlpha(', 'EnableMouse(', 'ShowUIPanel(', 'HideUIPanel(', 'DynamicCam',
 'GetMerchantItemInfo(', 'C_GossipInfo.'):
 need(bad not in p,'native trial forbidden: '+bad)
need(p.count('"OnShow"')==1, 'only one scoped OnShow hook')
need(p.count('"OnHide"')==1, 'prior same-frame OnHide restore retained')
need('if argument == "auto" or argument == "auto toggle" then' in c,
 'slash auto toggle')
need('trial.SetAuto(true)' in c and 'trial.SetAuto(false)' in c,
 'explicit on/off routes')
need('"Native Auto Position (TEST)"' in c and
 '"nativeserviceplacement auto toggle"' in c,
 'H button reuses single slot')
need('autoEnabled=%s autoStarts=%s autoDeferred=%s autoLast=%s' in c,
 'clear independent auto diagnostics')
need('"Native Service Center / Restore (TEST)"' not in c,
 'old crowded H button retired')
need('"Native Auto Position (TEST)"' in h and
 'scope = "opt-in-gossip-merchant-trainer-only"' in h,
 'P0271 historical checker migrated')
need('Quest\\NativeServicePlacementTrial.lua' in t,'same shared trial module')
reg=re.findall(r'Logres:RegisterDevPanelAction\(\s*"([^"]+)"\s*,\s*"[^"]+"\s*,\s*"[^"]+"\s*,\s*"([0A-HP])"\s*\)',c,re.S)
need(len(reg)>=108 and len([a for a,z in reg if z=='H'])>=20
 and len([a for a,z in reg if z=='P'])==35,'registry remains 108/18/34')
need(len([a for a,z in reg if a=='nativeServicePlacementTrial'])==1,
 'reuse one existing H action')
need('Quest\\ServiceCatalogModel.lua' not in t and
 not (R/'Logres/Quest/ServiceCatalogModel.lua').exists(),
 'do not revive P0268 speculative catalogues')
version=lambda pat,s:re.search(pat,s,re.M)
a=version(r'^## Version: (\S+)$',t)
v=version(r'^Logres\.VERSION = "([^"]+)"$',b)
need(bool(a and v and a.group(1)==v.group(1)), 'TOC and Bootstrap parity')
print('P0272 opt-in event-driven native service positioning contract')
for x in e: print('ERROR:',x)
if e:raise SystemExit(1)
print('PASS: 0 errors (STATIC; WoW automatic lifecycle remains pending)')
