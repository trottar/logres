#!/usr/bin/env python3
"""P0271: on-demand reversible native merchant/trainer placement; no transaction shadow."""
import re
from pathlib import Path
R=Path(__file__).resolve().parents[1]
get=lambda p:(R/p).read_text(encoding='utf-8')
p=get('Logres/Quest/NativeServicePlacementTrial.lua')
a=get('Logres/Quest/NativeServiceCapabilities.lua')
c=get('Logres/Core/Commands.lua')
t=get('Logres/Logres.toc')
b=get('Logres/Core/Bootstrap.lua')
errors=[]
def need(test,msg):
 if not test: errors.append(msg)
for s in ('Logres.NPCNativeServicePlacementTrial = Trial','function Trial.Toggle()',
 'function Trial.Restore(reason)','function Trial.GetAudit()',
 '[5] = { key = "merchant", name = "MerchantFrame" }',
 '[7] = { key = "trainer", name = "ClassTrainerFrame" }',
 'local points = capture(frame)','ordinary(count)','GetNumPoints',
 'safeMethod(frame, "IsProtected")','safeMethod(frame, "IsShown")',
 'safeMethod(frame, "HookScript")','if not unlocked() then',
 'set(frame, "CENTER", UIParent, "CENTER", 0, 0)',
 'Trial.Restore("native-hide")','PLAYER_REGEN_ENABLED',
 'function Trial.GetAudit()', 'nativeTransactions = 0',
 'styling = "unchanged"','scope = "opt-in-gossip-merchant-trainer-only"'):
 need(s in p,'placement missing '+s)
for f in ('BuyMerchantItem(', 'RepairAllItems(', 'SellCursorItem(',
 'TakeTaxiNode(', 'BuyTrainerService(', 'GetMerchantItemInfo(',
 'C_GossipInfo.', 'C_Timer.', 'DynamicCam', 'SetParent(', 'SetAlpha(',
 'EnableMouse(', 'UnregisterAllEvents(', 'OnUpdate'):
 need(f not in p,'prohibited in placement '+f)
need('frame:GetPoint(' not in p and 'frame:IsShown()' not in p,
 'native getters must use guarded method calls only')
need('frame:SetPoint(' not in p,'native positioning guarded method only')
need('"TaxiFrame"' in a and '"FlightMapFrame"' in a,
 'flight candidate aliases retained')
need('function Probe.Read()' in a and 'placementAuthorization = "none"' in a,
 'metadata probe still does not authorize mutation')
need('Quest\\NativeServiceCapabilities.lua\nQuest\\NativeServiceAccent.lua\nQuest\\NativeServicePlacementTrial.lua\nQuest\\NativeServicePolicy.lua' in t,
 'native capability and trial TOC ordering')
need('if command == "nativeserviceplacement" then' in c,
 'command routed')
need('"nativeServicePlacementTrial"' in c and
 '"Native Auto Position (TEST)"' in c,
 'H action exists (reused for opt-in auto)')
need('Quest\\ServiceCatalogModel.lua' not in t and
 not (R/'Logres/Quest/ServiceCatalogModel.lua').exists(),
 'do not revive custom service catalog')
check=get('tools/check_p0256_preview_hub_contract.py')
n=get('tools/check_p0261_n1_narrative_contract.py')
s=get('tools/check_p0269_native_service_ownership_contract.py')
x=get('tools/check_p0270_native_frame_capability_contract.py')
need('if len(actions) != 108:' in check and 'len(required) != 35' in check,
 'P0256 total 108 and P inventory 34')
need("'len(actions) != 108' in p" in n,
 'P0261 historical checker')
need("'len(actions) != 108' in h" in s and
 "'len(actions) != 108' in n" in s,'P0269 checker')
need("'if len(actions) != 108:' in preview_check" in x and
 "\"'len(actions) != 108' in p\" in narrative_check" in x and
 "\"'len(actions) != 108' in h\" in service_check" in x and
 "\"'len(actions) != 108' in n\" in service_check" in x,
 'P0270 checker historical inventory')
rg=re.compile(r'Logres:RegisterDevPanelAction\(\s*"([^"]+)"\s*,\s*"[^"]+"\s*,\s*"[^"]+"\s*,\s*"([0A-HP])"\s*\)',re.S)
entries=rg.findall(c)
need(len(entries)==108 and len([i for i,phase in entries if phase=='P'])==35,
 'exact registry 108/34')
need(len([i for i,phase in entries if phase=='H'])==20,'H <= 18 button limit')
need(t.count('Quest\\NativeServicePlacementTrial.lua')==1,'TOC once')
tv=re.search(r'^## Version: ([\w.\-]+)$',t,re.M)
bv=re.search(r'^Logres\.VERSION = "([\w.\-]+)"$',b,re.M)
need(bool(tv and bv and tv.group(1)==bv.group(1)),'bootstrap toc version parity')
for filename in ('Logres/Camera/ProfileContexts.lua','Logres/Camera/WorldCombat.lua'):
 need((R/filename).exists(),filename+' missing')
print('P0271 read-only flight alias + controlled native placement trial')
for e in errors: print('ERROR:',e)
if errors:raise SystemExit(1)
print('PASS: 0 errors (STATIC; no WoW runtime proof)')
