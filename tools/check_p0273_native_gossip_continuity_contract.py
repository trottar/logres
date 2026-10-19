#!/usr/bin/env python3
"""P0273: one opted-in guarded native controller across gossip->service; no replacement UI."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
s=read('Logres/Quest/NativeServicePlacementTrial.lua')
c=read('Logres/Core/Commands.lua')
t=read('Logres/Logres.toc')
b=read('Logres/Core/Bootstrap.lua')
e=[]
def need(ok,why):
 if not ok:e.append(why)
for tok in ('[3] = { key = "gossip", name = "GossipFrame" }',
 '[5] = { key = "merchant", name = "MerchantFrame" }',
 '[7] = { key = "trainer", name = "ClassTrainerFrame" }',
 'local gossipStarts, gossipRestores = 0, 0',
 'if active.key == "gossip" then gossipRestores = gossipRestores + 1 end',
 'if candidate.key == "gossip" then gossipStarts = gossipStarts + 1 end',
 'scope = "opt-in-gossip-merchant-trainer-only"',
 'gossipStarts = gossipStarts, gossipRestores = gossipRestores',
 'Logres:SubscribeState(function(state)',
 'ensureAutoOnShow(candidate)',
 'local candidate = state and state.interacting == true',
 'and CANDIDATES[state.interactionType] or nil',
 'if active and (not candidate or active.key ~= candidate.key) then',
 'Trial.Restore("interaction-ended")',
 'Trial.Restore("native-hide")','Trial.Restore("auto-disabled")',
 'if not unlocked() then','safeMethod(frame, "IsProtected")',
 'safeMethod(frame, "IsShown")','safeMethod(frame, "GetNumPoints")',
 'ordinary(count)','set(frame, "CENTER", UIParent, "CENTER", 0, 0)',
 'local autoEnabled = false','nativeTransactions = 0','styling = "unchanged"'):
 need(tok in s,'missing shared lifecycle/safety invariant: '+tok)
for bad in ('OnUpdate','C_Timer.','DynamicCam','BuyMerchantItem(',
 'BuyTrainerService(', 'RepairAllItems(', 'SellCursorItem(',
 'TakeTaxiNode(', 'C_GossipInfo.','SetParent(', 'SetAlpha(',
 'EnableMouse(', 'HideUIPanel(', 'ShowUIPanel('):
 need(bad not in s,'native placement must not own gameplay/presentation: '+bad)
need(s.count('"OnShow"')==1 and s.count('"OnHide"')==1,
 'existing scoped show/hide hooks only; no duplicated native controllers')
need('autoEnabled=%s autoStarts=%s autoDeferred=%s autoLast=%s gossipStarts=%s gossipRestores=%s' in c,
 'panel diagnostic reports gossip lifecycle without extra action')
need('tostring(report.gossipStarts), tostring(report.gossipRestores)' in c,
 'gossip counters bound to owner audit')
need('"Native Auto Position (TEST)"' in c and '"nativeserviceplacement auto toggle"' in c,
 'H panel button must remain single existing toggle')
rg=re.compile(r'Logres:RegisterDevPanelAction\(\s*"([^"]+)"\s*,\s*"[^"]+"\s*,\s*"[^"]+"\s*,\s*"([0A-HP])"\s*\)',re.S)
a=rg.findall(c)
need(len(a)==105 and sum(ph=='H' for _,ph in a)==18 and sum(ph=='P' for _,ph in a)==34,
 'existing panel registry 105 / H18 / P34 unchanged')
need(sum(name=='nativeServicePlacementTrial' for name,_ in a)==1,
 'one native placement panel action')
for history in ('tools/check_p0271_native_placement_trial_contract.py',
 'tools/check_p0272_native_auto_handoff_contract.py'):
 h=read(history)
 need('scope = "opt-in-gossip-merchant-trainer-only"' in h,
  'historical contract migration: '+history)
need((R/'docs/memory/evidence/P0272_NATIVE_AUTO_HANDOFF.md').is_file(),
 'recover missing P0272 record without falsely claiming former static pass')
need((R/'docs/memory/evidence/P0273_NATIVE_GOSSIP_CONTINUITY.md').is_file(),
 'new user evidence and runtime acceptance gate recorded')
need('Quest\\ServiceCatalogModel.lua' not in t and
 not (R/'Logres/Quest/ServiceCatalogModel.lua').exists(),
 'D-047: no speculative merchant/trainer catalogue')
need('Quest\\NativeServicePlacementTrial.lua' in t, 'existing shared controller loaded')
tv=re.search(r'^## Version: ([^\n]+)$',t,re.M)
bv=re.search(r'^Logres\.VERSION = "([^"]+)"$',b,re.M)
need(bool(tv and bv and tv.group(1)==bv.group(1)
          and re.fullmatch(r'\d+\.\d+\.\d+-dev', tv.group(1))),
 'TOC/Bootstrap development version parity (no historical version pin)')
for p in ('Logres/Camera/WorldCombat.lua','Logres/Camera/ProfileContexts.lua',
          'Logres/Quest/Dialogue.lua'):
 need((R/p).is_file(),'frozen existing runtime component: '+p)
print('P0273 native gossip/merchant/trainer shared placement and handoff contract')
for item in e:print('ERROR:',item)
if e:raise SystemExit(1)
print('PASS: 0 errors (STATIC; opt-in gossip lifecycle requires WoW validation)')
